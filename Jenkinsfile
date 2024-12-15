pipeline {
    agent any
    
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', // or 'master' depending on your repository
                    url: 'https://github.com/EmaanNasir196/devops-coursework.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("cw2-server:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('Test Container') {
            steps {
                script {
                    def testContainer = docker.image("cw2-server:${env.BUILD_NUMBER}")
                    testContainer.run('-p 8080:8080')
                    // Add additional test commands if needed
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        docker.image("cw2-server:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl set image deployment/cw2-server cw2-server=emaan067/cw2-server:${env.BUILD_NUMBER}"
                }
            }
        }
    }
}
