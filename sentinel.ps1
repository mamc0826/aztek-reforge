#Requires -RunAsAdministrator

<#
.SYNOPSIS
    AZTEK (a2k) tech - SENTINEL MASTER RELEASE
    - VERSION: 2.3 (2026-02-05)
    - ACCESS: irm a2k.lat/s | iex
#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
ipconfig /flushdns | Out-Null

# ============================================================================
# ANSI STYLE ENGINE
# ============================================================================
$E = [char]27
$Gold  = "$E[38;2;212;175;55m"  
$White = "$E[38;2;255;255;255m"
$Black = "$E[48;2;0;0;0m"        
$Red   = "$E[38;2;230;0;0m"      
$Gray  = "$E[38;2;100;100;100m"  
$Reset = "$E[0m"

$Global:Lang = "EN"
$Text = @{
    EN = @{
        PreSafe = "[!] SAFETY: System Restore point is recommended."; CreateR = "Create Safeguard? (Y/N): "
        RestWait = "Generating AZTEK Safeguard..."; Prompt = "AZTEK Command > "
        Opt0 = "EMERGENCY RESTORE (Undo)"; Opt1 = "THE WORKS (Setup + Activation)"
        Opt2 = "GOD MODE (Unlock Settings)"; Opt3 = "DNS JUMPER (Better Ping)"
        Opt4 = "WIFI PASS RECOVERY"; Opt5 = "APP KILLER (Force Close)"
        Opt6 = "WINDOWS SANDBOX"; Opt7 = "MAS ACTIVATION (Win/Office)"
        Opt8 = "INSTALL ESSENTIAL APPS"; Opt9 = "SET AZTEK WALLPAPER"
        Opt10 = "VISIT A2K.LAT TOOLS"; Opt11 = "VIEW SOURCE CODE"; OptH = "MANUAL / HELP"; OptX = "EXIT"
        GodDone = "[✓] God Mode Folder created on Desktop!"
    }
    ES = @{
        PreSafe = "[!] SEGURIDAD: Se recomienda punto de restauración."; CreateR = "¿Crear Salvaguarda? (S/N): "
        RestWait = "Generando Salvaguarda AZTEK..."; Prompt = "Comando AZTEK > "
        Opt0 = "RESTAURACIÓN DE EMERGENCIA"; Opt1 = "TODO EN UNO (Setup + Activación)"
        Opt2 = "MODO DIOS (Ajustes Ocultos)"; Opt3 = "DNS JUMPER (Mejor Ping)"
        Opt4 = "RECUPERAR CLAVES WIFI"; Opt5 = "APP KILLER (Cerrar Apps)"
        Opt6 = "WINDOWS SANDBOX"; Opt7 = "ACTIVACIÓN MAS (Win/Office)"
        Opt8 = "INSTALAR APPS ESENCIALES"; Opt9 = "PONER FONDO AZTEK"
        Opt10 = "VISITAR A2K.LAT HERRAMIENTAS"; Opt11 = "VER CÓDIGO FUENTE"; OptH = "MANUAL / AYUDA"; OptX = "SALIR"
        GodDone = "[✓] ¡Carpeta Modo Dios creada en el Escritorio!"
    }
}

function Get-Pad { return "                " }

function Show-Header {
    Write-Host "$Black" -NoNewline; Clear-Host
    $P = Get-Pad; $G = $Gold
    Write-Host "`n$P$G  █████╗ ███████╗████████╗███████╗██╗  ██╗"
    Write-Host "$P$G  ██╔══██╗╚══███╔╝╚══██╔══╝██╔════╝██║ ██╔╝"
    Write-Host "$P$G  ███████║  ███╔╝    ██║   █████╗  █████╔╝ "
    Write-Host "$P$G  ██╔══██║ ███╔╝     ██║   ██╔══╝  ██╔═██╗ "
    Write-Host "$P$G  ██║  ██║███████╗   ██║   ███████╗██║  ██╗"
    Write-Host "$P$G  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝"
}

function Show-Menu {
    Show-Header
    $P = Get-Pad; $L = $Text[$Global:Lang]; $G = $Gold; $W = $White; $Gy = $Gray; $R = $Red
    Write-Host "$P$Gy ╔════════════════════════════════════════════╗"
    Write-Host "$P$Gy ║ $R [0]$W $($L.Opt0.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ╠════════════════════════════════════════════╣"
    Write-Host "$P$Gy ║ $G [1]$W $($L.Opt1.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [2]$W $($L.Opt2.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [3]$W $($L.Opt3.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [4]$W $($L.Opt4.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [5]$W $($L.Opt5.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [6]$W $($L.Opt6.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [7]$W $($L.Opt7.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [8]$W $($L.Opt8.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [9]$W $($L.Opt9.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $G [10]$W $($L.Opt10.PadRight(36)) $Gy ║"
    Write-Host "$P$Gy ║ $G [11]$W $($L.Opt11.PadRight(36)) $Gy ║"
    Write-Host "$P$Gy ╠════════════════════════════════════════════╣"
    Write-Host "$P$Gy ║ $W [H]$W $($L.OptH.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ║ $R [X]$W $($L.OptX.PadRight(37)) $Gy ║"
    Write-Host "$P$Gy ╚════════════════════════════════════════════╝"
}

function Show-Help {
    $P = Get-Pad; $G = $Gold; $W = $White
    Clear-Host
    Write-Host "`n$P$G --- AZTEK SENTINEL MANUAL ---"
    Write-Host "`n$P$G [0] EMERGENCY RESTORE"
    Write-Host "$P$W Use this if you want to undo changes. It launches"
    Write-Host "$P$W Windows System Restore to roll back your PC."
    Write-Host "`n$P$G [2] GOD MODE"
    Write-Host "$P$W Creates a folder on your desktop that contains"
    Write-Host "$P$W every single Windows setting in one list."
    Write-Host "`n$P$G [7] MAS ACTIVATION"
    Write-Host "$P$W Uses the latest 'get.activated.win' protocol"
    Write-Host "$P$W to license Windows and Office permanently."
    Write-Host "`n$P$G [9] WALLPAPER"
    Write-Host "$P$W Downloads the official AZTEK aesthetic from GitHub."
    Write-Host "`n$P$W Press any key to return to menu..."
    pause > $null
}

function Create-A2KSafeguard {
    Write-Host "`n$Gold [!] $($Text[$Global:Lang].RestWait) $Reset"
    $Path = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore"
    Set-ItemProperty -Path $Path -Name "SystemRestorePointCreationFrequency" -Value 0 -Force -ErrorAction SilentlyContinue
    Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
    Checkpoint-Computer -Description "AZTEK_Sentinel" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
}

Write-Host "$Black" -NoNewline; Clear-Host
Write-Host "`n  $Gold [1] English  [2] Español"
if ((Read-Host "  AZTEK") -eq "2") { $Global:Lang = "ES" }

Show-Header
Write-Host "`n$Red $($Text[$Global:Lang].PreSafe) $Reset"
if ((Read-Host " $($Text[$Global:Lang].CreateR)") -match "[YySs]") { Create-A2KSafeguard }

do {
    Show-Menu
    $c = Read-Host "`n$(Get-Pad)$Gold $($Text[$Global:Lang].Prompt)$Reset"
    switch ($c) {
        '0' { Start-Process "rstrui.exe"; pause }
        '1' { Create-A2KSafeguard; irm https://get.activated.win | iex; pause }
        '2' { $p = "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
              if (!(Test-Path $p)) { New-Item -Path $p -ItemType Directory | Out-Null }
              Write-Host "`n$Gold $($Text[$Global:Lang].GodDone) $Reset"; pause }
        '3' { Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | % { Set-DnsClientServerAddress -InterfaceAlias $_.Name -ServerAddresses ("1.1.1.1", "1.0.0.1") -ErrorAction SilentlyContinue }; ipconfig /flushdns; pause }
        '4' { netsh wlan show profiles | Select-String "\:(.+)$" | % { $n = $_.Matches.Groups[1].Value.Trim(); netsh wlan show profile name="$n" key=clear | Select-String "Key Content" | % { Write-Host " SSID: $n | PASS: $($_.ToString().Split(':')[1].Trim())" -ForegroundColor Green } }; pause }
        '5' { Stop-Process -Name (Read-Host "Process Name") -Force; pause }
        '6' { Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -All; pause }
        '7' { irm https://get.activated.win | iex; pause }
        '8' { winget install --id Google.Chrome; winget install --id 7zip.7zip; pause }
        '9' { 
            $Url = "https://raw.githubusercontent.com/mamc0826/a2k-lat-site/main/wall1.jpg"
            $Dest = "$env:USERPROFILE\Pictures\aztek_wall.jpg"
            curl.exe -L -s -o $Dest $Url
            $code = 'using System.Runtime.InteropServices; public class Wall { [DllImport("user32.dll")] public static extern int SystemParametersInfo(int u, int p, string v, int f); }'
            if (!([System.Management.Automation.PSTypeName]"Wall").Type) { Add-Type $code }
            [Wall]::SystemParametersInfo(20, 0, $Dest, 3) | Out-Null; pause }
        '10'{ Start-Process "https://www.a2k.lat/#download"; pause }
        '11'{ Start-Process "https://github.com/mamc0826/a2k-lat-site/blob/main/sentinel.ps1"; pause }
        'h' { Show-Help }
        'H' { Show-Help }
        'x' { break }
        'X' { break }
    }
} while ($true)
