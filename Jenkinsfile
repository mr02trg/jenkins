pipeline {
    agent none
    stages {
        stage ('--- Info ---') {
            agent any 
            steps {
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
				sh 'npm install --prefix ./proj1 && npm run build --prod --prefix ./proj1'
            }
        }
        stage('--- Build Docker Image ---') {
            agent any
            steps {
                echo 'Build docker image'
                sh 'docker build -t test ./proj1/'
                sh 'docker tag test:latest 626379456089.dkr.ecr.ap-southeast-2.amazonaws.com/test:${BUILD_NUMBER}'
            }
        }
    }
}
