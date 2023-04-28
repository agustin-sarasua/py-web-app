# Variables
IMAGE_NAME = py-web-app
IMAGE_TAG = latest
AWS_REGION = us-east-1
ECR_REPO_NAME = my-ecr-repo
AWS_ACCOUNT_ID = 695251250319


# 
DEPLOYMENT_NAME = app3-deployment
DEPLOYMENT_POD_NAME = app3
NAMESPACE = app3

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

# Update the Kubernetes deployment with the new image
update:
	kubectl set image deployment/$(DEPLOYMENT_NAME) $(DEPLOYMENT_POD_NAME)=$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO_NAME):$(IMAGE_TAG) -n $(NAMESPACE)

# Rollout the Kubernetes deployment
rollout:
	kubectl rollout restart deployment/$(DEPLOYMENT_NAME) -n $(NAMESPACE)


# Run all the steps
deploy: build tag push clean
