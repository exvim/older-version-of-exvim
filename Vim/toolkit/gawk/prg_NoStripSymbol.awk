!/^!_TAG/{
    FS = "[\t]";
    KeyStr = $1;
    Mask[KeyStr] = KeyStr;
}
END{
    n = asort(Mask);
    for (i=0;i<=n;++i)
        print(Mask[i]);
}

