#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # check for elevated prompt
    $sAdmin = ""
    If (Test-Administrator) {
        $sAdmin = "$($sl.PromptSymbols.AdminIndicator) "
    }

    # virtualenv
    $sVenv = ""
    If (Test-VirtualEnv) {
        $sVenv = " $(Get-VirtualEnvName) "
    }

    # Last command success or failure
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object " " -ForegroundColor $sl.Colors.FailedCommandColor -BackgroundColor $sl.Colors.FailedCommandColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.FailedCommandColor -BackgroundColor $sl.Colors.OSBackgroundColor
    }

    # OS info section    
    $prompt += Write-Prompt -Object " $($sl.PromptSymbols.OSLogo) " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.OSBackgroundColor
    $prompt += Write-Prompt -Object $sVenv -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.OSBackgroundColor
    $prompt += Write-Prompt -Object $sAdmin -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.OSBackgroundColor
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.OSBackgroundColor -BackgroundColor $sl.Colors.DriveForegroundColor

    $prompt += Write-Prompt -Object " $(Get-FullPath -dir $pwd) " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.DriveForegroundColor

    # close drive & git info
    If ($vcsStatus = Get-VCSStatus) {
        $vcsInfo = Get-VcsInfo -status ($vcsStatus)
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.DriveForegroundColor -BackgroundColor $vcsInfo.BackgroundColor
        $prompt += Write-Prompt -Object " $($vcsInfo.VcInfo) " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $vcsInfo.BackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $vcsInfo.BackgroundColor
    } else {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.DriveForegroundColor
    }
    
    $prompt += Set-Newline
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.PromptIndicator)" -ForegroundColor $sl.Colors.PromptIndicatorColor
    
    $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.AdminIndicator = [char]::ConvertFromUtf32(0xf6a4)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x276F)
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.PromptSymbols.OSLogo = [char]::ConvertFromUtf32(0xf17a)

$sl.Colors.OSBackgroundColor = [ConsoleColor]::White
$sl.Colors.PromptForegroundColor = [ConsoleColor]::Black
$sl.Colors.PromptIndicatorColor = [ConsoleColor]::White
$sl.Colors.FailedCommandColor = [ConsoleColor]::DarkRed
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::Magenta
