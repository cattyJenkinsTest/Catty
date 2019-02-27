pipeline {
  agent any
  stages {
    stage('Carthage') {
      steps {
        sh 'make init'
      }
    }
    stage('Fastlane Test') {
      parallel {
        stage('Fastlane Test') {
          steps {
            sh 'cd src && fastlane tests'
          }
        }
        stage('Browserstack') {
          steps {
            sh '''cd src/ && set -o allexport

&& source /Users/catrobat/Documents/.env
 && set +o allexport && fastlane po_review'''
          }
        }
      }
    }
    stage('Archive') {
      steps {
        archiveArtifacts(artifacts: 'src/fastlane/test_output/', allowEmptyArchive: true)
      }
    }
  }
}