if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "Error: This script must be sourced, not executed."
    echo "Use: source ${BASH_SOURCE[0]} or . ${BASH_SOURCE[0]}"
    exit 1
fi

export SYSTEMC_INCLUDE=/usr/local/systemc-2.3.3/include/
export SYSTEMC_LIBDIR=/usr/local/systemc-2.3.3/lib-linux64/
export KLAW_ROOT=$PWD