<!--

    Copyright (c) 2019-present Sonatype, Inc.
    This program and the accompanying materials are made available under
    the terms of the Eclipse Public License 2.0 which accompanies this
    distribution and is available at https://www.eclipse.org/legal/epl-2.0/.

-->

# Document Purpose

This page provides high-level technical information regarding the **Helm3 Charts for Sonatype Products**


## Product Overview

[Helm](https://helm.sh/) is a package manager and templating engine for installing softare in [Kubernetes](https://kubernetes.io/). We provide our [own Helm Charts](https://sonatype.github.io/helm3-charts/) to help people install our servers in Kubernetes. 

These charts are indexed and promoted at ArtifactHub. The index we publish lives in a GitHub Pages site: https://sonatype.github.io/helm3-charts/index.yaml. With helm charts, the user can change settings by modifying a copy of the `values.yaml` before installing the chart.


## High-Level Technical Description

As described earlier in this project we use Helm, a package manager for Kubernetes. Helm will help us to quickly install/upgrade/mantain Nexus IQ and Nexus Repository Manager on a Kubernetes cluster.

In the repository we have two Charts, one for Nexus IQ `\charts\nexus-iq`,  and other for Nexus Repository Manager `\charts\nexus-repository-manager`. 

Each Charts is composed for a set of **templates** that are basically `yaml` files that descibe the different Kubernetes resources along with a templating syntaxys to define variables, that is used by Helm. Also, for each chart, we have a `values.yaml` file, with the default values for the different varaibles that you will find in the different **templates**.

Finally these charts are indexed and promoted at ArtifactHub. The Helm repository's `index.yaml` and all charts binaries are in `\docs` folder. The index we publish lives in a **GitHub Pages site**: https://sonatype.github.io/helm3-charts/index.yaml. The repository is exposed to the public using **GitHub pages**.


## Internal Dependencies

Here are some internal dependencies

- Nexus Repository Manager Docker Image
- Nexus IQ Docker Image


## External Dependencies

Here are some external dependencies

- GitHub pages
- Artifact Hub


## Data Persistence 
N/A


## Localhost Development
See [Helm Charts](https://docs.sonatype.com/display/INT/Helm+Charts) internal documentation.


## Architecture Diagram
See [Helm Charts](https://docs.sonatype.com/display/INT/Helm+Charts) internal documentation.


## Release Plan
See [Helm Charts](https://docs.sonatype.com/display/INT/Helm+Charts) internal documentation.
