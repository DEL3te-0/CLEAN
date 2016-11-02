![logo]

# CLEAN - Nettoyage de disques
##### Clean nettoye Windows automatiquement

- Latest version : 02/11/2016
- Author : Atao & Mayeul
- Version de Powershell : Powershell V3
- Site : (https://atao.github.io/CLEAN/)

Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).

Basé sur [ce script](https://gregramsey.net/2014/05/14/automating-the-disk-cleanup-utility/) de Greg Ramsey.

Le script fonctionne sur Windows 7 et Windows 10 ([Versions 6 et 10](https://en.wikipedia.org/wiki/Windows_NT#Releases)) .
Il suffit de réadapter les clefs de registre pour les autres versions de Windows.

[Pour Windows Serveur 2008 et suivants](https://technet.microsoft.com/fr-fr/library/ff630161%28v=ws.10%29.aspx). L'outils cleanmgr est nécessaire... Il faut donc ajouter le rôle Desktop-Experience (Windows Expérience) disponible sur toutes les versions de Windows. Le script l'installera automatiquement mais cela nécessitera un reboot.

PS : Une fois le reboot effectué, relancer le script.

Elements nettoyés | Description | Versions
:------------- | ------------- | ---------
Temporary Setup files | (Fonction plus utile désormais) | 7 , 10
Fichiers programmes téléchargés | Programmes téléchargés automatiquement lors de la visite sur certaines pages| 7 , 10
Fichiers Internet temporaires | Pages web stockées sur le disque dur| 7 , 10
Memory Dump files|Fichiers créés par Windows lors de l'écran bleu d'un BSOD| 7
Debug Dump files|Fichiers créés par Windows| 7 , 10
Anciens fichiers Chkdsk | Fichiers temporaires qui n'ont pas été modifiés depuis plus d'une semaine| 7 , 10
Précedente(s) installation(s) de Windows | Fichiers provenant d'une installation précedente de Windows| 7 , 10
Corbeille | Vide la corbeille| 7 , 10
RetailDemo Offline Content | Fichier permettant de revenir à un windows à l'état d'usine | 10
Fichiers de sauvegarde du Service Pack | Anciennes versions des fichiers qui ont été mis à jour par un Service Pack. Si supprimé, plus de désinstallation du Service Pack| 7 , 10
Fichiers enregistrement de l'installation | Fichiers créées par Windows| 7 , 10
Fichiers de vidage mémoire d'erreurs système | Supprime les fichiers de vidage mémoire d'erreurs système| 7 , 10
Fichiers de minividage d'erreurs système | Supprime les fichiers de minividage d'erreurs système| 7 , 10
Fichiers temporaires | Supprime les fichiers temporaires créés par des programmes, normalement supprimés après leur fermeture| 7 , 10
Fichiers d'installation temporaires de Windows | Fichiers d'installation utilisés par le programme d'installation de Windows| 7 , 10
Miniatures | Supprime les miniatures des fichiers (vidéos, photos...). Ils sont recréés automatiquement| 7 , 10
Nettoyage de Windows Update | Windows conserve des copies de toutes les mises à jour de Windows Update installées, même après les mises à jour ultérieures| 7 , 10
Fichiers ignorés par la mise à niveau de Windows | Fichiers d'une installation antérieur de Windows| 7 , 10
Fichiers archivés de rapport d'erreurs Windows par utilisateur | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions| 7 , 10
Fichiers en file d'attente de rapport d'erreurs Windows par utilisateur | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions| 7 , 10
Fichiers archivés de rapport d'erreurs Windows du système | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions| 7 , 10
Fichiers en file d'attente de rapport d'erreurs Windows du système | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions| 7 , 10
Fichiers Temp archivés de rapport d'erreurs Windows par utilisateur | Fichiers temporaires utilisés pour des rapports d'erreurs et la recherche de solutions| 7 , 10
Fichiers journaux de la mise à niveau de Windows | Fichiers journaux de la mise à niveau de Windows contenant des informations permettant d'identifier et de résoudre les problèmes qui se produisent lors de l'installation, de la mise à niveau ou de la maintenance de Windows| 7 , 10

Le script créer le profil 1 pour le nettoyage.

![demo]
***
[logo]: https://raw.githubusercontent.com/atao/CLEAN/master/img/256px-Recycle001.svg.png "Logo"
[demo]: https://raw.githubusercontent.com/atao/CLEAN/master/img/demo.gif "Demo"
