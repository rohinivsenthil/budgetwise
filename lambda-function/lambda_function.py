import boto3, json

region = "us-east-2"
user_meta_table = "user_meta"

dynamodb = boto3.resource("dynamodb", region_name=region)


def createExpense():
    pass


def viewAllExpense():
    pass


def viewSingleExpense():
    pass


def deleteExpense():
    pass


def updateExpense():
    pass


def createBudget():
    pass


def viewBudget():
    pass


def updateBudget():
    pass


def deleteBudget():
    pass


def lambda_handler(event, context):
    # loading user's metadata to get the collection name
    user_meta = dynamodb.Table(user_meta_table)

    # get the collection name from user_meta
    user_collection = user_meta.get_item(Key={"user_id": {"S": event.get("user_id")}})
