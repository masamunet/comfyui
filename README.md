# 🎨 runpod ComfyUI Docker

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/masamunet/runpod-comfyui)
[![CUDA](https://img.shields.io/badge/CUDA-12.9-green?style=for-the-badge&logo=nvidia)](https://developer.nvidia.com/cuda-downloads)
[![ComfyUI](https://img.shields.io/badge/ComfyUI-Latest-orange?style=for-the-badge)](https://github.com/comfyanonymous/ComfyUI)

runpod.io上でComfyUIとJupyterLabを統合して動作させる、最適化されたDockerイメージです。

## ✨ 特徴

- 🚀 **runpod.io完全対応** - 高性能GPU環境でComfyUIを即座に利用
- 🤝 **JupyterLab統合** - ノートブック経由でComfyUIサーバーを制御
- ⚡ **CUDA最適化** - CUDA 12.9 + PyTorch GPU対応で高速画像生成
- 🔧 **プリセットアップ** - ComfyUI-Manager、拡張機能を自動インストール
- 📱 **デュアルアクセス** - ComfyUI (8188) + JupyterLab (8888) の2ポート対応
- 🛠️ **拡張対応** - dynamicpromptsなど人気拡張をプリインストール

## 🚀 クイックスタート

### 1. runpod.ioでの使用

1. **runpod.io**にログインし、新しいGPUポッドを作成
2. **Docker Image**に `masamunet/runpod-comfyui:latest` を指定
3. **Ports**で `8188` (ComfyUI) と `8888` (JupyterLab) を公開
4. ポッドが起動したらJupyterLab (`http://your-pod-url:8888`) にアクセス
5. `run-comfyui.ipynb` を開いて実行 → ComfyUIが起動
6. ComfyUI (`http://your-pod-url:8188`) で画像生成を開始！

### 2. ローカル開発

```bash
# リポジトリをクローン
git clone https://github.com/your-username/comfyui.git
cd comfyui

# 環境設定
echo "DOCKER_USERNAME=your-dockerhub-username" > .env

# ビルド & プッシュ
make bp
```

## 🖥️ 使用方法

### JupyterLabからComfyUIを起動

1. JupyterLabにアクセス (port 8888, パスワード不要)
2. `run-comfyui.ipynb`を開く
3. セルを実行してComfyUIサーバーを起動
4. ComfyUI WebUIにアクセス (port 8188)

### 利用可能なMakeコマンド

```bash
make build           # ローカルでDockerイメージをビルド
make push            # Docker Hubにイメージをプッシュ
make build-and-push  # ビルド後にプッシュ
make bp              # build-and-pushの短縮形
make check-env       # 環境変数の確認
make help            # ヘルプ表示
```

## 🏗️ アーキテクチャ

```
┌─────────────────────────────────────┐
│           runpod.io GPU             │
├─────────────────────────────────────┤
│  JupyterLab (8888)  │ ComfyUI (8188) │
│  ┌─────────────────┐│ ┌─────────────┐ │
│  │run-comfyui.ipynb││ │ Web UI      │ │
│  │                 ││ │             │ │
│  │ Python Control  ││ │ Workflow    │ │
│  └─────────────────┘│ │ Editor      │ │
├─────────────────────┤ └─────────────┘ │
│ CUDA 12.9 + PyTorch │                 │
│ ComfyUI-Manager     │                 │
│ Extensions          │                 │
└─────────────────────────────────────┘
```

## 📦 プリインストール済み

- **ComfyUI** - 最新版のStable Diffusion WebUI
- **ComfyUI-Manager** - 拡張機能管理ツール
- **comfyui-workspace-manager** - ワークスペース管理
- **dynamicprompts** - 動的プロンプト生成拡張
- **PyTorch** (CUDA 12.8対応)
- **JupyterLab** - インタラクティブ開発環境

## 🔧 カスタマイズ

### 新しい拡張機能の追加

`install-extensions.sh` を編集して追加の拡張機能をインストール：

```bash
# 新しい拡張機能を追加
git clone https://github.com/your-extension/comfyui-extension.git
cd comfyui-extension
pip3 install -r requirements.txt
```

### 環境変数

`.env` ファイルで以下を設定：

```env
DOCKER_USERNAME=your-dockerhub-username
TAG=latest  # オプション: イメージタグを指定
```

## 🐛 トラブルシューティング

### よくある問題

**Q: `make bp` でエラーが発生する**
```bash
# Docker デーモンが起動していることを確認
docker --version

# 環境変数を確認
make check-env
```

**Q: ComfyUIが起動しない**
- JupyterLabで `run-comfyui.ipynb` が正常に実行されているか確認
- ポート8188が正しく公開されているか確認

**Q: GPU が認識されない**
- runpod.ioでGPU付きプランを選択しているか確認
- CUDA対応イメージを使用しているか確認

## 📚 詳細ドキュメント

- [ComfyUI公式ドキュメント](https://github.com/comfyanonymous/ComfyUI)
- [runpod.io使用方法](https://docs.runpod.io/)
- [ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager)

## 🤝 コントリビューション

プルリクエスト、Issue報告、機能提案を歓迎します！

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🙏 謝辞

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - 素晴らしいワークフローベースのUI
- [runpod.io](https://runpod.io/) - 高性能GPU環境の提供
- [ComfyUI-Manager](https://github.com/ltdrdata/ComfyUI-Manager) - 拡張機能管理

---

⭐ このプロジェクトが役に立ったら、ぜひスターをお願いします！