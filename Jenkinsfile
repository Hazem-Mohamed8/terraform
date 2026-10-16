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
        failure { echo 'Terraform pipeline failed.' }
        aborted { echo 'Aborted at the approval step.' }
    }
}