<img style="align="middle"" src="img/256px-Recycle001.svg.png">
# CLEAN
##### Clean nettoye Windows automatiquement

Script d'automatisation de l'outil Nettoyage de disque de Windows, pour le nettoyage des postes clients (cleanmgr).

Basé sur [ce script](https://gregramsey.net/2014/05/14/automating-the-disk-cleanup-utility/) de Greg Ramsey.

Le script fonctionne sur Windows 7 ([Windows 6.1](https://en.wikipedia.org/wiki/Windows_NT#Releases)).
Il suffit de réadapter les clefs de registre pour les autres versions de Windows.

[Pour Windows Serveur 2008 et suivants](https://technet.microsoft.com/fr-fr/library/ff630161%28v=ws.10%29.aspx) Il suffit d'ajouter l'outil...

|Elements nettoyés|Description
|:-------------
|Temporary Setup files | (Fonction plus utile désormais) |
|Fichiers programmes téléchargés | Programmes téléchargés automatiquement lors de la visite sur certaines pages |
|Fichiers Internet temporaires | Pages web stockées sur le disque dur |
|Debug Dump files|Fichiers créés par Windows |
|Anciens fichiers Chkdsk | Fichiers temporaires qui n'ont pas été modifiés depuis plus d'une semaine |
|Précedente(s) installation(s) de Windows | Fichiers provenant d'une installation précedente de Windows |
|Corbeille | Vide la corbeille
|Fichiers de sauvegarde du Service Pack | Anciennes versions des fichiers qui ont été mis à jour par un Service Pack. Si supprimé, plus de désinstallation du Service Pack
|Fichiers enregistrement de l'installation | Fichiers créées par Windows
|Fichiers de vidage mémoire d'erreurs système | Supprime les fichiers de vidage mémoire d'erreurs système
|Fichiers de minividage d'erreurs système | Supprime les fichiers de minividage d'erreurs système
|Fichiers temporaires | Supprime les fichiers temporaires créés par des programmes, normalement supprimés après leur fermeture
|Fichiers d'installation temporaires de Windows | Fichiers d'installation utilisés par le programme d'installation de Windows
|Miniatures | Supprime les miniatures des fichiers (vidéos, photos...). Ils sont recréés automatiquement
|Nettoyage de Windows Update | Windows conserve des copies de toutes les mises à jour de Windows Update installées, même après les mises à jour ultérieures
|Fichiers ignorés par la mise à niveau de Windows | Fichiers d'une installation antérieur de Windows
|Fichiers archivés de rapport d'erreurs Windows par utilisateur | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions
|Fichiers en file d'attente de rapport d'erreurs Windows par utilisateur | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions
|Fichiers archivés de rapport d'erreurs Windows du système | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions
|Fichiers en file d'attente de rapport d'erreurs Windows du système | Fichiers utilisés pour des rapports d'erreurs et la recherche de solutions
|Fichiers journaux de la mise à niveau de Windows | Fichiers journaux de la mise à niveau de Windows contenant des informations permettant d'identifier et de résoudre les problèmes qui se produisent lors de l'installation, de la mise à niveau ou de la maintenance de Windows

Le script créer le profil 1 pour le nettoyage.
<hr>
<img src="img/Telegram.svg" width="5%" height="5%" /> [Contactez moi!](https://telegram.me/ralevy)
