## Helm3 Charts for Sonatype Products

These charts are designed to work out of the box with minikube using both ingess and ingress dns addons.

The current releases have been tested on minikube v1.12.1 running k8s v1.18.3

### To Add as a Helm Repo
```helm repo add sonatype https://sonatype.github.io/helm3-charts/ ```

### To install Sonatype's Nexus products
```helm ```

### 413 Errors
The default setting for Nginx allows for very small upload sizes. Add this annotation to the ingress for each product to remove teh limit:
```nginx.ingress.kubernetes.io/proxy-body-size: "0"```