# One hailstone step in Tcl. scan, because Tcl 8 reads 010 as octal.
proc step {n} {
    expr {$n % 2 == 0 ? $n / 2 : 3 * $n + 1}
}

scan [gets stdin] %d n
puts [step $n]
