pipeline {
    agent { label 'docker-builder' }

    options {
        disableConcurrentBuilds()
    }

    environment {
        REGISTRY = 'kregistry.siwko.org:5000'
        IMAGE = "${REGISTRY}/home-assistant"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                sh "docker build --pull --provenance=false --sbom=false -f Dockerfile -t ${IMAGE}:${IMAGE_TAG} -t ${IMAGE}:latest ."
            }
        }
        stage('Push') {
            steps {
                sh "docker push ${IMAGE}:${IMAGE_TAG}"
                sh "docker push ${IMAGE}:latest"
            }
        }
        stage('Deploy') {
            steps {
                sh "kubectl apply -f k8s/home-assistant-pvc.yaml"
                sh "kubectl apply -f k8s/home-assistant-service.yaml"
                sh "kubectl apply -f k8s/home-assistant-deployment.yaml"
                sh "kubectl rollout restart deployment/home-assistant -n default"
                sh "kubectl rollout status deployment/home-assistant -n default --timeout=12m"
            }
        }
    }
}
