![Lint and Test Charts](https://github.com/sonatype/helm3-charts/workflows/Lint%20and%20Test%20Charts/badge.svg)

## Helm3 Charts for Sonatype Products

These charts are designed to work out of the box with minikube using both ingess and ingress dns addons.

The current releases have been tested on minikube v1.12.3 running k8s v1.18.3

### User Documentation

See docs/index.md which is also https://sonatype.github.io/helm3-charts/

### Contributing

See the [contributing document](./CONTRIBUTING.md) for details.

For Sonatypers, note that external contributors must sign the CLA and
the Dev-Ex team must verify this prior to accepting any PR.

### Updating Charts

Charts for Nexus IQ and for NXRM can be updated in `charts/` directories.
The most common updates will be to use new application images and to bump 
chart versions for release.

There should likely be no reason to update anything in `docs/` by hand.

Test a chart in a local k8s cluster (like minikube) by installing the local copy
from within each charts directory: 
```
helm install --generate-name ./
```

### Packaging and Indexing for Release

*Sonatype CI build will package, commit, and publish to the official helm repository.*

Upon update of the `charts/`, run `build.sh` from here in the project root to
create `tgz` packages of the latest chart changes and regenerate the `index.yaml`
file to the `docs/` directory which is the root of the 
[repo site](https://sonatype.github.io/helm3-charts/).

The build process requires Helm 3.

### Manually Testing the Helm Charts
To test Helm Charts locally you will need to follow the next steps:

1. Install docker, helm, kubectl, and [minikube](https://minikube.sigs.k8s.io/docs/start/), if you don't already have it on your local workstation.
    * You could also use docker with k8s enabled instead of minikube. You don't need both.
2. Start up minikube: `minikube start`
3. Confirm minikube is up and running: `minikube status`
4. List the existing pods in the cluster: `kubectl get pods`  (There should not be anything listed at this point.)
5. Install the helm chart in any of these ways:
    * From a copy of the source: `helm install iq {path/to/your/helm3-charts}/charts/nexus-iq --wait` 
    * From our production online repo: Add our helm repo locally as instructed at https://sonatype.github.io/helm3-charts/
6. List installed servers with helm: helm list 
7. Watch the server start in kubernetes by running: `kubectl get pods`
8. Use the pod name you get from last command to follow the console logs: `kubectl logs -f iq-nexus-iq-server-xxx` 
9. Confirm expected version numbers in those logs.
10. Forward a localhost port to a port on the running pod: `kubectl port-forward iq-nexus-iq-server-xxx 8070`
11. Connect and check that your fresh new server is successfully running: `http://localhost:8070/`
12. Uninstall the server with helm: `helm delete iq` 
13. Confirm it's gone: `helm list && kubectl get pods`
14. Shutdown minikube: `minikube stop`

### Running Lint
Helm's Lint command will highlight formatting problems in the charts that need to be corrected.
```
helm lint charts/nexus-iq charts/nexus-repository-manager
```

### Running Unit Tests
To unit test the helm charts you can follow the next steps:

1. Install the unittest plugin for Helm: https://github.com/quintush/helm-unittest
2. Run the tests for each individual chart:
   * `cd charts/nexus-iq; helm unittest -3 -t junit -o test-output.xml .`
   * `cd charts/nexus-repository-manager; helm unittest -3 -t junit -o test-output.xml .`

### Running Integration Tests
You can run the integration tests for the helm charts by running the next commands. 

Before running the integration tests:
* Install docker, helm, kubectl, and [minikube](https://minikube.sigs.k8s.io/docs/start/), if you don't already have it on your local workstation.
  * You could also use docker with k8s enabled instead of minikube.
* The integration tests will be executed on a running cluster. Each test will create a new POD that will connect to the server installed by our 
helm chart. Check [this](https://helm.sh/docs/topics/chart_tests/)

Running integration tests for Nexus IQ:
1. From source code: `helm install iq ./charts/nexus-iq --wait`
2. Run the tests: `helm test iq`

Running integration tests for Nexus Repository Manager:
1. From source code: `helm install nxrm ./charts/nexus-repository-manager --wait`
3. Run the tests: `helm test nxrm`

### Further Notes on Usage

#### Resolver File and Ingress-DNS

Get the default `values.yaml` for each chart.
- Nexus Repository: `helm show values nexus-repo sonatype/nexus-repository-manager > iq-values.yaml`
- Nexus IQ: `helm show values nexus-iq sonatype/nexus-iq-server > repo-values.yaml`

Edit the values file you just downloaded to enable ingress support, and install the chart 
with those values:

- Nexus Repository: `helm install nexus-repo sonatype/nexus-repository-manager -f repo-values.yaml`
- Nexus IQ: `helm install nexus-iq sonatype/nexus-iq-server -f iq-values.yaml`

If you want to use the custom values file for the demo environment that expose 
the apps on a local domain of *.demo which is done by creating a resolver file. 
On a Mac it's `/etc/resolver/minikube-minikube-demo` with the following entries:
```
domain demo
nameserver 192.168.64.8
search_order 1
timeout 5
```

You'll need to update the IP address to match the running instance's IP address.
Use `minikube ip` to get the address

Docs for Ingress-dns are here
https://github.com/kubernetes/minikube/tree/master/deploy/addons/ingress-dns
