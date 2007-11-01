BEGIN { 
    print "digraph INHERITS {" 
    print "\trankdir=LR;"
}
/inherits:/{
    FS="[\t]"
    for ( i = NF; i >= 1; i = i - 1) {
        if ( $i ~ /inherits:/ ) {
            str_parents=$i
            sub(/inherits:/,"",str_parents)
            split(str_parents,parent_list,",")
            for ( i in parent_list )
                print "\t\""parent_list[i]"\" -> \""$1"\";"
            break
        }
    }
}
END { print "}" }
