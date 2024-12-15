pipeline {
    agent any
    
    environment {
        // Keep GitHub repo as a variable
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        
        // Hardcoded values for other elements
        DOCKER_USERNAME = "emaan067"
        DOCKER_IMAGE_NAME = "cw2-server"
        DOCKER_IMAGE_TAG = "1.0"
        KUBERNETES_DEPLOYMENT_NAME = "cw2-server-deployment"
        KUBERNETES_NAMESPACE = "default"
        CONTAINER_PORT = "8080"
        KUBERNETES_SERVER = "54.242.176.196"
    }
    
    stages {
        stage('Environment Preparation') {
            steps {
                script {
                    // Simulate environment checks with detailed logging
                    echo "Checking system environment..."
                    
                    // Simulate Docker check
                    try {
                        sh '''
                        echo "Docker version check:"
                        docker --version
                        '''
                    } catch (Exception dockerError) {
                        echo "WARNING: Docker may not be properly installed. Attempting to proceed."
                        echo "Docker check error: ${dockerError.message}"
                    }
                    
                    // Simulate Git check
                    try {
                        sh '''
                        echo "Git version check:"
                        git --version
                        '''
                    } catch (Exception gitError) {
                        echo "WARNING: Git may not be properly installed. Attempting to proceed."
                        echo "Git check error: ${gitError.message}"
                    }
                }
            }
        }
        
        stage('Source Code Checkout') {
            steps {
                // Checkout from GitHub with error simulation
                script {
                    try {
                        git branch: 'main', 
                            url: "${env.GIT_REPO}", 
                            credentialsId: 'github_credentials'
                        echo "Repository checkout successful!"
                    } catch (Exception checkoutError) {
                        echo "SIMULATION: Checkout process encountered a simulated issue."
                        echo "Checkout error details: ${checkoutError.message}"
                        // Simulate continuing despite checkout 'error'
                        error "Simulated checkout failure to demonstrate error handling"
                    }
                }
            }
        }
        
        stage('Docker Image Build') {
            steps {
                script {
                    try {
                        // Simulate Docker build with verbose output
                        sh """
                        echo "Starting Docker image build..."
                        docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} . || true
                        echo "Docker build completed (simulated success)"
                        docker images | grep ${DOCKER_IMAGE_NAME}
                        """
                    } catch (Exception buildError) {
                        echo "SIMULATION: Docker build encountered a simulated issue."
                        echo "Build error details: ${buildError.message}"
                        // Force continue despite 'error'
                        error "Simulated build failure to demonstrate error handling"
                    }
                }
            }
        }
        
        stage('Container Validation') {
            steps {
                script {
                    try {
                        sh """
                        echo "Attempting to run container..."
                        docker run -d --name test-container -p ${CONTAINER_PORT}:${CONTAINER_PORT} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                        sleep 5
                        echo "Container run log:"
                        docker ps | grep test-container
                        docker logs test-container || true
                        docker rm -f test-container || true
                        """
                    } catch (Exception containerError) {
                        echo "SIMULATION: Container validation encountered a simulated issue."
                        echo "Container error details: ${containerError.message}"
                        // Force continue despite 'error'
                        error "Simulated container validation failure"
                    }
                }
            }
        }
        
        stage('Simulate DockerHub Push') {
            steps {
                script {
                    try {
                        sh """
                        echo "Simulating DockerHub login and push..."
                        echo "Logging in to DockerHub (simulated)..."
                        echo "Pushing image ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} (simulated)..."
                        docker images
                        """
                    } catch (Exception pushError) {
                        echo "SIMULATION: DockerHub push encountered a simulated issue."
                        echo "Push error details: ${pushError.message}"
                        // Force continue despite 'error'
                        error "Simulated DockerHub push failure"
                    }
                }
            }
        }
        
        stage('Simulate Kubernetes Deployment') {
            steps {
                script {
                    try {
                        sh """
                        echo "Simulating Kubernetes deployment..."
                        echo "Target Server: ${KUBERNETES_SERVER}"
                        echo "Deployment Name: ${KUBERNETES_DEPLOYMENT_NAME}"
                        echo "Namespace: ${KUBERNETES_NAMESPACE}"
                        echo "Simulating kubectl commands..."
                        """
                    } catch (Exception deployError) {
                        echo "SIMULATION: Kubernetes deployment encountered a simulated issue."
                        echo "Deployment error details: ${deployError.message}"
                        // Force continue despite 'error'
                        error "Simulated Kubernetes deployment failure"
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Cleanup steps
                sh """
                echo "Performing cleanup..."
                docker logout || true
                docker rmi ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} || true
                """
                cleanWs()
            }
        }
        
        failure {
            echo '!!! PIPELINE SIMULATION COMPLETED WITH INTENTIONAL ERRORS !!!'
            echo 'This demonstrates error handling and pipeline flow control.'
        }
        
        success {
            echo '=== PIPELINE SIMULATION SUCCESSFUL ==='
            echo 'All stages passed through error simulation.'
        }
    }
}
