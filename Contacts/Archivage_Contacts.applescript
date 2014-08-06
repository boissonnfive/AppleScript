(* *********************************************
Nom du fichier:	Archivage_Contacts.applescript
Auteur:			Bruno Boissonnet
Date:			Jeudi 23 janvier 2014
Description:		Archivage du carnet d'adresses sur le bureau.
				
Remarques:		
				1. On utilise le GUI Scripting pour cliquer sur le menu
				  Fichier > Exporter… > Archive Contacts...
				2. Les «delay» sont à modifier en fonction de votre environnement.
				3. testé sur Mac OS X 10.9 et 10.8
******************************************** *)

set osver to system version of (system info)

if osver does not contain "10.8" and osver does not contain "10.9" then
	
	set message to "ATTENTION !" & return & ¬
		"Ce script a été testé avec les versions 10.8 et 10.9 de Mac OS X." & return & ¬
		"Vous utilisez la version " & osver & "." & return & ¬
		"Il est possible que ce script ne fonctionne pas avec cette version."
	
	display dialog message buttons {"Continuer", "Terminer"} default button 2 with title "Script Archivage_Contacts.applescript"
	
	if the button returned of the result is "Terminer" then
		return -- on quitte le programme
	else
		--log "On est passé par ici!"
	end if
end if

tell application "Contacts"
	activate
	delay 3
	activate
	
	tell application "System Events"
		
		tell process "Contacts"
			
			-- on clique sur le menu «Archive Contacts»
			
			if osver contains "10.8" then
				click menu item "Archive Contacts..." of menu 1 of menu item "Exporter…" of menu 1 of menu bar item "Fichier" of menu bar 1
			else
				click menu item "Archive Contacts…" of menu "Exporter…" of menu item "Exporter…" of menu "Fichier" of menu bar item "Fichier" of menu bar 1
			end if
			
			delay 0.5
			
			-- on sélectionne le bureau comme destination
			if osver contains "10.8" then
				click pop up button 1 of sheet 1 of window 1
			else
				click pop up button 1 of group 1 of sheet 1 of window 1
			end if
			
			delay 0.5
			
			if osver contains "10.8" then
				click menu item "Bureau" of menu 1 of pop up button 1 of sheet 1 of window 1
			else
				click menu item "Bureau" of menu 1 of pop up button 1 of group 1 of sheet 1 of window 1
			end if
			
			-- on clique sur «Enregistrer»
			click button "Enregistrer" of sheet 1 of window 1
			
			delay 2
			
		end tell -- process "Contacts"
		
	end tell -- application "System Events"
	
end tell -- application "Contacts"

(*
   On affiche le bureau dans le «Finder»
   et on sélectionne le fichier d'archive
*)
tell application "Finder"
	
	activate
	open folder "Desktop" of home
	select (first item whose name contains "Contacts")
	
end tell -- application "Finder"

(*
   On ferme l'application «Contacts»
*)
tell application "Contacts" to quit