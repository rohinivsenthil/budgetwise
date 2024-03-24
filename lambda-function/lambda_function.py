import boto3
import simplejson as json
from boto3.dynamodb.conditions import Key

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)

def createExpense(table, data):
    try:
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])
        
def viewAllExpenses(table):
    try:
        response = table.scan()
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])
        
def viewExpense(table, expense_id):
    try:
        response = table.query(
            KeyConditionExpression = Key("expense_id").eq(expense_id)
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])

def deleteExpense(table, expense_id):
    try:
        response = table.delete_item(
            Key={"expense_id": expense_id}
        )
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])
        
def updateExpense(table, data):
    try:
        response = table.put_item(Item=data)
        return generateResponse(200, response)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])

def generateResponse(statusCode, body):
    return {
        "statusCode": statusCode,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }

def lambda_handler(event, context):
    # get user_id from the event
    user_id = "user1"
    
    # creating users table object
    users_table = dynamodb.Table("Users")

    # getting the user from the Users table
    user_data = users_table.query(
            KeyConditionExpression = Key("user_id").eq(user_id)
        )
        
    expenses_table = dynamodb.Table(user_data["Items"][0]["expenses_table"])

    response = None

    try:
        path = event.get("path")
        method = event.get("httpMethod")
        
        if path.startswith("/expenses"):
            if path.endswith("/expenses"):
                if method == "POST":
                    # do create expense
                    response = createExpense(expenses_table, json.loads(event["body"]))
                elif method == "GET":
                    # do get all expenses
                    response = viewAllExpenses(expenses_table)
            else:
                expense_id = int(path.split("/")[-1])
                if method == "GET":
                    # do get expense
                    response = viewExpense(expenses_table, expense_id)
                elif method == "DELETE":
                    # do delete expense
                    response = deleteExpense(expenses_table, expense_id)
                elif method == "PATCH":
                    # do update expense
                    response = updateExpense(expenses_table, json.loads(event["body"]))
        
    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
