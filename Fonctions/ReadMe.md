# fonctions.applescript #

## Description ##

Liste de fonctions utiles.

## Fonctions pour manipuler des chaînes de caractères ##

- majuscule          : Mets les caractères de la chaîne spécifiée en majuscules
- minuscule          : Mets les caractères de la chaîne spécifiée en minuscules
- sousChaine         : Récupère le texte entre les bornes spécifiées.
- SupprimeCaractere  : Supprime le caractère spécifié de la chaine passée en paramètres
- SupprimeCaractere2 : Supprime le caractère spécifié de la chaine passée en paramètres
- SupprimeLesEspaces : Une fonction pour supprimer tous les espaces dans une chaîne de caractères
- RemplaceCaractere  : Remplace le caractère spécifié de la chaine passée en paramètres par un autre
- RemplaceCaractere2 : Remplace le caractère spécifié de la chaine passée en paramètres par un autre
- contientAccent     : Détermine si la chaîne contient au moins un accent.
- supprimeAccents    : Remplace les caractères accentués par le même caractère non accentué


## Fonctions de manipulation de l'interface graphique ##

- UIscript_check : Fonction pour vérifier si "Activer l'accès pour les périphériques d'aide" est activé dans les préférences système > Accès Universel (ce qui permet d'utiliser les fonctionnalité de script GUI).
- do_menu        : Fonction pour atteindre un menu d'une application.
- do_submenu     : Fonction pour atteindre un sous-menu d'une application.
- clicEnregisterSous10_12 : Manipule la fenêtre « Enregistrer sous » de macOS 10.12 .


## Fonctions de manipulation des dates ##

- makeDateFr : Permet de récupérer les éléments de la date en français.


## Fonctions de trace ##

- traceDansFichier : Écrit une ligne (en UTF-8) à la fin du fichier referenceVersFichierLog.


## Fonctions de manipulation des boîtes de dialogue ##

- demandeInfo       : Affiche une boîte de dialogue qui permet de rentrer du texte
- demandeMotDePasse : Affiche une boîte de dialogue qui permet de rentrer un mot de passe (caché)


## Fonctions de manipulation des processus ##

- processusEstLance : Test si une application est en lancée ou pas


## Fonctions système ##

- nomOrdinateur  : Renvoi le nom de l'ordinateur
- nomUtilisateur : Renvoi le nom de l'utilisateur
- versionSysteme : Renvoi la version du système
- adresseIP      : Renvoi l'adresse IP en cours

## Fonctions sur les fichiers/dossiers ##

- creeDossier          : Crée un dossier à l'endroit indiqué
- deplaceElement       : Déplace un élément à l'endroit indiqué
- elementExiste        : Détermine si un élément existe ou pas
- POSIXVersAlias       : Renvoi un alias à partir d'un chemin POSIX
- aliasVersPOSIX       : Renvoi un chemin POSIX à partir d'un alias
- versionApplication   : Renvoi la version de l'application
- renommeElementFinder : Renomme un élément du Finder (fichier/dossier/alias)
- renommeApplication   : Renomme une application du Finder
- dossierParent        : Renvoi le dossier parent de l'élément passé en paramètre
- creeAlias            : Crée un raccourci (alias) vers un élément
- copieDansDossier     : Copie un élément dans un dossier
- supprimeElement      : Supprime un élément