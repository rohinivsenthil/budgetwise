import boto3
import uuid
import json
import datetime
from boto3.dynamodb.conditions import Key, Attr

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)


def addToDatabase(table, user_id, timestamp, value):
    try:
        data = {}
        data["daily_total_id"] = str(uuid.uuid4())
        data["user_id"] = user_id
        data["timestamp"] = timestamp
        data["value"] = value
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
    expenses_table = dynamodb.Table("expenses")
    daily_totals_table = dynamodb.Table("daily_total")
    user_ids = ["user1"]  # temporary user id
    response = None

    try:
        for user_id in user_ids:
            # get last updated date
            latest_entry = daily_totals_table.scan(
                FilterExpression=Attr("user_id").eq(user_id)
            )["Items"][0]

            if len(latest_entry["Items"]) == 1:
                latest_date = latest_entry["date"]
            else:
                latest_date = None

            if latest_date != None:
                # get all latest entries after the timestamp
                entries = expenses_table.scan(
                    FilterExpression=Attr("date").gt(latest_date)
                )
            else:
                # get all the records for the user
                entries = expenses_table.scan()

            sum = {}
            for item in entries["Items"]:
                timestamp = item["date"]

                if timestamp in sum:
                    sum[timestamp] += item["value"]
                else:
                    sum[timestamp] = item["value"]

            for timestamp, value in sum.items():
                addToDatabase(daily_totals_table, user_id, timestamp, value)

            response = generateResponse(200, "Success")

    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response