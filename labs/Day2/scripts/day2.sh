#!/bin/sh
dir=$(dirname $0)
${dir}/../../RuntimeModernization/scripts/lab-setup.sh && \
  ${dir}/build-container.sh && \
  ${dir}/../../RuntimeModernization/scripts/dev-deploy-pbw-ocp.sh
