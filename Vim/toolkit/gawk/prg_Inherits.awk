/inherits:/{
    FS="[\t]"
    for ( i = NF; i >= 1; i = i - 1) {
        if ( $i ~ /inherits:/ ) {
            print $1,"\t",$i
            continue
        }
    }
}
