import json
import boto3
import os
from collections import Counter

S3_BUCKET = os.getenv("S3_BUCKET", "log-processing")
SQS_QUEUE_URL = os.getenv("SQS_QUEUE_URL")
AWS_ENDPOINT_URL = os.getenv("AWS_ENDPOINT_URL")
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")


def get_s3():
    return boto3.client("s3", endpoint_url=AWS_ENDPOINT_URL, region_name=AWS_REGION)

def get_sqs():
    return boto3.client("sqs", endpoint_url=AWS_ENDPOINT_URL, region_name=AWS_REGION)


def create_resources():
    s3 = get_s3()
    sqs_client = get_sqs()
    try:
        s3.create_bucket(Bucket=S3_BUCKET)
        print(f"[init] created S3 bucket '{S3_BUCKET}'")
    except Exception:
        pass
    try:
        response = sqs_client.create_queue(QueueName="log-processing")
        print("[init] created SQS queue 'log-processing'")
        return response["QueueUrl"]
    except Exception:
        return sqs_client.get_queue_url(QueueName="log-processing")["QueueUrl"]


def parse_log(content: str) -> dict:
    lines = content.strip().splitlines()
    status_codes = Counter()
    ips = Counter()
    urls = Counter()

    for line in lines:
        parts = line.split()
        if len(parts) < 9:
            continue
        ip = parts[0]
        status = parts[8]
        url = parts[6]
        status_codes[status] += 1
        ips[ip] += 1
        urls[url] += 1

    errors = sum(v for k, v in status_codes.items() if k.startswith(("4", "5")))

    return {
        "total_requests": len(lines),
        "error_count": errors,
        "status_codes": dict(status_codes),
        "top_ips": dict(ips.most_common(5)),
        "top_urls": dict(urls.most_common(5)),
    }


def process_message(message: dict):
    body = json.loads(message["Body"])
    job_id = body["job_id"]
    s3_key = body["s3_key"]

    s3 = get_s3()
    obj = s3.get_object(Bucket=S3_BUCKET, Key=s3_key)
    content = obj["Body"].read().decode("utf-8")

    result = parse_log(content)
    result["job_id"] = job_id
    result["status"] = "done"

    s3.put_object(
        Bucket=S3_BUCKET,
        Key=f"results/{job_id}/summary.json",
        Body=json.dumps(result),
    )
    print(f"[done] job {job_id} — {result['total_requests']} lines processed")


def main():
    global SQS_QUEUE_URL
    SQS_QUEUE_URL = create_resources()

    sqs = get_sqs()
    print("Worker started, polling SQS...")

    while True:
        response = sqs.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=10,
        )
        messages = response.get("Messages", [])
        if not messages:
            continue

        message = messages[0]
        try:
            process_message(message)
            sqs.delete_message(
                QueueUrl=SQS_QUEUE_URL,
                ReceiptHandle=message["ReceiptHandle"],
            )
        except Exception as e:
            print(f"[error] {e}")


if __name__ == "__main__":
    main()
