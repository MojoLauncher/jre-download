#!/bin/bash
export SIGNPATH=$(realpath $1)

sign_runtime() {
   find -name "*.tar.xz" -type f -exec openssl dgst -sha256 -sign $SIGNPATH -passin env:PASS -out {}.sgn {} \;
   find -name "*.tar.xz" -type f -printf "%P:" -exec base64 -w 0 {}.sgn \; -printf "\n" > version
   find -name "*.sgn" -delete
}

gen_runtime() {
   mkdir -p $1
   wget https://github.com/MojoLauncher/android-openjdk-build-17-25/releases/download/rolling/jre$2-pojav.zip
   pushd $1
   unzip ../../jre$2-pojav.zip
   sign_runtime
   popd
   rm jre$2-pojav.zip
}

rm -rf *.zip components/

gen_runtime "components/jre-new" 17
gen_runtime "components/jre-21" 21
gen_runtime "components/jre-25" 25
