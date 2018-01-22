#!/bin/bash 

# Configure environment
export CONDA_DIR=/projects/anaconda2
export PATH=$CONDA_DIR/bin:$PATH
export KERNELS_DIR=/usr/local/share/jupyter

# Install sox 
sed -i 's/archive.ubuntu/old-releases.ubuntu/' /etc/apt/sources.list
apt-get update 
apt-get install sox --yes

cd /projects
mkdir -p $CONDA_DIR 
umask 002
/bin/bash Anaconda2-5.0.1-Linux-x86_64.sh -f -b -p $CONDA_DIR 

#$CONDA_DIR/bin/conda install --yes conda

# Update conda
cd $CONDA_DIR
. bin/activate root 
umask 002
conda update conda -y 
conda update --all -y 

# adding $CONDA_DIR paths to bashrc ..
echo "export PATH=$CONDA_DIR/bin:$PATH" >> /usr/local/lib/python2.7/dist-packages/smc_pyutil/templates/darwin/bashrc
echo "export PATH=$CONDA_DIR/bin:$PATH" >> /root/.bashrc
echo "export PATH=$CONDA_DIR/bin:$PATH" >> /home/sage/.bashrc
. /root/.bashrc


# Configure conda channels
conda config --add channels primatelang
wget -c https://raw.githubusercontent.com/primatelang/mcr/master/bin/prep_annot.sh -O $CONDA_DIR/bin/prep_annot.sh
chmod 755 $CONDA_DIR/bin/prep_annot.sh
source activate root

# Install conda packages for primate lang analysis
conda install mcr -y
pip install git+https://github.com/primatelang/spectral
pip install git+https://github.com/primatelang/pystruct
pip install git+https://github.com/primatelang/vad
pip install git+https://github.com/primatelang/lightning
pip install git+https://github.com/primatelang/zca

#TODO fix next conda install
#conda install easy_abx -y
cd /projects
umask 002
git clone https://github.com/primatelang/easy_abxpy
cd easy_abxpy
umask 002
conda install --file requirements.txt -y
python setup.py develop 

# Install conda kernel file to jupyter
cd /projects
umask 002
mkdir -p $KERNELS_DIR/kernels/anaconda2
cp kernel_anaconda2.json $KERNELS_DIR/kernels/anaconda2/kernel.json

## Change permission
chmod -R o+wxr $CONDA_DIR  

