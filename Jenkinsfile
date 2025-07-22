pipeline {
  agent any

  parameters {
    choice(name: 'Action', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
  }

  environment {
    AWS_REGION = 'us-east-1'
  }

  stages {
    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/senjaliyadhruv/project-1.git'
      }
    }

    stage('Terraform Init + Apply/Destroy') {
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          dir('terraform') {
            sh '''
              terraform init
              terraform validate

              if [ "$Action" = "apply" ]; then
                terraform apply -auto-approve
              elif [ "$Action" = "destroy" ]; then
                terraform destroy -auto-approve
              fi
            '''
          }
        }
      }
    }

    stage('Generate Ansible Inventory') {
      when {
        expression { params.Action == 'apply' }
      }
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          script {
            def ec2_ip = sh(
              script: "terraform -chdir=terraform output -raw ec2_public_ip",
              returnStdout: true
            ).trim()

            writeFile file: 'ansible/inventory.ini', text: """
[web]
${ec2_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/ec2.pem
"""
          }
        }
      }
    }

    stage('Run Ansible Playbook') {
      when {
        expression { params.Action == 'apply' }
      }
      steps {
        sh '''
          echo "Running Ansible Playbook..."
          export ANSIBLE_HOST_KEY_CHECKING=False
          ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
        '''
      }
    }
  }
}
