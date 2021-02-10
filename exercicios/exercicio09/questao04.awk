BEGIN {
    val = 0
}

NR > 1 && $2 > 5000 {
    val = val + $2
}

END {
    print val
}