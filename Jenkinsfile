pipeline {
    agent any
    
    environment {
        // GitHub repository details
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        
        // Docker configuration
        DOCKER_CREDENTIALS = credentials('dockerhub_credentials')
        DOCKER_IMAGE_NAME = "emaan067/cw2-server"
        DOCKER_IMAGE_TAG = "v${BUILD_NUMBER}"
        
        // Kubernetes configuration
        KUBERNETES_DEPLOYMENT_NAME = "cw2-server-deployment"
        KUBERNETES_NAMESPACE = "default"
        KUBERNETES_SERVER = "54.242.176.196"
    }
    
    stages {
        stage('Checkout Source Code') {
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
                        // Verify Dockerfile exists
                        def fileExists = fileExists 'Dockerfile'
                        if (!fileExists) {
                            error "Dockerfile not found in the repository root"
                        }
                        
                        // Build Docker image
                        docker.build("${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}")
                    } catch (Exception buildError) {
                        echo "Docker build failed: ${buildError.message}"
                        throw buildError
                    }
                }
            }
        }
        
        stage('Run Container Tests') {
            steps {
                script {
                    try {
                        // Run container and perform basic tests
                        sh '''
                        docker run -d --name test-container -p 8080:8080 ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                        sleep 10
                        docker ps | grep test-container
                        docker logs test-container
                        docker rm -f test-container
                        '''
                    } catch (Exception testError) {
                        echo "Container validation failed: ${testError.message}"
                        throw testError
                    }
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    try {
                        // Login to DockerHub and push image
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                            docker.image("${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG}").push()
                        }
                    } catch (Exception pushError) {
                        echo "DockerHub push failed: ${pushError.message}"
                        throw pushError
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    try {
                        // Use SSH to connect and update Kubernetes deployment
                        sshagent(credentials: ['ssh_credentials']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${KUBERNETES_SERVER} << EOF
                            kubectl set image deployment/${KUBERNETES_DEPLOYMENT_NAME} cw2-server=${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} -n ${KUBERNETES_NAMESPACE}
                            kubectl rollout status deployment/${KUBERNETES_DEPLOYMENT_NAME} -n ${KUBERNETES_NAMESPACE}
EOF
                            """
                        }
                    } catch (Exception deployError) {
                        echo "Kubernetes deployment failed: ${deployError.message}"
                        throw deployError
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup steps
            script {
                sh '''
                docker logout || true
                docker rmi ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} || true
                '''
                cleanWs()
            }
        }
        
        success {
            echo 'Pipeline completed successfully! Application deployed.'
        }
        
        failure {
            echo 'Pipeline failed. Check logs for detailed error information.'
        }
    }
}
