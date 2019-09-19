# Install Siesta Suite

### Summary
This repository contains the scripts to install the Siesta suite - consisting of
Siesta, Transiesta and TBtrans. The installation will use OpenMPI for parallel
execution. Currently supported Siesta versions are:

- 4.1-b3
- 4.1-b4

### Usage
1. Clone this repository on the target system [`git clone https://github.com/lalluanthoor/siesta-installation.git`]
1. Navigate to the directory [`cd siesta-installation`]
1. Verify that the permissions are OK [`chmod +x *.sh`]
1. Run the installation script [`./install.sh BASE_DIR SIESTA_VERSION`]

- `BASE_DIR`: base directory for installation
- `SIESTA_VERSION`: one of the versions from above list of supported versions
