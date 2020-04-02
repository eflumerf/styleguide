#!/bin/env bash

if [[ "$#" != "2" ]]; then

cat<<EOF >&2

    Usage: $(basename $0) <dir to examine> <full pathname of compile_commands.json for your build>

compile_commands.json is a file which this script needs to forward to
clang-tidy. It can be automatically produced in a cmake build; to get
cmake to do this, add the following line to your CMakeLists.txt file:

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "Set to ON to produce a compile_commands.json file which clang-tidy can use" FORCE)

More detail can be found in
https://cmake.org/cmake/help/v3.5/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html

EOF

    exit 1
fi

codedir=$1

if [[ ! -d $codedir ]]; then
    echo "Directory $codedir not found; exiting..." >&2
    exit 2
fi

compile_commands=$2

# May also want to add logic making sure this file is up-to-date
if [[ ! -f $compile_commands ]]; then
    echo "CMake-produced compile commands file $compile_commands not found; exiting..." >&2
    exit 3
fi

clang_products_dir=/cvmfs/fermilab.opensciencegrid.org/products/larsoft
. $clang_products_dir/setup
retval="$?"

if [[ "$retval" == 0 ]]; then
    echo "Set up the products directory $clang_products_dir"
else
    cat<<EOF >&2

There was a problem setting up the products directory 
$clang_products_dir ;
exiting...

EOF

    exit 1
fi

clang_version=$( ups list -aK+ clang | sort -n | tail -1 | sed -r 's/^\s*\S+\s+"([^"]+)".*/\1/' )

if [[ -n $clang_version ]]; then

    setup clang $clang_version
    retval="$?"

    if [[ "$retval" == "0" ]]; then
	echo "Set up clang $clang_version"
    else

	cat <<EOF

Error: there was a problem executing "setup clang $clang_version"
(return value was $retval). Please check the products directories
you've got set up. Exiting...

EOF

	exit 1
    fi

else

    cat<<EOF >&2

Error: a products directory containing clang isn't set up. Exiting...
EOF
    exit 2

fi


for sourcefile in $( find $codedir -name "*.cc" ); do

    echo
    echo "=========================Validating $sourcefile========================="

    clang-tidy -p=$compile_commands -checks=* -header-filter=.* $sourcefile    

done

