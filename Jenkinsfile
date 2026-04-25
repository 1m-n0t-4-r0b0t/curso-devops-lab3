pipeline {
    agent {
        docker
        {
            image "node:24"
        }
    }
    stages {
        stage("1.CI de la aplicación - DEPENDENCIAS") {
            steps{
                sh "npm install"
                sh "ls -l"
                sh "hostname"
            }
        }
        stage("2.CI de la aplicación - ESLINT") {
            steps{
                sh "npm run lint"
            }
        }
        stage("3.CI de la aplicación - TESTS") {
            steps{
                sh "npm run test"
            }
        }
        stage("4.CI de la aplicación - BUILD") {
            steps{
                sh "npm run build"
            }
        }
    }
}