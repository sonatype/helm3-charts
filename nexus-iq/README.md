# Sonatype IQ server

[Sonatype Nexus IQ Server](https://www.sonatype.com/nexus-iq-server)  is everything you need to know to trust your software supply chain. It powers Nexus Firewall, Nexus Lifecycle, and Nexus Auditor.

### Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- Helm 2

### With Open Docker Image

By default, the Chart uses Red Hat's Certified Container. If you want to use the standard docker image, run with `--set iq.imageName=sonatype/nexus-iq-server`.

### With Red Hat Certified container

Red Hat Certified Container (RHCC) requires authentication in order to pull the image. To do this:

  1. [Create a Service Account](https://access.redhat.com/terms-based-registry/)
  2. Copy the docker configuration JSON sample and replace the host from `registry.redhat.io` to `registry.connect.redhat.com` and save it as a file, eg:

```json
{
  "auths": {
    "registry.connect.redhat.com": {
      "auth": "TOKEN"
    }
  }
}
```

If the cluster fails to pull the image, try reverting back to `registry.redhat.io` in the `auths` configuration.

  3. Encode the file in Base 64 format:

```bash
cat service-auth.json | base64 > service.base64
```
  4. Add this to your `myvalues.yaml` as `iq.imagePullSecret`:

```yaml
iq:
  name: nxiq
  imageName: registry.connect.redhat.com/sonatype/nexus-iq-server
  imageTag: 1.85.0-01-ubi
  imagePullPolicy: IfNotPresent
  imagePullSecret: "{BASE64-DOCKER-CONFIG}"
```

## Initialize Helm/Tiller on the Kubernetes cluster if needed

Install helm/tiller:
```bash
$ helm init
```

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

### Installing the License Automatically
To do it automatically, first encode your `.lic` file in Base 64 with no line breaks, eg:

```bash
base64 --wrap=0 mylicense.lic > lic.base64
```

Then add this value to your `myvalues.yaml` file as `iq.licenseSecret`, eg:

```yaml
iq:
  licenseSecret: bXkgc2FtcGxlIGxpY2Vuc2U=
```

Specify the `licenseFile` path in your `myvalues.yaml` in `iq.configYaml` as:

```yaml
iq:
  configYaml:
    server:
      applicationConnectors:
        - type: http
          port: 8070
      adminConnectors:
        - type: http
          port: 8071
    createSampleData: true
    sonatypeWork: /sonatype-work
    # add this line and the `licenseSecret` above to autoconfigure licensing
    licenseFile: /etc/nexus-iq-license/license_lic
```
