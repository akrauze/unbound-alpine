#!/bin/bash

echo $CR_PAT | docker login ghcr.io

build() {
	UNBOUND_VERSION=${1}
	ALPINE_VERSION=${2}
	#CMD="docker build --build-arg UNBOUND_VERSION=$UNBOUND_VERSION --build-arg ALPINE_VERSION=$ALPINE_VERSION -t ghcr.io/akrauze/unbound-alpine:$UNBOUND_VERSION -t ghcr.io/akrauze/unbound-alpine:$ALPINE_VERSION  ."
        CMD="docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg UNBOUND_VERSION=$UNBOUND_VERSION --build-arg ALPINE_VERSION=$ALPINE_VERSION -t ghcr.io/akrauze/unbound-alpine:$UNBOUND_VERSION  -t ghcr.io/akrauze/unbound-alpine:$ALPINE_VERSION -o type=registry ."


	echo $CMD

	$CMD
}


UNBOUNDEDGE_VERSION=$( curl -s https://pkgs.alpinelinux.org/package/edge/main/x86/unbound | grep -a4 Version | sed 's/<\/td>//g' | sed 's/<\/tr>//g'| sed 's/<\/strong>//g' | sed '/^[[:space:]]*$/d' | tail -1 | cut -d '>' -f2 | sed 's/<\/a//g' )
echo "Edge:  $UNBOUNDEDGE_VERSION"


UNBOUNDLATEST_VERSION=$( ALPINE_BRANCH=$(curl -s https://pkgs.alpinelinux.org/packages | grep -a8 'name="branch"' | grep option | grep -v disabled | grep -v selected | head -1 |  cut -d '>' -f2 | sed 's/<\/option//g') && curl -s https://pkgs.alpinelinux.org/package/$ALPINE_BRANCH/main/x86/unbound | grep -a2 Version | tail -1 | sed 's/ //g' )
echo "Latest: $UNBOUNDLATEST_VERSION"


build $UNBOUNDLATEST_VERSION latest
build $UNBOUNDEDGE_VERSION edge

