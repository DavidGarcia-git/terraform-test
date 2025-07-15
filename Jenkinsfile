pipeline {
    /* Executa no próprio nó controller (Ubuntu) */
    agent any

    /* Opções de job */
    options {
        ansiColor('xterm')                        // cores no log
        timestamps()                              // horário em cada linha
        buildDiscarder(logRotator(numToKeepStr: '30'))
        disableConcurrentBuilds()                 // só um build por vez
        skipDefaultCheckout(true)                 // evita checkout automático
    }

    /* Usa a ferramenta cadastrada em
       Manage Jenkins ▸ Global Tool Configuration → Terraform (name = terraform) */
    tools {
        terraform 'terraform'
    }

    /* Variáveis fáceis de alterar sem editar o resto do script */
    environment {
        TF_BACKEND_BUCKET = ''        // deixe vazio enquanto não tiver bucket
        TF_BACKEND_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Init') {
            steps {
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

        stage('Fmt & Validate') {
            steps {
                /* Formata arquivos (se necessário) e mostra diff.
                   Não falha mesmo que mude algo.             */
                sh 'terraform fmt -recursive -diff'
                sh 'terraform validate'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        /* Descomente se quiser aplicar automaticamente na branch main
        stage('Apply') {
            when { branch 'main' }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        */
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan', fingerprint: true
        }
    }
}
