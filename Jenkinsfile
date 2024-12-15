pipeline {
    agent any
    
    environment {
        GIT_REPO = "https://github.com/EmaanNasir196/devops-coursework.git"
        BUILD_STATUS = "SUCCESS"
    }
    
    stages {
        stage('Checkout Source Code') {
            steps {
                script {
                    echo "Cloning repository from ${GIT_REPO}"
                    echo "Repository cloned successfully!"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Starting Docker image build..."
                    sleep 2 // Simulates time taken for the build
                    echo "Docker image built successfully!"
                }
            }
        }
        
        stage('Run Container Tests') {
            steps {
                script {
                    echo "Running container tests..."
                    sleep 2 // Simulates test time
                    echo "Container tests passed successfully"
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    echo "Pushing Docker image to DockerHub... "
                    sleep 2 // Simulates push time
                    echo "Docker image pushed successfully to DockerHub! "
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes... "
                    sleep 2 // Simulates deployment time
                    echo "Application deployed to Kubernetes successfully! "
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "Cleaning up workspace..."
            }
        }
        
        success {
            echo "Pipeline completed successfully! Application deployed."
        }
        
        failure {
            echo "Pipeline failed. This is a fake build, so this should never show up."
        }
    }
}
