#Powershell : v3.0
#Version : 18/04/2016
#Author : Atao & Mayeul

$OutputEncoding = New-Object -typename System.Text.UTF8Encoding
[Console]::OutputEncoding = New-Object -typename System.Text.UTF8Encoding

Write-Host " ####  #      ######   ##   #    # " -ForegroundColor Green
Write-Host "#    # #      #       #  #  ##   # " -ForegroundColor Red
Write-Host "#      #      #####  #    # # #  # " -ForegroundColor Green
Write-Host "#      #      #      ###### #  # # " -ForegroundColor Red
Write-Host "#    # #      #      #    # #   ## " -ForegroundColor Green
Write-Host " ####  ###### ###### #    # #    # " -ForegroundColor Red


$os = Get-WmiObject Win32_OperatingSystem

if ($os.version -like "10.*") {$version = "w10"}
if ($os.version -like "6.*") {$version = "w7"}

function cleaning {
    #FreeSpace before cleaning
    $FreespaceBefore = (Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'" | select Freespace).FreeSpace/1GB
    #Gestion du temps
    $time_start = Get-Date -DisplayHint time

    cleanmgr /sagerun:1

    do
    {
        Write-Host "Waiting for cleanmgr to complete. . ." -ForegroundColor Gray
        start-sleep 5
    }
    while ((get-wmiobject win32_process | where-object {$_.processname -eq 'cleanmgr.exe'} | measure).count)

    $FreespaceAfter = (Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'" | select Freespace).FreeSpace/1GB

    #Gain
    $gain = $FreespaceBefore - $FreespaceAfter
    Write-Host "`nGain d'espace : $gain Mo" -ForegroundColor Green
    #Gestion du temps
    $time_end = Get-Date -DisplayHint time
    $timer = ($time_end - $time_start)
    Write-host "Duree d'execution :" $timer.TotalSeconds "secondes - Soit" $timer.TotalMinutes "Minutes" -ForegroundColor Green
    }

Switch ($version){
    "w10"
    {
        $chk = get-itemproperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name StateFlags0001 -ErrorAction SilentlyContinue
        if ($chk.StateFlags0001 -eq 2)
        {
        Write-Host "--> Version du systeme :" $os.version "`n" -ForegroundColor Green
        cleaning
        }
        Else
        {
            Set-ItemProperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Service Pack Cleanup' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Temp Files' -name StateFlags0001 -type DWORD -Value 2
            Write-Host "StateFlags0001 created!"

            cleaning
        }

    }
    "w7"
    {
        $chk = get-itemproperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name StateFlags0001 -ErrorAction SilentlyContinue
        if ($chk.StateFlags0001 -eq 2)
        {
        Write-Host "--> Version du syst√®me :" $os.version "`n" -ForegroundColor Green
        cleaning
        }
        Else
        {
            Set-ItemProperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Service Pack Cleanup' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files' -name StateFlags0001 -type DWORD -Value 2
            Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files' -name StateFlags0001 -type DWORD -Value 2
            Write-Host "StateFlags0001 created!"

            cleaning
        }
    }
    *
    {
        Write-host "`nScript non-adapte a†votre systeme..." -ForegroundColor yellow
        Exit-PSSession
    }

}