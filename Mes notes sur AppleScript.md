# Mes notes sur AppleScript


## L' « Éditeur de script »

- Avant OS X 10.9 il s'appelait :  « Éditeur AppleScript »
- situé dans "/Applications/Utilitaires"
- penser à enregistrer les scripts au format texte (extension .applescript)
- ⌥ ↩ pour continuer une instruction à la ligne
- touche F5 ou esc : terminaison des mots quand on programme en applescript ("Utiliser l'Assistant Script" doit être coché dans les Préférences | Général)
- "Afficher le menu des scripts dans la barre de menu" dans "Préférences | Général"
- Les fichiers scripts .app peuvent être ouvert en les glissant sur l'appli Editeur de scripts SEULEMENT si ce ne sont pas de purs exécutables
- (**Avant Snow leopard 10.6**) Par défaut l'enregistrement d'un script en tant qu'application, crée une application PowerPC. Pour créer une application Universal Binary, il faut sauvegarder en tant que Progiciel.
- Pour associer un script à un raccourci clavier :
    + [Spark](http://www.shadowlab.org/Software/spark.php?lang=fr)
    + [FastScripts](http://www.red-sweater.com/fastscripts/index.html)
- Pour connaître les éléments d'une fenêtre et faire de la programmation d'interface (GUI scripting) :
    + [Prefab UI Browser 40.20 EUR](http://prefabsoftware.com/uibrowser/)


## Exemples de scripts

Des scripts exemples se trouvent dans le dossier : "/Library/Scripts" . Notamment le dossier "Mail Scripts" pour l'envoi de mail, mais aussi le dossier "Script Editor Scripts" pour la comparaison de chaîne de caractères, etc …


## Mise au point du code

Pour afficher la valeur de variables ou savoir où on se trouve dans le code, on peut utiliser les fonctions suivantes:

```applescript
set maVariable to 3.6
display alert "La valeur de ma variable est : " & maVariable
--> Affiche une boîte de dialogue avec un bouton "OK".

log "La valeur de ma variable est : " & maVariable
--> Écrit dans le panneau "Événements" de la fenêtre de l'« Éditeur de script »

say "La valeur de ma variable est : " & maVariable
--> Utilise le synthétiseur de voix pour dire la phrase

beep
--> Émet un bip
```

## Connaître le dictionnaire d'une application

- Tirer l'icône de l'application sur l'icône de l'« Éditeur de script »
- Fichier > Ouvrir un dictionnaire… et choisir l'application


## AppleScript dans Automator

La fonction principale d'un Applescript dans Automator est :

```applescript
on run {input, parameters}
end run
```

où 

- `input`: la liste des éléments passés en paramètres (une liste d'alias)
- `paramètres`: des paramètres de l'action (rarement utilisé)

*NOTE: Pour connaître le contenu de `input` et `parameters`, il faut faire un `return input` ou un `return parameters`. Pour lire le résultat, il faut faire apparaître le volet résultat qui se trouve entre le volet source et les boutons "Résultats Options Description".* 

Pour passer en revue tous les éléments de `input, on fait :

```applescript    
repeat with i in input
    display dialog i as text
    -- action sur l'élément
end repeat
```

## Lancer une boîte dialogue depuis le shell

    $ osascript -e 'tell app "System Events" to display dialog "Une boîte de dialogue avec 1 bouton OK et un bouton Annuler."'

Affiche une boîte de dialogue et renvoi le nom du bouton cliqué ou une erreur si on a cliqué sur le bouton **Annuler**.
Le code de retour est 0 si on a cliqué sur **OK**. Sinon, on a cliqué sur **Annuler**

[source](http://docwhat.gerf.org/2008/04/mac-shell-dialogs/)


## Lancer un applescript depuis un autre applescript

```applescript
set fichierScript to choose file
run script fichierScript
```

## Lancer un applescript depuis le Terminal

    # Un script
    $ osascript test.applescript

Si le applescript doit recevoir des paramètres, on utilisera la forme :

```applescript
on run {param1, param2}
end run
```

Si le applescript doit afficher une boîte de dialogue, on utilisera la forme :

```applescript
tell application "System Events"
    display dialog "Coucou!"
end tell
```

## Manipuler des images avec AppleScript

Il faut utiliser le gestionnaire "Image Events".
source : <http://www.macosxautomation.com/applescript/imageevents/01.html>

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


## Création de classes/Libraries ##

Le but est de créer des classes réutilisables dans ses projets. Pour cela, il suffit de créer un script : ses propriétés sont les membres de la classe, ses handlers sont les méthodes de la classe. Il suffit de sauvegarder son fichier en tant que script (.scpt) dans un dossier **Script Libraries** situé dans un des dossiers suivants : ~/Library/, /Library, dossier Resources d'une applet ou d'une application.

### 1°) On écrit une classe script ###

```applescript
property volumeEnCl : 24.7
property volumeMAX : 75.0
on remplitBouteille(volumeEnClAAJouter)
    set volumeEnCl to volumeEnCl + volumeEnClAAJouter
    if volumeEnCl is greater than volumeMAX then set volumeEnCl to volumeMAX
end remplitBouteille

on verseBouteille(volumeEnClAEnlever)
    set volumeEnCl to volumeEnCl - volumeEnClAEnlever
    if volumeEnCl is less than 0 then set volumeEnCl to 0
end verseBouteille

on videBouteille()
    set volumeEnCl to 0
end videBouteille
```

### 2°) On enregistre au format script (.scpt) ###

**Fichier** > **Enregistrer...**

1. Donnez un nom à votre script (ex: Bouteille) dans le champ **Enregistrer sous :**
2. Sélectionner le dossier **~/Library** et créez (si besoin) le dossier **Script Libraries**
2. Dans **Format de fichier :**, sélectionnez **Script**
3. Aucune option n'est cochée
4. Cliquez sur le bouton **Enregistrer** pour enregistrer votre script dans le dossier **Script Libraries**

### 3°) Utilisation de la classe/Library ###

```applescript
tell script "Bouteille"
    get volumeEnCl of it
    remplitBouteille(15.5)
    log volumeEnCl of it
    videBouteille()
    log volumeEnCl of it
end tell
```


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


## Application Mail ##

- Un expéditeur (sender) doit avoir le format suivant : `"Bruno Boissonnet <bruno@binfoservice.fr>"`
- BUG SIERRA: L'ajout d'une signature quand on crée un `Outgoing message` ne fonctionne pas => Il faut utiliser le GUI scripting (j'ai créé une fonction **ajouteSignatureDansMail**) [source](https://macscripter.net/viewtopic.php?pid=188442)

## ASObjC ##

### POSIX file

On ne peut pas utiliser la syntaxe `POSIX file toto` car elle n'est pas reconnue. Il faut procéder de la manière suivante :

```applescript
set aliasFichierLog to ((cheminPOSIXFichierLog as POSIX file) as alias)
-- ou
tell current application to set aliasFichierLog to ((POSIX file cheminPOSIXFichierLog) as alias)
```

## Coloration syntaxique AppleScript dans HTML ##

Pour obtenir la coloration syntaxique AppleScript dans une page HTML, voici la procédure : 

1. Sélectionnez votre code dans l' « Éditeur de script »
2. Copiez-le (Cmd C)
3. Ouvrez TextEdit
4. Copiez votre code à l'intérieur (Cmd V)
5. Enregistrez le fichier au format **Page web (.html)** (ex : script1.html)
6. Copier le code dans une balise `<iframe>`:

        <iframe src="script1.html" width="600px" height="700px">
            <-- Contenu du fichier !-->
        </iframe>


## Bibliothèques ou outils supplémentaires

- [JSON Helper](https://itunes.apple.com/fr/app/json-helper-for-applescript/id453114608?mt=12) : JSON Helper is an agent (or scriptable background application) which allows you to do useful things with JSON (JavaScript Object Notation) directly from AppleScript.
- [Location Helper](https://itunes.apple.com/fr/app/location-helper-for-applescript/id488536386?mt=12) : Location Helper is an agent which allows you to access the functionality of Core Location from AppleScript.
- [Smile companion osax](http://www.satimage.fr/software/en/downloads/downloads_companion_osaxen.html) : __Files osax 3.0__ contains some file utilities; __Satimage osax 3.7.0__ contains Text search-and-replace commands and regular expressions, scientific computing and folder synchronization.
- [AppleScript Toolbox](https://astoolbox.wordpress.com)


## Liens intéressants

- [Le langage AppleScript](http://developer.apple.com/library/mac/#documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html) 
- [AppleScript (Sub-Routines)](http://www.apple.com/applescript/sbrt/index.html)
- [AppleScript address book iCal](http://forum.macbidouille.com/index.php?showtopic=184799&hl=the_mailing_list)
- [Applescript Forums | MacScripter](http://bbs.macscripter.net/index.php)
- [Introduction to Scripting Address Book](http://www.mactech.com/articles/mactech/Vol.21/21.10/ScriptingAddressBook/index.html)