# blue-green-k8s
Zero-downtime Kubernetes deployments using blue-green strategy.
## Quick start
```bash
docker build -t myorg/myapp:2.0.0 .
docker push myorg/myapp:2.0.0
./scripts/deploy.sh 2.0.0 green
```
## File structure
```
Dockerfile                 # multi-stage build
.dockerignore              # exclude k8s/, scripts/ etc.
app/main.go                # sample Go app
k8s/                       # kubernetes manifests
scripts/                   # deploy + rollback helpers
.github/workflows/         # CI/CD pipeline