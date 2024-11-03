#!/bin/bash

set -ex

if [ -z ${NUM_GPUS+x} ]; then
  NUM_GPUS=1
fi

if [ -z ${NUM_NODES+x} ]; then
  NUM_NODES=1
fi

RUN_NAME="ego4d"

if [ -z ${PRIORITY+x} ]; then
  PRIORITY="normal"
fi

gantry run \
  --budget ai2/oe-training \
  --workspace ai2/mm-olmo \
  --name "${RUN_NAME}" \
  --task-name "${RUN_NAME}" \
  --priority ${PRIORITY} \
  --preemptible \
  --beaker-image mrezasal1/vid-llm \
  --cluster ai2/saturn-cirrascale \
  --no-nfs \
  --weka oe-training-default:/weka/oe-training-default \
  --env-secret GITHUB_TOKEN=GITHUB_TOKEN \
  --env OLMO_SHARED_FS=1 \
  --replicas ${NUM_NODES} \
  --leader-selection  \
  --host-networking \
  --shared-memory 10GiB \
  --install 'echo "no install"' \
  --env LOG_FILTER_TYPE=local_rank0_only \
  --propagate-failure \
  --propagate-preemption \
  --venv base \
  -- /bin/bash -c "python -m ego4d.cli.cli --output_directory=ego4d_data  --datasets full_scale"