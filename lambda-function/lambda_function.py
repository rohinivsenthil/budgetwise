import boto3
import uuid
import json
from boto3.dynamodb.conditions import Key
from decimal import Decimal

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)

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

def generateResponse(statusCode, body):
    # Convert Decimal to float if needed
    def convert_decimal(obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return obj

    return {
        "statusCode": statusCode,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body, default=convert_decimal),
    }

def lambda_handler(event, context):
    expenses_table = dynamodb.Table("expenses")
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
        
    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
