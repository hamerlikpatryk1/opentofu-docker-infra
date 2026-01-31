# App Docker Image

![Docker Build](https://github.com/hamerlikpatryk1/opentofu-docker-infra/actions/workflows/docker_build.yml/badge.svg)

## Description

The Docker image contains the **App** application, ready to run in a container.  
It supports the following environments: `dev`, `staging`, `prod`. 

---

## Table of Contents

- [Build](#build)
- [Monitoring](#monitoring)
  - [Prometheus](#prometheus)
  - [Grafana](#grafana)

---

## Build

To build the image locally:

```bash
docker build -t app:latest ./docker/web

```
## Monitoring

The stack includes Prometheus and Grafana.

### Prometheus

- Port: `9090`
- Configuration in `docker/prometheus/prometheus.yml`
- Data collected from the `web` container (endpoint `/metrics`)

### Grafana

- Port: `3000`
- Provisioning:
  - Dashboards: `docker/grafana/provisioning/dashboards/`
  - Datasource: `docker/grafana/provisioning/datasource/`
- Data from Prometheus
- Default login/password: admin/admin (change in prod!)
