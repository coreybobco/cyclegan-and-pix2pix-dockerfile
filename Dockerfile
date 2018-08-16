FROM nvidia/cuda:9.2-cudnn7-devel

MAINTAINER "Corey Bobco, https://github.com/coreybobco"

# Install dependencies
RUN set -ex && \
	apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
	sudo \
	wget \
    unzip \
	git \
    python3-pip \
	python3-setuptools \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -v -O miniconda.sh && \
    chmod +x miniconda.sh && ./miniconda.sh -b -p /opt/conda && rm -rf miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh 

ENV PATH /opt/conda/bin:$PATH
RUN conda install pytorch torchvision cuda92 -c pytorch
RUN pip install visdom dominate

# Clone neural-style app
WORKDIR /app
RUN git clone https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix.git . && \
              bash ./datasets/download_cyclegan_dataset.sh maps
RUN bash -c '(nohup python -m visdom.server &); sleep 10; python train.py --dataroot ./datasets/maps --name maps_cyclegan --model cycle_gan'

ENTRYPOINT ["/bin/bash"]
