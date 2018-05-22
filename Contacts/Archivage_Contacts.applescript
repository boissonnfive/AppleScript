---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    Archivage_Contacts.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Cr�e une archive de tous les contacts sur le bureau.
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				    - On utilise le GUI Scripting pour cliquer sur le menu Archive Contacts...
--				    - Les �delay� sont � modifier en fonction de votre environnement.
--				    - Test� sur Mac OS X 10.9 et 10.8 et mac0S 10.12.6
---------------------------------------------------------------------------------------------------------------------------

property listeVersionsOSAUtorisees : {"10.8", "10.9", "10.12"}


(*
Nom			: run 
Description	: Fonction appel�e lorsque le script est lanc�
argv        	: les arguments du script
retour		: le retour de la derni�re instruction
*)
on run argv
	if versionOSAutorisee() or forceAutorisation() then
		exporteTousLesContactsSurLeBureau()
	end if
end run


-----------------------------------------------------------------------------------------------------------
--                                                     FONCTIONS
-----------------------------------------------------------------------------------------------------------

(*
Nom			: versionOSAutorisee
Description	: Contr�le si le script a �t� test� avec cette version d'OS
R�sultat	: true si le script a �t� test� avec cette version d'OS, false sinon.
*)
on versionOSAutorisee()
	set versionRecherchee to versionSystemeCourte()
	return listeVersionsOSAUtorisees contains versionRecherchee
end versionOSAutorisee


(*
Nom			: versionSystemeCourte
Description	: Renvoi seulement les deux premiers nombres de la version du syst�me
R�sultat		: La version coute du syst�me.
Exemple		: 10.12.6 => 10.12
*)
on versionSystemeCourte()
	system info
	set versionOS to system version of result
	set ATID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "."
	set s to text items of versionOS -- {10, X, Y}
	set versionOS to item 1 of s & "." & item 2 of s
	set AppleScript's text item delimiters to ATID
	return versionOS
end versionSystemeCourte


(*
Nom			: forceAutorisation
Description	: Demande � l'utilisateur si on continue le script.
R�sultat		: true si l'utilisateur continue, false sinon.
*)

on forceAutorisation()
	set message to "ATTENTION !" & return & �
		"Vous utilisez une version non test�e de macOS." & return & �
		"Ce script a �t� test� avec les versions 10.8, 10.9 et 10.12 ." & return & �
		"Il est possible que ce script ne fonctionne pas avec votre version."
	
	display dialog message buttons {"Continuer", "Terminer"} default button 2 with title "Script Archivage_Contacts.applescript"
	
	return (the button returned of the result is "Continuer")
end forceAutorisation



(*
Nom			: exporteTousLesContactsSurLeBureau
Description	: Archive tous les contacts sur le bureau
R�sultat		: Un fichier Archive sur le bureau.
*)
on exporteTousLesContactsSurLeBureau()
	
	set versionOS to versionSystemeCourte()
	
	if versionOS contains "10.12" then
		exporteTousLesContactsSurLeBureau10_12()
	else if versionOS contains "10.9" then
		exporteTousLesContactsSurLeBureau10_9()
	else if versionOS contains "10.8" then
		exporteTousLesContactsSurLeBureau10_8()
	else
		exporteTousLesContactsSurLeBureau10_12()
	end if
end exporteTousLesContactsSurLeBureau


(*
Nom			: exporteTousLesContactsSurLeBureau10_12
Description	: Archive tous les contacts sur le bureau pour la version 10.12 de macOS
R�sultat		: Un fichier Archive sur le bureau.
*)
on exporteTousLesContactsSurLeBureau10_12()
	do_submenu("Contacts", "Fichier", "Exporter", "Archive Contacts�")
	clicEnregisterSous10_12("Contacts", "", "Bureau")
	fermeApplication("Contacts")
end exporteTousLesContactsSurLeBureau10_12


(*
Nom			: exporteTousLesContactsSurLeBureau10_9
Description	: Archive tous les contacts sur le bureau pour la version 10.9 de macOS
R�sultat		: Un fichier Archive sur le bureau.
*)
on exporteTousLesContactsSurLeBureau10_9()
	do_submenu("Contacts", "Fichier", "Exporter�", "Archive Contacts�")
	clicEnregisterSous10_9("Contacts", "", "Bureau")
	fermeApplication("Contacts")
end exporteTousLesContactsSurLeBureau10_9



(*
Nom			: exporteTousLesContactsSurLeBureau10_8
Description	: Archive tous les contacts sur le bureau pour la version 10.8 de macOS
R�sultat		: Un fichier Archive sur le bureau.
*)
on exporteTousLesContactsSurLeBureau10_8()
	do_submenu("Contacts", "Fichier", "Exporter�", "Archive Contacts�")
	clicEnregisterSous10_8("Contacts", "", "Bureau")
	fermeApplication("Contacts")
end exporteTousLesContactsSurLeBureau10_8


(*
Nom				: do_submenu
Description		: Clique un sous-menu d'une application
app_name		: nom de l'application
menu_name		: nom exact du menu
menu_item		: nom exact du sous-menu
submenu_item 	: nom exact du sous-menu vis�
Remarques 		:
  			exemple pour l'application �diteur AppleScript:
			Menu Fichier > Ouvrir l'�l�ment r�cent > Effacer le menu
			my do_submenu("�diteur AppleScript", "Fichier", "Ouvrir l'�l�ment r�cent", "Effacer le menu") 
*)
on do_submenu(app_name, menu_name, menu_item, submenu_item)
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
							tell menu item menu_item
								tell menu menu_item
									click menu item submenu_item
								end tell
							end tell
						end tell
					end tell
				end tell
			end tell
		end tell
		return true
	on error error_message
		return false
	end try
end do_submenu


(*
Nom								: clicEnregisterSous10_12
Description						: Manipule la fen�tre � Enregistrer sous � de macOS 10.12 .
nomApplication					: Nom de l'application dont on doit manipuler la fen�tre � Enregistrer sous �.
nomEnregistrement				: Nom sous lequel on foit faire l'enregistrement.
cheminPOSIXDossierEnregistrement	: Chemin POSIX du dossier dans lequel on doit faire l'enregistrement.
nomNouveauDossier				: Nom du nouveau dossier � cr�er
R�sultat							: RIEN.
*)
on clicEnregisterSous10_12(nomApplication, nomEnregistrement, cheminPOSIXDossierEnregistrement, nomNouveauDossier)
	
	-- bring the target application to the front
	tell application nomApplication
		activate
	end tell
	tell application "System Events"
		tell process nomApplication
			
			-- 1�) On affiche la fen�tre � Enregistrer sous � maximale
			
			set triangleDExpansion to item 1 of ((every UI element of sheet 1 of window 1) whose role is "AXDisclosureTriangle")
			
			if value of triangleDExpansion is 0 then
				click triangleDExpansion
			end if
			
			
			-- 2�) On rempli le champ "Enregistrer sous : "
			
			if nomEnregistrement is not "" then
				set value of (UI element 7 of sheet 1 of window 1) to nomEnregistrement
			end if
			
			-- 3�) On s�lectionne le dossier d'enregistrement (Le bureau par d�faut)
			
			if cheminPOSIXDossierEnregistrement is "" then
				set cheminPOSIXDossierEnregistrement to POSIX path of (path to desktop)
			end if
			
			keystroke "g" using {command down, shift down}
			-- Impossible d'avoir acc�s � la feuille ?
			keystroke cheminPOSIXDossierEnregistrement
			keystroke return -- ou space ou tab
			
			
			-- 4�) On cr�e un nouveau dossier s'il le faut
			
			if nomNouveauDossier is not "" then
				-- button "Nouveau dossier" of sheet 1 of window "Contacts" of application process "Contacts" of application "System Events"
				click (UI element 3 of sheet 1 of window 1)
				set value of (UI element 1 of window 1) to nomNouveauDossier
				click (UI element 2 of window 1)
			end if
			
			
			-- 5�) On clique sur le bouton "Enregistrer"
			
			--click button "Enregistrer" of sheet 1 of window 1
			click UI element 1 of sheet 1 of window 1
			
		end tell
	end tell
	
end clicEnregisterSous10_12


(*
Nom					: clicEnregisterSous10_9
Description			: Manipule la fen�tre � Enregistrer sous � de macOS 10.9 .
nomApplication		: Nom de l'application dont on doit manipuler la fen�tre � Enregistrer sous �.
nomEnregistrement	: Nom sous lequel on foit faire l'enregistrement.
dossierEnregistrement	: Dossier dans lequel on doit faire l'enregistrement.
R�sultat				: RIEN.
*)
on clicEnregisterSous10_9(nomApplication, nomEnregistrement, dossierEnregistrement)
	
	-- bring the target application to the front
	tell application nomApplication
		activate
	end tell
	tell application "System Events"
		tell process nomApplication
			
			click pop up button 1 of group 1 of sheet 1 of window 1
			click menu item dossierEnregistrement of menu 1 of pop up button 1 of group 1 of sheet 1 of window 1
			click button "Enregistrer" of sheet 1 of window 1
			
		end tell
	end tell
	
end clicEnregisterSous10_9


(*
Nom					: clicEnregisterSous10_8
Description			: Manipule la fen�tre � Enregistrer sous � de macOS 10.8 .
nomApplication		: Nom de l'application dont on doit manipuler la fen�tre � Enregistrer sous �.
nomEnregistrement	: Nom sous lequel on foit faire l'enregistrement.
dossierEnregistrement	: Dossier dans lequel on doit faire l'enregistrement.
R�sultat				: RIEN.
*)
on clicEnregisterSous10_8(nomApplication, nomEnregistrement, dossierEnregistrement)
	
	-- bring the target application to the front
	tell application nomApplication
		activate
	end tell
	tell application "System Events"
		tell process nomApplication
			
			click pop up button 1 of sheet 1 of window 1
			click menu item dossierEnregistrement of menu 1 of pop up button 1 of sheet 1 of window 1
			click button "Enregistrer" of sheet 1 of window 1
			
		end tell
	end tell
	
end clicEnregisterSous10_8

(*
Nom					: fermeApplication
Description			: Ferme l'application sp�cifi�e.
nomApplication		: Nom de l'application que l'on veut fermer.
R�sultat				: RIEN.
*)
on fermeApplication(nomApplication)
	tell application nomApplication to quit
end fermeApplication


-----------------------------------------------------------------------------------------------------------
--                                                     FIN
-----------------------------------------------------------------------------------------------------------
