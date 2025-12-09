# DevOps Assignment

This project implements two Docker-based microservices deployed on AWS ECS Fargate, using an Application Load Balancer, S3, and SQS.  
The infrastructure is fully automated using **Terraform**, and the deploy pipeline is automated using **GitHub Actions CI/CD**.

---

## Architecture Overview

### **Microservice 1 (API Gateway Service)**
- Exposed through an **Application Load Balancer (ALB)**
- Validates:
  - Token (retrieved securely from **SSM Parameter Store**)
  - Timestamp format (`email_timestream`)
- After validation publishes the request JSON into **SQS Queue**

### **Microservice 2 (Worker Service)**
- Continuously polls SQS
- Saves each message into S3 under:
  ```
  emails/{sender}/{timestamp}-{subject}.json
  ```

---

##  instructions 

```bash
git clone https://github.com/yarinbaslo/devops-assignment.git
cd devops-assignment
./setup.sh
```

This script will:

1. Validate dependencies  
2. Generate `terraform.tfvars` automatically  ( Update values as needed )
3. Deploying Infrastructure using Terraform
5. Print the deployment outputs:
   - ALB URL  
   - S3 bucket name  
   - SQS queue URL  
   - ECS cluster and service names  

6. Configuration of GitHub Secrets:
  - AWS_ACCESS_KEY_ID  
  - AWS_SECRET_ACCESS_KEY
7. A dummy commit that triggers both CI and CD pipelines automatically
---

## Testing the System

After infrastructure is deployed, get ALB DNS from Terraform output.
Example request to Microservice 1:

```bash
curl -X POST http://<ALB-DNS>/validate-and-publish \
  -H "Content-Type: application/json" \
  -d '{
    "token": "mysecret123!",
    "data": {
      "email_sender": "john",
      "email_subject": "Hello",
      "email_timestream": 1700000000,
      "email_content": "This is a test message"
    }
  }'
```

Example for invalid request :

```bash
curl -X POST http://<ALB-DNS>/validate-and-publish \
  -H "Content-Type: application/json" \
  -d '{
    "token": "mysecret123!",
  }'
```


### Expected Flow
1. MS1 validates token & timestamp
2. Publishes JSON to SQS
3. MS2 reads from SQS 
4. MS2 uploads to S3:
   ```
   emails/john/2023-10-14-12-00-00-Hello.json
   ```

### Logs
View logs in **CloudWatch → Log groups**:
- `/ecs/ms1`
- `/ecs/ms2`

---

##  CI/CD Overview

### CI Pipeline
- Triggered on changes inside `microservice1/` or `microservice2/`
- Builds Docker image
- Pushes image to ECR

### CD Pipeline
- Updates ECS Task Definition with the new image tag
- Forces ECS Service Deployment

---

### Cleanup
- run 'terraform destroy'

---

## Summary

This project demonstrates:
- ECS Fargate microservices architecture  
- SQS async pipelines  
- S3 data storage automation  
- Secure token handling with SSM  
- Complete CI/CD build & deploy pipeline  
- Fully provisioned AWS environment via Terraform  

Everything runs automatically once configured.

---
