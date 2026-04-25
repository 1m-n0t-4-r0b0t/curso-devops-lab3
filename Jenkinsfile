def tagAndPush(String localImage, String repo, String registry, String credential) {
    docker.withRegistry(registry, credential) {
        sh "docker tag ${localImage} ${repo}:latest"
        sh "docker tag ${localImage} ${repo}:${env.BUILD_NUMBER}"
        sh "docker tag ${localImage} ${repo}:${env.APP_SEMANTIC_VERSION}"
        sh "docker push ${repo}:latest"
        sh "docker push ${repo}:${env.BUILD_NUMBER}"
        sh "docker push ${repo}:${env.APP_SEMANTIC_VERSION}"
    }
}

pipeline {
    agent any

    environment {
        IMAGE_NAME = "curso-devops-lab3"
        DH_REPO = "moniqa/curso-devops-lab3"
        GHCR_REPO = "ghcr.io/1m-n0t-4-r0b0t/curso-devops-lab3"
        K8S_NAMESPACE = "mmeneses"
        K8S_DEPLOYMENT = "curso-devops-lab3-deployment"
        K8S_CONTAINER = "contenedor-curso-devops-lab3"
    }

    stages {
        stage("1.Integración continua") {
            agent {
                docker {
                    image 'node:24'
                    reuseNode true
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
                        sh "npm run test:cov"
                    }
                }

                stage("BUILD") {
                    steps {
                        sh "npm run build"
                    }
                }

                stage("VERSIÓN") {
                    steps {
                        script {
                            env.APP_SEMANTIC_VERSION = sh(
                                script: "node -p \"require('./package.json').version\"",
                                returnStdout: true
                            ).trim()
                            echo "Versión detectada: ${env.APP_SEMANTIC_VERSION}"
                        }
                    }
                }
            }
        }

        stage("2.Aseguramiento de Calidad") {
            agent {
                docker {
                    image 'sonarsource/sonar-scanner-cli:latest'
                    args "--network=devops-infra_default --entrypoint=''"
                    reuseNode true
                }
            }
            stages {
                stage("VALIDACIÓN CÓDIGO") {
                    steps {
                        withSonarQubeEnv('sonarqube') {
                            sh "sonar-scanner"
                        }
                    }
                }

                stage("VALIDACIÓN QUALITY GATE") {
                    steps {
                        timeout(time: 10, unit: 'MINUTES') {
                            waitForQualityGate abortPipeline: true
                        }
                    }
                }
            }
        }

        stage("DOCKERFILE") {
            steps {
                sh "docker build -t ${env.IMAGE_NAME} ."

                script {
                    if (!env.APP_SEMANTIC_VERSION?.trim()) {
                        error("APP_SEMANTIC_VERSION no definida en el stage anterior")
                    }

                    tagAndPush(
                        env.IMAGE_NAME,
                        env.DH_REPO,
                        "https://index.docker.io/v1/",
                        "credenciales-dockerhub"
                    )

                    tagAndPush(
                        env.IMAGE_NAME,
                        env.GHCR_REPO,
                        "https://ghcr.io",
                        "credenciales-github"
                    )
                }
            }
        }
                            stage("3.Despliegue Continuo en rama Develop") {

    agent {

        label 'mac-host'

    }

    steps {

        sh '''

            kubectl version --client

            kubectl cluster-info

            kubectl apply -f kubernetes.yaml --validate=false

            kubectl -n ${K8S_NAMESPACE} set image deployment/${K8S_DEPLOYMENT} ${K8S_CONTAINER}=${GHCR_REPO}:${BUILD_NUMBER}

            kubectl -n ${K8S_NAMESPACE} rollout status deployment/${K8S_DEPLOYMENT}

            kubectl -n ${K8S_NAMESPACE} wait --for=condition=Ready pod -l app=curso-devops-lab3-stack --timeout=180s

            kubectl -n ${K8S_NAMESPACE} get pods -o wide

        '''

    }

}
    }
}