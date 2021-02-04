@Library('subshell') _

pipeline {
    agent {
        docker {
            image 'docker.subshell.com/builder/helm-builder:0.2.0'
            label 'docker'
            args '-u root:root'
        }
    }
    environment {
        DOCKER_REGISTRY=credentials('DOCKERSUBSHELL_DOCKER')
    }
    stages {
        stage('Install python dependencies') {
            steps {
                sh '''#!/bin/sh
                python3 -m pip install -r requirements.txt
                '''
            }
        }
        stage('Setup Helm Repo') {
            steps {
                sh '''#!/bin/sh
                helm repo add sophora https://docker.subshell.com/chartrepo/sophora --username="\$DOCKER_REGISTRY_USR" --password="\$DOCKER_REGISTRY_PSW"
                helm repo add subshell-tools https://docker.subshell.com/chartrepo/tools --username="\$DOCKER_REGISTRY_USR" --password="\$DOCKER_REGISTRY_PSW"
                '''
            }
        }
        stage('Helm Build + Test') {
            steps {
                sh '''#!/bin/sh
                rm -rf out/
                python3 run.py all test
                python3 run.py all build
                '''
                archiveArtifacts artifacts: 'out/**/*.tgz', fingerprint: true
            }
        }
        stage('Helm Push Dev Version') {
            when {
                equals expected: true, actual: isMainBranch()
            }
            steps {
                sh '''#!/bin/sh
                python3 run.py all push
                '''
            }
        }
    }
}
