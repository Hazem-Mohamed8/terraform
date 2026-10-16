pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'stg', 'prod'], description: 'Target environment')
    }

    environment {
        TF_VAR_FILE = "environments/${params.ENVIRONMENT}.tfvars"
        TF_PLAN_OUT = "tfplan-${params.ENVIRONMENT}"
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }

        stage('Workspace Select') {
            steps {
                sh 'terraform workspace select ${ENVIRONMENT} || terraform workspace new ${ENVIRONMENT}'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -input=false -var-file="$TF_VAR_FILE" -out="$TF_PLAN_OUT"'
            }
        }

        stage('Approval') {
            steps {
                input message: "Apply the plan to ${params.ENVIRONMENT}?", ok: 'Approve'
            }
        }

        stage('Apply') {
            steps {
                sh 'terraform apply -input=false "$TF_PLAN_OUT"'
            }
        }
    }

    post {
        always  { sh 'rm -f tfplan-*' }
        success { echo "Terraform applied to ${params.ENVIRONMENT}." }
        aborted { echo 'Aborted at the approval step.' }
    

    failure {
    emailext(
        to: 'hm010685452780@gmail.com',
        subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        mimeType: 'text/html',
        body: '''
            <h2 style="color:#d32f2f;">Jenkins Pipeline Failed</h2>
            <p><b>Job:</b> $PROJECT_NAME</p>
            <p><b>Build:</b> #$BUILD_NUMBER</p>
            <p><b>Status:</b> $BUILD_STATUS</p>
            <p><a href="$BUILD_URL/console">Open Console Output</a></p>
        '''
    )
}
    }
}