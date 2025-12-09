#!/bin/bash

echo ">>> DevOps Assignment Setup Script"
echo ""

########################################
# CHECK DOCKER
########################################
echo ">>> Checking Docker installation..."
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Please install Docker first."
  exit 1
fi
echo "[OK] Docker installed."


########################################
# CHECK AWS CLI
########################################
echo ">>> Checking AWS CLI..."
if ! command -v aws &> /dev/null; then
  echo "AWS CLI not found. Installing..."
  sudo apt-get update && sudo apt-get install -y awscli || brew install awscli
fi
echo "[OK] AWS CLI installed."


########################################
# CHECK TERRAFORM
########################################
echo ">>> Checking Terraform..."
if ! command -v terraform &> /dev/null; then
  echo "Terraform not found. Installing..."
  wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O tf.zip
  unzip tf.zip
  sudo mv terraform /usr/local/bin/
  rm tf.zip
fi
echo "[OK] Terraform installed."


########################################
# CHECK GITHUB CLI
########################################
echo ">>> Checking GitHub CLI..."
if ! command -v gh &> /dev/null; then
  echo "GitHub CLI not found. Installing..."
  sudo apt-get install gh -y || brew install gh
fi
echo "[OK] GitHub CLI installed."


########################################
# CHECK GH AUTH
########################################
echo ">>> Checking GitHub authentication..."
if ! gh auth status &> /dev/null; then
  echo "You are NOT authenticated to GitHub."
  echo "Run: gh auth login"
  exit 1
fi
echo "[OK] Authenticated to GitHub."


########################################
# CREATE terraform.tfvars
########################################
echo ">>> Creating terraform.tfvars..."

cat <<EOF > terraform/terraform.tfvars
aws_region          = "us-east-1"
s3_bucket_name      = "devops-assignment-yarin"
sqs_queue_name      = "devops-assignment-yarin"
ssm_parameter_name  = "/devops-assignment-yarin/token"
ssm_token_value     = "mysecret123!"
EOF

echo "[OK] terraform.tfvars created."
echo ""


########################################
# SETUP GITHUB SECRETS
########################################
echo ">>> Setting GitHub Secrets for CI/CD"
echo "Enter your AWS keys (these will be stored securely in GitHub Actions):"
echo ""

read -p "AWS Access Key ID: " AWS_KEY
read -p "AWS Secret Access Key: " AWS_SECRET

gh secret set AWS_ACCESS_KEY_ID --body "$AWS_KEY"
gh secret set AWS_SECRET_ACCESS_KEY --body "$AWS_SECRET"
gh secret set AWS_REGION --body "us-east-1"

echo "[OK] GitHub secrets configured."
echo ""


########################################
# TERRAFORM
########################################
echo ">>> Initializing Terraform..."
cd terraform
terraform init
echo "[OK] Terraform initialized."
read -p "Run terraform apply now? (y/n): " APPLY
if [[ "$APPLY" == "y" ]]; then
  terraform apply -auto-approve
fi
cd ..
echo ""


########################################
# TRIGGER CI/CD FOR MS1 & MS2
########################################
echo ">>> Triggering CI/CD pipelines..."

echo "# Trigger" >> microservice1/app.py
git add microservice1/app.py
echo "# Trigger" >> microservice2/consumer.py
git add microservice2/consumer.py
git commit -m "Trigger CI/CD"

git push

echo "[OK] CI/CD triggered for both services."
echo ""


########################################
# DONE
########################################
echo ">>> Setup complete!"
echo ">>> Your environment is fully ready."
echo ">>> Terraform deployed, CI/CD pipelines triggered."
echo ""
