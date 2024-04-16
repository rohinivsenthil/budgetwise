import boto3
import uuid
import json
import datetime
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
import csv
from io import StringIO
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)
textract = boto3.client("textract")
ses = boto3.client("ses", region_name=region)
sns_client = boto3.client("sns")

###################
# Expenses APIs
###################


def createExpense(table, data):
    user_id = "1"  # Default user_id
    today = datetime.date.today()
    datetime_obj = datetime.datetime.combine(today, datetime.datetime.min.time())
    try:
        data["expense_id"] = str(uuid.uuid4())
        data["user_id"] = user_id
        data["amount"] = Decimal(str(data["amount"]))  # Convert amount to Decimal
        data["date"] = int(datetime_obj.timestamp())
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def viewAllExpenses(table):
    user_id = "1"  # Default user_id
    try:
        response = table.query(
            IndexName="user_id-index", KeyConditionExpression=Key("user_id").eq(user_id)
        )

        response["Items"] = sorted(
            response["Items"], key=lambda x: x["timestamp"], reverse=True
        )  # sorting by timestamp

        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def viewExpense(table, expense_id):
    try:
        response = table.query(KeyConditionExpression=Key("expense_id").eq(expense_id))
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def deleteExpense(table, data):
    try:
        expense_id = data["expense_id"]
        response = table.delete_item(Key={"expense_id": expense_id})
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def updateExpense(table, data):
    user_id = "1"  # Default user_id
    try:
        # Convert float to Decimal for amount
        data["amount"] = Decimal(str(data["amount"]))
        # Add user_id to data
        data["user_id"] = user_id
        # Update item
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


###################
# Budget APIs
###################


def createBudget(table, data):
    user_id = "1"  # Default user_id
    try:
        data["budget_id"] = str(uuid.uuid4())
        data["user_id"] = user_id
        data["amount"] = Decimal(str(data["amount"]))  # Convert amount to Decimal
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def viewAllBudgets(table):
    user_id = "1"  # Default user_id
    try:
        response = table.query(
            IndexName="user_id-index", KeyConditionExpression=Key("user_id").eq(user_id)
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def deleteBudget(table, data):
    try:
        budget_id = data["budget_id"]
        response = table.delete_item(Key={"budget_id": budget_id})
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def updateBudget(table, data):
    user_id = "1"  # Default user_id
    try:
        # Convert float to Decimal for amount
        data["amount"] = Decimal(str(data["amount"]))
        # Add user_id to data
        data["user_id"] = user_id
        # Update item
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


def generateResponse(statusCode, body):
    # Convert Decimal to float if needed
    def convert_decimal(obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return obj

    return {
        "statusCode": statusCode,
        "headers": {
            "Content-Type": "application/json", 
            'Access-Control-Allow-Origin' : '*',
            "Access-Control-Allow-Credentials" : "true",
            "Access-Control-Allow-Methods": "*",
            },
        "body": json.dumps(body, default=convert_decimal),
    }


###################
# Receipts APIs
###################


def analyze_receipts(table, receipt_file):
    try:
        # Call Amazon Textract to analyze the receipt file
        response = textract.analyze_document(
            Document={"Bytes": receipt_file.read()}, FeatureTypes=["FORMS"]
        )

        # Extracting amount from Textract response
        amount = None
        for item in response["Blocks"]:
            if item["BlockType"] == "LINE" and "Amount" in item["Text"]:
                amount_text = item["Text"].replace("$", "").replace(",", "").strip()
                amount = Decimal(amount_text)
                break

        if amount is not None:
            return generateResponse(200, {"amount": amount})
        else:
            return generateResponse(404, "Amount not found in receipt")

    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


###################
# Reports APIs
###################


def createReport(expenses_table):
    try:
        expenses = viewAllExpenses(expenses_table)
        body_json = json.loads(expenses["body"])
        expenses_data = body_json.get("Items", [])

        csv_report = StringIO()
        csv_writer = csv.DictWriter(
            csv_report,
            fieldnames=["expense_id", "user_id", "name", "amount", "date", "category"],
        )
        csv_writer.writeheader()
        for expense in expenses_data:
            csv_writer.writerow(expense)
        csv_report.seek(0)

        msg = MIMEMultipart()
        msg["Subject"] = "Monthly Expense Report"
        msg["From"] = "rohinivsenthil@gmail.com"
        msg["To"] = "rv8542@rit.edu"
        part = MIMEText("PFA")
        msg.attach(part)

        part = MIMEApplication(csv_report.getvalue())
        part.add_header(
            "Content-Disposition", "attachment", filename="expense_report.csv"
        )
        msg.attach(part)

        raw_message = {"Data": msg.as_string()}
        response = ses.send_raw_email(
            Source=msg["From"], Destinations=[msg["To"]], RawMessage=raw_message
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


###################
# Alerts APIs
###################


def createAlert(data):
    try:
        topic_arn = data["topic_arn"]
        message = f"Alert: Your expense has exceeded the budget threshold."
        response = sns_client.publish(TopicArn=topic_arn, Message=message)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


###################
# Forecast APIs
###################


def getForecast(table):
    user_id = "1"  # Default user_id
    try:
        ma_weight = 7
        preduction_count = 30

        response = table.scan(FilterExpression=Attr("user_id").eq(user_id))

        values = sorted(
            response["Items"], key=lambda x: x["timestamp"], reverse=True
        )  # sorting by timestamp

        date_label = []
        daily_total = []
        forecast = []

        today = datetime.date.today()
        date = today.strftime("%m/%d/%Y")

        for i in range(preduction_count):
            data = {}

            total = values[i]["value"] if i > 0 else 0
            total_sum = 0
            count = 0

            for j in range(ma_weight):
                try:
                    total_sum += values[i + j]["value"]
                    count += 1
                except Exception:
                    pass

            avg = total_sum / count if count > 0 else 0

            date_label.append(date)
            daily_total.append(total)
            forecast.append(avg)

            date = values[i]["date"]

        result = {
            "label": date_label,
            "amount": daily_total,
            "forecast": forecast
        }

        return generateResponse(200, result)

    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))


###################
# API Handler
###################


def lambda_handler(event, context):
    expenses_table = dynamodb.Table("expenses")
    budgets_table = dynamodb.Table("budgets")
    response = None

    try:
        path = event.get("path")
        method = event.get("httpMethod")

        if path.startswith("/expenses"):
            if path.endswith("/expenses"):
                if method == "POST":
                    response = createExpense(expenses_table, json.loads(event["body"]))
                elif method == "GET":
                    response = viewAllExpenses(expenses_table)
                elif method == "PATCH":
                    response = updateExpense(expenses_table, json.loads(event["body"]))
                elif method == "DELETE":
                    response = deleteExpense(expenses_table, json.loads(event["body"]))
            else:
                expense_id = path.split("/")[-1]
                if method == "GET":
                    response = viewExpense(expenses_table, expense_id)
        elif path.startswith("/budgets"):
            if path.endswith("/budgets"):
                if method == "POST":
                    response = createBudget(budgets_table, json.loads(event["body"]))
                elif method == "GET":
                    response = viewAllBudgets(budgets_table)
                elif method == "PATCH":
                    response = updateBudget(budgets_table, json.loads(event["body"]))
                elif method == "DELETE":
                    response = deleteBudget(budgets_table, json.loads(event["body"]))
        elif path.startswith("/receipts"):
            if method == "POST":
                response = analyze_receipts(expenses_table, event["body"])
        elif path.startswith("/reports"):
            if method == "POST":
                response = createReport(expenses_table)
        elif path.startswith("/alerts"):
            if method == "POST":
                response = createAlert(json.loads(event["body"]))
        elif path.startswith("/forecast"):
            response = getForecast(dynamodb.Table("daily_totals"))

    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
