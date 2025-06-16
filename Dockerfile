FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

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
  && apt-get clean \
  && pip3 install --upgrade pip \
  && pip3 install --no-cache-dir \
  torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124 \
  numpy \
  jupyter \
  jupyterlab \
  "notebook<7.0.0" \
  # notebook \
  jupyter_contrib_nbextensions \
  jupyter_nbextensions_configurator \
  ipywidgets \
  && rm -rf /root/.cache/pip \
  && jupyter contrib nbextension install --system \
  && jupyter nbextension enable --system widgetsnbextension

COPY runpod.yaml README.md entrypoint.sh install-extensions.sh /
COPY run-comfyui.ipynb /workspace_tmp/

WORKDIR /workspace_tmp
RUN set -euo pipefail \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cloning ComfyUI repository..." \
  && git clone https://github.com/comfyanonymous/ComfyUI.git \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installing ComfyUI requirements..." \
  && cd /workspace_tmp/ComfyUI \
  && pip3 install --no-cache-dir -r requirements.txt \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cloning ComfyUI-Manager..." \
  && cd /workspace_tmp/ComfyUI/custom_nodes \
  && git clone https://github.com/ltdrdata/ComfyUI-Manager.git \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installing ComfyUI-Manager requirements..." \
  && cd /workspace_tmp/ComfyUI/custom_nodes/ComfyUI-Manager \
  && pip3 install -r requirements.txt \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Setting up script permissions..." \
  && cd / \
  && chmod +x /*.sh \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running extensions installation..." \
  && /install-extensions.sh \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Setting up notebook permissions..." \
  && chmod 644 /workspace_tmp/run-comfyui.ipynb \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning up installation script..." \
  && rm -rf /install-extensions.sh \
  && echo "[$(date '+%Y-%m-%d %H:%M:%S')] ComfyUI setup completed successfully"


WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser", "--ServerApp.allow_origin=*", "--ServerApp.allow_remote_access=True", "--notebook-dir=/workspace"]
