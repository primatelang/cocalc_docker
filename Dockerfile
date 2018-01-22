FROM sagemathinc/cocalc

MAINTAINER William Stein <wstein@sagemath.com>

# Configure environment
ENV CONDA_DIR /opt/anaconda2
ENV PATH $CONDA_DIR/bin:$PATH
ENV KERNELS_DIR /usr/local/share/jupyter

# Install conda as root
COPY Anaconda2-5.0.1-Linux-x86_64.sh /tmp 

RUN mkdir -p $CONDA_DIR 
RUN umask 002
RUN /bin/bash /tmp/Anaconda2-5.0.1-Linux-x86_64.sh -f -b -p $CONDA_DIR 
RUN rm /tmp/Anaconda2-5.0.1-Linux-x86_64.sh 

#RUN $CONDA_DIR/bin/conda install --yes conda

# Update conda
RUN cd $CONDA_DIR && source bin/activate root && umask 002
#RUN conda update conda -y 
#RUN conda update --all -y 

# Configure conda channels
RUN conda config --add channels primatelang   

# Install conda packages
RUN umask 002
RUN conda install mcr -y
RUN conda install easy_abx -y

# Install conda kernel file to jupyter
RUN mkdir -p $KERNELS_DIR/kernels/anaconda2
COPY kernel_anaconda2.json $KERNELS_DIR/kernels/anaconda2/kernel.json

# adding $CONDA_DIR paths to bashrc ..
RUN echo "export PATH=$CONDA_DIR/bin:$PATH" >> /usr/local/lib/python2.7/dist-packages/smc_pyutil/templates/darwin/bashrc && \
    echo "export PATH=$CONDA_DIR/bin:$PATH" >> /root/.bashrc

## Change permission
#RUN chmod -R o+wxr $CONDA_DIR  

