#!/bin/bash

if [[ "$#" != "1" ]]; then
    echo "Usage: "$(basename $0)" <file or directory to examine>" >&2
    echo
    cat <<EOF >&2

The DUNE C++ style guide this script tries to look for violations of can be found in 
https://github.com/DUNE-DAQ/styleguide/blob/dune-daq-cppguide/dune-daq-cppguide.md

Given a file, it will apply a linter (dunecpplint.py) to that file

Given a directory, it will apply a linter (dunecpplint.py) to all the
source (*.cc) and header (*.hh) files in that directory as well as all
of its subdirectories.

EOF
    
    exit 1
fi

filename=$1

# -build/c++11/14 : No headers are explicitly disallowed

# -build/namespaces: for source (not header) files, allow using-directives

# -runtime/indentation_namespace: worry about whitespace with our formatting tools

# -readability/check: described in cpplint.py as "Checks the use of
# -CHECK and EXPECT macros" - i.e., DUNE doesn't need it as we don't
# -use those

# -readability/constructors: refers to unused Google macros

# -runtime/references: DUNE doesn't require that function arguments
#  which can be altered need to be pointers

# -runtime/string: DUNE doesn't require that static/global variables
#  be trivially destructible

# -runtime/vlog: refers to Google-specific VLOG function

# -whitespace: worry about this with our formatting tools

header_filters="-build/c++11,-build/c++14,-readability/check,-readability/constructors,-runtime/indentation_namespace,-runtime/references,-runtime/string,-runtime/vlog,-whitespace"
source_filters="-build/c++11,-build/c++14,-build/namespaces,-readability/check,-readability/constructors,-runtime/indentation_namespace,-runtime/references,-runtime/string,-runtime/vlog,-whitespace"


header_files=""
source_files=""

if [[ -d $filename ]]; then
    header_files=$( find $filename -name "*.hh" )
    source_files=$( find $filename -name "*.cc" ) 
elif [[ -f $filename ]]; then

    if [[ "$filename" =~ ^.*cc$ ]]; then
	source_files=$filename
    elif [[ "$filename" =~ ^.*hh$ ]]; then
	header_files=$filename
    else
	echo "Filename provided has unknown extension; exiting..." >&2
	exit 1
    fi

else
    echo "Unable to find $filename; exiting..." >&2
    exit 2
fi

for header_file in $header_files; do

    echo
    echo "=========================Validating $header_file========================="
    
    $( dirname $0 )/dunecpplint.py --extensions=hh,cc --headers=hh --filter=${header_filters} $header_file 

done

for source_file in $source_files; do

    echo
    echo "=========================Validating $source_file========================="
    
    $( dirname $0 )/dunecpplint.py --extensions=hh,cc --headers=hh --filter=${source_filters} $source_file 

done


