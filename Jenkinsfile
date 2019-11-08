pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building docker image ...'
                sh 'docker build -t jproj1 ./proj1/'
                sh 'docker build -t jproj2 ./proj2/'
            }
        }
    }
}
