# progitfr.applescript #

## Description ##

Ce script permet de créer la documentation anglaise du livre Eloquent JavaScript de Marijn Haverbeke au format PDF à partir du site web <http://eloquentjavascript.net/>.


1. Ouvrir Safari et aller à l'adresse : <http://eloquentjavascript.net/>.
2. Lancer le script **eloquentjs.applescript**. 
3. Fusionner les fichiers PDF en un seul (le script ne le fait pas).


## Remarques ##

- Le script crée un dossier "eloquentjs" (au même endroit que le script) qui contient chaque page au format PDF.
- La dernière page n'est pas imprimée en PDF (il faut le faire à la main).
- Il ne restera qu'à fusionner les fichiers PDF obtenus en un seul fichier PDF
- testé sur Mac OS X 10.9


## Algorithme ##

1. Crée un dossier du nom du livre dans le même dossier que le script. (\*)
2. Ouvre Safari sur la première page de la version HTML du livre.
3. Recherche la présence d'un bouton "next" pour aller sur la page suivante.
4. S'il n'est pas présent, le script se termine.
5. S'il est présent :
    6. Récupère l'adresse de la page suivante dans la page web.
    7. Reformate la page web pour enlever ce qui n'a pas lieu d'être dans un fichier PDF.
    8. Imprime la page dans un fichier PDF numéroté (\*\*),dans le dossier du (1.).
    9. On ouvre la page suivante.
    10. On revient au point (3.) .

(\*) : le nom du dossier correspond à la variable `nomProjet` (voir plus bas).
(\*\*) : Le nom des fichiers est séquentiel et son format est le suivant : un nombre de 4 chiffres qui commence par des zéros (ex: 0001.PDF, 0002.PDF, 0342.PDF).



## Si on veut utiliser ce script avec un autre site ##

Ce script peut-être réutilisé avec succès sur d'autres sites de documentation qui possèdent le même fonctionnement, à savoir : une page de documentation (un chaptire, par exemple) avec un bouton "suivant", un bouton "précédent" et éventuellement un bouton "table des matières".

Cependant, il faudra l'adapter au site en modifiant :

1. Les variables suivantes :

    + nomProjet : correspond au nom du dossier à créer.
    + siteWeb : l'adresse de la version HTML du livre
    + premierePage : l'adresse de la première page du livre HTML


2. Les fonctions javascript suivantes :

    + jsBoutonNextAbsent : code JavaScript qui recherche une balise `<a>` avec un attribut particulier et qui renvoie true si le bouton "next" n'a pas été trouvé, false sinon. 
    + jsGetNextPageUrl : code JavaScript qui renvoie l'URL de la page suivante en recherchant la même balise `<a>` et en lisant sa propriété `href`.
    + jsFormatWebPage : code JavaScript qui supprime de la page tout ce qu'on ne veut pas retrouver dans le fichier PDF (en utilisant `style.display = 'none'`) ou en affichant du texte caché par défaut.


*NOTE: si la modification des variables ne posera pas de problème, la modification des fonctions javascript sera, elle, un peu plus difficile et demandera de s'inspirer de ce qui existe déjà dans le script afin de l'adapter au nouveau site (je prévois, un jour, de créer des fonctions javascript plus génériques plutôt que ce code très spécifique).*
