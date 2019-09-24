#!/bin/bash -e

CURRENT_DIR=$(pwd)

# validate inputs
. "$CURRENT_DIR/validation.sh"

# handle prerequisites
. "$CURRENT_DIR/prereq.sh"

# install Siesta suite
. "$CURRENT_DIR/siesta.sh"
