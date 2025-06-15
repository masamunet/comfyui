# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
このプロジェクトは必ず日本語で対応しなければならない。

## プロジェクト概要

このプロジェクトは、runpod.io上でComfyUIとJupyterLabを統合して動作させるためのDockerイメージです。ComfyUIは画像生成AIのワークフローツールで、JupyterLabからノートブック経由で制御できます。

## 主要コマンド

### Docker開発

```bash
# イメージをローカルでビルド
make build

# Docker Hubにプッシュ
make push  

# ビルドしてプッシュ（一括）
make build-and-push
# または短縮形
make bp
```

### 環境設定

- `.env`ファイル作成が必要：`DOCKER_USERNAME=your-dockerhub-username`
- タグ指定：`TAG=v1.0.0 make build`

## アーキテクチャ

### コンテナ構成

- **ベースイメージ**: nvidia/cuda:12.9.0-devel-ubuntu22.04
- **PyTorch**: CUDA 12.8対応版
- **主要ポート**:
  - ComfyUI: 8188
  - JupyterLab: 8888

### ファイル構造

- `Dockerfile`: メインのコンテナ定義
- `entrypoint.sh`: `/workspace_tmp` から `/workspace` への初期化処理
- `install-extentions.sh`: ComfyUI拡張機能インストール（dynamicprompts等）
- `run-comfyui.ipynb`: ComfyUI起動用Jupyterノートブック
- `runpod.yaml`: runpod.ioサービス定義

### ComfyUI統合

- ComfyUI-Manager: プリインストール済み
- comfyui-workspace-manager: プリインストール済み  
- JupyterLabからPythonスクリプト経由でComfyUIサーバーを起動
- 拡張機能は`install-extentions.sh`で管理

### 実行フロー

1. runpod.ioでコンテナ起動
2. JupyterLab（port 8888）にアクセス
3. `run-comfyui.ipynb`実行でComfyUIを起動
4. ComfyUI（port 8188）でワークフロー操作

### ソースコード

- ファイルの末尾は必ず空行を入れる
