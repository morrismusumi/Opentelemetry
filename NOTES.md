
docker compose build microservices-demo-worker
kind -n otel load docker-image microservices-demo-worker
kp -n monitoring svc/grafana 8090:80 --address 0.0.0.0