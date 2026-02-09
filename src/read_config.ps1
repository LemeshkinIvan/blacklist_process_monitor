. "$PSScriptRoot\log.ps1"

# это не бэкенд. так можно
function handleErr{
    param([int]$arg)

    switch ($arg){
        1 { log -msg "File was empty" -level 3; return }
        2 { log -msg "Invalid type for processBlacklist, using empty array" -level 2; return }
        3 { log -msg "Config field 'logDirectory' was empty. Using default value." -level 2; return }
        4 { log -msg "Config field 'logDirectory' is invalid. Using default value." -level 2; return }
        5 { log -msg "Config field 'timeSleepSeconds' is invalid. Using default value." -level 2; return }
        default {}
    }
}

function ReadJson{param([string]$path)
    $raw = Get-Content $path -Raw

    if ([string]::IsNullOrWhiteSpace($raw)) {
        handleErr -arg 1
        return
    }

    $cfg = $raw | ConvertFrom-Json

    # приведение к типам
    $blacklist = @()
    if ($cfg.processBlacklist -is [System.Array] -or $cfg.processBlacklist -is [System.Object[]]) {
        $blacklist = @($cfg.processBlacklist)
    } elseif ($cfg.processBlacklist -is [string]) {
        $blacklist = @($cfg.processBlacklist)
    } else {
        handleErr -arg 2
    }

    # устанавливаем default если что
    $logDir = ""
    if ($cfg.logDirectory -is [string]) {
        if ($cfg.logDirectory -eq ""){
            $logDir = $PSScriptRoots
            handleErr -arg 3    
        }

        $logDir = [string]$cfg.logDirectory
    } else { 
        $logDir = "" 
        handleErr -arg 4
    }

    $sleep = 0
    if ($cfg.timeSleepSeconds -is [int]) { 
        $sleep = [int]$cfg.timeSleepSeconds 
    } else { 
        $sleep = 5 
        handleErr -arg 5    
    }

    return @{
        Blacklist = $blacklist
        LogDirectory = $logDir
        TimeSleepSeconds = $sleep
    }
} 

