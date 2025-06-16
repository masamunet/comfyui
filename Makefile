# Extract DOCKER_USERNAME from .env file if it exists
DOCKER_USERNAME ?= $(shell if [ -f .env ]; then grep -E '^DOCKER_USERNAME=' .env | cut -d '=' -f2 | tr -d ' '; fi)
IMAGE_NAME = runpod-comfyui
TAG ?= latest

# 使い方:
#   make build                  # イメージをローカルにビルドする
#   make push                   # イメージをDocker Hubにプッシュする
#   make build-and-push        # ビルドしてDocker Hubにプッシュする
#
# 環境変数:
#   DOCKER_USERNAME  - Docker Hubのユーザー名 (.envファイルまたは環境変数で設定)
#   TAG             - イメージのタグ (デフォルト: latest)
#
# 例:
#   DOCKER_USERNAME=myname TAG=v1.0.0 make build
#   DOCKER_USERNAME=myname make build-and-push
#
# .envファイルの例:
#   DOCKER_USERNAME=your-dockerhub-username

.PHONY: build push build-and-push bp check-env help

help:
	@echo "Available targets:"
	@echo "  build           - Build Docker image locally"
	@echo "  push            - Push Docker image to registry"
	@echo "  build-and-push  - Build and push Docker image"
	@echo "  bp              - Alias for build-and-push"
	@echo "  check-env       - Validate environment variables"
	@echo "  help            - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  DOCKER_USERNAME - Docker Hub username (required)"
	@echo "  TAG             - Docker image tag (default: latest)"
	@echo ""
	@echo "Create a .env file with:"
	@echo "  DOCKER_USERNAME=your-dockerhub-username"

check-env:
	@echo "Checking environment configuration..."
	@if [ -z "$(DOCKER_USERNAME)" ]; then \
		echo "ERROR: DOCKER_USERNAME is not set"; \
		echo "Please create a .env file with DOCKER_USERNAME=your-dockerhub-username"; \
		echo "Or set the environment variable: export DOCKER_USERNAME=your-dockerhub-username"; \
		exit 1; \
	fi
	@if [ ! -f .env ] && [ -z "$$DOCKER_USERNAME" ]; then \
		echo "WARNING: .env file not found and DOCKER_USERNAME environment variable not set"; \
		echo "Create .env file with: echo 'DOCKER_USERNAME=your-dockerhub-username' > .env"; \
	fi
	@echo "✓ DOCKER_USERNAME: $(DOCKER_USERNAME)"
	@echo "✓ IMAGE_NAME: $(IMAGE_NAME)"
	@echo "✓ TAG: $(TAG)"
	@echo "✓ Full image name: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)"

build: check-env
	@echo "Building Docker image: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)"
	docker buildx build --platform linux/amd64 --load -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG) .
	@echo "✓ Build completed successfully"

push: check-env
	@echo "Pushing Docker image: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)"
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)
	@echo "✓ Push completed successfully"

build-and-push: bp
bp: check-env
	@echo "Building and pushing Docker image: $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)"
	docker buildx build --platform linux/amd64 --push -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG) .
	@echo "✓ Build and push completed successfully"
