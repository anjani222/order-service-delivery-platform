pipeline {
  agent any

  parameters {
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS deployment region')
    string(name: 'ECR_REPOSITORY', defaultValue: '437287029768.dkr.ecr.us-east-1.amazonaws.com/gitops-platform/order-service', description: 'ECR repository URL')
    string(name: 'GITOPS_REPO_SSH', defaultValue: 'git@github.com:anjani222/order-service-gitops.git', description: 'SSH URL used to push the desired-state change')
    booleanParam(name: 'RUN_SONAR', defaultValue: true, description: 'Run SonarQube analysis and quality gate')
  }

  environment {
    APP_NAME = 'order-service'
    GITOPS_VALUES = 'charts/order-service/values-dev.yaml'
  }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          env.IMAGE_TAG = sh(script: 'git rev-parse --short=8 HEAD', returnStdout: true).trim()
        }
      }
    }

    stage('Unit Test and Package') {
      steps {
        dir('app') { sh 'mvn -B clean verify' }
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: 'app/target/surefire-reports/*.xml'
          archiveArtifacts allowEmptyArchive: true, artifacts: 'app/target/*.jar'
        }
      }
    }

    stage('SonarQube Analysis') {
      when { expression { return params.RUN_SONAR } }
      steps {
        withSonarQubeEnv('sonarqube') {
          dir('app') { sh 'mvn -B sonar:sonar -Dsonar.projectKey=order-service' }
        }
      }
    }

    stage('Quality Gate') {
      when { expression { return params.RUN_SONAR } }
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Build Container') {
      steps {
        sh 'docker build --pull -t ${APP_NAME}:${IMAGE_TAG} .'
      }
    }

    stage('Security Scan') {
      steps {
        sh 'trivy image --exit-code 1 --severity CRITICAL --ignore-unfixed ${APP_NAME}:${IMAGE_TAG}'
      }
    }

    stage('Push to ECR') {
      when { branch 'main' }
      steps {
        sh '''
          ECR_REGISTRY="${ECR_REPOSITORY%%/*}"
          ECR_REPOSITORY_NAME="${ECR_REPOSITORY#*/}"
          aws ecr get-login-password --region "${AWS_REGION}" | \
            docker login --username AWS --password-stdin "${ECR_REGISTRY}"
          docker tag "${APP_NAME}:${IMAGE_TAG}" "${ECR_REPOSITORY}:${IMAGE_TAG}"
          if aws ecr describe-images --region "${AWS_REGION}" \
              --repository-name "${ECR_REPOSITORY_NAME}" \
              --image-ids imageTag="${IMAGE_TAG}" >/dev/null 2>&1; then
            echo "ECR image ${IMAGE_TAG} already exists; keeping the immutable artifact."
          else
            docker push "${ECR_REPOSITORY}:${IMAGE_TAG}"
          fi
        '''
      }
    }

    stage('Update GitOps Desired State') {
      when { branch 'main' }
      steps {
        sshagent(credentials: ['github-deploy-key']) {
          dir('gitops-worktree') {
            deleteDir()
            sh '''
              git clone --branch main "${GITOPS_REPO_SSH}" .
              yq -i '.image.repository = strenv(ECR_REPOSITORY) | .image.tag = strenv(IMAGE_TAG)' "${GITOPS_VALUES}"
              git config user.name "jenkins-ci"
              git config user.email "jenkins-ci@users.noreply.github.com"
              git add "${GITOPS_VALUES}"
              git diff --cached --quiet && exit 0
              git commit -m "chore(dev): promote order-service ${IMAGE_TAG}"
              git push origin HEAD:main
            '''
          }
        }
      }
    }
  }

  post {
    always {
      sh 'docker image rm "${APP_NAME}:${IMAGE_TAG}" "${ECR_REPOSITORY}:${IMAGE_TAG}" >/dev/null 2>&1 || true'
      cleanWs()
    }
  }
}
