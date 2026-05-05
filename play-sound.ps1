param(
    [Parameter(Mandatory=$true)]
    [string]$EventName
)

$soundFile = Join-Path $PSScriptRoot "sounds\$EventName.mp3"

if (-not (Test-Path $soundFile)) { exit 0 }

if (-not ([System.Management.Automation.PSTypeName]'Win32.WinMM').Type) {
    Add-Type -Name WinMM -Namespace Win32 -MemberDefinition @'
[DllImport("winmm.dll", CharSet = CharSet.Unicode)]
public static extern int mciSendString(string command, System.Text.StringBuilder buffer, int bufferSize, System.IntPtr callback);
'@
}

[Win32.WinMM]::mciSendString("open `"$soundFile`" type mpegvideo alias snd", $null, 0, [System.IntPtr]::Zero) | Out-Null
[Win32.WinMM]::mciSendString("play snd wait", $null, 0, [System.IntPtr]::Zero) | Out-Null
[Win32.WinMM]::mciSendString("close snd", $null, 0, [System.IntPtr]::Zero) | Out-Null
