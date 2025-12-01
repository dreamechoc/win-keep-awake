$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$stopFile  = Join-Path $scriptDir "stop.keep"
Set-Content -Path $stopFile -Value "stop" -Encoding UTF8
