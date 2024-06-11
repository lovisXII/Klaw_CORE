#! /bin/bash
IS_SOURCE=false

if [ -n "$ZSH_VERSION" ]; then
    case $ZSH_EVAL_CONTEXT in
    toplevel:file)
    IS_SOURCE=true;; # Script is sourced
     *) IS_SOURCE=false
     esac
else  # Add additional POSIX-compatible shell names here, if needed.
    case ${0##*/} in
    dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) IS_SOURCE=true;; # Script is sourced
    *) IS_SOURCE=false
    esac
fi
if [ "$IS_SOURCE" = true ]; then
    # Export environment variables
    export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.3/include/
    export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.3/lib-linux64/
    export KLAW_ROOT=$PWD
else
    echo "[ERROR] This script must be source, please run : "
    echo "source setup.sh"
fi