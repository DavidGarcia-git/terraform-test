/* destroy.Jenkinsfile
 * Remove TODOS os recursos que pertencem ao state deste repositório
 * ⚠  Executa sem confirmação. Use com cautela.
 */
pipeline {
    agent any
    tools { terraform 'terraform' }      // nome configurado em Manage Jenkins ▸ Tools

    options { skipDefaultCheckout(true) }

    /* Ajuste apenas se já estiver usando backend S3 --------------------- */
    environment {
        BACKEND_BUCKET = ''              // ex.: 'bucket-test12213'  (deixe vazio se state local)
        BACKEND_REGION = 'us-east-1'
    }

    stages {
        /* Checkout ------------------------------------------------------ */
        stage('Checkout') {
            steps { checkout scm }
        }

        /* Init ---------------------------------------------------------- */
        stage('Init') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',          // AccessKey + SecretKey
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    script {
                        if (env.BACKEND_BUCKET?.trim()) {
                            sh """
                              terraform init \
                                -backend-config="bucket=${BACKEND_BUCKET}" \
                                -backend-config="region=${BACKEND_REGION}"
                            """
                        } else {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        /* Destroy ------------------------------------------------------- */
        stage('Destroy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh 'terraform apply -auto-approve destroy tfplan'
                }
            }
        }
    }
}
