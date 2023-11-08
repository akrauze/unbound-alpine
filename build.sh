#!/bin/bash

echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

build() {
	UNBOUND_VERSION=${1:=1.18.0-r0}
	ALPINE_VERSION=${2:=edge}
	CMD="docker build  --build-arg UNBOUND_VERSION=$UNBOUND_VERSION --build-arg ALPINE_VERSION=$ALPINE_VERSION -t ghcr.io/akrauze/unbound-alpine:$UNBOUND_VERSION -t ghcr.io/akrauze/unbound-alpine:$ALPINE_VERSION -o type=registry ."

	echo $CMD

	$CMD
}

#build 1.15.0-r0 latest
build 1.18.0-r0 edge

