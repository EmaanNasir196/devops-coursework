pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub_credentials') // Use correct DockerHub credentials ID
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        IMAGE_NAME = "emaan067/cw2-server"
        IMAGE_TAG = "1.0"
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: 'main', url: "${env.GIT_REPO}", credentialsId: 'github_credentials'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        stage('Test Container Launch') {
            steps {
                sh '''
                docker run -d --name cw2-test -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                sleep 5 # Give the container time to start
                curl -f http://localhost:8080 || (echo "App not responding" && exit 1)
                docker rm -f cw2-test
                '''
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh '''
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no ubuntu@54.242.176.196 \
                "kubectl set image deployment/cw2-server-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG} && kubectl rollout status deployment/cw2-server-deployment"
                '''
            }
        }
    }
    post {
        always {
            script {
                try {
                    sh "docker logout"
                } catch (Exception e) {
                    echo "Docker logout failed or not found, skipping..."
                }
            }
        }
    }
}
