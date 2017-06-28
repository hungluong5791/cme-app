#!/bin/bash
CLUSTER="cme-devops-app"
SERVICE="cme-devops-app"
TASK_FAMILY="cme-devops-app"

DOCKER_REGISTRY="768738047170.dkr.ecr.us-east-1.amazonaws.com"
DOCKER_REPO="cme-devops"
DOCKER_TAG="latest"
DOCKER_IMAGE="${DOCKER_REGISTRY}/${DOCKER_REPO}:${DOCKER_TAG}"

CURRENT_TASK=$(aws ecs describe-task-definition --task-definition $TASK_FAMILY --output json)
UPDATED_TASK=$(echo ${CURRENT_TASK} | jq --arg UPDATED_IMAGE ${DOCKER_IMAGE} '.taskDefinition.containerDefinitions[0].image=$UPDATED_IMAGE' | jq '.taskDefinition|{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions}')

aws ecs register-task-definition --family $TASK_FAMILY --cli-input-json "$(echo $UPDATED_TASK)"
aws ecs update-service --service $SERVICE --task-definition $TASK_FAMILY --cluster $CLUSTER