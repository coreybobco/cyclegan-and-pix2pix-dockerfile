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
#RUN bash -c '(nohup python -m visdom.server &); sleep 10; python train.py --dataroot ./datasets/maps --name maps_cyclegan --model cycle_gan'
RUN bash ./scripts/download_cyclegan_model.sh apple2orange && \
    bash ./scripts/download_cyclegan_model.sh orange2apple && \
    bash ./scripts/download_cyclegan_model.sh summer2winter_yosemite && \
    bash ./scripts/download_cyclegan_model.sh winter2summer_yosemite && \
    bash ./scripts/download_cyclegan_model.sh horse2zebra && \
    bash ./scripts/download_cyclegan_model.sh zebra2horse && \
    bash ./scripts/download_cyclegan_model.sh monet2photo && \
    bash ./scripts/download_cyclegan_model.sh style_monet && \
    bash ./scripts/download_cyclegan_model.sh style_cezanne && \
    bash ./scripts/download_cyclegan_model.sh style_ukiyoe && \
    bash ./scripts/download_cyclegan_model.sh style_vangogh && \
    bash ./scripts/download_cyclegan_model.sh sat2map && \
    bash ./scripts/download_cyclegan_model.sh map2sat && \
    bash ./scripts/download_cyclegan_model.sh cityscapes_photo2label && \
    bash ./scripts/download_cyclegan_model.sh cityscapes_label2photo && \
    bash ./scripts/download_cyclegan_model.sh facades_photo2label && \
    bash ./scripts/download_cyclegan_model.sh facades_label2photo && \
    bash ./scripts/download_cyclegan_model.sh iphone2dslr_flower && \
    bash ./scripts/download_pix2pix_model.sh edges2shoes && \
    bash ./scripts/download_pix2pix_model.sh sat2map && \
    bash ./scripts/download_pix2pix_model.sh facades_label2photo

RUN bash ./datasets/download_cyclegan_dataset.sh apple2orange && \
    bash ./datasets/download_cyclegan_dataset.sh summer2winter_yosemite && \
    bash ./datasets/download_cyclegan_dataset.sh horse2zebra && \
    bash ./datasets/download_cyclegan_dataset.sh monet2photo && \
    bash ./datasets/download_cyclegan_dataset.sh cezanne2photo && \
    bash ./datasets/download_cyclegan_dataset.sh ukiyoe2photo && \
    bash ./datasets/download_cyclegan_dataset.sh vangogh2photo && \
    bash ./datasets/download_cyclegan_dataset.sh maps && \
    bash ./datasets/download_cyclegan_dataset.sh cityscapes && \
    bash ./datasets/download_cyclegan_dataset.sh facades && \
    bash ./datasets/download_cyclegan_dataset.sh iphone2dslr_flower && \
    bash ./datasets/download_cyclegan_dataset.sh ae_photos && \
    bash ./datasets/download_pix2pix_dataset.sh cityscapes && \
    bash ./datasets/download_pix2pix_dataset.sh night2day && \
    bash ./datasets/download_pix2pix_dataset.sh edges2handbags && \
    bash ./datasets/download_pix2pix_dataset.sh edges2shoes && \
    bash ./datasets/download_pix2pix_dataset.sh facades && \
    bash ./datasets/download_pix2pix_dataset.sh maps

ENTRYPOINT ["/bin/bash"]