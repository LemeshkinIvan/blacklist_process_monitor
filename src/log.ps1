function log{
    param([string]$msg, [int]$level)

    $time = Get-Date -Format "dd-MM-yyyy_HH:mm:ss"
    switch ($level) {
        1 { Write-Host -NoNewline "[INFO]" -ForegroundColor Green; Write-Host " $time $msg" }
        2 { Write-Host -NoNewline "[WARNING]" -ForegroundColor Yellow; Write-Host " $time $msg"}
        3 { Write-Host -NoNewline "[ERROR]" -ForegroundColor Red; Write-Host " $time $msg"}
    }
}