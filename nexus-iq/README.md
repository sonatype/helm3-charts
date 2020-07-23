# Sonatype IQ server

[Sonatype Nexus IQ Server](https://www.sonatype.com/nexus-iq-server)  is everything you need to know to trust your software supply chain. It powers Nexus Firewall, Nexus Lifecycle, and Nexus Auditor.

### Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- Helm 3

These charts are designed to work out of the box with minikube using both ingess and ingress-dns addons.

The current releases have been tested on minikube v1.12.1 running k8s v1.18.3

To Add as a Helm Repo
helm repo add sonatype https://sonatype.github.io/helm3-charts/

To install Sonatype's Nexus products
helm

413 Errors
The default setting for Nginx allows for very small upload sizes. Add this annotation to the ingress for each product to remove teh limit: nginx.ingress.kubernetes.io/proxy-body-size: "0"


## Testing the Chart
To test the chart:
```bash
$ helm install --dry-run --debug ./
```
To test the chart with your own values:
```bash
$ helm install --dry-run --debug -f my_values.yaml ./
```

## Installing the Chart

To install the chart:

```bash
$ helm install ./
```

The above command deploys IQ on the Kubernetes cluster in the default configuration.

If you are getting the error `Error: no available release name found` during
`helm install`, grant cluster-admin to kube-system:default service account:
```bash
$ kubectl create clusterrolebinding add-on-cluster-admin \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:default
```

You can pass custom configuration values as:

```
helm install -f myvalues.yaml ./ --name sonatype-
```

The default login is admin/admin123

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm list
NAME           	REVISION	UPDATED                 	STATUS  	CHART      	                NAMESPACE
plinking-gopher	1       	Fri Sep  1 13:19:50 2017	DEPLOYED	iqserver-0.1.0	            default
$ helm delete plinking-gopher
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Chart Configuration Options

| Parameter            | Description                                                  | Default           |
| -------------------- | ------------------------------------------------------------ | ----------------- |
| `iq.imageName`       | The image name to use for the IQ Container, eg `sonatype/nexus-iq-server`  | `"registry.connect.redhat.com/sonatype/nexus-iq-server"`              |
| `iq.imageTag`        | The image tag to use                                         | the latest tag, eg `"1.85.0-01-ubi"`              |
| `iq.imagePullSecret` | The base-64 encoded secret to pull a container from Red Hat  | `""`              |
| `iq.applicationPort` | Port of the application connector. Must match the value in the `configYaml` property | `8070`            |
| `iq.adminPort`       | Port of the application connector. Must match the value in the `configYaml` property | `8071`            |
| `iq.memory`          | The amount of RAM to allocate                                | `1Gi`             |
| `iq.licenseSecret`   | The base-64 encoded license file to be installed at startup  | `""`              |
| `iq.configYaml`      | A YAML block which will be used as a configuration block for IQ Server. | See `values.yaml` |
| `ingress.enabled`                           | Create an ingress for Nexus         | `true`                                  |
| `ingress.annotations`                       | Annotations to enhance ingress configuration  | `{}`                          |
| `ingress.tls.enabled`                       | Enable TLS                          | `true`                                 |
| `ingress.tls.secretName`                    | Name of the secret storing TLS cert, `false` to use the Ingress' default certificate | `nexus-tls`                             |
| `ingress.path`                              | Path for ingress rules. GCP users should set to `/*` | `/`                    |
| `deployment.preStart.command`               | Command to run before starting the IQ Server container  | `nil`                   |
| `deployment.postStart.command`              | Command to run after starting the IQ Server container  | `nil`                    |
| `deployment.terminationGracePeriodSeconds`  | Update termination grace period (in seconds)        | 120s                    |
| `persistence.storageClass` | The provisioner class                        | `-` (disables dynamic provisioning             |
| `persistence.storageSize` | The amount of drive space to allocate                        | `1Gi`             |
| `persistence.accessMode` | Default access mode                        | `ReadWriteOnce`             |
| `persistence.volumeConfiguration` | A YAML block to configure the persistent volume type. Defaults to `hostPath` which should not be used in production | `hostPath`             |



## Configuring IQ Server

You can define the `config.yml` for IQ Server in your `myvalues.yml` file on startup. 
It is the `iq.configYaml` property. For more details, see the [Configuring IQ Server](https://help.sonatype.com/iqserver/configuring) help page.


## Installing the License

The license file can be installed via the UI when IQ server is running, or it can be done as a part of the deploy. 
If you leave the `licenseFile` field empty/commented, IQ Server will start and prompt you to manually install the license 
when you first enter the GUI.

