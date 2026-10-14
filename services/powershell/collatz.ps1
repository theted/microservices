# One hailstone step from PowerShell: Microsoft's shell, on Linux, in a container.
function Get-CollatzStep([long] $n) {
    if ($n % 2 -eq 0) { $n -shr 1 } else { 3 * $n + 1 }
}

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add('http://+:8000/')
$listener.Start()
Write-Host 'PowerShell is listening on :8000'

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $n = 0L
    if ([long]::TryParse($context.Request.QueryString['n'], [ref] $n) -and $n -gt 0) {
        $status = 200
        $body = "$(Get-CollatzStep $n)"
    } else {
        $status = 400
        $body = 'need ?n=<positive integer>'
    }
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $context.Response.StatusCode = $status
    $context.Response.ContentType = 'text/plain'
    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $context.Response.Close()
}
