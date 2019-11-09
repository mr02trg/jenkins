pipeline {
    agent none
    stages {
        stage('Build Node Application') {
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
        stage('Build Docker Image') {
            agent any
            steps {
                echo 'Build docker image'
                sh 'docker build -t jproj1 ./proj1/'
            }
        }
    }
}
