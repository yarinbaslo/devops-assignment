import os
import json
from datetime import datetime
import boto3
from flask import Flask, request, jsonify
from botocore.exceptions import ClientError

app = Flask(__name__)

# Environment variables
AWS_REGION = os.environ.get("AWS_REGION", "us-east-1")
SQS_QUEUE_URL = os.environ.get("SQS_QUEUE_URL")
SSM_TOKEN_PARAM = os.environ.get("SSM_PARAMETER_NAME", "/devops-assignment/token")

# AWS clients
sqs = boto3.client("sqs", region_name=AWS_REGION)
ssm = boto3.client("ssm", region_name=AWS_REGION)


def get_token_from_ssm():
    try:
        param = ssm.get_parameter(Name=SSM_TOKEN_PARAM, WithDecryption=True)
        return param["Parameter"]["Value"]
    except Exception as e:
        app.logger.error(f"Could not retrieve token from SSM: {e}")
        return None

def validate_token(request_token):
    expected = get_token_from_ssm()

    if expected is None:
        return False

    return request_token == expected


def validate_timestream(ts):
    try:
        ts_int = int(ts)
        datetime.utcfromtimestamp(ts_int)
        return True
    except Exception:
        return False


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy"}), 200

@app.route("/validate-and-publish", methods=["POST"])
def validate_and_publish():
    try:
        body = request.get_json()

        if not body:
            return jsonify({"error": "Invalid JSON body"}), 400

        token = body.get("token")
        email_data = body.get("data")

        if not token:
            return jsonify({"error": "Missing token"}), 400

        if not email_data:
            return jsonify({"error": "Missing data"}), 400

        timestamp = email_data.get("email_timestream")
        if not timestamp:
            return jsonify({"error": "Missing email_timestream"}), 400

        if not validate_token(token):
            return jsonify({"error": "Invalid token"}), 401

        if not validate_timestream(timestamp):
            return jsonify({"error": "Invalid email_timestream"}), 400

        # Publish message to SQS
        try:
            sqs.send_message(
                QueueUrl=SQS_QUEUE_URL,
                MessageBody=json.dumps(email_data)
            )
            app.logger.info(f"Message published to SQS: {email_data.get('email_subject', 'unknown')}")
            return jsonify({
                "status": "success",
                "message": "Data validated and published to SQS"
            }), 200

        except ClientError as e:
            app.logger.error(f"Error publishing to SQS: {e}")
            return jsonify({"error": "Failed to send to SQS"}), 500

    except Exception as e:
        app.logger.error(f"Unexpected error: {e}")
        return jsonify({"error": "Internal server error"}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
# Trigger
