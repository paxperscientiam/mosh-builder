#!/bin/sh

# https://stackoverflow.com/a/28776166
sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then 
    case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
    [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && sourced=1 
else # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) sourced=1;; esac
fi

if [ 1 -eq $sourced ]
then
    printf 'To avoid polluting your environment, please do not source this file\n'
    return
fi


unset CDPATH

# references
# build Protocol Buffers
# https://github.com/protocolbuffers/protobuf/blob/master/src/README.md

# referencing protoc compiler
# https://github.com/mobile-shell/mosh/issues/1047#issuecomment-501483899

# mosh could be build from latest source or by using specific tarball version
# https://mosh.org/#getting

build="${HOME}/build"
prefix="${HOME}/my-prefix"

# augmenting PKG_CONFIG_PATH could be done as alternative to adding special protobuff environemnt variables
#export PKG_CONFIG_PATH="${build}/protobuf"

export PATH="${prefix}/bin:${PATH}"
export PROTOC="${prefix}/bin/protoc"
export protobuf_CFLAGS="-I${prefix}/include"
export protobuf_LIBS="${prefix}/lib/libprotobuf.a"

buildProtoc() {
    cd "${build}" || return 1
    git clone https://github.com/protocolbuffers/protobuf.git
    cd protobuf || return 1
    git submodule update --init --recursive
    ./autogen.sh
    ./configure --prefix="${prefix:?}"
    make
    make check
    make install
}

buildMosh() {
    cd "${build}" || return 1
    git clone https://github.com/mobile-shell/mosh
    cd mosh || return 1
    ./autogen.sh
    ./configure --prefix="${prefix:?}"
    make
    make install
}


if [ 0 -lt "${#*}" ];
then
    printf 'Making build directory: %s ... ' "${HOME}/build"
    mkdir -p "${HOME}/build"
    printf 'done\n'
else
    cat <<'HEREDOC'
Usage:
 ./build.sh <command> [command2]

Commands:
 buildProtoc
 buildMosh
HEREDOC

fi


for fun in ${@};
do
    if type "${fun}" >/dev/null 2>&1; then
        "${fun}" &
        printf 'working ... '
        wait $!
        printf ' done\n\n'
    else
        printf '"%s" is not a known function' "$fun"
    fi
done


# buildProtoc &
# printf '\v Building protocol buffers ... '
# wait $! || printf 'failed\n'; exit
# printf 'done!\n'

# buildMosh &
# printf '\v Building mosh!!! ... '
# wait $! || printf 'failed\n'; exit
# printf 'done!\n'


# printf 'Add `prefix="%s"` and `export PATH="${prefix}/bin:${PATH}"` to remote .bashrc and to .bash_profile\n\n' "${prefix}"

# printf 'Add `export LANG="en_US.UTF-8"` and `export LD_LIBRARY_PATH="${HOME}/my-prefix/lib"` to .bash_profile\n\n'

# printf 'Hope it works!\n'
