# fonctions.applescript #

## Description ##

Liste de fonctions utiles.

## Fonctions pour manipuler des chaînes de caractères ##

- majuscule : Mets les caractères de la chaîne spécifiée en majuscules.
- minuscule : Mets les caractères de la chaîne spécifiée en minuscules.
- sousChaine : Récupère le texte entre les bornes spécifiées.
- SupprimeCaractere : Supprime le caractère spécifié de la chaine passée en paramètres.
- SupprimeCaractere2 : Supprime le caractère spécifié de la chaine passée en paramètres.
- SupprimeLesEspaces : Une fonction pour supprimer tous les espaces dans une chaîne de caractères.
- RemplaceCaractere : Remplace le caractère spécifié de la chaine passée en paramètres par un autre.
- RemplaceCaractere2 : Remplace le caractère spécifié de la chaine passée en paramètres par un autre.
- contientAccent : Détermine si la chaîne contient au moins un accent.
- supprimeAccents : Remplace les caractères accentués par le même caractère non accentué


## Fonctions de manipulation de l'interface graphique ##

- UIscript_check : Fonction pour vérifier si "Activer l'accès pour les périphériques d'aide" est activé dans les préférences système > Accès Universel (ce qui permet d'utiliser les fonctionnalité de script GUI).
- do_menu : Fonction pour atteindre un menu d'une application.
- do_submenu : Fonction pour atteindre un sous-menu d'une application.


## Fonctions de manipulation des dates ##

- makeDateFr : Permet de récupérer les éléments de la date en français.


## Fonctions de trace ##

- traceDansFichier : Écrit une ligne (en UTF-8) à la fin du fichier referenceVersFichierLog.


## Fonctions de manipulation des boîtes de dialogue ##

- demandeInfo : Affiche une boîte de dialogue qui permet de rentrer du texte
- demandeMotDePasse : Affiche une boîte de dialogue qui permet de rentrer un mot de passe (caché)


## Fonctions de manipulation des processus ##

- test_process : Test si l'application "processName" est en lancée ou pas


## Prérequis ##

Aucuns.

