pipeline {
    agent any{
    stages {
        stage("1.Integración continua") {
            agent {
                docker
                {
                    image "node:24"
                }
            }
            stages {    
                    stage("DEPENDENCIAS") {
                            steps{
                                sh "npm install"
                                sh "ls -l"
                                sh "hostname"
                            }
                    }
                    stage("ESLINT") {
                            steps{
                                sh "npm run lint"
                            }
                    }
                    stage("TESTS") {
                            steps{
                                sh "npm run test"
                            }
                    }
                    stage("BUILD") {
                            steps{
                                sh "npm run build"
                            }
                    }
                } 
            }
        }
        stage("DOCKERFILE") {
            steps{
                sh "docker build -t curso-devops-lab3"
            }
        }
    }
}

    
