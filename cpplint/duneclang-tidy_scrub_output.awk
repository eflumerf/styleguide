BEGIN {
    
    RS="^"
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
	next
    }

    if ($0 ~ /defines a copy constructor, a copy assignment operator, a move constructor and a move assignment operator but does not define a destructor/) {
     	next
    }

    print
}
