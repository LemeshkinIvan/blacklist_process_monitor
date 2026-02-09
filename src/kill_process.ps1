function KillProcessTree{
    param(
        [Parameter(Mandatory = $true)]
        [int]$ProcessId
    )

    try {
        # Найти дочерние процессы
        $children = Get-CimInstance Win32_Process -Filter "ParentProcessId=$ProcessId" -ErrorAction Stop

        foreach ($child in $children) {
            KillProcessTree -ProcessId $child.ProcessId
        }

        Stop-Process -Id $ProcessId -Force
    }
    catch {
        # наверное лучше все таки выводить
    }
}

# необязательно
function Remove-Executable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    try {
        if ([string]::IsNullOrWhiteSpace($Path)) {
            return
        }

        if (-not (Test-Path -LiteralPath $Path)) {
            log -msg "EXECUTABLE NOT FOUND: $Path" -level 2
            return
        }

        Remove-Item -LiteralPath $Path -Force -ErrorAction Stop
        log -msg "EXECUTABLE REMOVED: $Path" -level 1
    }
    catch {
        log -msg "FAILED TO REMOVE EXECUTABLE: $Path | $($_.Exception.Message)" -level 3
    }
}