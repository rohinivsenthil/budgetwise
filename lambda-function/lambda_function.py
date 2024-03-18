import boto3, json, uuid

region = "us-east-2"
user_meta_table = "user_meta"

dynamodb = boto3.resource("dynamodb", region_name=region)

# Expense Table creation
table = dynamodb.Table('expense_table')

def createExpense(name, category, value):
    try:
        expense_item = {
            "id": str(uuid.uuid4()), 
            "name": name,
            "category": category,
            "value": value
        }
        response = table.put_item(Item=expense_item)
        body = {"Operation": "CREATE", "Message": "Expense created", "Item": response}
        return generateResponse(200, body)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])

def deleteExpense(id):
    try:
        response = table.delete_item(Key={"id": id})
        body = {"Operation": "DELETE", "Message": "Expense deleted", "Item": response}
        return generateResponse(200, body)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])


def updateExpense(id, name, category, value):
    try:
        # add update values
        response = table.delete_item(Key={"id": id})
        body = {"Operation": "PATCH", "Message": "Expense updated", "Item": response}
        return generateResponse(200, body)
    except Exception as e:
        print("Error:", e)
        return generateResponse(400, e.response["Error"]["Message"])


def createBudget():
    pass


def viewBudget():
    pass


def updateBudget():
    pass


def deleteBudget():
    pass


def generateResponse(statusCode, body):
    return {
        "statusCode": statusCode,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }


def lambda_handler(event, context):
    # loading user's metadata to get the collection name
    user_meta = dynamodb.Table(user_meta_table)

    # get the collection name from user_meta
    user_collection = user_meta.get_item(Key={"user_id": {"S": event.get("user_id")}})

    response = None

    try:
        path = event.get("path")
        method = event.get("httpMethod")
        
        # Path for GET method with params
        path_resource= event['resource']
        
        if path == "/expenses" and method == "DELETE":
            body = json.load(event["body"])
            response = deleteExpense(body["expense_id"])
        elif path == "/expenses" and method == "PATCH":
            body = json.load(event["body"])
            response = updateExpense(
                body["id"], body["name"], body["category"], body["value"]
            )
        elif path == "/expenses" and method == "POST":
            body = json.loads(event["body"])
            name = body.get("name")
            category = body.get("category")
            value = body.get("value")
            response = createExpense(name, category, value)

    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
