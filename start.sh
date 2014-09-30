#!/bin/bash

COREOS_MEMORY=${COREOS_MEMORY:-1024}
COREOS_CPUS=${COREOS_CPUS:-1}
COREOS_CHANNEL=${COREOS_CHANNEL:-alpha}
NUM_INSTANCES=${NUM_INSTANCES:-3}

ENABLE_KUBERNETES=${ENABLE_KUBERNETES:-true}
ENABLE_LIBSWARM=${ENABLE_LIBSWARM:-true}
ENABLE_PANAMAX=${ENABLE_PANAMAX:-true}
ENABLE_ELASTICSEARCH=${ENABLE_ELASTICSEARCH:-true}
ENABLE_KIBANA=${ENABLE_KIBANA:-true}
ENABLE_LOGSTASH=${ENABLE_LOGSTASH:-true}
ENABLE_DEIS=${ENABLE_DEIS:-true}

export COREOS_MEMORY COREOS_CPUS COREOS_CHANNEL NUM_INSTANCES

set -ex

which vagrant || (
  echo "Vagrant is required for this project"
  false
)

(
  cat user-data.sample
  cat cloud-init/flannel.unit
  [ "$ENABLE_LIBSWARM" = "true" ] && cat cloud-init/libswarm.unit
  [ "$ENABLE_KUBERNETES" = "true" ] && cat cloud-init/kubernetes.unit
  [ "$ENABLE_ELASTICSEARCH" = "true" ] && cat cloud-init/elasticsearch.unit
  [ "$ENABLE_LOGSTASH" = "true" ] && cat cloud-init/logstash.unit
  [ "$ENABLE_KIBANA" = "true" ] && cat cloud-init/kibana.unit
  [ "$ENABLE_PANAMAX" = "true" ] && cat cloud-init/panamax.unit
  [ "$ENABLE_DEIS" = "true" ] && cat cloud-init/deis.unit
  echo "write_files:"
  [ "$ENABLE_KUBERNETES" = "true" ] && cat cloud-init/kubernetes.write_file
  [ "$ENABLE_ELASTICSEARCH" = "true" ] && cat cloud-init/elasticsearch.write_file
  [ "$ENABLE_LOGSTASH" = "true" ] && cat cloud-init/logstash.write_file
  [ "$ENABLE_KIBANA" = "true" ] && cat cloud-init/kibana.write_file
  [ "$ENABLE_PANAMAX" = "true" ] && cat cloud-init/panamax.write_file
  [ "$ENABLE_DEIS" = "true" ] && cat cloud-init/deis.write_file
) > user-data

vagrant up

