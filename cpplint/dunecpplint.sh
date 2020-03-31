#!/bin/bash

if [[ "$#" != "1" ]]; then
    echo "Usage: "$(basename $0)" <dir to examine>" >&2
    exit 1
fi

codedir=$1

if [[ ! -d $codedir ]]; then
    echo "Directory $codedir not found; exiting..." >&2
    exit 2
fi

for headerfile in $( find $codedir -name "*.hh" ); do

    echo
    echo "=========================Validating $headerfile========================="
    
    $( dirname $0 )/dunecpplint.py --extensions=hh,cc --headers=hh --filter=-whitespace $headerfile 

done

for sourcefile in $( find $codedir -name "*.cc" ); do

    echo
    echo "=========================Validating $sourcefile========================="
    
    $( dirname $0 )/dunecpplint.py --extensions=hh,cc --headers=hh --filter=-whitespace $sourcefile 

done


