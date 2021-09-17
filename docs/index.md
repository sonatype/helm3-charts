## Helm3 Charts for Sonatype Products

These charts are designed to work out of the box with minikube using both Ingress
and Ingress DNS addons.

The current releases have been tested on minikube v1.12.3 running k8s v1.18.3

### Add the Sonatype Repo to Your Helm

`helm repo add sonatype https://sonatype.github.io/helm3-charts/`

### Install a Server

- NXRM: `helm install nexus-repo sonatype/nexus-repository-manager`
- Nexus IQ: `helm install nexus-iq sonatype/nexus-iq-server`

### Get the Values for Configuring a Chart

- NXRM: `helm show values nexus-repo sonatype/nexus-repository-manager`
- Nexus IQ: `helm show values nexus-iq sonatype/nexus-iq-server`

Capture that output as your own `values.yaml`, and feed it into the `helm install` 
with the `-f` option.

### Source

Visit https://github.com/sonatype/helm3-charts.
