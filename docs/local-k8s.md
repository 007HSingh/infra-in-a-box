## Registry

The cluster uses a k3d-managed registry for storing container images locally.

### Registry Details

- **Name**: k3d-infra-registry
- **Host Access**: localhost:5000
- **Cluster Access**: k3d-infra-registry:5000
- **Management**: Automatically managed by k3d
- **Persistence**: Volume persists across cluster restarts

### Usage Examples

#### From Host Machine

```bash
# Build and tag
docker build -t localhost:5000/myapp:v1 .

# Push to local registry
docker push localhost:5000/myapp:v1

# List images in registry
curl http://localhost:5000/v2/_catalog
```

#### From Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: myapp
          image: k3d-infra-registry:5000/myapp:v1
          imagePullPolicy: Always
```

### Registry Management

The registry is automatically:

- Created when the cluster is created
- Started when the cluster starts
- Stopped when the cluster stops
- Deleted when the cluster is deleted (use `k3d registry delete infra-registry` to delete separately)

### Troubleshooting

```bash
# Check registry status
docker ps | grep registry

# View registry logs
docker logs k3d-infra-registry

# Test registry connectivity
curl http://localhost:5000/v2/_catalog

# Recreate everything
k3d cluster delete infra
k3d registry delete infra-registry
./scripts/setup-k3d.sh
```
