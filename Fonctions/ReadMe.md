# fonctions.applescript #

## Description ##

Liste de fonctions utiles.

## Fonctions pour manipuler des chaînes de caractères ##

- __majuscule__          : Mets les caractères de la chaîne spécifiée en majuscules
- __minuscule__          : Mets les caractères de la chaîne spécifiée en minuscules
- __sousChaine__         : Récupère le texte entre les bornes spécifiées.
- __SupprimeCaractere__  : Supprime le caractère spécifié de la chaine passée en paramètres
- __SupprimeCaractere2__ : Supprime le caractère spécifié de la chaine passée en paramètres
- __SupprimeLesEspaces__ : Une fonction pour supprimer tous les espaces dans une chaîne de caractères
- __RemplaceCaractere__  : Remplace le caractère spécifié de la chaine passée en paramètres par un autre
- __RemplaceCaractere2__ : Remplace le caractère spécifié de la chaine passée en paramètres par un autre
- __contientAccent__     : Détermine si la chaîne contient au moins un accent.
- __supprimeAccents__    : Remplace les caractères accentués par le même caractère non accentué
- __aLEnvers__           : Renvoie la chaîne avec les caractères dans l'ordre inverse


## Fonctions de manipulation de l'interface graphique ##

- __UIscript_check__ : Fonction pour vérifier si "Activer l'accès pour les périphériques d'aide" est activé dans les préférences système > Accès Universel (ce qui permet d'utiliser les fonctionnalité de script GUI).
- __do_menu__        : Fonction pour atteindre un menu d'une application.
- __do_submenu__     : Fonction pour atteindre un sous-menu d'une application.
- __clicEnregisterSous10_12__ : Manipule la fenêtre « Enregistrer sous » de macOS 10.12 .


## Fonctions de manipulation des dates ##

- __makeDateFr__ : Permet de récupérer les éléments de la date en français.


## Fonctions de trace ##

- __creerUnCheminDeFichierLog__ : Renvoi un chemin vers un fichier de log dans ~/Library/Logs/
- __traceDansFichier__ : Écrit une ligne (en UTF-8) à la fin du fichier referenceVersFichierLog.


## Fonctions de manipulation des boîtes de dialogue ##

- __demandeInfo__       : Affiche une boîte de dialogue qui permet de rentrer du texte
- __demandeMotDePasse__ : Affiche une boîte de dialogue qui permet de rentrer un mot de passe (caché)


## Fonctions de manipulation des processus ##

- __processusEstLance__ : Test si une application est en lancée ou pas


## Fonctions système ##

- __nomOrdinateur__         : Renvoi le nom de l'ordinateur
- __nomUtilisateur__        : Renvoi le nom de l'utilisateur
- __nomUtilisateurComplet__ : Renvoi le nom complet de l'utilisateur
- __versionSysteme__        : Renvoi la version du système
- __versionSystemeCourte__  : Renvoi seulement les deux premiers nombres de la version du système
- __versionApplication__    : Renvoi la version de l'application
- __adresseIP__             : Renvoi l'adresse IP en cours

## Fonctions sur les fichiers/dossiers ##

- __POSIXVersAlias__     : Renvoi un alias à partir d'un chemin POSIX
- __aliasVersPOSIX__     : Renvoi un chemin POSIX à partir d'un alias
- __nomSansExtension__   : Renvoi le nom du fichier sans extension
- __dossierParent__      : Renvoi le dossier parent de l'élément passé en paramètre
- __creeDossier__        : Crée un dossier à l'endroit indiqué
- __creeAlias__          : Crée un raccourci (alias) vers un élément
- __copieElement__       : Copie un élément dans un dossier
- __deplaceElement__     : Déplace un élément à l'endroit indiqué
- __supprimeElement__    : Supprime un élément
- __elementExiste__      : Détermine si un élément existe ou pas
- __renommeElement__     : Renomme un élément du Finder (fichier/dossier/alias)
- __renommeApplication__ : Renomme une application du Finder
- __aliasDeLaRessource__ : Récupère l'alias de la ressource dont le nom est spécifié

## Fonctions de messagerie ##

- __envoieAvecMail__          : Crée et envoie un mail avec Mail
- __ajouteSignatureDansMail__ : ajouteSignatureDansMail
