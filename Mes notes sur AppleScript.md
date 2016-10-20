# Mes notes sur AppleScript


## Utilisation des boîtes de dialogue ##

### Boîte de dialogue qui demande une valeur ###

    tell application "System Events"
        set retour to ""
        set reponse to missing value
        try
            -- Si on ne mets pas: cancel button "Annuler"
            -- on obtient: error -1708
            set reponse to display dialog ¬
                "Entrer le lieu de départ de l'itinéraire" default answer ¬
                "17 rue du Liron 30133 LES ANGLES" buttons {"Annuler", "OK"} ¬
                default button 2 ¬
                cancel button ¬
                "Annuler" with icon caution ¬
                with title "OT"
            set retour to text returned of reponse
        on error
            --display alert "mon erreur"
        end try
        return retour
    end tell


### Récupérer une liste dans une boîte de dialogue ###

    property parent : application "TextMate"
    
    
    display dialog "Taper une liste de nom séparés par des virgules" ¬
        default answer "default answer" ¬
        with icon 1 ¬
        buttons {"Cancel", "OK"} ¬
        default button "OK"
    --set button_pressed to the button returned of result
    --set tutu to the text returned of result
    copy the result as list to {text_returned, button_pressed}
    if button_pressed is "OK" then
        text_returned
    else
        -- statements for cancel button
    end if

---

## Fichiers/Dossiers

Pour utiliser les Fichiers/Dossiers, il faut :

1. Créer un alias :

        set monFichierAlias to "Macintosh HD:Users:bruno:Desktop:test.txt" as alias

2. Utiliser l'application "Finder"

        tell application "Finder"
        ...
        end tell


### Récupérer les informations d'un fichier/Dossier ###

    get container of monFichierAlias --> Dossier contenant le fichier (folder)
    name extension of monFichierAlias --> Extension du fichier (string)
    name of monFichierAlias --> Nom du fichier (string)
    modification date of monFichierAlias --> Date de modification (date)
    physical size of monFichierAlias --> Taille (integer)


### Récupérer le dossier contenant le script ###

	set dossierParent to container of (path to me)


### Créer une variable fichier ###

Un alias hors de l'objet application Finder :

    set monFichierAlias to alias "Macintosh HD:Users:bruno:Desktop:test.txt"
    set monFichierAlias to "Macintosh HD:Users:bruno:Desktop:test.txt" as alias

Dans l'objet application Finder :

    set monFichier to file "Macintosh HD:Users:bruno:Desktop:test.txt"
    set monFichier to "Macintosh HD:Users:bruno:Desktop:test.txt" as file

Un fichier à partir d'un chemin Unix :

    set monFichierPOSIX to POSIX file "/Users/bruno/Desktop/test.txt"
    set monFichierPOSIX to "/Users/bruno/Desktop/test.txt" as POSIX file


### Créer un fichier (dans Finder) ###

    set nouveauFichier to make new file at desktop with properties {name:"coucou.txt", extension hidden:false,comment:"créé par AppleScript"} --> (Document file)


## Fichiers/Dossiers Unix


set monDossier to "/usr/local/bin"
get info for monDossier
get folder of (info for monDossier)


Dans AppleScript, il vaut toujours mieux utiliser les alias :

    set monFichierAlias to (POSIX file "/Users/bruno/Desktop/test.txt") as alias


On met `\\` quand il y a une espace dans le nom POSIX :

    set my_folder to "/Library/Desktop\\ Pictures"


De Alias vers POSIX (quand on veut afficher le chemin) :

	set p to POSIX path of monFichierAlias



## GUI Scripting


## Utiliser AppleScript dans un script bash

fichier : applescript_shell.sh

	#!/usr/bin/osascript

	tell application "Finder"
		set nomsFenetres to name of every Finder window
		choose from list nomsFenetres
	end tell

On le lance comme un script normal :

	./applescript_shell.sh

La valeur de retour du script est la dernière valeur de la variable result.