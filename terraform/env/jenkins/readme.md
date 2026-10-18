## Get the initial administrator password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Configure Nginx as a Jenkins reverse proxy

```bash
sudo nano /etc/nginx/conf.d/jenkins-websocket.conf
```

## Now create the Jenkins site configuration:

```bash
sudo nano /etc/nginx/sites-available/jenkins
```

## Nginx Config

```bash
server {
    listen 80;
    listen [::]:80;

    server_name jenkins.akesha.site;

    access_log /var/log/nginx/jenkins.access.log;
    error_log  /var/log/nginx/jenkins.error.log;

    location / {
        proxy_pass http://127.0.0.1:8080;

        proxy_http_version 1.1;

        proxy_set_header Host              $http_host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        proxy_connect_timeout 90;
        proxy_send_timeout    90;
        proxy_read_timeout    90;

        proxy_request_buffering off;
        proxy_buffering off;

        client_max_body_size 20m;
    }
}
```

## Enable the site

```bash
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/jenkins
```

## disable default Nginx site

```bash
sudo rm -f /etc/nginx/sites-enabled/default
```

## Install Certbot using the recommended Snap method:

```bash
sudo apt update
sudo apt install -y snapd

sudo snap install certbot --classic
```

## Make sure the Certbot command is available:

```bash
sudo ln -s /snap/bin/certbot /usr/local/bin/certbot
```

## Generate the SSL certificate

```bash
sudo certbot --nginx -d jenkins.akesha.site
```

## Enable and test automatic SSL renewal

```bash
sudo systemctl status snap.certbot.renew.timer
```

## Test automatic renewal without waiting for the certificate to expire:

```bash
sudo certbot renew --dry-run
```


## Install kubectl on the Jenkins server

```bash
sudo apt-get update
sudo apt-get install -y curl

cd /tmp

KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm kubectl

kubectl version --client
```

## Give jenkins docker permisions

```bash
sudo usermod -aG docker jenkins
```