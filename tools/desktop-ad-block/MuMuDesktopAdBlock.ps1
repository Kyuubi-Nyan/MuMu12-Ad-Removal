# MuMu 桌面去广告脚本
# 原理：只添加以 MuMuDesktopAdBlock-Codex 开头的 Windows 防火墙出站规则。
# 不修改 MuMu 文件，不修改 hosts，不下载 DataPart，可随时撤销。

[CmdletBinding()]
param(
    [ValidateSet('Apply','Undo','Status')]
    [string]$Mode = 'Status',

    [string]$MuMuRoot,

    [switch]$IncludeMessageCenter,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$RulePrefix = 'MuMuDesktopAdBlock-Codex'
$DesktopIps = @(
    '42.186.25.77',
    '115.236.122.147',
    '117.147.201.42',
    '101.71.7.42'
)
$MessageIps = @(
    '42.186.241.52',
    '42.186.110.59'
)

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-MuMuRoot {
    param([string]$ExplicitPath)

    if ($ExplicitPath) {
        return (Resolve-Path -LiteralPath $ExplicitPath).Path
    }

    $registryPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    $entry = Get-ItemProperty -Path $registryPaths -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -match 'MuMu' -and $_.InstallLocation } |
        Select-Object -First 1

    if ($entry) {
        try { return (Resolve-Path -LiteralPath $entry.InstallLocation).Path } catch { }
    }

    $candidates = @(
        'D:\应用\MuMu模拟器',
        'C:\Program Files\Netease\MuMuPlayer-12.0',
        'C:\Program Files\MuMuVMMVbox'
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw '没有找到 MuMu 安装目录。请用 -MuMuRoot 指定目录。'
}

function Get-HeadlessPrograms {
    param([string]$Root)

    $patterns = @(
        (Join-Path $Root 'nx_device\*\hypervisor\MuMuVMMHeadless.exe'),
        (Join-Path $Root 'hypervisor\MuMuVMMHeadless.exe'),
        (Join-Path $Root 'shell\MuMuVMMHeadless.exe'),
        'C:\Program Files\MuMuVMMVbox\Hypervisor\MuMuVMMHeadless.exe'
    )

    $files = foreach ($pattern in $patterns) {
        Get-Item -Path $pattern -ErrorAction SilentlyContinue
    }

    return @($files | Where-Object { $_ } | Sort-Object FullName -Unique)
}

function Get-PlayerPrograms {
    param([string]$Root)

    $patterns = @(
        (Join-Path $Root 'shell\MuMuPlayer.exe'),
        (Join-Path $Root 'nx_device\*\shell\MuMuPlayer.exe'),
        'C:\Program Files\MuMuVMMVbox\shell\MuMuPlayer.exe'
    )

    $files = foreach ($pattern in $patterns) {
        Get-Item -Path $pattern -ErrorAction SilentlyContinue
    }

    return @($files | Where-Object { $_ } | Sort-Object FullName -Unique)
}

function Get-RuleName {
    param(
        [System.IO.FileInfo]$Program,
        [string]$Kind
    )

    $bytes = [Text.Encoding]::UTF8.GetBytes($Program.FullName)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $pathHash = ([BitConverter]::ToString($sha.ComputeHash($bytes)) -replace '-', '').Substring(0, 8)
    } finally {
        $sha.Dispose()
    }
    return "$RulePrefix-$Kind-$pathHash"
}

function Remove-OurRules {
    $rules = Get-NetFirewallRule -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "$RulePrefix-*" }

    if (-not $rules) {
        Write-Host '没有发现本脚本创建的规则。' -ForegroundColor Yellow
        return
    }

    foreach ($rule in $rules) {
        if ($DryRun) {
            Write-Host "[DryRun] 将删除规则: $($rule.DisplayName)" -ForegroundColor DarkYellow
        } else {
            Remove-NetFirewallRule -Name $rule.Name -ErrorAction Stop
            Write-Host "已删除规则: $($rule.DisplayName)" -ForegroundColor Green
        }
    }
}

function Add-BlockRule {
    param(
        [System.IO.FileInfo]$Program,
        [string]$Kind,
        [string[]]$RemoteIps
    )

    $ruleName = Get-RuleName -Program $Program -Kind $Kind
    $ips = ($RemoteIps -join ',')
    $programPath = $Program.FullName

    if ($DryRun) {
        Write-Host "[DryRun] 将添加规则: $ruleName" -ForegroundColor DarkYellow
        Write-Host "          程序: $programPath"
        Write-Host "          拦截: $ips"
        return
    }

    New-NetFirewallRule `
        -DisplayName $ruleName `
        -Description 'MuMu 桌面广告拦截规则，可用关闭脚本撤销。' `
        -Direction Outbound `
        -Action Block `
        -Program $programPath `
        -RemoteAddress $RemoteIps `
        -Profile Any `
        -Enabled True | Out-Null

    Write-Host "已添加规则: $ruleName" -ForegroundColor Green
    Write-Host "          程序: $programPath"
    Write-Host "          拦截: $ips"
}

function Show-Status {
    $rules = Get-NetFirewallRule -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "$RulePrefix-*" }

    if (-not $rules) {
        Write-Host '桌面去广告：未启用。' -ForegroundColor Yellow
        return
    }

    Write-Host "桌面去广告：已启用，共 $($rules.Count) 条规则。" -ForegroundColor Green
    foreach ($rule in $rules) {
        $addressFilter = $rule | Get-NetFirewallAddressFilter
        $applicationFilter = $rule | Get-NetFirewallApplicationFilter
        Write-Host "  - $($rule.DisplayName)"
        Write-Host "    程序: $($applicationFilter.Program)"
        Write-Host "    拦截: $($addressFilter.RemoteAddress -join ', ')"
    }
}

if ($Mode -eq 'Status') {
    Show-Status
    exit 0
}

if ((-not (Test-Administrator)) -and (-not $DryRun)) {
    Write-Host '需要管理员权限，正在请求提权...' -ForegroundColor Yellow
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Mode $Mode"
    if ($DryRun) { $arguments += ' -DryRun' }
    if ($IncludeMessageCenter) { $arguments += ' -IncludeMessageCenter' }
    if ($MuMuRoot) { $arguments += " -MuMuRoot `"$MuMuRoot`"" }
    Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList ('-NoExit ' + $arguments)
    exit 0
}

$root = Get-MuMuRoot -ExplicitPath $MuMuRoot
$headlessPrograms = Get-HeadlessPrograms -Root $root

if (-not $headlessPrograms -or $headlessPrograms.Count -eq 0) {
    throw "没有找到 MuMuVMMHeadless.exe。MuMu 目录: $root"
}

if ($Mode -eq 'Undo') {
    Remove-OurRules
    Write-Host '撤销操作完成。' -ForegroundColor Cyan
    exit 0
}

Write-Host "MuMu 目录: $root" -ForegroundColor Cyan
Write-Host '正在处理桌面广告拦截规则...' -ForegroundColor Cyan

Remove-OurRules

foreach ($program in $headlessPrograms) {
    Add-BlockRule -Program $program -Kind 'Desktop' -RemoteIps $DesktopIps
}

if ($IncludeMessageCenter) {
    $playerPrograms = Get-PlayerPrograms -Root $root
    foreach ($program in $playerPrograms) {
        Add-BlockRule -Program $program -Kind 'Message' -RemoteIps $MessageIps
    }
}

Write-Host ''
if ($DryRun) {
    Write-Host 'DryRun 检查完成，没有修改防火墙。' -ForegroundColor Cyan
} else {
    Write-Host '桌面去广告规则已应用。' -ForegroundColor Green
    Write-Host '如果游戏中心、虚拟定位或游戏加速出现异常，运行“关闭桌面去广告.bat”即可恢复。' -ForegroundColor Yellow
}