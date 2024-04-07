import boto3
import simplejson as json
from boto3.dynamodb.conditions import Key, Attr

region = "us-east-2"

dynamodb = boto3.resource("dynamodb", region_name=region)


def generateResponse(statusCode, body):
    return {
        "statusCode": statusCode,
        "headers": {"Content-Type": "application/json"},
        "body": body,
    }


def lambda_handler(event, context):
    # get user_id from the event
    user_id = "user1"

    # creating users table object
    users_table = dynamodb.Table("Users")

    # getting the user from the Users table
    user_data = users_table.query(KeyConditionExpression=Key("user_id").eq(user_id))

    daily_total_table = dynamodb.Table(user_data["Items"][0]["daily_total_table"])

    response = None
    
    ma_count = 7
    entry_count = 7

    try:
        values = daily_total_table.scan(Limit=(ma_count + entry_count - 1))
        print(values)
        
        data = {}
        
        for i in range(entry_count):
            sum = 0
            count = 0
            for j in range(ma_count):
                sum += values["Items"][i + j]["value"]
                count += 1
                
            avg = sum / count
            data[i] = avg
            
        response = generateResponse(200, data)

    except Exception as e:
        print("Error:", e)
        response = generateResponse(400, "Error processing request")

    return response
