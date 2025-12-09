import os
import json
import boto3
import time
from datetime import datetime
from botocore.exceptions import ClientError

# Environment variables
AWS_REGION = os.environ.get('AWS_REGION', 'us-east-1')
SQS_QUEUE_URL = os.environ.get('SQS_QUEUE_URL')
S3_BUCKET_NAME = os.environ.get('S3_BUCKET_NAME')
POLL_INTERVAL = int(os.environ.get('POLL_INTERVAL', '1'))

# AWS clients
sqs_client = boto3.client('sqs', region_name=AWS_REGION)
s3_client = boto3.client('s3', region_name=AWS_REGION)

def process_message(message):
    """Process a single SQS message and upload to S3"""
    try:
        # Parse message body
        email_data = json.loads(message['Body'])
        
        # Extract data from email_data
        sender = email_data.get("email_sender", "unknown")
        subject = email_data.get('email_subject', 'no-subject').replace(' ', '-').replace('/', '-')
        timestream = email_data.get('email_timestream')
        # Convert timestream (unix timestamp) to readable date format (YYYY-MM-DD-HH-MM-SS)
        timestamp_int = int(timestream)
        readable_date = datetime.utcfromtimestamp(timestamp_int).strftime('%Y-%m-%d-%H-%M-%S')
        
        s3_key = f"emails/{sender}/{readable_date}-{subject}.json"
        
        # Upload to S3
        s3_client.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=s3_key,
            Body=json.dumps(email_data, indent=2),
            ContentType='application/json'
        )
        
        print(f"Uploaded to S3: {s3_key}")
        
        # Delete message from queue
        sqs_client.delete_message(
            QueueUrl=SQS_QUEUE_URL,
            ReceiptHandle=message['ReceiptHandle']
        )
        
        return True
    
    except json.JSONDecodeError as e:
        print(f"Error parsing message: {e}")
        return False
    except ClientError as e:
        print(f"Error processing message: {e}")
        return False
    except Exception as e:
        print(f"Unexpected error: {e}")
        return False


def poll_sqs():
    """Poll SQS queue for messages"""
    try:
        response = sqs_client.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=5,
            WaitTimeSeconds=10,
            VisibilityTimeout=30
        )
        
        messages = response.get('Messages', [])
        
        if messages:
            for message in messages:
                process_message(message)
        else:
            print("No messages in queue")
    
    except ClientError as e:
        print(f"Error polling SQS: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")


if __name__ == '__main__':
    print(f"Starting SQS consumer...")
    print(f"Queue URL: {SQS_QUEUE_URL}")
    print(f"S3 Bucket: {S3_BUCKET_NAME}")
    
    while True:
        poll_sqs()
        time.sleep(POLL_INTERVAL)# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
