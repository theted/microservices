# One hailstone step in PowerShell.
function Get-CollatzStep([long] $n) {
    if ($n % 2 -eq 0) { $n -shr 1 } else { 3 * $n + 1 }
}

Get-CollatzStep ([long] [Console]::In.ReadLine())
