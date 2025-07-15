pipeline {
    /* Usa o próprio nó Jenkins (Ubuntu) como agente */
    agent any

    /* Saída colorida no console */
    options { ansiColor('xterm') }

    /* Diz ao Jenkins que já existe Terraform instalado em /usr/bin/terraform */
    tools { terraform 'terraform' }

    stages {

        stage('Checkout') {
            steps {
                /* Clona o branch configurado no job */
                checkout scm
            }
        }

        stage('Fmt & Validate') {
            steps {
                sh 'terraform fmt -check -recursive'   // verifica formatação
                sh 'terraform validate'               // valida sintaxe
            }
        }

        stage('Plan') {
            steps {
                /* Ajuste o backend conforme precisar.
                   Se não usar S3/Terraform Cloud, remova as linhas -backend-config. */
                sh '''
                   terraform init \
                     -backend-config="bucket=meu-state" \
                     -backend-config="region=us-east-1"

                   terraform plan -out=tfplan
                '''
            }
        }

        /* Descomente este bloco se quiser aplicar automaticamente na branch main
        stage('Apply') {
            when { branch 'main' }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        */
    }

    /* Salva o arquivo tfplan como artefato, para baixar depois se quiser */
    post {
        always { archiveArtifacts artifacts: 'tfplan', fingerprint: true }
    }
}
