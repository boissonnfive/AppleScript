# Mes notes sur AppleScript


## Utilisation des boîtes de dialogue ##

[Documentation Apple](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/DisplayDialogsandAlerts.html#//apple_ref/doc/uid/TP40016239-CH15-SW1)

### Boîte de dialogue qui affiche une liste ###

ex : Affiche une boîte de dialogue qui demande de sélectionner un prénom (ATTENTION! la réponse est un objet liste)

```applescript   
set mesPrenoms to {"Robin", "Hugo", "Quentin", "Léo", "Jules"}
set prenom to choose from list mesPrenoms
```

### Boîte de dialogue OK/Annuler ###

    
    - set reponse to fenetreQuestion("Où habitez-vous?", "Les Angles")
    set reponse to fenetreQuestion("Voulez-vous continuer?", "")
    
    if button returned of reponse is equal to "Annuler" then
        
        tell application "System Events" to display alert "Réponse  : Annuler"
    else
        tell application "System Events" to display alert "Réponse  : OK"
    end if
    (*
 
      fenetreQuestion : affiche 2 types de fenêtre.
      
        + type 1: une fenêtre qui pose une question à laquelle
        on répond par "OK" ou "Annuler".
        + type 2: une fenêtre qui demande d'entrer un texte.
      
      Pour sélectionner le type 1, on met "" dans le paramètre
      reponseProposee. Pour sélectionner le type 2, on met une
      chaîne non vide dans reponseProposee.
      
      La fenêtre affichée a un bouton "OK", un bouton "Annuler",
      une icône "attention", un titre "Facture" et reste affichée
      300 secondes.
      
      question: une chaîne de caractère qui correspond à la question
      posée par la fenêtre.
      
      reponseProposee: un exemple de réponse affiché dans un
      champ de texte modifiable. Mettre "" si pas de proposition.
      
      Résultat: dépend de la forme de la question.
      {button returned: "OK"} pour une question,
      {text returned: "blabla", button returned: "OK"} pour une
      demande de réponse texte.
      
    *)
    on fenetreQuestion(question, reponseProposee)
        local reponse
        tell application "System Events"
            
            set reponse to missing value
            try
                -- Si on ne mets pas: Cancel button 1
                -- on obtient: error -1708
                if reponseProposee is equal to "" then
                    set reponse to display dialog question ¬
                        buttons {"Annuler", "OK"} ¬
                        default button 2 ¬
                        cancel button 1 ¬
                        with icon caution ¬
                        with title "Facture" giving up after 300
                else
                    set reponse to display dialog question ¬
                        default answer reponseProposee ¬
                        buttons {"Annuler", "OK"} ¬
                        default button 2 ¬
                        cancel button 1 ¬
                        with icon caution ¬
                        with title "Facture" giving up after 300
                end if
            on error errStr number errorNumber
                -- Si l'utilisateur clique sur "Annuler"
                if the errorNumber is equal to -128 then
                    --set annulation to true
                    set reponse to {button returned:"Annuler", gave up:false}
                else
                    -- An unknown error occurred. Resignal, so the caller
                    -- can handle it, or AppleScript can display the number.
                    error errStr number errorNumber
                end if
            end try
            return reponse
            
        end tell -- application "System Events"
        
    end fenetreQuestion

- Code bien formatée
- se ferme automatiquement au bout de 5 minutes (= 300 secondes)
- Gère le cas où l'utilisateur clique sur "Annuler" (exception)


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
        default answer "ex: reponse1, reponse2, reponse3" ¬
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

## Fichiers/Dossiers ##

[Documentation Apple](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ReferenceFilesandFolders.html#//apple_ref/doc/uid/TP40016239-CH34-SW1)

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


### Fichiers/Dossiers Unix ###


set monDossier to "/usr/local/bin"
get info for monDossier
get folder of (info for monDossier)


Dans AppleScript, il vaut toujours mieux utiliser les alias :

    set monFichierAlias to (POSIX file "/Users/bruno/Desktop/test.txt") as alias


On met `\\` quand il y a une espace dans le nom POSIX :

    set my_folder to "/Library/Desktop\\ Pictures"


De Alias vers POSIX (quand on veut afficher le chemin) :

	set p to POSIX path of monFichierAlias


---

## Manipulation de chaînes de caractère (string) ##

[Documentation Apple](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html#//apple_ref/doc/uid/TP40016239-CH33-SW1)


### chaîne vers liste ###

    words of theText      -- sépare les éléments à partir des blancs, des retour charriot ou des fin de ligne
    paragraphs of theText -- sépare les éléments à partir des retour charriot ou des fin de ligne


    -- Renvoie une liste à partir d'une chaîne
    -- theText : chaîne de caractère
    -- theDelimiter : caractère permettant de séparer les éléments de la chaîne
    -- retour : une liste
    -- exemple : "un kiwi, une banane, une poire" => {"un kiwi", "une banane", "une poire"} avec la virgule comme séparateur

    on splitText(theText, theDelimiter)
        set tid to AppleScript's text item delimiters
        set AppleScript's text item delimiters to theDelimiter
        --set theTextItems to every text item of theText
        set theTextItems to text items of theText
        set AppleScript's text item delimiters to tid -- whatever they were before - ALWAYS SET THEM BACK!
        return theTextItems
    end splitText


---

## GUI Scripting ##

[Documentation Apple](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/AutomatetheUserInterface.html#//apple_ref/doc/uid/TP40016239-CH69-SW1)


---

## Utiliser AppleScript dans un script bash ##

fichier : applescript_shell.sh

	#!/usr/bin/osascript

	tell application "Finder"
		set nomsFenetres to name of every Finder window
		choose from list nomsFenetres
	end tell

On le lance comme un script normal :

	./applescript_shell.sh

La valeur de retour du script est la dernière valeur de la variable result.