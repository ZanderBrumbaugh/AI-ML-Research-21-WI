# Fixed DenseCap Pre-Trained Model Demo (tested in Ubuntu 20.04)
# Zander Brumbaugh
# Jan. 13 2021
# DenseCap original authors: Justin Johnson*, Andrej Karpathy*, Li Fei-Fei,
# (* equal contribution)


# Installing all packages assuming you're in a completely new Ubuntu environment
# If a package is already installed, it will simply check for updates or skip

sudo apt-get update
sudo apt-get install git
sudo apt-get install build-essential cmake
sudo apt-get install libreadline-dev 
sudo apt-get install libvtk7-dev

# pip and python have been replaced with pip3 and python3 respectively, both are needed

sudo apt-get install python3-pip
pip3 install ipython

# Clone in Torch library and recursively replace refereces to old packages

git clone https://github.com/torch/distro.git ~/torch --recursive
 
cd ~/torch
grep -rl 'python-software-properties' ./ | xargs sed -i 's/python-software-properties/software-properties-common/g'
grep -rl 'libqt4-dev' ./ | xargs sed -i 's/libqt4-dev/libvtk7-dev/g'
 
# Fails to find ipython, run, ignore warning, and proceed

bash install-deps
 
# Respond yes to Torch PATH prompt after running install.sh

./install.sh
cd ..
source ~/.bashrc
 
# RESTART SYSTEM IF UNABLE TO INSTALL FOLLOWING PACKAGE

sudo apt-get install luarocks

# Install Lua libraries

luarocks install torch
luarocks install nn
luarocks install image
luarocks install lua-cjson
luarocks install https://raw.githubusercontent.com/qassemoquab/stnbhwd/master/stnbhwd-scm-1.rockspec
luarocks install https://raw.githubusercontent.com/jcjohnson/torch-rnn/master/torch-rnn-scm-1.rockspec
luarocks list
 
# Optional accelerators for Nvidia GPUs; will fail to compile and skip if GPU unavailable

luarocks install cutorch
luarocks install cunn
luarocks install cudnn

# Clone in DenseCap repo and download pre-trained model
 
git clone https://github.com/jcjohnson/densecap.git DenseCap --recursive
cd DenseCap
sh scripts/download_pretrained_model.sh
 
# Create your evaluation with the following. Change path to desired image, elephant exists by default
# It may take around 5 minutes to process the image with a CPU; remove "-gpu -1" flag to run in GPU mode

th run_model.lua -input_image imgs/elephant.jpg -gpu -1

# Original images and current JSON-encoded results should appear in vis/data directory

cd vis

# Make a local server and view the visual results of the image evaluation

python3 -m http.server &
xdg-open http://localhost:8000/view_results.html

# You should run the following to terminate the local server after viewing results

pkill python3
