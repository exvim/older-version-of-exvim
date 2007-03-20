{
    if ($1~/^[[:digit:]]>/)
    {
        string = substr($0,3)
        print string
    }
    else
        print $0
}
