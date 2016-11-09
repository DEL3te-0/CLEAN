#Powershell : v3.0
#Version : 02/11/2016
#Authors : Atao & Mayeul

<#
.SYNOPSIS
    Clean nettoye Windows automatiquement.
    Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).
    Basé sur ce script de Greg Ramsey.
.DESCRIPTION
    Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).
    Basé sur ce script de Greg Ramsey (https://gregramsey.net/2014/05/14/automating-the-disk-cleanup-utility/).
    Le script fonctionne sur Windows 7 et Windows 10 (Versions 6 & 10) . Il suffit de réadapter les clefs de registre pour les autres versions de Windows.
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

#Reg
#('HKLM(.)*\\)
$ActiveSetupTempFolders = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders'
$DownloadedProgramFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files'
$BranchCache = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache'
$InternetCacheFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files'
$OldChkDskFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files'
$PreviousInstallations = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations'
$RecycleBin = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin'
$RetailDemoOfflineContent = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content'
$ServicePackCleanup = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Service Pack Cleanup'
$SetupLogFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files'
$Systemerrormemorydumpfiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files'
$Systemerrorminidumpfiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files'
$TemporaryFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files'
$TemporarySetupFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files'
$ThumbnailCache = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache'
$UpdateCleanup = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup'
$UpgradeDiscardedFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files'
$Userfileversions = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions'
$WindowsDefender = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender'
$WindowsErrorReportingArchiveFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files'
$WindowsErrorReportingQueueFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files'
$WindowsErrorReportingSystemArchiveFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files'
$WindowsErrorReportingSystemQueueFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files'
$WindowsUpgradeLogFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files'
$OfflinePagesFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files'
$WindowsErrorReportingTempFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Temp Files'
$MemoryDumpFiles = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files'

#Profile
$flag = 'StateFlags0001'

#Messages
$msgKeyOK = "Les clées ont été ajouté au registre."
$msgSupport = "`nSystem not supported..."

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
        $chk = get-itemproperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name $flag -ErrorAction SilentlyContinue
        if ($chk.$flag -eq 2)
        {
        cleaning
        }
        Else
        {
            Try{
              $chk = Get-ItemProperty -path $ActiveSetupTempFolders -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $ActiveSetupTempFolders -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $DownloadedProgramFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $DownloadedProgramFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $BranchCache -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $BranchCache -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $InternetCacheFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $InternetCacheFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $OldChkDskFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $OldChkDskFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $PreviousInstallations -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $PreviousInstallations -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $RecycleBin -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $RecycleBin -name $flag -type DWORD -Value 2}
              #$chk = Get-ItemProperty -path $RetailDemoOfflineContent -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $RetailDemoOfflineContent -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $ServicePackCleanup -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $ServicePackCleanup -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $SetupLogFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $SetupLogFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $Systemerrormemorydumpfiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $Systemerrormemorydumpfiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $Systemerrorminidumpfiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $Systemerrorminidumpfiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $TemporaryFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $TemporaryFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $TemporarySetupFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $TemporarySetupFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $ThumbnailCache -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $ThumbnailCache -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $UpdateCleanup -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $UpdateCleanup -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $UpgradeDiscardedFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $UpgradeDiscardedFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $Userfileversions -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $Userfileversions -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsDefender -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsDefender -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingArchiveFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsErrorReportingArchiveFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingQueueFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsErrorReportingQueueFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingSystemArchiveFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsErrorReportingSystemArchiveFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingSystemQueueFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsErrorReportingSystemQueueFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsUpgradeLogFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsUpgradeLogFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $OfflinePagesFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $OfflinePagesFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingTempFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty $WindowsErrorReportingTempFiles -name $flag -type DWORD -Value 2}
              Write-Host $msgKeyOK
            }
            catch{
              Write-Warning -Message "$($_.Exception.Message)"
            }

            cleaning
        }

    }
    "w7"
    {
        $chk = get-itemproperty -path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -name $flag -ErrorAction SilentlyContinue
        if ($chk.$flag -eq 2)
        {
        cleaning
        }
        Else
        {
            Try{
              $chk = Get-ItemProperty -path $ActiveSetupTempFolders -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $ActiveSetupTempFolders -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $DownloadedProgramFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $DownloadedProgramFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $InternetCacheFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $InternetCacheFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $MemoryDumpFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $MemoryDumpFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $OldChkDskFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $OldChkDskFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $PreviousInstallations -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $PreviousInstallations -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $RecycleBin -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $RecycleBin -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $ServicePackCleanup -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $ServicePackCleanup -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $SetupLogFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $SetupLogFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $Systemerrormemorydumpfiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $Systemerrormemorydumpfiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $Systemerrorminidumpfiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $Systemerrorminidumpfiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $TemporaryFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $TemporaryFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $TemporarySetupFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $TemporarySetupFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $ThumbnailCache -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $ThumbnailCache -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $UpdateCleanup -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $UpdateCleanup -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $UpgradeDiscardedFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $UpgradeDiscardedFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingArchiveFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $WindowsErrorReportingArchiveFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingSystemQueueFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $WindowsErrorReportingSystemQueueFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingArchiveFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $WindowsErrorReportingArchiveFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsErrorReportingQueueFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $WindowsErrorReportingQueueFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $WindowsUpgradeLogFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $WindowsUpgradeLogFiles -name $flag -type DWORD -Value 2}
              $chk = Get-ItemProperty -path $OfflinePagesFiles -ErrorAction SilentlyContinue ; if ($? -eq $false) {Set-ItemProperty -path $OfflinePagesFiles -name $flag -type DWORD -Value 2}
              Write-Host $msgKeyOK
            }
            catch{
              Write-Warning -Message "$($_.Exception.Message)"
            }
            cleaning
        }
    }
    *
    {
        Write-host $msgSupport -ForegroundColor yellow
        Exit-PSSession
    }

}
