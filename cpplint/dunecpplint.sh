#!/bin/bash

if [[ "$#" != "1" ]]; then
    echo "Usage: "$(basename $0)" <dir to examine>" >&2
    exit 1
fi


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


codedir=$1

if [[ ! -d $codedir ]]; then
    echo "Directory $codedir not found; exiting..." >&2
    exit 2
fi

for headerfile in $( find $codedir -name "*.hh" ); do

    echo
    echo "=========================Validating $headerfile========================="
    
    $( dirname $0 )/dunecpplint.py --extensions=hh,cc --headers=hh --filter=${header_filters} $headerfile 

done

for sourcefile in $( find $codedir -name "*.cc" ); do

    echo
    echo "=========================Validating $sourcefile========================="
    
    $( dirname $0 )/dunecpplint.py --extensions=hh,cc --headers=hh --filter=${source_filters} $sourcefile 

done


