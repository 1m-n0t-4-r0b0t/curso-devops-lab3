pipeline {
    agent any

    stages {
        stage("1.Integración continua") {
            agent {
                docker {
                    image 'node:24'
                }
            }
            stages {
                stage("DEPENDENCIAS") {
                    steps {
                        sh "npm install"
                        sh "ls -l"
                        sh "hostname"
                    }
                }

                stage("ESLINT") {
                    steps {
                        sh "npm run lint"
                    }
                }

                stage("TESTS") {
                    steps {
                        sh "npm run test"
                    }
                }

                stage("BUILD") {
                    steps {
                        sh "npm run build"
                    }
                }
            }
        }

        stage("DOCKERFILE") {
            steps {
                sh "docker build -t curso-devops-lab3 ."

                script {
                    def semantic = sh(
                        script: "node -p \"require('./package.json').version\"",
                        returnStdout: true
                    ).trim()

                    docker.withRegistry("https://index.docker.io/v1/", "credenciales-dockerhub") {
                        sh "docker tag curso-devops-lab3 moniqa/curso-devops-lab3:latest"
                        sh "docker tag curso-devops-lab3 moniqa/curso-devops-lab3:${env.BUILD_NUMBER}"
                        sh "docker tag curso-devops-lab3 moniqa/curso-devops-lab3:${semantic}"

                        sh "docker push moniqa/curso-devops-lab3:latest"
                        sh "docker push moniqa/curso-devops-lab3:${env.BUILD_NUMBER}"
                        sh "docker push moniqa/curso-devops-lab3:${semantic}"
                    }

                    docker.withRegistry("https://ghcr.io", "credenciales-github") {
                        sh "docker tag curso-devops-lab3 ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3:latest"
                        sh "docker tag curso-devops-lab3 ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3:${env.BUILD_NUMBER}"
                        sh "docker tag curso-devops-lab3 ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3:${semantic}"

                        sh "docker push ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3:latest"
                        sh "docker push ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3:${env.BUILD_NUMBER}"
                        sh "docker push ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3:${semantic}"
                    }
                }
           }
        }   
    }
}