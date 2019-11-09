pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building docker image ...'
				sh 'npm install --prefix ./proj1 && npm run build --prod --prefix ./proj1'
                sh 'docker build -t jproj1 ./proj1/'
            }
        }
    }
}
