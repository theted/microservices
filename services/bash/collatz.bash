# One hailstone step in Bash. The 10# is there because bash reads 010 as octal.
read -r n
echo $((10#$n % 2 ? 3 * 10#$n + 1 : 10#$n / 2))
