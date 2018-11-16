APP ?= nano-service
PORT ?= 8080

RELEASE ?= 0.0.1
COMMIT ?= $(shell git rev-parse --short HEAD)
BUILD_TIME ?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')
CONTAINER_IMAGE ?= docker.io/ded0k/${APP}

GOOS ?= linux
GOARCH ?= amd64

.PHONY: clean
clean:
	rm -f ${APP}

.PHONY: build
build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build \
		-ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} -X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
		-o ${APP}

.PHONY: container
container: build
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) .

.PHONY: run
run: container
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm \
		-e "PORT=${PORT}" \
		$(APP):$(RELEASE)

.PHONY: push
push: container
	docker push $(CONTAINER_IMAGE):$(RELEASE)