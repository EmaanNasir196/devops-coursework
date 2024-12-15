pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub_credentials') // DockerHub credentials
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        IMAGE_NAME = "emaan067/cw2-server"
        IMAGE_TAG = "1.0"
    }
    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Check and install Docker if not found
                    try {
                        sh "docker --version || sudo apt-get update && sudo apt-get install -y docker.io && sudo usermod -aG docker jenkins"
                        echo "Docker is installed and configured."
                    } catch (Exception e) {
                        error "Failed to install Docker: ${e.message}"
                    }

                    // Check and install Git if not found
                    try {
                        sh "git --version || sudo apt-get update && sudo apt-get install -y git"
                        echo "Git is installed and configured."
                    } catch (Exception e) {
                        error "Failed to install Git: ${e.message}"
                    }
                }
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}", credentialsId: 'github_credentials'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    } catch (Exception e) {
                        error "Docker build failed: ${e.message}"
                    }
                }
            }
        }
        stage('Test Container Launch') {
            steps {
                script {
                    try {
                        sh '''
                        docker run -d --name cw2-test -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 5 # Give the container time to start
                        curl -f http://localhost:8080 || (echo "App not responding" && exit 1)
                        docker rm -f cw2-test
                        '''
                    } catch (Exception e) {
                        error "Test container launch failed: ${e.message}"
                    }
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    script {
                        try {
                            sh '''
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                            '''
                        } catch (Exception e) {
                            error "Docker push failed: ${e.message}"
                        }
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    try {
                        sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@54.242.176.196 \
                        "kubectl set image deployment/cw2-server-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG} && kubectl rollout status deployment/cw2-server-deployment"
                        '''
                    } catch (Exception e) {
                        error "Kubernetes deployment failed: ${e.message}"
                    }
                }
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
