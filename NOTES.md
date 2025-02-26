Deploy microservices demo app

kubectl create ns microservices-demo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install postgresql bitnami/postgresql -n microservices-demo
cd otel/step-1/microservices-demo
docker compose build
docker images
kind get clusters
kind load docker-image microservices-demo-api microservices-demo-worker -n otel
kubectl  apply -f api-deploy-svc.yml
kubectl  apply -f worker-deploy.yml

kubectl exec -it microservices-demo-worker-8556dddb68-9jkl8  -- sh
/app # pip install opentelemetry-distro opentelemetry-exporter-otlp
/app # opentelemetry-bootstrap
/app # opentelemetry-bootstrap install -a

cd otel/step-2/microservices-demo
docker compose build
kind load docker-image microservices-demo-api microservices-demo-worker -n otel
kubectl  apply -f api-deploy-svc.yml
kubectl  apply -f worker-deploy.yml

kubectl logs microservices-demo-worker-696f5bcb79-dnq2p

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
kubectl apply -f otel-collector.yml
kubectl logs microservices-demo-collector-848784b95c-99zcf


helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana-tempo -n monitoring grafana/tempo 

helm install grafana -n monitoring grafana/grafana

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl port-forward svc/grafana --address 0.0.0.0 8000:80 -n monitoring

cd otel/step-3/microservices-demo
docker compose build
kind load docker-image microservices-demo-api microservices-demo-worker -n otel
kubectl  apply -f api-deploy-svc.yml
kubectl  apply -f worker-deploy.yml