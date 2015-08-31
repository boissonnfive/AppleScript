(*
Nom du fichier:	progitfr.applescript
Auteur:			Bruno Boissonnet
Date:			lundi 30 août 2015
Description:		Ce script transforme la verion HTML du livre "Progit" en PDF.
Remarques:
				0. Avant de lancer le script, afficher la première page dans Safari
				1. Ce script va modifier la page pour ne garder que le contenu du livre,
				 puis va exporter la page en PDF avec un nom croissant (ex: 0001.PDF, 
				0002.PDF, etc...) dans le dossier "nomProjet" du dossier du script,
				 et va aller à la page suivante. Ainsi de suite jusqu'à ce qu'il n'y
				 ait plus de bouton "next"
				2. Il ne restera qu'à fusionner les fichiers PDF obtenus en un seul fichier PDF
				3. testé sur Mac OS X 10.9
*)

property nomProjet : "progitfr"
property numeroGroupe : 0


tell application "Finder"
	
	-- 0. On récupère le chemin du script
	set dossierScript to container of (path to me) as alias
	
	-- 1. On crée un dossier "nom projet" dans le dossier du script
	try
		set dossierProjet to make new folder with properties {name:nomProjet} at dossierScript
		
	on error
		tell application "System Events" to display alert "Impossible de créer le dossie: " & ¬
			nomProjet & return ¬
			& "Un dossier portant le même nom existe peut-être déjà." & return ¬
			& "Opération de création annulée."
		return
	end try
	
	-- 2. On récupère le chemin POSIX complet du dossier "mon projet"
	set dossierDestination to POSIX path of (dossierProjet as alias)
	log ("dossierDestination : " & dossierDestination)
	
end tell



tell application "Safari"
	activate
	delay 1.3
	activate
end tell


-- Mise à zéro du compteur qui est utilisé pour nommer les fichiers en séquence
set compteur to 0

-- Tant qu'il existe un bouton "Next"
repeat while my existLinkNextPage()
	
	set compteur to compteur + 1
	-- on crée le nom du fichier (format 0001, 0010, 0100, etc ...)
	set nom to formatNamefromCounter(compteur)
	log "Nom : " & nom
	
	-- 0. On récupère l'adresse de la prochaine page web
	set myNextPage to my getNextPageUrl()
	
	-- 1. On reformate la page Web pour ne garder que ce que l'on veut imprimer
	my formatWebPage()
	
	-- 2. On imprime la page dans un PDF
	my printPageWithNameInDirectory(nom, dossierDestination)
	
	-- On attend un peu que l'impression se termine
	delay 1.5
	
	-- 2. On passe à la page suivante
	--my clickOnNextPage()
	my goToNextPage(myNextPage)
	
	-- On attend un peu que la nouvelle page se charge
	delay 2.5
	
end repeat

display dialog "Fin du script"


---------------------------------------------------------------------------
--                              Fonctions 
---------------------------------------------------------------------------



---------------------------------------------------------------------------
--                              existLinkNextPage()  
---------------------------------------------------------------------------

-- Recherche dans le code de la page s'il y a un bouton "next"
-- Renvoie true s'il existe, false sinon.
-- Remarque : on considère que le bouton "next" existe
--                  si on trouve son parent "div#nav"
on existLinkNextPage()
	set existe to false
	
	tell application "Safari"
		
		set bubu to document 1
		tell bubu
			if URL of bubu contains "https://git-scm.com/book/fr/v1" then
				
				set boutonNextAbsent to do JavaScript "!document.getElementById('nav')"
				log "boutonNextAbsent = " & boutonNextAbsent
				set existe to not boutonNextAbsent
				log "Boutons de navigation dans la page : " & existe
			end if
		end tell -- document1
		
	end tell -- safari
	
	return existe
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
	
	set nextPage to ""
	tell application "Safari"
		set bubu to document 1
		tell bubu
			if URL of bubu contains "https://git-scm.com/book/fr/v1/" then
				-- on récupère l'url de la prochaine page dans nextPage
				set nextPage to do JavaScript "document.getElementById('nav').children[1].href;"
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
			if URL of bubu contains "https://git-scm.com/book/fr/v1/" then
				
				do JavaScript "
			
			// Supprime le header
			var x = document.getElementsByClassName('inner');
			x[0].style.display = 'none';
			
			// Supprime le footer
			var my_footer = document.getElementsByTagName('footer');
			my_footer[0].style.display = 'none';
			
			// Supprime la colonne de gauche
			var y = document.getElementsByClassName('sidebar');
			y[0].style.display = 'none';
			
			// Supprime la liste des chapitres
			document.getElementById('book-chapters').style.display = 'none';
			
			// Supprime les boutons de navigation
			document.getElementById('nav').style.display = 'none';
						
			"
			end if
		end tell -- document1
		
	end tell -- safari
	
end formatWebPage



---------------------------------------------------------------------------
--                              goToNextPage(nextPage)
---------------------------------------------------------------------------


-- Ouvre l'URL nextPage dans la page en cours de Safari
on goToNextPage(nextPage)
	tell application "Safari"
		tell window 1 to set the URL of the front document to nextPage
	end tell
end goToNextPage




---------------------------------------------------------------------------
--                              FIN DU SCRIPT
---------------------------------------------------------------------------


(*
tell UI element 1 of scroll area 1 of group 1 of group 1 of group 3 of window 1
				--get every UI element of group 1
				--get every UI element of group 2
				click UI element "Next Page" of group 2
				delay 2.0
				
				
				
				
if exists (UI element "Next Page" of group 1) then
					click UI element "Next Page" of group 1
				else
					display dialog "Erreur : il n'y a pas de bouton \"Next\" sur la page."
				end if
				
				
				
				repeat while (exists (UI element "Next Page" of group 2) or (exists (UI element "Next Page" of group 1)))
					
					click UI element "Next Page" of group 2
					delay 2.0
					
				end repeat
*)