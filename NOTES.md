Project: Distributed Tracing with OpenTelemetry
    Goal: Enable Collecting and Exporting of Trace Telemetry in Kubernetes

1. Review example micro-service application in kind cluster (starts off deployed with no instrumentation)
    Components
        a. worker micro-service:  generates orders and posts to API
        b. API micro-service: receives orders and stores to Postgres DB
        c. Postgres DB  
    a. list pods, deployments, postgres statefulset
    b. confirm applications are working from logs

2. Review example micro-service application code
    a. review code for worker and API: main.py, config.py, requirements.txt
    b. review Docker files and docker-compose file
    c. review k8s manifests (no OTEL_EXPORTER_OTLP_TRACES_ENDPOINT envar at this time)

3. Perfrom manual instrumentation
    a. add packages to worker requirements.txt
    b. instrument worker in main.py, only export to console and without inject headers
    c. These packages provide the building blocks for creating and exporting spans
    c. add packages to API requirements.txt
    d. instrument API in main.py, only export to console and without inject headers

4. Build and deploy
    a. docker build
    b. kind load into cluster
    c. kubectl apply manifests
    d. inspect logs and check for spans

5. Exporting and Visualising traces
    a. install OpenTelemetry Operator and CRDs from manifest
    b. install OpenTelemetry collector from collector manifest
    a. install grafana helm repo
    b. install grafana Tempo
    c. install grafana
    d. log into grafana
    e. add Tempo as a data surce in grafana

6. Continue worker and API instrumentation
    a. add otel exporter in main.py and add exporter ednpoint envar in config.py
    b. build and load new image to kind
    c. add OTEL_EXPORTER_OTLP_TRACES_ENDPOINT envar to k8s manifests
    d. check for trace data in grafana
    e. verify if trace context is being propagated

7. Finish worker instrumentation
    a. add context inject to main.py
    b. build and load new image to kind
    c. delete pod to restart with latest image
    d. check for trace data in grafana
    e. verify context propagation

8. Auto instrumentation
    a. start with uninstrumented application deployed
    b. install Instrumentation manifest
    c. annotate deployments
    d. describe pods, check for init container and OTEL envars
    e. check for trace data in grafana

docker compose build microservices-demo-worker
kind -n otel load docker-image microservices-demo-worker
kp -n monitoring svc/grafana 8090:80 --address 0.0.0.0