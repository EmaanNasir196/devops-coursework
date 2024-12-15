pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        IMAGE_NAME = "emaan067/cw2-server"
        IMAGE_TAG = "1.0"
    }
    
    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    // Ensure Docker is available
                    sh 'docker version || true'
                    sh 'git version || true'
                }
            }
        }
        
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: "${env.GIT_REPO}", 
                    credentialsId: 'github_credentials'
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
        
        stage('Container Validation') {
            steps {
                script {
                    try {
                        sh '''
                        docker run -d --name test-container -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 10
                        docker ps | grep test-container
                        docker rm -f test-container
                        '''
                    } catch (Exception e) {
                        error "Container validation failed: ${e.message}"
                    }
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    try {
                        sh '''
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        '''
                    } catch (Exception e) {
                        error "DockerHub push failed: ${e.message}"
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
                        "kubectl set image deployment/cw2-server-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG} && \
                        kubectl rollout status deployment/cw2-server-deployment"
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
                // Cleanup steps
                sh 'docker logout || true'
                cleanWs()
            }
        }
        
        failure {
            echo 'Pipeline failed. Check the logs for more information.'
        }
        
        success {
            echo 'Pipeline completed successfully!'
        }
    }
}
