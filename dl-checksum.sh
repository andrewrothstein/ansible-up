#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://cli.upbound.io

# https://github.com/upbound/up/releases

dl()
{
    local channel=$1
    local ver=$2
    local os=$3
    local arch=$4
    local dotexe=${5:-""}
    local platform="${os}_${arch}"
    local file=pulumi-v$ver-$platform.$archive_type
    local url="${MIRROR}/${channel}/${ver}/bin/${platform}/up${dotexe}"
    local lfile="${DIR}/up_${channel}_${platform}_${ver}${dotexe}"

    if [ ! -e $lfile ];
    then
        curl -sSLf -o $lfile $url
    fi

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dlver () {
    local channel=$1
    local ver=$2
    printf "  %s:\n" $ver
    dl $channel $ver linux amd64
    dl $channel $ver linux arm64
    dl $channel $ver darwin arm64
    dl $channel $ver darwin amd64
    dl $channel $ver windows amd64 .exe
}

dlver stable ${1:-v0.37.0}
