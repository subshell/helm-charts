@Library('subshell') _

pipeline {
    agent {
        docker {
            image 'docker.subshell.com/builder/helm-builder:0.2.0'
            label 'docker'
            args '-u root'
        }
    }
    environment {
        DOCKER_REGISTRY=credentials('DOCKERSUBSHELL_DOCKER')
        BITBUCKET=credentials('889af355-bde5-46e7-a30f-6a764694ee0d')
    }
    parameters {
        booleanParam(name: 'ScanConfig', defaultValue: false, description: 'Scans for new release configurations. This is needed if a new helm chart was recently added.')
        choice(name: 'HelmChart', choices: ['o-neko', 'sophora-repo-import', 'sophora-indexing-service', 'sophora-dashboard-old', 'sophora-importer', 'sophora-server', 'deskclient-downloads', 'sophora-webclient', 'subshell-technology-radar', 'sophora-export-job'], description: 'What helm chart to release')
        choice(name: 'ReleaseType', choices: ['patch', 'minor', 'major'], description: 'SemVer Release type patch, minor or major')
        choice(name: 'ExistingMajorVersion', choices: ['latest', 'v0', 'v1', 'v2', 'v3', 'v4', 'v5'], description: 'Target an existing major version (matches the sub directory)')
    }
    stages {
        stage('Scan configuration') {
            when {
                equals expected: true, actual: params.ScanConfig
            }
            steps {
                sh '''#!/bin/sh
                echo "Searching for new release configuration... All other steps will be skipped!"
                exit 1
                '''
            }
        }
        stage('Git config') {
            steps {
                sh '''#!/bin/sh
                git remote set-url origin https://${BITBUCKET_USR}:${BITBUCKET_PSW}@bitbucket.org/subshell_gmbh/helm-charts.git 
                git config --global user.name "Jenkins"
                git config --global user.email "jenkins@subshell.com"
                git remote -v
                git status
                git fetch
                git checkout master
                '''
            }
        }
        stage('Check for master branch') {
            when {
                equals expected: false, actual: isMainBranch()
            }
            steps {
                sh '''#!/bin/sh
                echo "## Releases are restricted to run on the master branch ##"
                exit 1
                '''
            }
        }
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
                python3 run.py ${HelmChart} test --chart_sub_dir ${ExistingMajorVersion}
                python3 run.py ${HelmChart} build --chart_sub_dir ${ExistingMajorVersion}
                '''
            }
        }
        stage('Helm Release') {
            steps {
                sh '''#!/bin/sh
                python3 run.py ${HelmChart} release --release_goal ${ReleaseType} --chart_sub_dir ${ExistingMajorVersion}
                '''
                archiveArtifacts artifacts: 'out/**/*.tgz', fingerprint: true
            }
        }
    }
}
