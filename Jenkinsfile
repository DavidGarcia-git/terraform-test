pipeline {
    /* Executa no próprio nó “controller” (Ubuntu) */
    agent any

    /* Saída colorida + descarte de builds antigos + proibição de concorrência */
    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '30'))
        disableConcurrentBuilds()
    }

    /* Usa o Terraform que você configurou em
       Manage Jenkins ▸ Global Tool Configuration  */
    tools {
        terraform 'terraform'          // Name = terraform, Install dir = /usr
    }

    /* Variáveis que você pode alterar sem mexer no script */
    environment {
        TF_BACKEND_BUCKET = 'meu-state'      // nome do bucket S3 (ou deixe vazio)
        TF_BACKEND_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Init') {
            steps {
                sh '''
                    if [ -n "$TF_BACKEND_BUCKET" ]; then
                      terraform init \
                        -backend-config="bucket=$TF_BACKEND_BUCKET" \
                        -backend-config="region=$TF_BACKEND_REGION"
                    else
                      terraform init
                    fi
                '''
            }
        }

        stage('Fmt & Validate') {
            steps {
                /* Se algum arquivo não estiver formatado, corrigimos e prosseguimos */
                sh 'terraform fmt -recursive'
                sh 'terraform validate'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        /* Descomente se quiser aplicar automaticamente na branch main */
        /*
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
