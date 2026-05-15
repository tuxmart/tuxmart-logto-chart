# Tuxmart Logto Helm Chart

This Helm chart deploys Logto Identity Service with:
- External PostgreSQL database (required for production)
- MetalLB LoadBalancer support
- Kubernetes best practices
- Production-grade security


## Features

- External PostgreSQL database support (PostgreSQL 17)
- MetalLB LoadBalancer configuration
- Pod Disruption Budget
- Horizontal Pod Autoscaler
- Network Policies
- Pod Anti-Affinity rules
- Security Contexts (runAsNonRoot, readOnlyRootFilesystem)
- Resource limits and requests
- Liveness and readiness probes
- Service accounts with RBAC
- ConfigMaps and Secrets management
- Ingress support with TLS
- Topology spread constraints
- Priority class configuration
- Image pull secrets for private registries

## Requirements

Kubernetes: `>=1.23.0`
Helm: `>=3.8.0`

## Values

See [values.yaml](values.yaml) for all configurable options.

## Team Practices

This chart follows Tuxmart team practices:
1. External PostgreSQL database (PostgreSQL 17)
2. MetalLB LoadBalancer support
3. Kubernetes best practices (security, reliability, observability)

## Deployment Modes

### Production (Recommended)
```yaml
service:
  type: LoadBalancer
  loadBalancerIP: "192.168.1.100"

externalDatabase:
  enabled: true
  host: "prod-pg.example.com"
  port: 5432
  username: "logto"
  password: "<secret>"
  database: "logto"
  ssl: true
```

### Development
```yaml
service:
  type: ClusterIP

externalDatabase:
  enabled: true
  host: "localhost"
  port: 5432
  username: "postgres"
  password: "postgres"
  database: "logto"
```
