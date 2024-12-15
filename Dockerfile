FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  libopenblas-dev \
  liblapack-dev \
  libeigen3-dev \
  python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN pip3 install --upgrade pip

RUN pip3 install --no-cache-dir \
  torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124 \
  numpy \
  jupyter \
  jupyterlab \
  "notebook<7.0.0" \
  jupyter_contrib_nbextensions \
  jupyter_nbextensions_configurator \
  ipywidgets

RUN jupyter contrib nbextension install --system && \
  jupyter nbextension enable --system widgetsnbextension

COPY runpod.yaml README.md /

WORKDIR /workspace
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /workspace/ComfyUI
RUN pip3 install --no-cache-dir -r requirements.txt


ENTRYPOINT []
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser"]
