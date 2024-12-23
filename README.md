# runpod ComfyUI Docker Image

Docker image to run ComfyUI on runpod.io with JupyterLab integration.

## Features

- ComfyUI running on port 8188
- JupyterLab running on port 8888
- CUDA 12.4 support
- Pre-installed PyTorch with CUDA support

## Usage

1. Create a new pod on runpod.io using this image
2. Connect to ComfyUI at port 8188
3. Connect to JupyterLab at port 8888 (no password required)

---

# runpod ComfyUI Dockerイメージ

runpod.io上でJupyterLab統合のComfyUIを実行するためのDockerイメージです。

## 特徴

- ComfyUIをポート8188で実行
- JupyterLabをポート8888で実行 
- CUDA 12.4対応
- PyTorch（CUDA対応）プリインストール済み
- ComfyUI-Managerとcomfyui-workspace-managerをインストール済み

## 使用方法

1. runpod.io上で本イメージを使用して新しいポッドを作成
2. ポート8888でJupyterLabに接続（パスワード不要）
3. run-comfyui.ipynbをJupyterLab上で開いて実行。そうするとComfyUIが起動する。
4. ポート8188でComfyUIに接続

## 注意

- .env.exampleを参考に .envファイルを作成。Dockerhubのユーザー名を設定してください
