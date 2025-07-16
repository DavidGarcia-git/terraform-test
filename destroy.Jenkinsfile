/* destroy.Jenkinsfile
 * Remove TODOS os recursos gerenciados por este state
 */
pipeline {
    agent any
    tools { terraform 'terraform' }

    options { skipDefaultCheckout(true) }

    stages {
        stage('Checkout') { steps { checkout scm } }

        stage('Init') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    /* Se já usa backend S3, mantenha a mesma config  */
                    sh '''
                      terraform init \
                        -backend-config="bucket=bucket-test12213" \
                        -backend-config="region=us-east-1"
                    '''
                }
            }
        }

        stage('Destroy') {
            /* prompt opcional de segurança */
            input {
                message 'Tem certeza que quer destruir TUDO?'
                ok      'Sim, destruir'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-terraform',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
