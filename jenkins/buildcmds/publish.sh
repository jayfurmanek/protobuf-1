#!/bin/bash
#
# This is the top-level script we give to Jenkins as the entry point for
# running the "publish deb" project:
#
#   https://grpc-testing.appspot.com/view/Protocol%20Buffers/job/protobuf_pull_request/
#
# This script selects a specific Dockerfile (for building a Docker image) and
# a script to run inside that image.  Then we delegate to the general
# build_and_run_docker.sh script.

export DOCKERFILE_DIR=jenkins/docker
export DOCKER_RUN_SCRIPT=jenkins/publish_deb.sh
export OUTPUT_DIR=testoutput
export PKGBUILD_COMMIT="22e0d63b7b23805ea23e54a89137984cf50dc0f8"  # I.e. "CI-dev"
export PKGBUILD_REMOTE="git@github.ibm.com:mldlppc/pkgbuild.git"
./jenkins/build_and_run_docker_for_publish.sh
