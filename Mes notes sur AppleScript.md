# Mes notes sur AppleScript


## Utilisation des boîtes de dialogue ##

[Documentation Apple](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/DisplayDialogsandAlerts.html#//apple_ref/doc/uid/TP40016239-CH15-SW1)

### Boîte de dialogue la plus simple ###

```applescript
display alert "Bonjour tout le monde !"
```

### Boîte de dialogue OK/Annuler ###

Forme de base :

```applescript
display dialog "Bonjour tout le monde !"
--> {button returned:"OK"} -- Clic sur le bouton "OK"
--> error number -128      -- Clic sur le bouton "Annuler"
```

Gestion des réponses :

```applescript
try
    display dialog "Bonjour tout le monde !"
on error errStr number errorNumber
    log "ERREUR"
    return
end try
-- Si on arrive ici, c'est que l'utilisateur n'a pas cliqué sur "Annuler"
log "Si on arrive ici, c'est que l'utilisateur n'a pas cliqué sur \"Annuler\""
```

**ATTENTION !** Si on renomme le bouton "Annuler", il faut utiliser `cancel button` pour désigner le nouveau bouton "Annuler". Sinon, l'erreur -128 ne sera pas lancée quand on clique dessus.

(Voir plus bas pour une gestion complète d'une boîte de dialogue)


### Boîte de dialogue qui affiche une liste ###

ex : Affiche une boîte de dialogue qui demande de sélectionner un prénom.  
(ATTENTION! la réponse est un objet liste)

```applescript
set mesPrenoms to {"Robin", "Hugo", "Quentin", "Léo", "Jules"}
set prenom to choose from list mesPrenoms
```


### Boîte de dialogue qui récupère une liste ###
    
 ```applescript
display dialog ("Taper une liste de noms séparés par des virgules") ¬
default answer ("ex: reponse1, reponse2, reponse3") ¬
with icon 1 ¬
buttons {"Annuler", "OK"} ¬
default button "OK"
```

(Voir plus bas comment transformer une chaîne de mots séparés par des virgules en liste.)


### Boîte de dialogue qui demande une valeur ###

```applescript
set retour to ""
set reponse to missing value
try
    set reponse to display dialog ("Entrer le lieu de départ de l'itinéraire") ¬
        default answer ("Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France") ¬
        buttons {"Annuler", "Valider"} ¬
        default button 2 ¬
        cancel button ("Annuler") ¬
        with icon caution ¬
        with title ("OT")
    set retour to text returned of reponse
on error errStr number errorNumber
    display alert errStr & " (" & errorNumber & ")"
end try
return retour
```

*NOTE : On utilise les parenthèses autour des chaînes de caractères pour garder le formatage du code.*


### Boîte de dialogue OK/Annuler dans une fonction ###

```applescript
-- set reponse to fenetreQuestion("Où habitez-vous?", "Les Angles", 300)
set reponse to fenetreQuestion("Voulez-vous continuer?", "", 300)

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
{button returned: "OK", gave up:false} pour une question,
{button returned:"OK", text returned:"Les Angles", gave up:false} pour une
demande de réponse texte.

*)
on fenetreQuestion(question, reponseProposee, attente)
    local reponse
    set reponse to missing value
    try
        if reponseProposee is equal to "" then
            set reponse to display dialog question ¬
                with icon caution ¬
                with title "Facture" giving up after attente
        else
            set reponse to display dialog question ¬
                default answer reponseProposee ¬
                with icon caution ¬
                with title "Facture" giving up after attente
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
end fenetreQuestion
```

- Code bien formatée
- se ferme automatiquement au bout de 5 minutes (= 300 secondes)
- Gère le cas où l'utilisateur clique sur "Annuler" (exception)

---

## Fichiers/Dossiers ##

### Procédure ###

[Documentation Apple](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ReferenceFilesandFolders.html#//apple_ref/doc/uid/TP40016239-CH34-SW1)

Pour manipuler les Fichiers/Dossiers, il faut :

1. Créer un alias :

```applescript
set monFichierAlias to "Macintosh HD:Users:bruno:Desktop:test.txt" as alias
-- ou
set monFichierAlias to (POSIX file "/Users/bruno/Desktop/test.txt") as alias
```

2. Utiliser l'application "Finder"

*NOTE : l'application "Finder" ne reconnaît pas l'objet `POSIX file`.*

```applescript
tell application "Finder"
-- Manipulation de fichiers/dossiers
end tell
```


### Lister le contenu d'un dossier ###

**Pour récupérer les fichiers :**
```applescript
tell application "Finder"
    set tousLesFichiers to every file of folder aliasDossierFactures
    repeat with unFichier in tousLesFichiers
        get name of unFichier
    end repeat
end tell
```

**Pour récupérer les dossiers :**
```applescript
tell application "Finder"
    set tousLesDossiers to every folder of folder "Desktop" of home
    repeat with unDossier in tousLesDossiers
        set nomDossier to the name of unDossier
    end repeat
end tell
```


### Récupérer les informations d'un fichier/Dossier ###

**Hors de l'objet application Finder :**

```applescript
get info for monFichierAlias -- ou : get info for monFichierPOSIX
```

**Dans l'objet application Finder :**
```applescript
tell application "Finder"
    get properties of monFichierAlias --> container, name, name extension, etc...
    -- ou
    get properties of file "log.txt" of folder "Desktop" of home
end tell
```

### Récupérer le dossier contenant le script ###

```applescript
tell application "Finder" to set dossierParent to container of (path to me)
```

NOTE: `container` appartient à **Finder**, `path to` appartient aux **Standard Additions**


### Créer une variable fichier ###

**Hors de l'objet application Finder => un alias :**

*ATTENTION ! Un alias doit obligatoirement pointer sur un fichier/dossier existant (contrairement à un fichier POSIX).*

```applescript
set monFichierAlias to alias "Macintosh HD:Users:bruno:Desktop:test.txt"
set monFichierAlias to "Macintosh HD:Users:bruno:Desktop:test.txt" as alias
--> alias "Macintosh HD:Users:bruno:Desktop:test.txt"
-- ou
set monFichierAlias to (POSIX file "/Users/bruno/Desktop/test.txt") as alias
set monFichierAlias to ("/Users/bruno/Desktop/test.txt" as POSIX file) as alias
--> alias "Macintosh HD:Users:bruno:Desktop:test.txt"
```

**Dans l'objet application Finder => alias ou file ou folder :**

L'objet application Finder peut utiliser indifféremment un alias ou un objet file/foler.

```applescript
tell application "Finder"
    -- Fichier à partir d'un chemin mac
    set monFichier to file "Macintosh HD:Users:bruno:Desktop:log.txt"
    --> document file "log.txt" of folder "Desktop" of folder "bruno" of folder "Users" of startup disk
    class of monFichier
    --> document file
    -- Fichier à partir d'un alias
    set monFichier to file aliasFichierLog
    --> document file "log.txt" of folder "Desktop" of folder "bruno" of folder "Users" of startup disk
    class of monFichier
    --> document file
    -- Fichier à partir d'un chemin POSIX
    set monFichier to file (POSIX file "/Users/bruno/Desktop/log.txt")
    --> document file "log.txt" of folder "Desktop" of folder "bruno" of folder "Users" of startup disk
    class of monFichier
    --> document file
    --
    set monFichier to file "log.txt" of folder "Desktop" of home
    --> document file "log.txt" of folder "Desktop" of folder "bruno" of folder "Users" of startup disk
    class of monFichier
    --> document file
    -- Dossier à partir d'un alias
    set monDossier to folder aliasDossierFactures
    --> folder "Factures" of folder "binfoservice" of folder "Documents" of folder "bruno" of folder "Users" of startup disk
    class of monDossier --> folder
end tell
```


### Créer un fichier (dans Finder) ###

```applescript
tell application "Finder"
    set nouveauFichier to make new file at desktop with properties {name:"coucou.txt", extension hidden:false,comment:"créé par AppleScript"} --> (Document file)
end tell
```


### Passer de alias à POSIX et inversement ###

```applescript
set monFichierAlias to "Macintosh HD:Users:bruno:Desktop:16 Bit installer:" as alias --> alias "Macintosh HD:Users:bruno:Desktop:16 Bit installer:"
class of monFichierAlias --> alias

set p to POSIX path of monFichierAlias --> "/Users/bruno/Desktop/16 Bit installer/"
class of p --> text
set monFichierPOSIX to (POSIX file p) --> file "Macintosh HD:Users:bruno:Desktop:16 Bit installer:"
class of monFichierPOSIX --> «class furl»
```

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

### Taper au clavier ###

Pour simuler la frappe d'une touche du clavier on utilise les fonctions `keystroke` ou `key code`.

exemples :

```applescript
keystroke "Bonjour tout le monde !" -- tape cette phrase
keystroke "g" using {command down, shift down} -- tape le raccourci ⌘ ⇧ G
key code 123 using option down -- flêche gauche avec Alt
key code 51 -- retour arrière
```

**constantes keystroke** : `return`, `tab`, `space`

**codes clavier utiles** : 

- flêche gauche : 123
- flêche droite : 124
- flêche bas : 125
- flêche haut : 126
- début : 115
- fin : 119
- retour arrière : 51
- échappe : 53


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


## Erreurs AppleScript ##

- erreur -1708 : Si on ne mets pas `cancel button "Annuler"`` on obtient "error -1708"

## Bugs Applescript ##

Dans Sierra, il est impossible de lire ou de modifier une signature de Mail. Il faut utiliser le code suivant :

```applescript

set theSignatureName to "Signature n°2"
try
        set message signature of new_message to signature theSignatureName
        
    on error --BUG SIERRA 
        
        tell application "Mail" to activate
        tell application "System Events"
            tell process "Mail"
                click pop up button 2 of window 1
                delay 0.5
                keystroke {down} --put here the first letter of the name of your signature 
                delay 0.5
                keystroke {down} --put here the first letter of the name of your signature 
                delay 0.5
                keystroke return
                delay 0.1
            end tell
        end tell
        
        
    end try
```