@Library('subshell') _

pipeline {
    agent {
        docker {
            image 'docker.subshell.com/builder/helm-builder:0.1.0'
            label 'docker'
            args '-u root:root'
        }
    }
    environment {
        DOCKER_REGISTRY=credentials('DOCKERSUBSHELL_DOCKER')
    }
    stages {
        stage('Setup Helm Repo') {
            steps {
                sh '''#!/bin/sh
                helm repo add sophora https://docker.subshell.com/chartrepo/sophora --username="\$DOCKER_REGISTRY_USR" --password="\$DOCKER_REGISTRY_PSW"
                '''
            }
        }
        stage('Helm Build + Test') {
            steps {
                sh '''#!/bin/sh
                for d in */; do
                    make build chart_dir=\$d
                done
                '''
                archiveArtifacts artifacts: 'out/**/*.tgz', fingerprint: true
            }
        }
        stage('Helm Push') {
            when {
                equals expected: true, actual: isMainBranch()
            }
            steps {
                sh '''#!/bin/sh
                for d in */; do
                    make push_only chart_dir=\$d
                done
                '''
            }
        }
    }
}
