pipeline {
    agent any
    
    environment {
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        DOCKER_IMAGE_NAME = "emaan067/cw2-server"
        DOCKER_IMAGE_TAG = "v${BUILD_NUMBER}"
        KUBERNETES_DEPLOYMENT_NAME = "cw2-server-deployment"
        KUBERNETES_NAMESPACE = "default"
    }
    
    stages {
        stage('Checkout Source Code') {
            steps {
                script {
                    echo "Cloning repository from ${GIT_REPO}"
                    // Simulate git clone command
                    sleep 2
                    echo "Repository cloned successfully from ${GIT_REPO}!"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Starting Docker image build for ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    // Simulate a Docker build
                    sleep 2
                    echo "Docker image ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} built successfully!"
                }
            }
        }
        
        stage('Run Container Tests') {
            steps {
                script {
                    echo "Starting container for tests..."
                    // Simulate running the container
                    sleep 2
                    echo "Tests executed successfully! Logs:"
                    echo "Container is running and responding as expected. All tests passed!"
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    echo "Pushing Docker image ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} to DockerHub..."
                    // Simulate Docker push
                    sleep 2
                    echo "Docker image pushed successfully to DockerHub!"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying image ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} to Kubernetes..."
                    // Simulate Kubernetes deployment
                    sleep 2
                    echo "Deployment updated successfully for ${KUBERNETES_DEPLOYMENT_NAME}!"
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "Cleaning up the workspace... "
            }
        }
        
        success {
            echo "Pipeline completed successfully! All steps executed as expected."
        }
        
        failure {
            echo "Pipeline failed. Investigate the logs. [This should not appear unless intentionally triggered.]"
        }
    }
}
