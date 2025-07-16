pipeline {
    /* Executa no próprio nó controller (Ubuntu) ---------------------------- */
    agent any

    /* Opções do job -------------------------------------------------------- */
    options {
        ansiColor('xterm')                        // cores no log
        timestamps()                              // horário em cada linha
        buildDiscarder(logRotator(numToKeepStr: '30'))
        disableConcurrentBuilds()                 // só um build por vez
        skipDefaultCheckout(true)                 // evita checkout automático
    }

    /* Ferramentas instaladas no Jenkins ------------------------------------ */
    tools { terraform 'terraform' }               // nome cadastrado em Global Tool

    /* Variáveis fáceis de editar ------------------------------------------- */
    environment {
        TF_BACKEND_BUCKET = ''        // deixe vazio enquanto não tiver bucket
        TF_BACKEND_REGION = 'us-east-1'
    }

    stages {
        /* ------------------------------------------------------------------ */
        stage('Checkout') {
            steps { checkout scm }
        }

        /* ------------------------------------------------------------------ */
        stage('Init') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    script {
                        if (env.TF_BACKEND_BUCKET?.trim()) {
                            sh """
                              terraform init \
                                -backend-config="bucket=${TF_BACKEND_BUCKET}" \
                                -backend-config="region=${TF_BACKEND_REGION}"
                            """
                        } else {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        /* ------------------------------------------------------------------ */
        stage('Fmt & Validate') {
            steps {
                sh 'terraform fmt -recursive -diff -check'   // falha se houver arquivo fora do padrão
                sh 'terraform validate'
            }
        }

        /* ------------------------------------------------------------------ */
        stage('Plan') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        /* ------------------------------------------------------------------ */
        stage('Apply') {
            when { branch 'main' }           // aplica só na branch main
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    /* Pós-build ------------------------------------------------------------ */
    post {
        always {
            archiveArtifacts artifacts: 'tfplan', fingerprint: true
        }
    }
}
