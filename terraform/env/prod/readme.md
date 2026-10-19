# Configure kubectl

aws eks update-kubeconfig \
  --region us-east-1 \
  --name othm-eks-prod \
  --profile fitwin-dev

  # Import the existing EKS access entry

  terraform import \
  'module.eks.aws_eks_access_entry.admin' \
  'othm-eks-prod:arn:aws:iam::125022369875:user/terraform'

  # Import the existing access policy association

  terraform import \
  'module.eks.aws_eks_access_policy_association.admin' \
  'othm-eks-prod#arn:aws:iam::125022369875:user/terraform#arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy'

## w

curl -vk --connect-timeout 5 \
  https://ECA8B860D205E2C53A1A94F6BE846BE7.gr7.us-east-1.eks.amazonaws.com


kubectl get nodes

kubectl get pods -A

## Configure kubectl to use your EKS cluster

```bash
aws eks update-kubeconfig --name othm-eks-prod
```

```bash
kubectl config current-context
```

## Deploy test website to eks

``` bash
cat <<'EOF' > html-test.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: html-test-content
data:
  index.html: |
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>EKS Test Website</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background: #f1f5f9;
          color: #0f172a;
          display: flex;
          justify-content: center;
          align-items: center;
          min-height: 100vh;
          margin: 0;
        }
        .card {
          background: white;
          padding: 40px;
          border-radius: 16px;
          text-align: center;
          box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        h1 { color: #2563eb; }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>Hello from Amazon EKS!</h1>
        <p>Your HTML website is running successfully.</p>
        <p>Deployed from an EC2 management server.</p>
      </div>
    </body>
    </html>
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: html-test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: html-test
  template:
    metadata:
      labels:
        app: html-test
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 3
            periodSeconds: 5
          volumeMounts:
            - name: html-content
              mountPath: /usr/share/nginx/html/index.html
              subPath: index.html
      volumes:
        - name: html-content
          configMap:
            name: html-test-content
---
apiVersion: v1
kind: Service
metadata:
  name: html-test-service
spec:
  type: ClusterIP
  selector:
    app: html-test
  ports:
    - name: http
      port: 80
      targetPort: 80
EOF
```

## Apply the configuration:
``` bash
kubectl apply -f html-test.yaml
```

## website pods
 ``` bash
 kubectl rollout status deployment/html-test --timeout=180s
 ```

 ## test pods

 ``` bash
 kubectl get pods -o wide
 ```

 ## Check the Service and its endpoints

 ``` bash
 kubectl get service html-test-service
 kubectl get endpoints html-test-service
 ```

 ## Install helm
 ```bash
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
  chmod 700 get_helm.sh
  ./get_helm.sh
 ```

 ## Add the AWS EKS Helm repository
 ```bash
 helm repo add eks https://aws.github.io/eks-charts

 helm repo update
```

 ## Create Service Account

 ```bash
 helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<EKS_CUSTER_NAME> \
  --set region=us-east-1 \
  --set vpcId=<VPC_ID> \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<LB_CONTROLER_ARN>

  helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=othm-eks-prod \
  --set region=us-east-1 \
  --set vpcId=vpc-05b1f6a9796aa404c \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::125022369875:role/othm-lb-controller-role-prod

 ## Create the binding config on EKS management server

 ```bash
 cat <<'EOF' > nextjs-website-tgb.yml
  apiVersion: elbv2.k8s.aws/v1beta1
  kind: TargetGroupBinding
  metadata:
    name: nextjs-website-tgb
    namespace: default
  spec:
    serviceRef:
      name: nextjs-website-service
      port: 80
    targetGroupARN: arn:aws:elasticloadbalancing:us-east-1:125022369875:targetgroup/othm-eks-tg-prod/18eded28dc55e8fe
    targetType: ip
EOF
 ```

 ## Check whether the TargetGroupBinding CRD exists
 ```bash
 kubectl get crd targetgroupbindings.elbv2.k8s.aws
 ```

## Apply the TargetGroupBinding

```bash
kubectl apply -f nextjs-website-tgb.yml
```

## Verify the TargetGroupBinding
```bash
kubectl get targetgroupbinding -n default

kubectl describe targetgroupbinding nextjs-website-tgb -n default
```

### verify
```bash
kubectl describe targetgroupbinding html-test-tgb
kubectl -n kube-system logs deploy/aws-load-balancer-controller --tail=50
```


## auto scale

## Check whether the add-on already exists

aws eks list-addons \
  --cluster-name othm-eks-prod \
  --region us-east-1

## If metrics-server is not listed, install it:

aws eks create-addon --cluster-name othm-eks-prod --addon-name metrics-server

{
    "addon": {
        "addonName": "metrics-server",
        "clusterName": "othm-eks-prod",
        "status": "CREATING",
        "addonVersion": "v0.9.0-eksbuild.13",
        "health": {
            "issues": []
        },
        "addonArn": "arn:aws:eks:us-east-1:125022369875:addon/othm-eks-prod/metrics-server/b2d0a9d2-a1fe-a8e9-1d94-501504093818",
        "createdAt": "2026-10-19T10:11:42.401000+00:00",
        "modifiedAt": "2026-10-19T10:11:42.419000+00:00",
        "tags": {},
        "namespaceConfig": {
            "namespace": "kube-system"
        }
    }
}