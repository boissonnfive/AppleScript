(*
Nom du fichier :    Modele.applescript
Auteur           :    Bruno Boissonnet
Date             :    jeudi 3 mai 2018
Description     :    Ce fichier est un mod�le, un gabarit qui doit servir de base � tout script.
Remarques      :
				    1. ...
				    2. ...
				    3. test� sur Mac OS X 10.12.6
*)

-- Fonction run implicite
on run argv
	
	creeDossierDansFinder("ASDossier")
	
end run



(*
  Description : Cr�e un dossier nomDossier dans le dossier "Documents"
  Param�tres  :
                - nomDossier  : nom du dossier � cr�er
*)
on creeDossierDansFinder(nomDossier)
	
	tell application "Finder"
		set dossierProjet to make new folder with properties {name:nomDossier} at folder "Documents" of home
		activate
		open folder "Documents" of home
		select dossierProjet
	end tell
	
end creeDossierDansFinder

(*
  Fonction pour atteindre un menu d'une application

  app_name : nom de l'application
  menu_name : nom du menu qui contient le menu
  menu_item : le menu � atteindre
  
 exemple pour l'application �diteur AppleScript:
 Menu Pr�sentation > Masquer la barre de navigation
 my do_submenu("Pr�sentation", "Masquer la barre de navigation") 
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