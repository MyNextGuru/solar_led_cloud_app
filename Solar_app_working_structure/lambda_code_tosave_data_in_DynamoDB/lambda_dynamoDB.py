import json
import boto3
import datetime
from decimal import Decimal
from botocore.exceptions import ClientError

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('fetch_data_flutter')

def lambda_handler(event, context):
    # ✅ Step 0: Handle CORS Preflight (OPTIONS) Request
    if event.get("httpMethod") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "OPTIONS,POST"
            },
            "body": json.dumps("CORS preflight OK")
        }

    try:
        # Step 1: Get and validate the request body
        raw_body = event.get('body')
        if not raw_body:
            return {
                'statusCode': 400,
                'headers': {"Access-Control-Allow-Origin": "*"},
                'body': json.dumps({'error': 'Empty request body'})
            }

        # Step 2: Parse JSON body (string or dict)
        body = raw_body if isinstance(raw_body, dict) else json.loads(raw_body)
        print("Parsed body:", body)  # For CloudWatch debugging

        # Step 3: Extract required fields
        user_id = body.get('UniqueUserId')
        tag_name = body.get('TagName')

        if not user_id or not tag_name:
            return {
                'statusCode': 400,
                'headers': {"Access-Control-Allow-Origin": "*"},
                'body': json.dumps({'error': 'UniqueUserId and TagName are required'})
            }

        # Step 4: Create timestamp and sort key
        timestamp_str = datetime.datetime.utcnow().strftime('%Y%m%d%H%M%S')
        sort_key = f"{timestamp_str}_{tag_name}"

        # Step 5: Prepare DynamoDB item
        item = {
            'userid': user_id,
            'timestamp_tag': sort_key,
            'NumberOfDevices': Decimal(str(body.get('NumberOfDevices', 1))),
            'DeviceVersion': body.get('DeviceVersion', ''),
            'DeviceType': body.get('DeviceType', ''),
            'RMSEnabled': body.get('RMSEnabled', False),
            'Brightness': Decimal(str(body.get('Brightness', 0.0))),
            'SolarPanelVoltage': Decimal(str(body.get('SolarPanelVoltage', 0.0))),
            'SolarPanelPower': Decimal(str(body.get('SolarPanelPower', 0.0))),
            'BatteryVoltage': Decimal(str(body.get('BatteryVoltage', 0.0))),
            'LoadLedPower': Decimal(str(body.get('LoadLedPower', 0.0))),
            'ConfigurationTimestamp': datetime.datetime.utcnow().isoformat() + 'Z'
        }

        # Conditionally add APNEndpoint if RMS is enabled
        if item['RMSEnabled'] and 'APNEndpoint' in body:
            item['APNEndpoint'] = body['APNEndpoint']

        # Step 6: Save item to DynamoDB
        table.put_item(Item=item)

        # Step 7: Return success response
        return {
            'statusCode': 200,
            'headers': {"Access-Control-Allow-Origin": "*"},
            'body': json.dumps({
                'message': 'Configuration saved successfully',
                'TagName': tag_name,
                'UserId': user_id,
                'ConfigurationId': sort_key
            })
        }

    # Error handling
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'headers': {"Access-Control-Allow-Origin": "*"},
            'body': json.dumps({'error': 'Invalid JSON payload'})
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'headers': {"Access-Control-Allow-Origin": "*"},
            'body': json.dumps({'error': f'DynamoDB error: {str(e)}'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {"Access-Control-Allow-Origin": "*"},
            'body': json.dumps({'error': f'Server error: {str(e)}'})
        }
