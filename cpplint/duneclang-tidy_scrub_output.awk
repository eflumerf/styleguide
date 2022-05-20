BEGIN {
    
    RS="^"

    in_ers_lint=0
}


{
    # Get rid of complaints about external headers
    if ($0 ~ /^[[:space:]~]*\/cvmfs\/dunedaq.*opensciencegrid.org.*/) {
       next
    }

    # Get rid of complaints about TLOG expansions
    if ($0 ~ /TLOG/) {
       next
    }

    # Get rid of complaints about ERS expansions
    if ($0 ~ /ERS/) {
	in_ers_lint = 1
        next
    }

    # Usually an expanded ERS macro has several warnings and
    # errors. They include expansions from /cvmfs-located headers, as
    # well as complaints about copy-by-values in expressions like
    # "((std::string)connection_name)((std::string)message))". We
    # don't need or want them cluttering up the linting output

    if (in_ers_lint == 1 && \
	($0 ~ /xpanded from here/ || $0 ~ /\(\(.*\).*\)/)) {
	next
    }
    in_ers_lint = 0

    if ($0 ~ /defines a copy constructor, a copy assignment operator, a move constructor and a move assignment operator but does not define a destructor/) {
       next
    }

    printf("\nRECORD TO CHECK:\n")
    print
}
