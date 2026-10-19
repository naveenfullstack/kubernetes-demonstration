pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '125022369875'

        EKS_CLUSTER_NAME = 'othm-eks-prod'

        ECR_REPOSITORY = 'othm-eks'

        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        IMAGE_NAME = "${ECR_REGISTRY}/${ECR_REPOSITORY}"

        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        // =================================================
        // 1. CHECKOUT SOURCE CODE
        // =================================================
        stage('Checkout') {
            steps {
                git(
                    branch: 'live',
                    url: 'https://github.com/naveenfullstack/kubernetes-demonstration.git'
                )
            }
        }

        // =================================================
        // 2. BUILD NEXT.JS DOCKER IMAGE
        // =================================================
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} \
                        -t ${IMAGE_NAME}:latest \
                        ./next
                '''
            }
        }

        // =================================================
        // 3. CREATE ECR REPOSITORY IF NOT EXISTS
        // =================================================
        stage('Create ECR Repository') {
            steps {
                sh '''
                    aws ecr describe-repositories \
                        --repository-names ${ECR_REPOSITORY} \
                        --region ${AWS_REGION} \
                    || \
                    aws ecr create-repository \
                        --repository-name ${ECR_REPOSITORY} \
                        --region ${AWS_REGION}
                '''
            }
        }

        // =================================================
        // 4. LOGIN TO AMAZON ECR
        // =================================================
        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password \
                        --region ${AWS_REGION} | \
                    docker login \
                        --username AWS \
                        --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        // =================================================
        // 5. PUSH DOCKER IMAGE TO ECR
        // =================================================
        stage('Push to ECR') {
            steps {
                sh '''
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }

        // =================================================
        // 6. CONFIGURE EKS ACCESS
        // =================================================
        stage('Configure EKS Access') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                        --name ${EKS_CLUSTER_NAME} \
                        --region ${AWS_REGION}

                    kubectl cluster-info
                '''
            }
        }

        // =================================================
        // 7. DEPLOY NEXT.JS APPLICATION TO EKS
        // =================================================
        stage('Deploy to EKS') {
            steps {
                dir('next') {
                    sh '''
                        set -eu

                        # Verify the Kubernetes manifest exists
                        test -f k8-deployment.yml

                        # Substitute the image variables
                        envsubst '${IMAGE_NAME} ${IMAGE_TAG}' \
                            < k8-deployment.yml \
                            > /tmp/nextjs-deployment.yml

                        # Display the image being deployed
                        echo "Deploying image: ${IMAGE_NAME}:${IMAGE_TAG}"

                        # Apply Kubernetes resources
                        kubectl apply -f /tmp/nextjs-deployment.yml

                        # Wait for the deployment to complete
                        kubectl rollout status \
                            deployment/nextjs-website \
                            --timeout=300s

                        # Verify deployment status
                        echo "Deployment status:"
                        kubectl get deployment nextjs-website

                        echo "Application pods:"
                        kubectl get pods -l app=nextjs-website

                        echo "Application service:"
                        kubectl get service nextjs-website-service
                    '''
                }
            }
        }

        // =====================================================
        // 9. APPLY HORIZONTAL POD AUTOSCALER
        // =====================================================
        stage('Configure Pod Autoscaling') {
            steps {
                sh '''
                    set -eu

                    echo "Applying HPA configuration..."

                    kubectl apply \
                        -f kubernetes/deployment/nextjs-website-hpa.yaml

                    echo "Checking HPA..."

                    kubectl get hpa nextjs-website-hpa

                    echo "HPA details:"

                    kubectl describe hpa nextjs-website-hpa
                '''
            }
        }

        // =====================================================
        // 10. VERIFY DEPLOYMENT
        // =====================================================
        stage('Verify Deployment') {
            steps {
                sh '''
                    set -eu

                    echo "========================================"
                    echo "DEPLOYMENT STATUS"
                    echo "========================================"

                    kubectl get deployment nextjs-website

                    echo "========================================"
                    echo "APPLICATION PODS"
                    echo "========================================"

                    kubectl get pods \
                        -l app=nextjs-website \
                        -o wide

                    echo "========================================"
                    echo "APPLICATION SERVICE"
                    echo "========================================"

                    kubectl get service nextjs-website-service

                    echo "========================================"
                    echo "HORIZONTAL POD AUTOSCALER"
                    echo "========================================"

                    kubectl get hpa nextjs-website-hpa

                    echo "========================================"
                    echo "TARGET GROUP BINDING"
                    echo "========================================"

                    kubectl get targetgroupbinding nextjs-website-tgb
                '''
            }
        }
    }

    post {
        success {
            echo '============================================'
            echo 'BUILD AND DEPLOYMENT SUCCESSFUL'
            echo '============================================'

            echo "EKS Cluster: ${EKS_CLUSTER_NAME}"
            echo "ECR Repository: ${ECR_REPOSITORY}"
            echo "Deployed Image: ${IMAGE_NAME}:${IMAGE_TAG}"
            echo "Latest Image: ${IMAGE_NAME}:latest"
        }

        failure {
            echo '============================================'
            echo 'BUILD OR DEPLOYMENT FAILED'
            echo '============================================'

            echo 'Check the failed Jenkins stage and console output.'
        }

        always {
            echo "Jenkins Build Number: ${BUILD_NUMBER}"
        }
    }
}