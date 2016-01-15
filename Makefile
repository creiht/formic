SHA := $(shell git rev-parse --short HEAD)
VERSION := $(shell cat VERSION)
ITTERATION := $(shell date +%s)
export GO15VENDOREXPERIMENT=1

deps:
	go get -u google.golang.org/grpc
	go get -u github.com/golang/protobuf/proto
	go get -u github.com/golang/protobuf/protoc-gen-go
	go get -u github.com/gogo/protobuf/proto
	go get -u github.com/gogo/protobuf/protoc-gen-gogo
	go get -u github.com/gogo/protobuf/gogoproto
	go get -u github.com/gogo/protobuf/protoc-gen-gofast
	go get -u github.com/pandemicsyn/oort/api/valueproto
	go get -u github.com/pandemicsyn/oort/api/groupproto
	go get -u bazil.org/fuse
	go get -u github.com/docker/go-plugins-helpers/sdk
	go install github.com/docker/go-plugins-helpers/sdk
	godep save ./...
	godep update ./...

build:
	mkdir -p packaging/output
	mkdir -p packaging/root/usr/local/bin
	go build -i -v -o packaging/root/usr/local/bin/formicd github.com/creiht/formic/formicd
	go build -i -v -o packaging/root/usr/local/bin/cfs github.com/creiht/formic/cfs
	go build -i -v -o packaging/root/usr/local/bin/cfsdvp github.com/creiht/formic/cfsdvp

clean:
	rm -rf packaging/output
	rm -f packaging/root/usr/local/bin/formicd
	rm -f packaging/root/usr/local/bin/cfs
	rm -f packaging/root/usr/local/bin/cfsdvp

install: build
	cp -av packaging/root/usr/local/bin/* $(GOPATH)/bin

test:
	go test $$(go list ./... | grep -v /vendor/)

packages: clean deps build deb
