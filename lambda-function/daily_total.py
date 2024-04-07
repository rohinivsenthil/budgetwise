import boto3
import simplejson as json
from boto3.dynamodb.conditions import Key, Attr

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)


def addToDatabase(table, timestamp, value):
    try:
        data = {"timestamp": timestamp, "value": value}
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
    user_data = users_table.query(KeyConditionExpression=Key("user_id").eq(user_id))

    daily_total_table = dynamodb.Table(user_data["Items"][0]["daily_total_table"])

    expenses_table = dynamodb.Table(user_data["Items"][0]["expenses_table"])

    response = None

    try:
        # get last updated date
        latest_entry = daily_total_table.scan(Limit=1)

        if len(latest_entry["Items"]) == 1:
            latest_date = latest_entry["Items"][0]["timestamp"]
        else:
            latest_date = None

        if latest_date != None:
            # get all latest entries after the timestamp
            entries = expenses_table.scan(
                FilterExpression=Attr("timestamp").gt(latest_date)
            )
        else:
            # get all the records for the user
            entries = expenses_table.scan()

        sum = {}
        for item in entries["Items"]:
            timestamp = item["timestamp"]

            if timestamp in sum:
                sum[timestamp] += item["value"]
            else:
                sum[timestamp] = item["value"]

        for timestamp, value in sum.items():
            addToDatabase(daily_total_table, timestamp, value)

        response = generateResponse(200, "Success")

    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
