##Docker install

# Update the apt package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify that you now have the key with the fingerprint
sudo apt-key fingerprint 0EBFCD88

# Set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the apt package index again
sudo apt-get update

# Install the latest version of Docker CE
sudo apt-get install -y docker-ce

# Enable Docker to start on boot
sudo systemctl enable docker

# Add the current user to the docker group to avoid using 'sudo' with Docker commands
# (Optional: Remove the following two lines if you don't want to do this)
sudo usermod -aG docker $USER
newgrp docker

# Print Docker version to confirm installation
docker --version


#### NEW!
# Download the Miniconda installer
echo "Downloading Miniconda installer..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh

# Make the installer script executable
chmod +x miniconda.sh

# Run the installer script
echo "Installing Miniconda..."
./miniconda.sh -b -p $HOME/miniconda

# Add Miniconda to PATH in .bashrc
echo "Initializing Miniconda..."
source $HOME/miniconda/bin/activate
conda init

# Clean up the installer script
rm miniconda.sh

# inside miniconda's base
#conda install -c conda-forge libgomp -y
#conda install -c conda-forge glibc
bash compile_bundle.sh
LLVM_ROOT="$(pwd)/llvm-release"
export PATH=${LLVM_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=${LLVM_ROOT}/lib:$LD_LIBRARY_PATH
#  Intel® Extension for PyTorch*
cd intel-extension-for-pytorch
python -m pip install -r requirements.txt
export LLVM_DIR=${LLVM_ROOT}/lib/cmake/llvm
export DNNL_GRAPH_BUILD_COMPILER_BACKEND=1

python setup.py
# pip3 install --user torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
# extract environment variables, work AFTER running compile_bundle.sh and within intel-pytorch
python3 setup.py develop --user