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
                    // Check for Docker and Git
                    def dockerInstalled = sh(script: 'which docker', returnStatus: true) == 0
                    def gitInstalled = sh(script: 'which git', returnStatus: true) == 0
                    
                    if (!dockerInstalled) {
                        error "Docker is not installed. Please install Docker in the Jenkins environment."
                    }
                    
                    if (!gitInstalled) {
                        error "Git is not installed. Please install Git in the Jenkins environment."
                    }
                }
            }
        }
        
        stage('Checkout') {
            steps {
                // Improved error handling for checkout
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    git branch: 'main', 
                        url: "${env.GIT_REPO}", 
                        credentialsId: 'github_credentials'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        // Verify Dockerfile exists before building
                        def fileExists = fileExists 'Dockerfile'
                        if (!fileExists) {
                            error "Dockerfile not found in the repository root"
                        }
                        
                        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    }
                }
            }
        }
        
        stage('Container Validation') {
            steps {
                script {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        sh '''
                        docker run -d --name test-container -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 10
                        docker ps | grep test-container
                        docker logs test-container
                        docker rm -f test-container
                        '''
                    }
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', 
                                                         usernameVariable: 'DOCKER_USER', 
                                                         passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                            docker logout
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        // Use more robust SSH connection with error handling
                        sshagent(credentials: ['ssh_credentials']) {
                            sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@54.242.176.196 << EOF
                            kubectl set image deployment/cw2-server-deployment cw2-server=${IMAGE_NAME}:${IMAGE_TAG}
                            kubectl rollout status deployment/cw2-server-deployment
EOF
                            '''
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Enhanced cleanup
                sh '''
                docker logout || true
                docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true
                '''
                cleanWs()
            }
        }
        
        failure {
            echo 'Pipeline failed. Detailed logs are available for investigation.'
        }
        
        success {
            echo 'Pipeline completed successfully! All stages passed.'
        }
    }
}
