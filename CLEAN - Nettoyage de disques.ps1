#Powershell : v3.0
#Version : 22/06/2016
#Authors : Atao & Mayeul

<#
.SYNOPSIS
    Clean nettoye Windows automatiquement.
    Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).
    Basé sur ce script de Greg Ramsey.
.DESCRIPTION
    Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).
    Basé sur ce script de Greg Ramsey (https://gregramsey.net/2014/05/14/automating-the-disk-cleanup-utility/).
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
$sys = Get-WmiObject -Class Win32_Computersystem

#Selection de l'OS

if ($os.version -like "10.*") {$version = "w10"}
if ($os.version -like "6.*") {$version = "w7"}

function cleaning {
    #Gestion du temps
    $time_start = Get-Date

    Write-Host "[INFO] Nom :" $sys.Name "`n[INFO] Domaine :" $sys.Domain "`n[INFO] Systeme :" $os.Caption"" -ForegroundColor Green

    #FreeSpace before cleaning
    $FreespaceBefore = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object FreeSpace
    Try{
        cleanmgr /sagerun:1
       }
    catch
       {
        #Cleanmg pas disponible. Installation du rôle.
        Write-Host -ForegroundColor DarkYellow "[ERREUR] Il manque un rôle! Installation..."
        Install-WindowsFeature Desktop-Experience
        if ((Get-WindowsFeature Desktop-Experience | Select-Object -ExpandProperty installstate) -like "InstallPending")
        {
            Write-Host -ForegroundColor Yellow "[OK] Merci de redémarrer le poste."
        }
        Get-WindowsFeature Desktop-Experience | ft -AutoSize
        break #Sortie du script
       }

    do
    {
        Write-Host "[INFO] Waiting for cleanmgr. . ." -ForegroundColor Gray
        start-sleep 5
    }
    while ((get-wmiobject win32_process | where-object {$_.processname -eq 'cleanmgr.exe'} | measure).count)

    $FreespaceAfter = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object FreeSpace
    #Sans WMI
    #Get-Volume | Select-Object DriveLetter, @{n='SizeRemaining'; e={'{0:N2}' -f ($_.SizeRemaining / 1MB) }} | Where-Object DriveLetter -Like "C"

    #Gain d'espace
    $g = ($FreespaceBefore.FreeSpace - $FreespaceAfter.FreeSpace)
    $gain = $g | Select @{n="Gaindespace" ; e={'{0:N2}' -f ($_ / 1MB) }}
    $gain = $gain.Gaindespace
    Write-Host "`n[INFO] Gain d'espace : $gain MB (Sur $env:SystemDrive)" -ForegroundColor Green

    #Gestion du temps
    $time_end = Get-Date
    $timer = ($time_end - $time_start)
    $tps = $timer.TotalSeconds
    $tps = $tps | select @{n='Temps'; e={'{0:N1}' -f ($_) }}
    $tps = $tps | select -ExpandProperty Temps
    Write-host "[INFO] Duree d'execution : $tps secondes" -ForegroundColor Green
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
            Try{
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
            }
            catch{
              Write-Warning -Message "$($_.Exception.Message)"
            }

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
            Try{
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
            }
            catch{
              Write-Warning -Message "$($_.Exception.Message)"
            }
            cleaning
        }
    }
    *
    {
        Write-host "`nScript non-adapte a votre système..." -ForegroundColor yellow
        Exit-PSSession
    }

}
