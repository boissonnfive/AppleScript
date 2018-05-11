# Applescript

![Applescript](applescript.png)

[AppleScript Language Guide](https://developer.apple.com/library/content/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html)
[Mac Automation Scripting Guide](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/AutomatetheUserInterface.html#//apple_ref/doc/uid/TP40016239-CH69-SW1)

## Le langage

### Les instructions

- une instruction tient sur une ligne
- toute instruction retourne un résultat
- le résultat d'une instruction est stockée dans la propriété globale `result`
- un bloc d'instructions tient sur plusieurs lignes et se termine par le mot "end"
- une instruction se compose de mots clés, d'opérateur et de noms de variables
- les caractères blancs (espace, tabulation, saut de ligne) sont ignorés.

### Le caractère de continuation

⌥ ↩ pour continuer une instruction à la ligne

```applescript
display dialog "This is just a test." buttons {"Great", "OK"} ¬
default button "OK" giving up after 3
```

### Les commentaires

Un commentaire est une ligne de code qui est ignorée. Cela permet d'insérer dans le code des informations qui permettront de le rendre plus compréhensible. Cela permet aussi d'ignorer des instructions.

```applescript
-- Affiche une boîte de dialogue qui dit "Coucou!"
display dialog "coucou!"
(*
 Commentaires sur
 plusieurs
 lignes
*)
-- commentaire sur une ligne
\# commentaire sur une ligne
```

Les commentaires peuvent s'encapsuler et peuvent être ajoutés à la fin d'une ligne de code.
	

### Les types

Ce sont en fait des classes.

`boolean`, `constant`, `text`, `number` (`integer`, `real`), `list` et `record`.


### Les variables

- elles suivent les règles de nommage des identifiants (voir [1])
- elles peuvent être créées et initialisées avec set et copy
- une variable n'a pas de type associé

        set myName to "John"
        copy 33 to myAge

- les propriétés : `property propertyLabel : expression`
      + portée globale à tout le script
- les variables locales : `local variableName [, variableName ]`
      + on ne peut leur donner une valeur ou une classe lors de la déclaration
      + par défaut, une variable définie dans une action est locale
      + la portée d'une variable locale est l'action run ou l'action dans laquelle elle est déclarée
- les variables globales : global variableName [, variableName ].
      + on ne peut leur donner une valeur ou une classe lors de la déclaration
      + portée globale à tout le script
      + doit être initialisée sinon erreur
      + si on veut utiliser une variable globale dans une action, il faut faire une déclaration (ex: global ma_variable)

```applescript
-- variable propriété
property nomDuScript "script de test"

-- variable locale
local bubu, bobo, baba -- la portée sera le script entier, cad la fonction run implicite

-- variable globale
global toto, tutu, tata -- la portée sera le script entier
```

[1]: #id

#### Les nombres ####

- number   : tout les types nombre
- entier   : integer
- décimaux : real

#### Les chaînes ####

- entourées par des guillemets
- concaténation : &
- longueur        : length of
- guillemets  : à échapper avec \ (\") ou """
- caractère spéciaux : \n, \t, \r
- chaîne vers liste de caractères : every character of chaine
- chaîne vers liste de mots : every word of chaine
- chaine vers liste de lignes : every paragraph of chaine
- text item delimiters : déliminteur permettant de transformer une chaîne en liste (à modifier si nécessaire)

#### Listes ####

item 1, item 2, ...
first (1st), second (2nd), ... tenth (10th)
last : dernier élément de la liste

item -1 <=> last
item -2 <=> avant dernier
etc ...

items 2 through 5 of liste : sous-liste 
items 5 through 2 of liste : même chose
reverse of liste : inverse l'ordre de la liste
taille de la liste : length ou count
some item of liste : élément au hasard

#### Coercitions ####

- chaîne vers liste : every character of chaine
- liste vers chaine : chaine as list

*ATTENTION ! La coercition dépend du paramètre "text item delimiters".*
 
 
#### Enregistrements ####

C'est une liste de propriétés => accolades {} et virgules entre les propriétés
Chaque propriété possède deux parties séparées par le symbole deux-point :
- une étiquette/nom
- une valeur

=> {nom1:val1,nom2:val2...,nom10:val10}

ex : {hauteur: 10.0, largeur: 15.0}

Taille de l'enregistrement : count of varRecord


### Les structures de contrôle

#### Les conditions

```applescript
set x to 3
if x > 10 then
    log "x est supérieur à 10"
else if x = 10 then
    log "x est égal à 10"
else
    log "x est strictement inférieur à 10"
end if
```

**Les opérateurs de comparaison booléens**

and, or, not, &, =, and ≠
is equal to, is not equal to, equals, and so on

#### Les boucles

```applescript
set noms to {"bruno", "marine", "marc"}
repeat with i in noms
   log i
end repeat
```
```applescript
repeat with i from 1 to count of noms
   log "nom n°" & i & ": " & item i of noms
end repeat
```
```applescript
set rep_non to false
repeat while (rep_non is false)
	set reponse to display dialog "On continue?" buttons {"Non", "Oui"} default button 2
	if button returned of reponse is "Non" then
		set rep_non to true
	end if
end repeat
```

*NOTE: pour sortir d'une boucle `exit repeat`*

#### La gestion des erreurs

```applescript
set x to 4
set y to 0
try
   x/y
on error
   log "Division impossible par 0"
end try
```	



### Les Objets

- En applescript tout est objet
- Un script est donc un objet
- Un objet possède des propriétés et des méthodes/actions/commandes
- Un script a toujours une méthode `run`. Elle peut être explicite ou implicite (le script se compose alors d'une suite de commandes)
- Un script a toujours une propriété `parent`
- Un objet peut être converti en un autre objet (cf tableau) par l'opérateur "as" ou automatiquement lors d'une opération

```applescript
script monObjet
    property maProp : "Bruno"
    on bonjour()
        display alert "Bonjour " & maProp
    end bonjour
    display alert "Méthode run lancée"
end script

set maProp of monObjet to "Marc"
tell monObjet to bonjour() --result: "Bonjour Marc"
run of monObjet --result: "Méthode run lancée"
display alert (name of (parent of monObjet) as string) --result: "Script Editor"
```

### Héritage

- Si un script est l'enfant d'un autre script, la définition du parent doit précéder celle de l'enfant
- Pour hériter d'un script, il faut donner à sa propriété parent le nom du script
- Pour utiliser une propriété d'un parent, on utilise `my prop_`
- Pour appeler la fonction d'un parent, on utilise `continue fonction`

### Les méthodes

- une méthode qui n'a pas de paramètres doit avoir des parenthèses
- une méthode peut avoir une étiquette de variable (le `the` n'est pas pris en compte)
- on utilise les parenthèses pour les paramètres qui doivent être passés selon l'ordre de la définition de la méthode
- on utilise aussi les parenthèses lorsque l'on veut définir les types des paramètres
- une méthode peut être récursive (mais se pose le problème de l'occupation mémoire)

```applescript
to findNumbers of numberList above minLimit given rounding:roundBoolean
    set resultList to {}
    repeat with i from 1 to (count items of numberList)
        set x to item i of numberList
        if roundBoolean then -- round the number
            -- Use copy so original list isn’t modified.
            copy (round x) to x
        end if
        if x > minLimit then
            set end of resultList to x
        end if
    end repeat
    return resultList
end findNumbers

set myList to {2, 5, 19.75, 99, 1}
findNumbers of myList above 19 given rounding:true
--result: {20, 99}
findNumbers of myList above 19 given rounding:false
--result: {19.75, 99}
```

```applescript
on hello(a, b, {length:l, bounds:{x, y, w, h}, name:n})
    set q to a   b
    set response to "Hello" & n & ",you are" & l & ¬
    "inches tall and occupy position (" & x & "," & y & ")."
    display dialog response
end hello
set thing to {bounds:{1, 2, 4, 5}, name:"George", length:72}
hello (2,  3, thing)
--result: A dialog displaying "Hello George, you are 72 inches tall
-- and occupy position (1,2)."
```

### Les mots clés it and me

- `me` fait référence au script en cours (of me = my)
- `it` fait référence à la cible en cours ou sinon vaut me (of it = its)

On les utilise pour différencier les actions et propriétés du script et de la cible (ex: my superFonction(param) dans un bloc tell permet d'appeler la fonction du script et pas de la cible du tell).

### Les Abbréviations

- app  <= application
- thru <= throuh


* * *

## Manipuler des dates

- propriétés : day, weekday, month, year, time, date string/short date string, time string
- Operateurs : &,  , –, =, ≠, >, ≥, <, ≤, comes before, comes after, and as
- constantes : minutes, hours, days, weeks


### Récupérer la date

```applescript
set dateDuJour to current date -- ou date string of (current date)
--> resultat : date "mardi 1 novembre 2011 14:08:39"
short date string of dateDuJour
--> resultat : date "01/11/2011"
set {year:y, month:m, day:d, hours:h, minutes:min} to (current date)
set todayDate to (d & "-" & (m as integer) & "-" & y & "-" & h & "-" & min) as string

time string of (dateDuJour)                 --> heures:minutes:secondes
weekday of (dateDuJour) as text             --> jour
month of (dateDuJour)                       --> mois
year of (dateDuJour)                        --> année
(time of (dateDuJour)) div 3600             --> heure
((time of (dateDuJour)) mod 3600) div 60    --> minutes
(time of (dateDuJour)) mod 60               --> secondes
```
 
### Créer une date

```applescript
set ma_date to date "01/11/2011"
--> resultat : "mardi 1 novembre 2011 00:00:00"
set ma_date to date "mardi 1 novembre 2011 00:00:00"
--> resultat : "mardi 1 novembre 2011 00:00:00"
```

### Ajouter du temps à une date

```applescript
set myDate to (current date)   (4 * days   3 * hours   2 * minutes) - (1 * days   5 * hours   31 * minutes)
-- resultat : current date => date "mardi 1 novembre 2011 14:08:39"
-- resultat : date "vendredi 4 novembre 2011 11:39:39"
```

### Mesurer un temps

```applescript
set t to (time of (current date)) -- début
-- instructions ...
set total to (time of (current date)) - t -- fin
```

### Récupérer la date en français

```applescript
set mon_instant to current date
set en_francais to mon_instant as string
set mon_jour_semaine_fr to 1st word of en_francais
set mon_jour_fr to 2nd word of en_francais
set mon_mois_fr to 3rd word of en_francais
set mon_annee_fr to 4th word of en_francais
set mon_heure_fr to 6th word of en_francais
set ma_minute_fr to 7th word of en_francais
set ma_seconde_fr to 8th word of en_francais

set ma_date_fr to ""
set ma_date_fr to ma_date_fr & "Jour de la semaine : " & mon_jour_semaine_fr & return
set ma_date_fr to ma_date_fr & "Jour du mois : " & mon_jour_fr & return
set ma_date_fr to ma_date_fr & "Mois : " & mon_mois_fr & return
set ma_date_fr to ma_date_fr & "Année : " & mon_annee_fr & return
set ma_date_fr to ma_date_fr & "Heures : " & mon_heure_fr & return
set ma_date_fr to ma_date_fr & "Minutes : " & ma_minute_fr & return
set ma_date_fr to ma_date_fr & "Secondes : " & ma_seconde_fr

display alert ma_date_fr
```


## Manipuler des listes

###  Le type list

- propriétés : class, length, rest, reverse
- éléments : item
- Opérateurs : &, =, ≠, starts with, ends with, contains, is contained by.
- commandes : count
- On ne peut enlever un élément d'une liste

### Créer une liste

```applescript
set myList to {"Bruno", 12.4, "01/11/2011"}
```

### Récupérer un ou des éléments d'un liste

```applescript
item 3 of {"this", "is", "a", "list"} --> "a"
items 2 thru 3 of {"soup", 2, "nuts"} --> {2, "nuts"}
```

### Compter le nombre d'éléments

```applescript
count {"a", "b", "c", 1, 2, 3} --result: 6
length of {"a", "b", "c", 1, 2, 3} --result: 6
```

### Ajouter un élément à une liste

```applescript
{"This"} & {"is", "a", "list"} --> {"This", "is", "a", "list"}
set myList to {1, "what", 3} --> {1, "what", 3}
set beginning of myList to 0
set end of myList to "four"
myList --> {0, 1, "what", 3, "four"}
```

## Manipuler des enregistrements

### Le type record

- propriétés : class, length
- Opérateurs : &, =, ≠, contains, and is contained by
- commandes : count

### Créer une variable record

```applescript
set myRecord to {product:"pen", price:2.34}
```

### Récupérer une valeur d'un record

```applescript
product of myRecord
price of myRecord
```

### Modifier une valeur d'un record

```applescript
set product of myRecord to "pencil"
```

### Compter le nombre de propriétés dans un record

```applescript
length of {name:"Chris", mileage:1957, city:"Kalamazoo"} --> 3
count of {name:"Chris", mileage:1957, city:"Kalamazoo"}  --> 3
```

### Mauvaise manière de récupérer une valeur d'un record

```applescript
item 2 of {product:"pen", price:2.34}
```


## Manipuler du texte

### Les types textes

- Il existe 3 classes pour le texte
      text
      string
      Unicode text
- Ces 3 classes sont identiques
- Le type text est immuable

### Les caractères à échapper

- l'anti-slash  ( \ ) : \\
- les guillemets ( " ) : \" ou quote

### Les constantes

    Nom             Constant        Value
    espace          space           " "
    tabulation      tab             "\t"
    fin de ligne    return          "\r"
    saut de ligne   linefeed        "\n"

### Concaténer du texte

```applescript
set ma_phase to "un debut" & " et " & "une fin" --> "un début et une fin"
```

### Retrouver une partie d'un texte

### Extraire une partie d'un texte


## Les expressions régulières ##

AppleScript ne permet pas de manipuler des expressions régulières. Il y a donc 3 possibilité :

- utiliser un composant osax : [Satimage osax](http://www.satimage.fr/software/en/downloads/downloads_companion_osaxen.html)
- utiliser un outil de ligne de commande : sed, grep, awk, etc ...
- coder en applescript la recher du patron

* * *

## AppleScript dans Mac OS X ##

Dans Mac OS X, l'applescript permet de manipuler des applications, des fenêtres, le système, des bases de données suivant le dictionnaire de chacun.

La première étape consiste donc à consulter le dictionnaire de l'application que l'on veut utiliser.

### Exemple 1: TextEdit

Le dictionnaire contient:

- Standard Suite
- Text Suite
- TextEdit Suite
- Type Definition

#### TextEdit Suite

	application n [see also Standard Suite] : TextEdit's top level scripting object.
	ELEMENTS
	contains documents.

Le tout premier objet de TextEdit est l'application elle-même, c'est-à-dire l'objet `application`. Pour utiliser un objet AppleScript, on procède de la sorte:

```applescript
tell application "TextEdit"
end tell
```

Entre les bornes du bloc tell, on pourra manipuler tous les objets contenus par l'application TextEdit. D'ailleurs, d'après sa définition, l'objet application contient des objet de la classe `documents`. Par convention, on met un "s" à la fin d'une classe quand il s'agit d'une collection (liste) de cette classe. Nous avons donc affaire à une liste d'objets de la classe `document`. Il est logique de parcourir le dictionnaire pour voir la définition de `document`.

	document n [inh. item; see also TextEdit suite] : A document.
	ELEMENTS
	contained by application, application.
	PROPERTIES
	modified (boolean, r/o) : Has the document been modified since the last save?
	name (text) : The document's name.
	path (text) : The document's path.

Traduction: un document est un objet héritant de la classe `item`, contenu par une application et qui possède les propriétés suivantes: un nom (name, de la classe `text`), un chemin (path, de la classe `text`) et un statut modifié ou non (modified, de la classe `boolean`, en lecture seulement).

Une première utilisation, pourrait être de lister les documents contenus par l'application TextEdit et d'afficher pour chacun son nom, son chemin et son statut.

```applescript
tell application "TextEdit"
    repeat with doc in documents
        tell doc to display alert "Nom du document : " & name & return ¬
            & "Chemin du document : " & path & return ¬
            & "Document modifié depuis la dernière sauvegarde : " & modified
    end repeat
end tell
```

(On notera la conversion implicite de `boolean` à `text`.)

Si nous revenons à la définition de l'objet `application` de la suite "TextEdit Suite", nous voyons un renvoi vers la suite "Standard Suite". Voici la définition de l'objet `application` dans cette suite:

	application n [inh. item; see also TextEdit suite] : An application's top level scripting object.
	ELEMENTS
	contains documents, windows.
	PROPERTIES
	frontmost (boolean, r/o) : Is this the frontmost (active) application?
	name (text, r/o) : The name of the application.
	version (text, r/o) : The version of the application.

Un objet `application`, en général (car la suite "Standard Suite" est valable pour tous les dictionnaires d'application), contient des collections de `document` et de `window`. Ses propriétés sont : un nom (`name`, de la classe `text`, en lecture seule), une version (`version`, de la classe `text`, en lecture seule), et un statut active ou non (`frontmost`, de la classe `boolean`, en lecture seule).

Ainsi, on pourrait manipuler l'objet application TextEdit de la façon suivante:

```applescript
tell application "TextEdit"
	display alert "Nom de l'application: " & name & return ¬
		& "Version: " & version & return ¬
		& "Active: " & frontmost
end tell
```

De même, nous n'avons regardé que la définition de la classe `document` de la suite "Standard Suite". La suite "TextEdit Suite" ajoute une propriété à la classe document: le texte contenu dans le document (`text`, de la classe `text`).

Attention ! Il est important de signaler que la classe `text` dont il est fait référence ici, n'est pas la classe synonyme de la classe `string`. Il s'agit de la classe dont la définition est:

	text n [inh. item] : Rich (styled) text
	ELEMENTS
	contains attachments, attribute runs, characters, paragraphs, words.
	PROPERTIES
	color (color) : The color of the first character.
	font (text) : The name of the font of the first character.
	size (integer) : The size in points of the first character.

On pourra manipuler un objet de cette classe en créant un document dans TextEdit et en y collant un texte de son cru, puis en lançant le script suivant:

```applescript
```


* * *

## Références

### Les identifiants

Les identifiants permettent de nommer des variables, des classes, des propriétés, des actions.

Un identifiant doit commencer par une lettre et peut contenir les caractères suivants :
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_

Les identifiants ne sont pas sensibles à la casse (myvariable = MyVariable)

Un identifiant ne peut être identique à un mot clé (middle est interdit car c'est un mot clé)

### Liste des mots clés

about, above, after, against, and, apart from, around, as, aside from, at, back, before, beginning, behind, below, beneath, beside, between, but, by, considering, contain, contains, contains, continue, copy, div, does, eighth, else, end, equal, equals, error, every, exit, false, fifth, first, for, fourth, from, front, get, given, global, if, ignoring, in, instead of, into, is, it, its, last, local, me, middle, mod, my, ninth, not, of, on, onto, or, out of, over, prop, property, put, ref, reference, repeat, return, returning, script, second, set, seventh, since, sixth, some, tell, tenth, that, the, then, third, through, thru, timeout, times, to, transaction, true, try, until, where, while, whose, with, without.

### Liste des constantes globales

pi, result, Text Constants, text item delimiters, version, current application Constant, missing value Constant, true, false.


* * *


* * *

## Divers

### Les types des scripts

- text (.applescript) : mon format préféré car facile à archiver
- script compilé (.scpt) : format standard des scripts et des bibliothèques de scripts
- Paquets de script (.scptd) : format pour les bibliothèques de scripts
- application (.app) : format pour les applications
      + Écran de démarrage : affiche au démarrage ce qu'on a écrit dans le panneau "Description" de l'Éditeur AppleScript
      + Rester en arrière-plan : pour les applications qui gèrent la méthode `idle`

### Applescript dans un fichier bash

Il est possible de créer des scripts shell en applescript en commençant le fichier par :

    #!/usr/bin/osascript


* * *

## A approfondir

- La possibilité d'appeler un script dans un autre apple script, c'est parce-qu'un script est un objet. C'est comme ça qu'on peut créer un objet. Et c'est à ça que servent les propriétés d'un script.
- Tout script est un objet avec une fonction implicite run. Ainsi, on appelle un objet script avec un tell
- la notion de portée des variables (globales, locales)

