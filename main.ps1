. "$PSScriptRoot\src\watcher.ps1"
. "$PSScriptRoot\src\log.ps1"
. "$PSScriptRoot\src\kill_process.ps1"
. "$PSScriptRoot\src\read_config.ps1"

$configPath = "$PSScriptRoot\config.json"

function Main{
    log -msg "Starting app..." -level 1
    
    # проверяем существует ли файл
    if (-Not (Test-Path($configPath))){
        log -msg "Can't find config.json" -level 3
        return
    }

    # читаем и парсим в map
    $cfg = ReadJson -Path $configPath
    if ($null -eq $cfg){
        log -msg "Can't read config.json" -level 3
        return
    }
    
    log -msg "Config was init..." -level 1
    log -msg "----------------------------------" -level 1
    log -msg "Start watching..." -level 1
   
    # запускаем мониторинг
    while ($true) {
        StartWatcher -blackList $cfg.Blacklist

        log -msg "Sleep $($cfg.TimeSleepSeconds) seconds..." -level 1
        Start-Sleep -Seconds $cfg.TimeSleepSeconds
    }

    # сомнительно, но оке
    log -msg "App was finished..." -level 1    
}

# вход 
Main