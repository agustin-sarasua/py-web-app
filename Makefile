# Variables
IMAGE_NAME = py-web-app
IMAGE_TAG = latest
AWS_REGION = us-east-1
ECR_REPO_NAME = my-ecr-repo
AWS_ACCOUNT_ID = 695251250319

# Build and tag the Docker image
build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

tag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO_NAME):$(IMAGE_TAG)

# Push the Docker image to ECR
push:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO_NAME):$(IMAGE_TAG)

# Clean up the Docker image
clean:
	docker image rm $(IMAGE_NAME):$(IMAGE_TAG)

# Apply Terraform changes
terraform-apply:
	cd terraform && \
	terraform init && \
	terraform apply

# Run all the steps
deploy: build tag push clean
