pipeline {
    agent any
    stages {
        stage("etapa1") {
            steps{
                sh "echo 'mi primer step en mi primera etapa'"
                sh "echo 'mi segundo step en mi primera etapa'"
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