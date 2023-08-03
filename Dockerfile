FROM kasmweb/core-ubuntu-focal:1.13.1
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

WORKDIR $HOME

######### Customize Container Here ###########

RUN apt-get update -y \
    && apt-get install -y sudo \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/list/*

# Install Google Chrome
COPY ./src/ubuntu/install/chrome $INST_SCRIPTS/chrome/
RUN bash $INST_SCRIPTS/chrome/install_chrome.sh  && rm -rf $INST_SCRIPTS/chrome/

#Install VSCode

COPY ./src/ubuntu/install/vs_code $INST_SCRIPTS/vs_code/
RUN bash $INST_SCRIPTS/vs_code/install_vs_code.sh  && rm -rf $INST_SCRIPTS/vs_code/

#Install Anaconda
RUN cd /tmp/ && \
    wget https://repo.anaconda.com/archive/Anaconda3-2023.07-1-Linux-x86_64.sh && \
    bash Anaconda3-2023.07-1-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm -r Anaconda3-2023.07-1-Linux-x86_64.sh

# Add Anaconda to PATH and set up environment
ENV PATH="/opt/anaconda3/bin:$PATH"
RUN echo 'export PATH="/opt/anaconda3/bin:$PATH"' >> /etc/bash.bashrc && \
    /opt/anaconda3/bin/conda update -n base conda && \
    /opt/anaconda3/bin/conda update --all && \
    /opt/anaconda3/bin/conda clean --all && \
    /opt/anaconda3/bin/conda config --set ssl_verify /etc/ssl/certs/ca-certificates.crt && \
    /opt/anaconda3/bin/conda install pip && \
    mkdir -p /home/kasm-user/.pip && \
    chown -R 1000:1000 /opt/anaconda3 /home/kasm-default-profile/.conda/ && \
    /opt/anaconda3/bin/conda install -y jupyter

#Install Dev Tools
COPY ./tools_install.sh $INST_SCRIPTS/tools/
RUN bash $INST_SCRIPTS/tools/tools_install.sh  && rm -rf $INST_SCRIPTS/tools/


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

