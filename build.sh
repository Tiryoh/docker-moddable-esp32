#!/usr/bin/env bash
set -eu

if [ -d moddable ]; then
    pushd moddable && git pull && popd
else
    git clone --depth=1 https://github.com/Moddable-OpenSource/moddable
fi
pushd moddable
    HASH=`git rev-parse --short HEAD`
popd
docker build -t tiryoh/moddable-esp32:moddable-${HASH} .

read -p "Is this image '*:latest'?(y/N): " yn
case "$yn" in
  [yY]*) IS_LATEST="True";;
  *) IS_LATEST="";;
esac

read -p "Push to hub.docker.com?(y/N): " yn
case "$yn" in [yY]*) ;; *) echo "Done" >&1 ; exit 0 ;; esac

docker push tiryoh/moddable-esp32:moddable-${HASH}

if [ "${IS_LATEST}" -eq "True" ]; then
	docker tag tiryoh/moddable-esp32:moddable-${HASH} tiryoh/moddable-esp32:latest
	docker push tiryoh/moddable-esp32:latest
fi
