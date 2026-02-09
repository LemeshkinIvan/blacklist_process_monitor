function StartWatcher {
    param(
        [string[]]$blackList
    )

    # преобразуем все паттерны в lower-case для сравнения
    $blackList = $blackList | ForEach-Object { $_.ToLower() }

    Get-Process | ForEach-Object {
        $procName = $_.Name.ToLower()
        $id = $_.Id

        try {
            # Проверяем каждое правило blacklist
            foreach ($pattern in $blackList) {
                if ($procName -match $pattern) {
                    # Получаем CimInstance для процесса
                    $wmi = Get-CimInstance Win32_Process -Filter "ProcessId=$id" -ErrorAction SilentlyContinue
                    if (-not $wmi) {
                        log -msg "PROCESS VANISHED PID=$id ($($_.Name)) | Already exited" -level 2
                        continue
                    }

                    # Получаем владельца 
                    $owner = Invoke-CimMethod -InputObject $wmi -MethodName GetOwner -ErrorAction SilentlyContinue

                    log -msg "FOUND: $($_.Name) | PID=$id | USER=$($owner.User)" -level 1
                    log -msg "PATH: $($wmi.ExecutablePath)" -level 1

                    # убиваем и процесс и саб-процессы
                    KillProcessTree -ProcessId $id

                    # Remove-Executable -Path $wmi.ExecutablePath
                    break
                }
            }
        }
        catch {
            log -msg "ERROR PID=$id : $($_.Exception.Message)" -level 3
        }
    }
}