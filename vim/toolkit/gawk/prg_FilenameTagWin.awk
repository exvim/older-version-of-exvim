# ======================================================================================
# File         : prg_FilenameTagWin.awk
# Author       : Wu Jie 
# Last Change  : 06/09/2009 | 21:13:17 PM | Tuesday,June
# Description  : 
# ======================================================================================

# ------------------------------------------------------------------ 
# Desc: 
# ------------------------------------------------------------------ 

{
    text=$0;
    gsub( /\\/, "/", text );
    split( text, array, "/" );
    max_num = 0;
    for ( idx in array )
        ++max_num;
    lines[$1] = array[max_num] "\t" text "\t1";
}
END{
    print "!_TAG_FILE_SORTED	2	/0=unsorted, 1=sorted, 2=foldcase/";
    n = asort(lines);
    for ( i = 1; i <= n; ++i )
        print ( lines[i] );
}
