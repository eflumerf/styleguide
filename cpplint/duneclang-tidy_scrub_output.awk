BEGIN {

    in_system_header_complaint = 0
    found_system_header_complaint = 0

    in_no_destructor_complaint = 0

    in_external_code_complaint = 0

    possibly_needed_error_complaint=""
    num_errors = 0
}


{
    if ($0 ~ /^\s*\/cvmfs\/dunedaq.*opensciencegrid.org.*/) {
	in_external_code_complaint = 1
	next
    }

    if (in_external_code_complaint == 1) {
	if ($0 ~ /^[^#]*\^/) {   # Risk of picking up bitwise XOR?
	    in_external_code_complaint = 0
	}
	next
    }

    if ($0 ~ /error:.*file not found \[clang-diagnostic-error\]/) {
	in_system_header_complaint = 1
	found_system_header_complaint = 1
    }

    if (in_system_header_complaint == 1) {
	if ($0 ~ /^\s*\^\s*$/) {
	    in_system_header_complaint = 0
	}
	next
    }

    if ($0 ~ /defines a copy constructor, a copy assignment operator, a move constructor and a move assignment operator but does not define a destructor/) {
	in_no_destructor_complaint = 1
    }

    if (in_no_destructor_complaint == 1) {
	if ($0 ~ /^\s*\^\s*$/) {
	    in_no_destructor_complaint = 0
	}
	next
    }

    if ($0 ~ /Error while processing/) {
	possibly_needed_error_complaint=sprintf("%s\n%s", possibly_needed_error_complaint, $0);
	next
    }

    if ($0 ~ /error generated\./) {
	possibly_needed_error_complaint=sprintf("%s\n%s", possibly_needed_error_complaint, $0);
	num_errors = $(NF - 2) ;
	next;
    }

    # Did we only suppress warnings that weren't in our code?

    if ($0 ~ /Suppressed [0-9]+ warnings/) {
	warning_count=$2 ;
	benign_complaint=sprintf("Suppressed %d warnings (%d in non-user code).", warning_count, warning_count)
	if ($0 == benign_complaint ) {
	    possibly_needed_error_complaint=sprintf("%s\n%s", possibly_needed_error_complaint, $0);
	    next;
	} 
    }

    if ($0 ~ /^Use -header-filter=.* to display errors.*/) {
	next
    }

    if ($0 ~ /Found compiler error\(s\)/) {
	if (found_system_header_complaint != 0 && num_errors == 1) {
	    next
	} else {
	    printf("%s\n", possibly_needed_error_complaint);
	}
	
    }

print
    

}
