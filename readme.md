(mostly) POSIX compliant script for unprivileged users to build mosh and protocol buffers.

Usage:

```sh
./build.sh buildProtoc buildMosh
```

If you have protocol buffers installed already, you'll want to update the PROTOC, protobuf_CFLAGS, and protobuf_LIBS environment variables in the script to suit your needs.

In .bashrc, you'll need to add the following:
```sh
prefix="${HOME}/my-prefix"
export PATH="${prefix}/bin:${PATH}"
```

In .bash_profile, add the following:
```sh
prefix="${HOME}/my-prefix"
export PATH="${prefix}/bin:${PATH}"
export LANG="en_US.UTF-8"
export LD_LIBRARY_PATH="${HOME}/my-prefix/lib"
```

### Note
This script is meant to be run directly, and not sourced.

As always, you use this script at your own peril. 
