# Nexus

[Nexus OSS](https://www.sonatype.com/nexus-repository-oss) is a free open source repository manager. It supports a wide range of package formats and it's used by hundreds of tech companies.

## Introduction

This chart bootstraps a Nexus OSS deployment on a cluster using Helm.
\
## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- Helm 2

### With Open Docker Image

By default, the Chart uses Red Hat's Certified Container. If you want to use the standard docker image, run with `--set nexus.imageName=sonatype/nexus3`.

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
  4. Add this base64 encoded string to your `myvalues.yaml` file as `nexus.imagePullSecret`:

```yaml
nexus:
  imagePullSecret: {BASE64_ENCODED_SECRET}
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
$ helm install -f myvalues.yaml ./
```

If you are getting the error `Error: no available release name found` during
`helm install`, grant cluster-admin to kube-system:default service account:
```bash
$ kubectl create clusterrolebinding add-on-cluster-admin \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:default
```

The above command deploys Nexus on the Kubernetes cluster in the default configuration.

You can pass custom configuration values as:

```
helm install -f myvalues.yaml ./ --name sonatype-nexus
```

The default login is admin/admin123

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm list
NAME           	REVISION	UPDATED                 	STATUS  	CHART      	NAMESPACE
plinking-gopher	1       	Fri Sep  1 13:19:50 2017	DEPLOYED	sonatype-nexus-0.1.0	default
$ helm delete plinking-gopher
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Nexus chart and their default values.

| Parameter                                   | Description                         | Default                                 |
| ------------------------------------------  | ----------------------------------  | ----------------------------------------|
| `statefulset.enabled`                       | Use statefulset instead of deployment | `false` |
| `replicaCount`                              | Number of Nexus service replicas    | `1`                                     |
| `deploymentStrategy`                        | Deployment Strategy     |  `rollingUpdate` |
| `nexus.imagePullPolicy`                     | Nexus image pull policy             | `IfNotPresent`                          |
| `nexus.imagePullSecret`                     | Secret to download Nexus image from private registry      | `nil`             |
| `nexus.env`                                 | Nexus environment variables         | `[{install4jAddVmParams: -Xms1200M -Xmx1200M -XX:MaxDirectMemorySize=2G -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap}]` |
| `nexus.resources`                           | Nexus resource requests and limits  | `{}`                                    |
| `nexus.dockerPort`                          | Port to access docker               | `5003`                                  |
| `nexus.nexusPort`                           | Internal port for Nexus service     | `8081`                                  |
| `nexus.service.type`                        | Service for Nexus                   |`NodePort`                                |
| `nexus.service.clusterIp`                   | Specific cluster IP when service type is cluster IP. Use None for headless service |`nil`   |
| `nexus.securityContext`                     | Security Context (for enabling official image use `fsGroup: 2000`) | `{}`     |
| `nexus.labels`                              | Service labels                      | `{}`                                    |
| `nexus.podAnnotations`                      | Pod Annotations                     | `{}`
| `nexus.livenessProbe.initialDelaySeconds`   | LivenessProbe initial delay         | 30                                      |
| `nexus.livenessProbe.periodSeconds`         | Seconds between polls               | 30                                      |
| `nexus.livenessProbe.failureThreshold`      | Number of attempts before failure   | 6                                       |
| `nexus.livenessProbe.timeoutSeconds`        | Time in seconds after liveness probe times out    | `nil`                     |
| `nexus.livenessProbe.path`                  | Path for LivenessProbe              | /                                       |
| `nexus.readinessProbe.initialDelaySeconds`  | ReadinessProbe initial delay        | 30                                      |
| `nexus.readinessProbe.periodSeconds`        | Seconds between polls               | 30                                      |
| `nexus.readinessProbe.failureThreshold`     | Number of attempts before failure   | 6                                       |
| `nexus.readinessProbe.timeoutSeconds`       | Time in seconds after readiness probe times out    | `nil`                    |
| `nexus.readinessProbe.path`                 | Path for ReadinessProbe             | /                                       |
| `nexus.hostAliases`                         | Aliases for IPs in /etc/hosts       | []                                      |
| `ingress.enabled`                           | Create an ingress for Nexus         | `true`                                  |
| `ingress.annotations`                       | Annotations to enhance ingress configuration  | `{}`                          |
| `ingress.tls.enabled`                       | Enable TLS                          | `true`                                 |
| `ingress.tls.secretName`                    | Name of the secret storing TLS cert, `false` to use the Ingress' default certificate | `nexus-tls`                             |
| `ingress.path`                              | Path for ingress rules. GCP users should set to `/*` | `/`                    |
| `tolerations`                               | tolerations list                    | `[]`                                    |
| `config.enabled`                            | Enable configmap                    | `false`                                 |
| `config.mountPath`                          | Path to mount the config            | `/sonatype-nexus-conf`                  |
| `config.data`                               | Configmap data                      | `nil`                                   |
| `deployment.annotations`                    | Annotations to enhance deployment configuration  | `{}`                       |
| `deployment.initContainers`                 | Init containers to run before main containers  | `nil`                        |
| `deployment.postStart.command`              | Command to run after starting the nexus container  | `nil`                    |
| `deployment.preStart.command`               | Command to run before starting the nexus container  | `nil`                   |
| `deployment.terminationGracePeriodSeconds`  | Update termination grace period (in seconds)        | 120s                    |
| `deployment.additionalContainers`           | Add additional Container         | `nil`                                      |
| `deployment.additionalVolumes`              | Add additional Volumes           | `nil`                                      |
| `deployment.additionalVolumeMounts`         | Add additional Volume mounts     | `nil`                                      |
| `secret.enabled`                            | Enable secret                    | `false`                                    |
| `secret.mountPath`                          | Path to mount the secret         | `/etc/secret-volume`                       |
| `secret.readOnly`                           | Secret readonly state            | `true`                                     |
| `secret.data`                               | Secret data                      | `nil`                                      |
| `service.enabled`                           | Enable additional service        | `nil`                                      |
| `service.name`                              | Service name                     | `nil`                                      |
| `service.portName`                          | Service port name                | `nil`                                      |
| `service.labels`                            | Service labels                   | `nil`                                      |
| `service.annotations`                       | Service annotations              | `nil`                                      |
| `service.loadBalancerSourceRanges`          | Service LoadBalancer source IP whitelist | `nil`                              |
| `service.targetPort`                        | Service port                     | `nil`                                      |
| `service.port`                              | Port for exposing service        | `nil`                                      |
| `route.enabled`         | Set to true to create route for additional service | `false` |
| `route.name`            | Name of route                                      | `docker` |
| `route.portName`        | Target port name of service                        | `docker` |
| `route.labels`          | Labels to be added to route                        | `{}` |
| `route.annotations`     | Annotations to be added to route                   | `{}` |
| `route.path`            | Host name of Route e.g jenkins.example.com         | nil |


### Persistence

By default a PersistentVolumeClaim is created and mounted into the `/nexus-data` directory. In order to disable this functionality
you can change the `values.yaml` to disable persistence which will use an `emptyDir` instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*


You must enable StatefulSet (`statefulset.enabled=true`) for true data persistence. If using Deployment approach, you can not recover data after restart or delete of helm chart. Statefulset will make sure that it picks up the same old volume which was used by the previous life of the nexus pod, helping you recover your data. When enabling statefulset, its required to enable the persistence.
