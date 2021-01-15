## Helm3 Charts for Sonatype Products

These charts are designed to work out of the box with minikube using both Ingess 
and Ingress DNS addons.

The current releases have been tested on minikube v1.12.3 running k8s v1.18.3

### Add as a Helm Repo

`helm repo add sonatype https://sonatype.github.io/helm3-charts/`

### Install a Server

* NXRM: `helm install nexus-repo sonatype/nexus-repository-manager`
* Nexus IQ: `helm install nexus-iq sonatype/nexus-iq-server`

### Source

Visit https://github.com/sonatype/helm3-charts.
