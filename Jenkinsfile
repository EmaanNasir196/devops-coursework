pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-credentials-id') // Set in Jenkins Credentials
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        IMAGE_NAME = "emaan067/cw2-server"
        IMAGE_TAG = "1.0"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        stage('Test Container Launch') {
            steps {
                sh "docker run -d --name cw2-test -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "sleep 5" // give the container time to start
                sh "curl -f http://localhost:8080 || (echo 'App not responding' && exit 1)"
                sh "docker rm -f cw2-test"
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                }
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // Update the image in the existing deployment
                sh "ssh -o StrictHostKeyChecking=no ubuntu@<PRODUCTION_SERVER_PUBLIC_IP> 'kubectl set image deployment/cw2-server-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG}'"
                // Optionally check rollout status
                sh "ssh -o StrictHostKeyChecking=no ubuntu@<PRODUCTION_SERVER_PUBLIC_IP> 'kubectl rollout status deployment/cw2-server-deployment'"
            }
        }
    }
    post {
        always {
            sh "docker logout"
        }
    }
}
