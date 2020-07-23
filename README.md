## Helm3 Charts for Sonatype Products

These charts are designed to work out of the box with minikube using both ingess and ingress dns addons.

The current releases have been tested on minikube v1.12.1 running k8s v1.18.3

### To Add as a Helm Repo

```helm repo add sonatype https://sonatype.github.io/helm3-charts/ ```

### Resolver file and Ingress-DNS

Out of the box this chart is set to expose the apps on a local domain of *.demo which is done by creating a resolver file. On my Mac ghat is at /etc/resolver/minikube-minikube-demo with the following entries:
```
domain demo
nameserver 192.168.64.8
search_order 1
timeout 5
```

You'll need to update the IP address to match the running instance's IP address.

Docs for Ingress-0dns are here
https://github.com/kubernetes/minikube/tree/master/deploy/addons/ingress-dns

### 413 Errors
The default setting for Nginx allows for very small upload sizes. Add this annotation to the ingress for each product to remove teh limit:
```nginx.ingress.kubernetes.io/proxy-body-size: "0"```