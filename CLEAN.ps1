#Powershell : v3.0
#Version : 02/06/2016
#Authors : Atao & Mayeul

<#
.SYNOPSIS
    Clean nettoye Windows automatiquement.
    Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).
    Basé sur ce script de Greg Ramsey.
.DESCRIPTION
    Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).
    BasÃ© sur ce script de Greg Ramsey (https://gregramsey.net/2014/05/14/automating-the-disk-cleanup-utility/).
    Le script fonctionne sur Windows 7 et Windows 10 (Versions 6 & 10) . Il suffit de rÃ©adapter les clefs de registre pour les autres versions de Windows.
    Pour Windows Serveur 2008 et suivants. Il suffit d'ajouter l'outil cleanmgr...
.PARAMETER path
    Emplacement du repertoire depuis lequel le script est lancé, Récupéré par le batch!
.NOTES
    Auteur : Atao & Mayeul
    Project : https://github.com/atao/CLEAN
.EXAMPLE
    .\CLEAN.ps1
#>
Clear-Host
Write-Host " ####  #      ######   ##   #    # " -ForegroundColor Green
Write-Host "#    # #      #       #  #  ##   # " -ForegroundColor Red
Write-Host "#      #      #####  #    # # #  # " -ForegroundColor Green
Write-Host "#      #      #      ###### #  # # " -ForegroundColor Red
Write-Host "#    # #      #      #    # #   ## " -ForegroundColor Green
Write-Host " ####  ###### ###### #    # #    # " -ForegroundColor Red


#Check OS
$os = Get-WmiObject -Class Win32_OperatingSystem

#Selection de l'OS

if ($os.version -like "10.*") {$version = "w10"}
if ($os.version -like "6.*") {$version = "w7"}

function cleaning {
    #FreeSpace before cleaning
    $FreespaceBefore = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object @{n='Free'; e={'{0:N2}' -f ($_.FreeSpace / 1MB) }}
    #Gestion du temps
    $time_start = Get-Date
    Write-Host "--> Système :" $os.Caption "`n--> Version noyau :" $os.version "`n" -ForegroundColor Green
    
    Try{
        cleanmgr /sagerun:1
       }
    catch
       {
        #Cleanmg pas disponible. Installation du rôle.
        Write-Host -ForegroundColor DarkYellow "Il manque un rôle! Installation..."
        Install-WindowsFeature Desktop-Experience
        if ((Get-WindowsFeature Desktop-Experience | Select-Object -ExpandProperty installstate) -like "InstallPending")
        {
            Write-Host -ForegroundColor Yellow "Merci de rémarrer le poste."
        }
        Get-WindowsFeature Desktop-Experience | ft -AutoSize
        break #Sortie du script
       }

    do
    {
        Write-Host "Waiting for cleanmgr to complete. . ." -ForegroundColor Gray
        start-sleep 5
    }
    while ((get-wmiobject win32_process | where-object {$_.processname -eq 'cleanmgr.exe'} | measure).count)

    $FreespaceAfter = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object @{n='Free'; e={'{0:N2}' -f ($_.FreeSpace / 1MB) }}
    #Sans WMI
    #Get-Volume | Select-Object DriveLetter, @{n='SizeRemaining'; e={'{0:N2}' -f ($_.SizeRemaining / 1MB) }} | Where-Object DriveLetter -Like "C"

    #Gain
    $gain = ($FreespaceBefore.size - $FreespaceAfter.size)
    Write-Host "`nGain d'espace : $gain MB" -ForegroundColor Green
    #Gestion du temps
    $time_end = Get-Date
    $timer = ($time_end - $time_start)
    $tps = $timer.TotalSeconds
    $tps = $tps | select @{n='Temps'; e={'{0:N1}' -f ($_) }}
    $tps = $tps | select -ExpandProperty Temps
    Write-host "Duree d'execution : $tps secondes" -ForegroundColor Green
    }

Switch ($version){
    "w10"
    {
        $chk = get-itemproperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name StateFlags0001 -ErrorAction SilentlyContinue
        if ($chk.StateFlags0001 -eq 2)
        {
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
            #Set-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content' -name StateFlags0001 -type DWORD -Value 2
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
        Write-host "`nScript non-adapte a votre systeme..." -ForegroundColor yellow
        Exit-PSSession
    }

}
