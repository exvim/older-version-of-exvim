!/^!_TAG/{
    FS = "[\t]";
    if ($1~/::/)
    {
        split($1,ta,"::");
        KeyStr = ta[2];
    }else
        KeyStr = $1;
    Mask[KeyStr] = KeyStr;
}
END{
    n = asort(Mask);
    for (i=0;i<=n;++i)
        print(Mask[i]);
}

