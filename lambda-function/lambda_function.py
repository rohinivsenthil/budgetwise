import boto3
import uuid
import json
from boto3.dynamodb.conditions import Key
from decimal import Decimal

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)
textract = boto3.client('textract')

###################
# Expenses APIs
###################

def createExpense(table, data):
    user_id = "1"  # Default user_id
    try:
        data["expense_id"] = str(uuid.uuid4())
        data["user_id"] = user_id
        data["amount"] = Decimal(str(data["amount"]))  # Convert amount to Decimal
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))
        
def viewAllExpenses(table):
    user_id = "1"  # Default user_id
    try:
        response = table.query(
            IndexName="user_id-index",
            KeyConditionExpression=Key("user_id").eq(user_id)
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))

def viewExpense(table, expense_id):
    try:
        response = table.query(
            KeyConditionExpression=Key("expense_id").eq(expense_id)
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))

def deleteExpense(table, data):
    try:
        expense_id = data["expense_id"]
        response = table.delete_item(
            Key={"expense_id": expense_id}
        )
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
            IndexName="user_id-index",
            KeyConditionExpression=Key("user_id").eq(user_id)
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, str(e))
    
def deleteBudget(table, data):
    try:
        budget_id = data["budget_id"]
        response = table.delete_item(
            Key={"budget_id": budget_id}
        )
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
        "headers": {"Content-Type": "application/json", 'Access-Control-Allow-Origin' : '*'},
        "body": json.dumps(body, default=convert_decimal),
    }

###################
# Receipts APIs
###################

def analyze_receipts(table, receipt_file):
    try:
        # Call Amazon Textract to analyze the receipt file
        response = textract.analyze_document(Document={'Bytes': receipt_file.read()}, FeatureTypes=["FORMS"])
        
        # Extracting amount from Textract response
        amount = None
        for item in response['Blocks']:
            if item['BlockType'] == 'LINE' and 'Amount' in item['Text']:
                amount_text = item['Text'].replace('$', '').replace(',', '').strip()
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
                response = analyze_receipts(expenses_table, event['body'])
        
    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
