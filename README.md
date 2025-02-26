# OpenTelemetry for Applications in Kubernetes

## Deploy Microservices Demo App

### Step 1: Set Up Namespace and Database
```sh
kubectl create ns microservices-demo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install postgresql bitnami/postgresql -n microservices-demo
```

### Step 2: Build and Deploy Microservices
```sh
cd microservices-demo
docker compose build
docker images
kind create cluster -n otel
kind load docker-image microservices-demo-api microservices-demo-worker -n otel

cd ..
kubectl apply -f microservices-demo/k8s/api-deploy-svc.yml
kubectl apply -f microservices-demo/k8s/worker-deploy.yml
```

## Deploy Enable OpenTelemetry

### Step 3: Install OpenTelemetry Operator and Collector
```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml

kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

kubectl apply -f microservices-demo/k8s/otel-collector.yml

kubectl get pods -n opentelemetry-operator-system
```

### Step 4: Install and Configure Grafana and Tempo
```sh
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install grafana-tempo -n monitoring grafana/tempo 

helm install grafana -n monitoring grafana/grafana

kubectl get pods -n monitoring
```

### Step 5: Retrieve Grafana Admin Password
```sh
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### Step 6: Port Forward Grafana
```sh
kubectl port-forward svc/grafana --address 0.0.0.0 8000:80 -n monitoring
```

