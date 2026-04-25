pipeline {
    agent {
        docker
        {
            image "node:24"
        }
    }
    stages {
        stage("1.CI de la aplicación") {
            steps{
                sh "npm install"
                sh "ls -l"
                sh "hostname"
            }
        }
        stage("mi segunda etapa") {
            steps{
                sh "echo 'mi primer step en mi segunda etapa'"
                sh "echo 'mi segundo step en mi segunda etapa'"
            }
        }
    }
}