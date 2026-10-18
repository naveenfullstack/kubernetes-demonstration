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
        
        LB_CONTROLLER_ROLE_ARN = 'arn:aws:iam::125022369875:role/othm-lb-controller-role-prod'

        EKS_VPC_ID = 'vpc-0e4ff9b74b9e7f013'

        POD_MGMT_NAMESPACE = 'default'

        TARGET_GROUP_ARN  = 'arn:aws:elasticloadbalancing:us-east-1:125022369875:targetgroup/othm-eks-tg-prod/5d984f9da6c4747a'
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

        // =================================================
        // 8. INSTALL / UPGRADE AWS LOAD BALANCER CONTROLLER
        // =================================================
        stage('Install AWS Load Balancer Controller') {
            steps {
                sh '''
                    set -eu

                    # Verify required tools
                    command -v helm
                    command -v kubectl

                    # Add AWS EKS Helm repository
                    helm repo add eks https://aws.github.io/eks-charts \
                        --force-update

                    helm repo update

                    # Verify Kubernetes access
                    kubectl cluster-info

                    # Install or upgrade the controller
                    helm upgrade --install aws-load-balancer-controller \
                        eks/aws-load-balancer-controller \
                        --namespace kube-system \
                        --create-namespace \
                        --set clusterName="${EKS_CLUSTER_NAME}" \
                        --set region="${AWS_REGION}" \
                        --set vpcId="${EKS_VPC_ID}" \
                        --set serviceAccount.create=true \
                        --set serviceAccount.name=aws-load-balancer-controller \
                        --set-string "serviceAccount.annotations.eks\\\\.amazonaws\\\\.com/role-arn=${LB_CONTROLLER_ROLE_ARN}"

                    # Wait for the controller to become ready
                    kubectl rollout status \
                        deployment/aws-load-balancer-controller \
                        -n kube-system \
                        --timeout=300s

                    # Verify controller
                    kubectl get deployment aws-load-balancer-controller \
                        -n kube-system

                    kubectl get serviceaccount aws-load-balancer-controller \
                        -n kube-system
                '''
            }
        }

        // =================================================
        // 8. APPLY TARGET GROUP BINDING
        // =================================================
        stage('Apply Pod Management') {
            steps {
                dir('next') {
                    sh '''
                        set -eu

                        echo "Checking required manifest..."

                        test -f k8-pods-mg.yml

                        : "${TARGET_GROUP_ARN:?TARGET_GROUP_ARN is required}"

                        echo "Checking target group in AWS..."

                        aws elbv2 describe-target-groups \
                            --target-group-arns "${TARGET_GROUP_ARN}" \
                            --region "${AWS_REGION}" \
                            --query 'TargetGroups[0].{ARN:TargetGroupArn,TargetType:TargetType,Port:Port,VpcId:VpcId,Protocol:Protocol}' \
                            --output table

                        echo "Checking controller..."

                        kubectl rollout status \
                            deployment/aws-load-balancer-controller \
                            -n kube-system \
                            --timeout=300s

                        echo "Checking application deployment..."

                        kubectl rollout status \
                            deployment/nextjs-website \
                            --timeout=300s

                        echo "Generating TargetGroupBinding manifest..."

                        envsubst '${TARGET_GROUP_ARN}' \
                            < k8-pods-mg.yml \
                            > /tmp/nextjs-tgb.yml

                        echo "Validating generated manifest..."

                        grep 'targetGroupARN:' /tmp/nextjs-tgb.yml

                        echo "Testing webhook and manifest validation..."

                        kubectl apply \
                            --dry-run=server \
                            -f /tmp/nextjs-tgb.yml

                        echo "Applying TargetGroupBinding..."

                        kubectl apply -f /tmp/nextjs-tgb.yml

                        echo "Waiting for Kubernetes resources..."

                        kubectl get deployment nextjs-website

                        kubectl get pods \
                            -l app=nextjs-website \
                            -o wide

                        kubectl get service nextjs-website-service

                        echo "Checking TargetGroupBinding..."

                        kubectl get targetgroupbindings -n default

                        kubectl describe targetgroupbinding \
                            nextjs-website-tgb \
                            -n default

                        echo "Checking controller logs..."

                        kubectl logs \
                            deployment/aws-load-balancer-controller \
                            -n kube-system \
                            --tail=50
                    '''
                }
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