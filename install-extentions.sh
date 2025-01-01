#!/bin/bash

# ディレクトリを移動
cd /workspace_tmp/ComfyUI/custom_nodes/

# dynamicpromptsのインストール
git clone https://github.com/adieyal/comfyui-dynamicprompts.git
cd comfyui-dynamicprompts
pip3 install -r requirements.txt
python3 install.py
