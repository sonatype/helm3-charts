# Sonatype IQ server

[Sonatype Nexus IQ Server](https://www.sonatype.com/nexus-iq-server)  is everything you need to know to trust your software supply chain. It powers Nexus Firewall, Nexus Lifecycle, and Nexus Auditor.

### Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- Helm 3

These charts are designed to work out of the box with minikube using both ingess and ingress-dns addons.

The current releases have been tested on minikube v1.14.2 running k8s v1.19.2

## Adding the repo
To Add as a Helm Repo
```helm repo add sonatype https://sonatype.github.io/helm3-charts/```

## Testing the Chart
To test the chart:
```bash
$ helm install --dry-run --debug --generate-name ./
```
To test the chart with your own values:
```bash
$ helm install --dry-run --debug --generate-name -f myvalues.yaml ./ 
```

## Installing the Chart

To install the chart:

```bash
$ helm install nexus-iq sonatype/nexus-iq-server [ --version v90.0.0 ]
```

The above command deploys IQ on the Kubernetes cluster in the default configuration. Note the optional version flag.

You can pass custom configuration values as:

```bash
$ helm install -f myvalues.yaml ./ --name nexus-iq
```

The default login for the IQ Server is admin/admin123

## Upgrading the Chart

```bash
$ helm upgrade nexus-iq sonatype/nexus-iq-server [--version v91.0.0]
```

Note: optional version flag shown

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm list
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
plinking-gopher	        default         1               2021-03-10 15:13:04.614125 -0800 PST    deployed        nexus-iq-server-106.0.0 1.106.0    
$ helm delete plinking-gopher
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Chart Configuration Options

| Parameter            | Description                                                  | Default           |
| -------------------- | ------------------------------------------------------------ | ----------------- |
| `iq.imageName`       | The image name to use for the IQ Container, eg `sonatype/nexus-iq-server`  | `"registry.connect.redhat.com/sonatype/nexus-iq-server"`              |
| `iq.imagePullSecret` | The base-64 encoded secret to pull a container from Red Hat  | `""`              |
| `iq.applicationPort` | Port of the application connector. Must match the value in the `configYaml` property | `8070`            |
| `iq.adminPort`       | Port of the application connector. Must match the value in the `configYaml` property | `8071`            |
| `iq.memory`          | The amount of RAM to allocate                                | `1Gi`             |
| `iq.licenseSecret`   | The base-64 encoded license file to be installed at startup  | `""`              |
| `iq.configYaml`      | A YAML block which will be used as a configuration block for IQ Server. | See `values.yaml` |
| `iq.env`             | IQ server environment variables | `[{JAVA_OPTS: -Xms1200M -Xmx1200M}]` |
| `iq.secretName`      | The name of a secret to mount inside the container  | See `values.yaml` |
| `iq.secretMountName`      | Where in the container to mount the data from `secretName`  | See `values.yaml` |
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
| `persistence.existingClaim` | Pre-created PVC name for Data Volume                        | `nil`             |
| `persistence.existingLogClaim` | Pre-created PVC name for Log Volume                        | `nil`             |
| `persistence.volumeConfiguration` | A YAML block to configure the persistent volume type. Defaults to `hostPath` which should not be used in production | `hostPath`             |

## Configuring IQ Server

You can define the `config.yml` for IQ Server in your `myvalues.yml` file on startup. 
It is the `iq.configYaml` property. For more details, see the [Configuring IQ Server](https://help.sonatype.com/iqserver/configuring) help page.
Additionally the server can be started with JAVA_OPTS exported to the environment. This will be added to the server 
process invocation and can be used for purposes such as changing the server memory settings. See the defaults set in
[the values.yaml file](values.yaml).

## Installing the License

The license file can be installed via the UI when IQ server is running, or it can be done as a part of the deploy. 
If you leave the `licenseFile` field empty/commented, IQ Server will start and prompt you to manually install the license 
when you first enter the GUI.

## 413 Errors
The default setting for Nginx allows for very small upload sizes. Add this annotation to the ingress for each product to remove the limit: nginx.ingress.kubernetes.io/proxy-body-size: "0"
 
## Specifying custom Java keystore/truststore
There is an example of how to implement this in [the values.yaml file](values.yaml) using secrets to store both the
Java keystores and their associated passwords. In order to utilize the provided example directly secrets can be created 
from a directory containing the keystore and truststore files like so:
```shell
kubectl create secret generic secret-jks 
	--from-file=truststore.jks=./truststore.jks 
	--from-file=keystore.jks=./keystore.jks 
	--from-literal='keystorePassword=password' 
	--from-literal='truststorePassword=password'
```



