pipeline {
    agent none
    stages {
        stage ('--- Info ---') {
            agent any 
            steps {
                echo 'FETCHING JENKINSFILE FROM ${GIT_URL} : ${GIT_BRANCH}'
                echo 'BUILD_VERSION: ${BUILD_NUMBER}'
            }
        }
        stage('--- Build Node Application ---') {
            agent {
                docker {
                    image 'node:latest'
                }
            }
            environment {
                HOME = '.'
            }
            steps {
                echo 'NPM Build Application ...'
				sh "npm install --prefix ./proj1 && npm run build --prod --prefix ./proj1"
            }
        }
        stage('--- Build Docker Image ---') {
            agent any
            steps {
                echo 'Build docker image'
                sh "docker build -t test ./proj1/"
                sh "docker tag test:latest 626379456089.dkr.ecr.ap-southeast-2.amazonaws.com/test:${BUILD_NUMBER}"
            }
        }
        stage('--- Push to ECR ---') {
            agent any
            steps {
                script {
                    docker.withRegistry("https://626379456089.dkr.ecr.ap-southeast-2.amazonaws.com", "ecr:ap-southeast-2:test-ecr-credentials")
                    {
                        docker.image("626379456089.dkr.ecr.ap-southeast-2.amazonaws.com/test:${BUILD_NUMBER}").push()
                    }                
                }
            }
        }
        stage('--- Deploy to ECS ---') {
            agent any
            environment {
                TASK_FAMILY= "test-definition"
                SERVICE_NAME= "test-service"
                NEW_DOCKER_IMAGE="626379456089.dkr.ecr.ap-southeast-2.amazonaws.com/test:${BUILD_NUMBER}"
                CLUSTER_NAME= "test-cluster"
            }
            steps {
                sh "OLD_TASK_DEF=\$(aws ecs describe-task-definition --task-definition ${env.TASK_FAMILY} --output json)"
                sh "NEW_TASK_DEF=\$(echo $OLD_TASK_DEF | jq --arg NDI ${env.NEW_DOCKER_IMAGE} \'.taskDefinition.containerDefinitions[0].image=$NDI\')"
                sh "FINAL_TASK=\$(echo $NEW_TASK_DEF | jq '.taskDefinition|{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions}')"
                sh "aws ecs register-task-definition --family ${env.TASK_FAMILY} --cli-input-json \"\$(echo $FINAL_TASK)\""
                sh "aws ecs update-service --service ${env.SERVICE_NAME} --task-definition ${env.TASK_FAMILY} --cluster ${env.CLUSTER_NAME}"
            }
        }
    }
}
