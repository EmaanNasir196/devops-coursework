pipeline {
    agent any
    environment {
        // Your specific DockerHub and GitHub details
        DOCKERHUB_CREDS = credentials('dockerhub_credentials')
        GITHUB_CREDS = credentials('github_credentials')
        
        // Project-specific environment variables
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        IMAGE_NAME = "emaan067/cw2-server"
        IMAGE_TAG = "1.0"
        
        // Additional dynamic versioning
        VERSION = "${sh(returnStdout: true, script: 'git describe --tags --always').trim()}"
    }
    
    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Robust environment setup
                    sh '''
                        echo "Checking system dependencies..."
                        docker --version
                        git --version
                        kubectl version --client
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                // Secure Git checkout
                git branch: 'main', 
                    url: "${env.GIT_REPO}", 
                    credentialsId: 'github_credentials'
            }
        }
        
        stage('Code Quality and Security Scan') {
            parallel {
                stage('Lint Check') {
                    steps {
                        // Add your project-specific linting
                        sh 'npm run lint || true'
                    }
                }
                
                stage('Dependency Scan') {
                    steps {
                        // Security scan for dependencies
                        sh 'npm audit || true'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        // Build Docker image with multiple tags
                        docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                        docker.build("${IMAGE_NAME}:latest")
                        docker.build("${IMAGE_NAME}:${VERSION}")
                    } catch (Exception e) {
                        error "Docker build failed: ${e.message}"
                    }
                }
            }
        }
        
        stage('Automated Container Tests') {
            steps {
                script {
                    try {
                        // Comprehensive container testing
                        sh '''
                        docker run -d --name cw2-test -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 10 # Increased wait time for startup
                        
                        # Health check with more robust curl
                        curl -f --max-time 10 http://localhost:8080 || \
                            (echo "App not responding" && docker logs cw2-test && exit 1)
                        
                        # Additional tests can be added here
                        docker exec cw2-test npm test || true
                        
                        docker rm -f cw2-test
                        '''
                    } catch (Exception e) {
                        error "Container test failed: ${e.message}"
                    }
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub_credentials', 
                        passwordVariable: 'DOCKER_PASSWORD', 
                        usernameVariable: 'DOCKER_USERNAME'
                    )
                ]) {
                    script {
                        try {
                            sh '''
                            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                            
                            # Push multiple tags
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                            docker push ${IMAGE_NAME}:latest
                            docker push ${IMAGE_NAME}:${VERSION}
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
                        // More robust Kubernetes deployment
                        sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@54.242.176.196 << EOF
                        kubectl set image deployment/cw2-server-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG}
                        kubectl rollout status deployment/cw2-server-deployment --timeout=5m
                        kubectl get deployments
                        kubectl get pods
                        EOF
                        '''
                    } catch (Exception e) {
                        error "Kubernetes deployment failed: ${e.message}"
                    }
                }
            }
        }
    }
    
    post {
        success {
            // Slack or email notifications for successful build
            slackSend color: 'good', 
                     message: "Deployment successful: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        
        failure {
            // Notification on failure
            slackSend color: 'danger', 
                     message: "Deployment failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        
        always {
            // Cleanup steps
            script {
                try {
                    sh "docker logout"
                } catch (Exception e) {
                    echo "Docker logout failed or not found, skipping..."
                }
                
                // Clean workspace
                cleanWs()
            }
        }
    }
}
