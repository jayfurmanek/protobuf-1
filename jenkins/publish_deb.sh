#!/bin/bash
#
# This is the script that runs inside Docker, once the image has been built,
# to execute all tests for the "pull request" project.

WORKSPACE_BASE=`pwd`
MY_DIR="$(dirname "$0")"
#TEST_SCRIPT=$MY_DIR/../tests.sh
BUILD_DIR=/tmp/protobuf
PKG_DIR=/tmp/pkgbuild

set -e  # exit immediately on error
set -x  # display all commands


# The protobuf repository is mounted into our Docker image, but read-only.
# We clone into a directory inside Docker (this is faster than cp).
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR
git clone /var/local/jenkins/protobuf

# The pkgbuild repository is mounted into our Docker image, but read-only.
# We clone into a directory inside Docker (this is faster than cp).
rm -rf $PKG_DIR
mkdir -p $PKG_DIR
cd $PKG_DIR
git clone /var/local/jenkins/protobuf/pkgbuild
cd pkgbuild/protobuf

# Set up the directory where our test output is going to go.
OUTPUT_DIR=`mktemp -d`
LOG_OUTPUT_DIR=$OUTPUT_DIR/logs
mkdir -p $LOG_OUTPUT_DIR/1/cpp

# Call into the package build code
pkgbuild_jenkins.sh


cat $OUTPUT_DIR/joblog

# The directory that is copied from Docker back into the Jenkins workspace.
COPY_FROM_DOCKER=/var/local/git/protobuf/testoutput
mkdir -p $COPY_FROM_DOCKER
TESTOUTPUT_XML_FILE=$COPY_FROM_DOCKER/testresults.xml

# Process all the output files from "parallel" and package them into a single
# .xml file with detailed, broken-down test output.
python $MY_DIR/make_test_output.py $OUTPUT_DIR > $TESTOUTPUT_XML_FILE

ls -l $TESTOUTPUT_XML_FILE
