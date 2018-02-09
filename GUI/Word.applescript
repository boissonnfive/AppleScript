(*
Nom du fichier :	Word_Vers_PDF.applescript
Auteur :			Bruno Boissonnet
Date :			dimanche 21 janvier 2018
Description :		Transforme un fichier Word en fichier PDF.
Remarques :		
				1. Nécessite MS Word
				2. testé sur macOS 10.12.2 (Sierra)
*)



-- Avant de lancer le script, on vérifie que Word n'est pas déjà lancé (pour ne pas interrompre quelque chose et perdre des données)
if application "Microsoft Word" is running then
	display alert "MS Word est déjà lancé." message "Veuillez fermer Word et relancer le script."
else
	--display alert "MS Word n'est pas lancé." message "Lancement de MS Word"
	
	set fichierWord to choose file
	--> alias "Macintosh HD:Users:bruno:ASL_Google_Drive:Membres du bureau de l’ASL.docx"
	
	--tell application "Finder" to set nomFichierWord to name of fichierWord
	--log nomFichierWord
	
	tell application "Microsoft Word"
		--activate
		open fichierWord
	end tell
	
	my export_to_PDF()
	
end if


(*
  Fonction pour exporter un fichier dans Word en PDF
 
*)
on export_to_PDF()
	
	my do_menu("Microsoft Word", "Fichier", "Enregistrer sous...")
	
	tell application "System Events"
		tell process "Microsoft Word"
			
			delay 0.8
			click pop up button 1 of group 1 of sheet 1 of window 2
			
			delay 0.8
			click menu item "PDF" of menu 1 of pop up button 1 of group 1 of sheet 1 of window 2
			
			delay 0.1
			click button "Enregistrer" of sheet 1 of window 2
			
			delay 0.5
			--keystroke "w" using command down
			
		end tell
	end tell
	
end export_to_PDF

(*
  Fonction pour atteindre un menu d'une application

  app_name : nom de l'application
  menu_name : nom du menu qui contient le menu
  menu_item : le menu à atteindre
  
 exemple pour l'application Éditeur AppleScript:
 Menu Présentation > Masquer la barre de navigation
 my do_submenu("Présentation", "Masquer la barre de navigation") 
*)
on do_menu(app_name, menu_name, menu_item)
	try
		-- bring the target application to the front
		tell application app_name
			activate
		end tell
		tell application "System Events"
			tell process app_name
				tell menu bar 1
					tell menu bar item menu_name
						tell menu menu_name
							click menu item menu_item
						end tell
					end tell
				end tell
			end tell
		end tell
		return true
	on error error_message
		return false
	end try
end do_menu














(*
tell application "Microsoft Word"
	activate
	open fichierWord
end tell
*)


(*
tell application "Microsoft Word"
	close active document
end tell
*)


-- get every UI element of window 1
-- {static text "Demande Tel et mail.docx" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", toolbar "Standard" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", grow area 1 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", button 1 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", button 2 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", button 3 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", tab group 1 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", toolbar "Contrôle de création d'état" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", scroll bar 1 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", radio group "View Switcher" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", UI element 11 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", static text "116%" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", slider 1 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", UI element "Barre d'état" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", UI element 15 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", UI element "Barre de fractionnement horizontale" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", scroll bar 2 of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events", UI element "Volet Document" of window "Demande Tel et mail.docx" of application process "Microsoft Word" of application "System Events"}



--get every UI element of menu bar 1

--{menu bar item "Apple" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Word" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Édition" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Affichage" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Insertion" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Format" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Police" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Outils" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Tableau" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Fenêtre" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Scripts" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu bar item "Aide" of menu bar 1 of application process "Microsoft Word" of application "System Events"}

-- get every UI element of menu bar item "Fichier" of menu bar 1
-- {menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events"}

-- get every UI element of menu "Fichier" of menu bar item "Fichier" of menu bar 1

-- {menu item "Nouveau document" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Nouveau à partir d'un modèle..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Ouvrir..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Ouvrir une URL..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Ouvrir récent" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 6 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Fermer" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Enregistrer" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Enregistrer sous..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Enregistrer en tant que page Web..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 11 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Partager" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 13 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Aperçu de la page Web" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 15 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Restreindre les autorisations" of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 17 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Réduire la taille du fichier..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 19 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Mise en page..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Imprimer..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item 22 of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events", menu item "Propriétés..." of menu "Fichier" of menu bar item "Fichier" of menu bar 1 of application process "Microsoft Word" of application "System Events"}
-- get every UI element of sheet 1 of window 1

--{group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", button "Enregistrer" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", checkbox "Masquer l’extension" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", button "Nouveau dossier" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", button "Annuler" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", UI element 7 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", text field "Enregistrer sous :" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", static text "Enregistrer sous :" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", static text "Tags :" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", text field "Tags :" of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events"}


-- get every UI element of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx"

-- {group 1 of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", radio group 1 of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", group 2 of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", pop up button 1 of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", text field 1 of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", splitter group 1 of group 2 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events"}

-- get every UI element of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx"

-- {radio button "Enregistrer uniquement les informations sur l'affichage au format HTML" of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", radio button "Enregistrer tout le fichier au format HTML" of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", static text "Vérification de compatibilité recommandée" of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", image 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", button "Rapport de compatibilité..." of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", button "Options..." of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", checkbox "Conserver la compatibilité avec Word 2008" of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", checkbox "Conserver la compatibilité avec Word 98-2004" of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", checkbox 3 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", group "Description" of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events"}
-- get every UI element of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx"

-- {menu item "Document Word (.docx)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item 2 of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Formats courants" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Document Word 97-2004 (.doc)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Modèle Word (.dotx)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Modèle Word 97-2004 (.dot)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Format RTF (.rtf)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Texte brut (.txt)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Page Web (.html)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "PDF" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item 11 of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Formats spéciaux" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Document Word prenant en charge les macros (.docm)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Modèle Word prenant en charge les macros (.dotm)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Document Word XML (.xml)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Document XML Word 2003 (.xml)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Page Web à fichier unique (.mht)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Document papier à lettres Word (.doc)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", menu item "Compatible avec Word 4.0-6.0/95 (.rtf)" of menu 1 of pop up button 1 of group 1 of sheet 1 of window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events"}




--get every UI element of application process "Microsoft Word" of application "System Events"

-- {menu bar 1 of application process "Microsoft Word" of application "System Events", window 1 of application process "Microsoft Word" of application "System Events", window "Membres du bureau de l’ASL.docx" of application process "Microsoft Word" of application "System Events", window "Bibliothèque de documents Word" of application process "Microsoft Word" of application "System Events", window "Microsoft Word" of application process "Microsoft Word" of application "System Events"}
