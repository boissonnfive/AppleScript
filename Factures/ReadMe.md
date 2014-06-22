# facture.applescript #

## Description ##

Ce script permet de remplir une facture à partir d'un fichier modèle excel et de l'envoyer à un client par mail.

Il demande :

- le nom du client (pour chercher son adresse mail et son adresse)
- la durée d'intervention
- Le type d'intervention
- de modifier ou non la date d'intervention

A partir de ces données, il crée une facture au format pdf (à partir d'un
 fichier modèle excel), sauvegardée dans un dossier factures.

Enfin, il envoie ce fichier au client par courrier électronique.

## Les variables à modifier ##

Il faudra modifier dans le code les variables suivantes :

- cheminFichierModeleFactureExcel : le chemin du fichier modèle excel
	 utilisé pour créer la facture.
- chemindossierFactures : le chemin du dossier où sont archivées toutes les factures envoyées au client.
- cheminfichierFacture : le chemin où est enregistré la facture avant d'être insérée dans le mail puis déplacée dans le dossier Factures. C'est à cet endroit que l'on peut retrouver une facture quand quelque chose n'a pas bien fonctionné.
- monAdresseCourrier : l'adresse utilisée pour envoyer le mail.
- maSignature : la signature utilisée pour envoyer le mail.
- monSujet : le sujet du mail.


## Précision sur le nom du fichier facture ##

- son nom a le format suivant : "Facture_" + numéro à 5 chiffres précédés par des zéros + ".pdf" (exemple: Facture_00123.pdf)
- son numéro est incrémenté à chaque nouvelle facture
- le numéro de la facture est retrouvé à partir du nom de la dernière facture du dossier "Factures", incrémenté de 1.