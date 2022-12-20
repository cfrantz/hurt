#!/bin/bash
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

: ${REMOVE:=--rm}
: ${IMAGE:=ubuntu:20.04}

if [[ -z "${DOCKER+is_set}" ]]; then
    if [[ -x /usr/bin/docker ]]; then
        DOCKER=/usr/bin/docker
    elif [[ -x /usr/bin/podman ]]; then
        DOCKER=/usr/bin/podman
        IMAGE="docker://${IMAGE}"
    else
        echo "No container manager found.  Install docker or podman."
        exit 1
    fi
fi

GIT_USER_NAME=$(git config --get user.name)
GIT_USER_EMAIL=$(git config --get user.email)

${DOCKER} run \
    --network=host \
    --volume=$PWD:/src/work \
    --volume=$HOME/.config/gh:/root/.config/gh \
    --volume=$HOME/.ssh:/root/.ssh \
    -it \
    ${REMOVE} \
    ${IMAGE} \
    /bin/bash -c "
        cd /src/work && \
        apt update && \
        DEBIAN_FRONTEND=noninteractive apt install -y \
            build-essential \
            curl \
            gettext \
            git \
            python-is-python3 \
            python3-pkg-resources \
            ssh \
            vim \
            \$(
                find . -name apt-requirements.txt | xargs cat
            ) && \
        export EDITOR=vim && \
        eval \$(ssh-agent) && \
        (for f in \$(grep -l 'PRIVATE KEY' ~/.ssh/*); do \
            ssh-add \$f
        done) && \
        git config --global user.name \"${GIT_USER_NAME}\" && \
        git config --global user.email \"${GIT_USER_EMAIL}\" && \
        ./bazelisk.sh run :release -- $@; \
        exec bash -i
    "
