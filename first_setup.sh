#!/bin/bash

PACKAGES="ninja-build cppcheck"

apt-get update

apt-get install -y $PACKAGES

apt install lsb-release wget software-properties-common gnupg -y

# Install LLVM
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
yes | ./llvm.sh 17 all
