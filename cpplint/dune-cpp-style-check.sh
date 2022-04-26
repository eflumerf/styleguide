#!/bin/env bash


if [[ "$#" != "2" ]]; then

cat<<EOF >&2

    Usage: $(basename $0) <directory containing the compile_commands.json file for your build> <file or directory to examine> 

Given a file, it will apply two linters to that file:

-dunecpplint.sh, which calls dunecpplint.py, a DUNE version of Google's cpplint.py
-duneclang-tidy.sh, which wraps clang-tidy (if the file is a sourcefile and not a header)

Given a directory, it will apply these linters to all the source
(*.cpp, *.cxx) and header (*.hpp) (if applicable) files in that directory as
well as all of its subdirectories.


compile_commands.json is a file which this script needs to forward to
clang-tidy. It can be automatically produced in a cmake build; to get
cmake to do this, add the following line to your CMakeLists.txt file:

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "Set to ON to produce a compile_commands.json file which clang-tidy can use" FORCE)

More detail can be found in
https://cmake.org/cmake/help/v3.5/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html

EOF

    exit 1
fi

compile_commands_dir=$1

# May also want to add logic making sure compile_commands.json is up-to-date

if [[ ! -e $compile_commands_dir ]]; then

    cat<<EOF >&2

Directory meant to provide compile_commands.json file,
"$compile_commands_dir", doesn't appear to exist; exiting...

EOF
    exit 3
elif [[ ! -d $compile_commands_dir ]]; then

    cat<<EOF >&2

"$compile_commands_dir" appears to be a file; all this script needs is
the directory which contains compile_commands.json. Exiting...

EOF

    exit 4
    
elif [[ ! -f $compile_commands_dir/compile_commands.json ]]; then

cat<<EOF >&2

Expected file "compile_commands.json" not found in provided directory,
$compile_commands_dir; exiting...

EOF
    exit 5
fi


filename=$2

files=""

if [[ -d $filename ]]; then
    files=$( find $filename -name "*.cxx" )" "$( find $filename -name "*.cpp" )" "$( find $filename -name "*.hpp" ) 
elif [[ -f $filename ]]; then

    if [[ "$filename" =~ ^.*cxx$ || "$filename" =~ ^.*cpp$ || "$filename" =~ ^.*hpp$ ]]; then
	files=$filename
    else
	echo "Filename provided has unknown extension; exiting..." >&2
	exit 1
    fi

else
    echo "Unable to find $filename; exiting..." >&2
    exit 2
fi


if [[ -n $SPACK_ROOT ]]; then

    llvmdir=$( spack find -p llvm | sed -r -n 's!.*(/cvmfs/dunedaq.opensciencegrid.org.*)$!\1!p' )
    
    if [[ -z $llvmdir ]]; then
	echo "Spack appears to be set up (SPACK_ROOT == $SPACK_ROOT) but unable to find directory for package llvm. Exiting..." >&2
	exit 10
    fi

    theclang=$( which clang 2>/dev/null )
    if ! [[ -n $( $theclang ) && "$theclang" =~ "^${llvmdir}/bin/clang" ]]; then
	cmd="spack load llvm"
	$cmd
	if [[ "$?" != "0" ]]; then
	    echo "Unable to successfully call \"$cmd\"; exiting..." >&2
	    exit 11
	fi
    fi

else
    clang_products_dir=/cvmfs/dunedaq.opensciencegrid.org/products

    if [[ -d $clang_products_dir ]]; then
	. $clang_products_dir/setup
	retval="$?"
    else
	cat <<EOF >&2

The $clang_products_dir products area
is not found; this is currently needed for the script to find clang-tidy. Exiting...

EOF
	exit 20;
    fi

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
fi


files=$( echo $files | tr " " "\n" | sort | tr "\n" " " )
DIR="$(dirname "$(readlink -f "$0")")"

for file in $files ; do

    if [[ $file =~ .*/Structs.hpp || $file =~ .*/Nljs.hpp ]]; then
	continue
    fi

    echo
    echo "Applying dunecpplint.sh"
    $DIR/dunecpplint.sh $file
    if [[ "$file" =~ .*cxx$ || "$file" =~ .*cpp$ ]]; then
	echo
	echo "Applying duneclang-tidy.sh"
	$DIR/duneclang-tidy.sh $compile_commands_dir $file
    fi

done

exit 0
