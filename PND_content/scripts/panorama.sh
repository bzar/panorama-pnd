#!/bin/sh
export PATH=":${PATH:-"/usr/bin:/bin:/usr/local/bin"}"
export LD_LIBRARY_PATH="lib:${LD_LIBRARY_PATH:-"/usr/lib:/lib"}"
export QML_IMPORT_PATH=$(pwd)/imports

if [ ! -d ./interfaces ]; then
	cp -R interfaces_default interfaces
fi

[ -e "./scripts/pre_script.sh" ]  && . ./scripts/pre_script.sh

./panorama $*

[ -e "./scripts/post_script.sh" ] && . ./scripts/post_script.sh
