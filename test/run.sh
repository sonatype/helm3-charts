#!/bin/sh

# https://github.com/torokmark/assert.sh
. test/assert.sh

set -x -e

# watch everything: watch kubectl get all --all-nameespaces

mkdir -p test/output
rm -f test/output/*

function shutdown {
    #minikube logs -p helm-test 2>&1 > test/output/minikube.log
    minikube stop -p helm-test
    minikube delete -p helm-test
}

trap shutdown EXIT

BASEDIR=$(pwd)

minikube start -p helm-test --addons=dashboard,metrics-server $MINIKUBE_OPTS
echo '--------------------'

echo 'Nexus Repository Manager'
helm install nexus-repository-manager \
     $BASEDIR/charts/nexus-repository-manager
helm_installs=$(helm list)
assert_contain "$helm_installs" 3.29.0

kubectl wait \
        --for=condition=available \
        --timeout=5m \
        deployments/nexus-repository-manager

helm test nexus-repository-manager \
     > $BASEDIR/test/output/test-nexus-repostiory-manager.log

POD_NAME=$(kubectl get pods \
                   -l "app.kubernetes.io/name=nexus-repository-manager,app.kubernetes.io/instance=nexus-repository-manager" \
                   -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward $POD_NAME 8081 &
PF_PID=$!

sleep 4

curl -L http://localhost:8081/ > test/output/nexus-repository-manager.html 2>&1

kill -INT $PF_PID

kubectl logs $POD_NAME > test/output/nexus-repository-manager.log

# helm test nexus-repository-manager

helm delete nexus-repository-manager

echo '--------------------'

echo 'Nexus IQ Server'
helm install nexus-iq \
     $BASEDIR/charts/nexus-iq
helm_installs=$(helm list)
assert_contain "$helm_installs" 1.105.0 

kubectl wait \
        --for=condition=available \
        --timeout=5m \
        deployments/nexus-iq-nexus-iq-server

helm test nexus-iq \
    > $BASEDIR/test/output/test-nexus-iq.log

POD_NAME=$(kubectl get pods \
    -l "app.kubernetes.io/name=nexus-iq-server,app.kubernetes.io/instance=nexus-iq" \
    -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8070 &
PF_PID=$!

sleep 4

curl -L  http://localhost:8070/ > test/output/nexus-iq.html

kill -INT $PF_PID

kubectl logs $POD_NAME > test/output/nexus-iq.log

# helm test iq-server

helm delete nexus-iq

echo '--------------------'
