#!/bin/bash
TASK_FAMILY= "test-definition"
SERVICE_NAME= "test-service"
NEW_DOCKER_IMAGE= "626379456089.dkr.ecr.ap-southeast-2.amazonaws.com/test:${BUILD_NUMBER}"
CLUSTER_NAME= "test-cluster"
OLD_TASK_DEF=$(aws ecs describe-task-definition --task-definition $TASK_FAMILY --output json)
NEW_TASK_DEF=$(echo $OLD_TASK_DEF | jq --arg NDI $NEW_DOCKER_IMAGE '.taskDefinition.containerDefinitions[0].image=$NDI')
FINAL_TASK=$(echo $NEW_TASK_DEF | jq '.taskDefinition|{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions}')
aws ecs register-task-definition --family $TASK_FAMILY --cli-input-json "$(echo $FINAL_TASK)"
aws ecs update-service --service $SERVICE_NAME --task-definition $TASK_FAMILY --cluster $CLUSTER_NAME
