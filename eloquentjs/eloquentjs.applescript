(*
Nom du fichier:	eloquentjs.applescript
Auteur:			Bruno Boissonnet
Date:			lundi 30 août 2015
Description:		Ce script transforme la verion HTML d'un livre en PDF.
Remarques:
				Ce script va parcourir toutes les pages de la version HTML, pour imprimer
				chaque page dans un fichier PDF enregistré dans un dossier, au même endroit 
				que le script.
				Algorithme :
				1. Créer un dossier du nom du livre dans le même dossier que le script.
				2. Ouvrir Safari sur la première page de la version HTML du livre.
				3. Rechercher la présence d'un bouton "next" pour aller sur la page suivante (avec du code JavaScript)
				4. S'il n'est pas présent, le script se termine.
				5. S'il est présent :
					6. On récupère l'adresse de la page suivante dans la page web (avec du code JavaScript)
					7. On reformate la page web (pour enlever ce qui n'a pas lieu d'être dans un fichier PDF) (avec du code JavaScript)
					8. On imprime la page dans le dossier du (1.)
					9. On ouvre la page suivante
					10. On revient au point (3.) 
				
				- Ce qu'il faut modifier pour utiliser ce script:
					+ nomProjet : correspond au nom du dossier à créer.
					+ siteWeb : l'adresse de la version HTML du livre
					+ premierePage : l'adresse de la première page du livre HTML
					+ jsBoutonNextAbsent : code JavaScript qui renvoie true si le bouton "next" n'a pas été trouvé, false sinon.
					+ jsGetNextPageUrl : code JavaScript qui renvoie l'URL de la page suivante
					+ jsFormatWebPage : code JavaScript qui supprime de la page tout ce qu'on ne veut pas retrouver dans le fichier PDF.
					
				- Nomenclature des fichiers PDF produits :  0001.PDF, 	0002.PDF, etc ...
				- Il ne restera qu'à fusionner les fichiers PDF obtenus en un seul fichier PDF
				- testé sur Mac OS X 10.9
*)

---------------------------------------------------------------------------
--                          Variables à modifier
---------------------------------------------------------------------------

property nomProjet : "eloquentjs"
property siteWeb : "http://eloquentjavascript.net"
property premierePage : "00_intro.html"



-- jsBoutonNextAbsent représente du code javascript
-- qui renvoie si oui ou non le bouton "next" est présent

property jsBoutonNextAbsent : "
				
// On recherche les <a> dans <nav>
// S'il y en a 3, c'est qu'il y a un bouton next
var my_nav = document.getElementsByTagName('nav');
var my_a_tags = my_nav[0].getElementsByTagName('a');

// Le bouton next est absent (true) s'il y a 3 <a>
// donc s'il n'y en a pas moins de 3
//!(my_a_tags.length < 3);


// On parcours tous les <a> de <na> pour trouver
// le 'next chapter'
var i=0;
var my_next_chapter_trouve = false;
for (i = 0; i < my_a_tags.length ; i++)
{
	if (my_a_tags[i].getAttribute('title') == 'next chapter')
	{
		my_next_chapter_trouve = true;
	}
}

!my_next_chapter_trouve;

"




-- jsGetNextPageUrl représente du code javascript
-- qui renvoie l'URL de la page suivante

property jsGetNextPageUrl : "
								
// On recherche les <a> dans <nav>
// S'il y en a 3, c'est qu'il y a un bouton next
var my_nav = document.getElementsByTagName('nav');
var my_a_tags = my_nav[0].getElementsByTagName('a');
				

// On parcours tous les <a> de <nav> pour trouver
// le 'next chapter'
var i=0;
var my_next_chapter_URL = '';
for (i = 0; i < my_a_tags.length ; i++)
{
	if (my_a_tags[i].getAttribute('title') == 'next chapter')
	{
		my_next_chapter_URL = my_a_tags[i].href;
	}
}
				
"

-- jsFormatWebPage représente du code javascript
-- qui supprime de la page ce qu'on ne veut pas retrouver
-- dans le fichier PDF.

property jsFormatWebPage : "
			
// Supprime le bandeau du haut
document.body.children[1].style.display = 'none';

// Supprime les boutons de navigation
var my_navs = document.getElementsByTagName('nav');
my_navs[0].style.display = 'none';
my_navs[1].style.display = 'none';

// Supprime le lien des solutions
var y = document.getElementsByClassName('solution');
var i = 0;
for (i=0; i < y.length ; i++)
{
	y[i].className = 'solution open';
}
		
"



---------------------------------------------------------------------------
--                            DÉBUT DU SCRIPT 
---------------------------------------------------------------------------


property compteur : 0 -- utilisé pour nommer les fichiers en séquence

-- 0. On récupère le chemin du script
-- 1. On crée un dossier "nom projet" dans le dossier du script
-- 2. On récupère le chemin POSIX complet du dossier "mon projet"
tell application "Finder"
	
	-- 0. On récupère le chemin du script
	set dossierScript to container of (path to me) as alias
	
	-- 1. On crée un dossier "nom projet" dans le dossier du script
	try
		set dossierProjet to make new folder with properties {name:nomProjet} at dossierScript
		
	on error
		tell application "System Events" to display alert "Impossible de créer le dossier: " & ¬
			nomProjet & return ¬
			& "Un dossier portant le même nom existe peut-être déjà." & return ¬
			& "Opération de création annulée."
		return
	end try
	
	-- 2. On récupère le chemin POSIX complet du dossier "mon projet"
	set dossierDestination to POSIX path of (dossierProjet as alias)
	log ("dossierDestination : " & dossierDestination)
	
end tell


-- On construit l'URL de la première page
set premierePageSite to siteWeb & "/" & premierePage
-- Ouvre Safari sur cette page
my goToWebPage(premierePageSite)

-- On active Safari
my activeApplication("Safari")


-- Tant qu'il existe un bouton "Next"
-- 1. On crée le nom du fichier (format 0001, 0010, 0100, etc ...)
-- 2. On récupère l'adresse de la prochaine page web
-- 3. On reformate la page Web pour ne garder que ce que l'on veut imprimer
-- 4. On imprime la page dans un PDF
-- 5. On passe à la page suivante
repeat while my existLinkNextPage()
	
	set compteur to compteur + 1
	-- 1. On crée le nom du fichier (format 0001, 0010, 0100, etc ...)
	set nom to formatNamefromCounter(compteur)
	log "Nom : " & nom
	
	-- 2. On récupère l'adresse de la prochaine page web
	set myNextPage to my getNextPageUrl()
	
	-- 3. On reformate la page Web pour ne garder que ce que l'on veut imprimer
	my formatWebPage()
	
	-- 4. On imprime la page dans un PDF
	my printPageWithNameInDirectory(nom, dossierDestination)
	
	-- On attend un peu que l'impression se termine
	delay 1.5
	
	-- 5. On passe à la page suivante
	my goToWebPage(myNextPage)
	
	-- On attend un peu que la nouvelle page se charge
	delay 2.5
	
end repeat

display dialog "Fin du script"


---------------------------------------------------------------------------
--                              FIN DU SCRIPT
---------------------------------------------------------------------------



---------------------------------------------------------------------------
--                              FONCTIONS 
---------------------------------------------------------------------------


---------------------------------------------------------------------------
--                              existLinkNextPage()  
---------------------------------------------------------------------------

-- Recherche dans le code de la page s'il y a un bouton "next"
-- Renvoie true s'il existe, false sinon.
-- Remarque : on considère que le bouton "next" existe
--                  si on trouve son parent "div#nav"
on existLinkNextPage()
	--set existe to false
	set boutonNextAbsent to false
	tell application "Safari"
		
		set bubu to document 1
		tell bubu
			if URL of bubu contains siteWeb then
				
				set boutonNextAbsent to do JavaScript jsBoutonNextAbsent
				log "boutonNextAbsent = " & boutonNextAbsent
				--set existe to not boutonNextAbsent
				--log "Boutons de navigation dans la page : " & existe
			end if
		end tell -- document1
		
	end tell -- safari
	
	return (not boutonNextAbsent)
end existLinkNextPage


---------------------------------------------------------------------------
--                printPageWithNameInDirectory(nom, repertoire)
---------------------------------------------------------------------------

-- Rempli la boîte de dialogue "Imprimer..." de Safari avec le nom du fichier
-- dans le répertoire indiqué, grâce au GUI Scripting.
-- Remarques : 1. Pomme + P pour atteindre la page "Imprimer..."
--                     2. On clique sur le menu "Enregistrer au format PDF..."
--			   3. Pomme + G pour changer le répertoire de destination
--			   4. On entre le nom du fichier PDF
--			   5. On ferme la boîte de dialogue
on printPageWithNameInDirectory(nom, repertoire)
	
	tell application "System Events"
		tell process "Safari"
			
			set frontmost to true
			keystroke "p" using {command down}
			--delay 1
			
			tell window 1
				-- on attend la sheet impression			
				repeat until (sheet 1) exists
					delay 0.2
				end repeat
				-- clic sur le bouton "PDF"
				click menu button "PDF" of sheet 1
				--clic sur le menu "Enregistrer en format PDF..."
				click menu item 2 of menu 1 of menu button "PDF" of sheet 1
				-- on attend la dialog de sauvegarde
				delay 1
				-- on fait apparaître la fenêtre pour changer le répertoire de destination
				keystroke "g" using {shift down, command down}
				-- la destination, c'est dossierDestination
				keystroke repertoire as text
				-- hit return to name the folder
				keystroke return
				-- on attend un peu
				delay 0.9
				-- on sélectionne tout le texte dans le champ du nom ...
				keystroke "a" using {command down}
				-- ... et on efface tout (avec la touche "delete"
				keystroke (ASCII character 127)
				-- on tape le nom du fichier PDF (sans l'extension)
				keystroke nom
				-- on attend un peu
				delay 0.9
				-- On ferme la dialog de sauvegarde
				keystroke return
				-- on attend un peu
				delay 0.9
				-- On ferme la sheet "Imprimer"
				keystroke return
			end tell
			
		end tell
	end tell
	
end printPageWithNameInDirectory



---------------------------------------------------------------------------
--                formatNamefromCounter(compteur)
---------------------------------------------------------------------------

-- Créer un nom à partir du compteur.
-- Ce nom se compose du compteur précédé d'autant de 0
-- qu'il faut pour avoir un nom de 4 lettres.
-- Exemples : 0003, 0046, O592 (compteur : 3, 46, 592)
-- Remarque : ne fonctionne que jusqu'à 9999.
on formatNamefromCounter(compteur)
	
	set nom to "" -- nom de la forme 0001
	
	if compteur < 10 then
		set nom to "000" & compteur
	else if compteur > 9 and compteur < 100 then
		set nom to "00" & compteur
	else if compteur > 99 and compteur < 1000 then
		set nom to "0" & compteur
	else if compteur = 1000 then
		set nom to (compteur as text)
	end if
	
	return nom
	
end formatNamefromCounter



---------------------------------------------------------------------------
--                              getNextPageUrl()
---------------------------------------------------------------------------

-- Renvoie l'adresse de la prochaine page
-- Récupère la valeur de l'attribut href avec du JavaScript
on getNextPageUrl()
	
	local nextPage
	tell application "Safari"
		set bubu to document 1
		tell bubu
			if URL of bubu contains siteWeb then
				-- on récupère l'url de la prochaine page dans nextPage
				set nextPage to do JavaScript jsGetNextPageUrl
				log "Prochaine page : " & nextPage
				
			end if
		end tell
	end tell
	return nextPage
	
end getNextPageUrl




---------------------------------------------------------------------------
--                              formatWebPage()
---------------------------------------------------------------------------

-- Supprime de la page web tout ce qu'on ne veut pas voir dans le PDF
-- Remarque : utilise JavaScript pour faire le ménage dans le code HTML
on formatWebPage()
	
	tell application "Safari"
		
		set bubu to document 1
		tell bubu
			if URL of bubu contains siteWeb then
				
				do JavaScript jsFormatWebPage
			end if
		end tell -- document1
		
	end tell -- safari
	
end formatWebPage



---------------------------------------------------------------------------
--                              goToWebPage(nextPage)
---------------------------------------------------------------------------


-- Ouvre l'URL nextPage dans la page en cours de Safari
on goToWebPage(nextPage)
	tell application "Safari"
		tell window 1 to set the URL of the front document to nextPage
	end tell
end goToWebPage



---------------------------------------------------------------------------
--                         activeApplication(nomApplication)
---------------------------------------------------------------------------

-- Active l'application dont le nom est passé en paramètre
on activeApplication(nomApplication)
	tell application nomApplication
		activate
		delay 1.3
		activate
	end tell
end activeApplication

