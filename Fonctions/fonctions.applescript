(*
Liste de fonctions utiles :

1. String
2. GUI
3. Divers
*)

--display dialog "Coucou" buttons {"OK"} default button 1
display alert lowercase("OÙ EST PASSÉE FRANÇOISE ?")

-- 1. String -------------------
(*
Mets les caractères de la chaîne spécifiée en majuscules
s : chaine à utiliser
return : la chaîne en majuscules
*)
on uppercase(s)
	set uc to "ÆŒÄÅÇÉÑÖÜÀÃÕŸÂÊÁËÈÍÎÏÌÓÔÒÚÛÙABCDEFGHIJKLMNOPQRSTUVWXYZ"
	set lc to "æœäåçéñöüàãõÿâêáëèíîïìóôòúûùabcdefghijklmnopqrstuvwxyz"
	repeat with i from 1 to 54
		set AppleScript's text item delimiters to character i of lc
		set s to text items of s
		set AppleScript's text item delimiters to character i of uc
		set s to s as text
	end repeat
	set AppleScript's text item delimiters to ""
	return s
end uppercase

(*
Mets les caractères de la chaîne spécifiée en minuscules
s : chaine à utiliser
return : la chaîne en minuscules
*)
on lowercase(s)
	set uc to "ÆŒÄÅÇÉÑÖÜÀÃÕŸÂÊÁËÈÍÎÏÌÓÔÒÚÛÙABCDEFGHIJKLMNOPQRSTUVWXYZ"
	set lc to "æœäåçéñöüàãõÿâêáëèíîïìóôòúûùabcdefghijklmnopqrstuvwxyz"
	repeat with i from 1 to 54
		set AppleScript's text item delimiters to character i of uc
		set s to text items of s
		set AppleScript's text item delimiters to character i of lc
		set s to s as text
	end repeat
	set AppleScript's text item delimiters to ""
	return s
end lowercase


(*
Récupère le texte entre les bornes spécifiées
this_text : chaine à utiliser
start : l'indice de début du texte dans la chaîne (doit être >=1)
end : l'indice de fin du texte dans la chaîne (doit être <= longueur de la chaîne)
return : la sous-chaîne entre les bornes spécifiées ou la chaîne si les bornes sont incorrectes

Remarque: 
Il est possible de récupérer une sous-chaîne en partant de la fin. Il suffit de donner des valeurs négatives.

ex: sub_string(maPhrase, -1, -9) récupère les 9 derniers caractères de la chaîne maPhrase
*)
on sub_string(this_text, istart, iend)
	try
		return (text (istart) thru (iend) of this_text)
	on error
		return this_text
	end try
end sub_string



(*
Supprime le caractère spécifié de la chaine passée en paramètres
this_text : chaine à modifier
trim_char : le caractère à supprimer
retour : la chaîne sans le caractère
*)
on remove_char(this_text, trim_char)
	set new_text to ""
	
	repeat with i from 1 to the length of the this_text
		set my_char to character i of this_text
		-- log my_char
		if my_char is not equal to trim_char then
			set new_text to new_text & my_char
		end if
	end repeat
	return new_text
end remove_char

(*
Supprime le caractère spécifié de la chaine passée en paramètres
this_text : chaine à modifier
trim_char : le caractère à supprimer
retour : la chaîne sans le caractère
*)
on remove_char2(this_text, trim_char)
	set prevTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to trim_char
	set s to text items of this_text
	set AppleScript's text item delimiters to ""
	set s to s as text
	set AppleScript's text item delimiters to prevTIDs
	
	return s
end remove_char2

(*
Une fonction pour supprimer tous les espaces dans une chaîne de caractères

myText : le texte contenant des espaces à supprimer
retour : le texte sans les espaces
Remarque: l'espace n'est pas toujours le séparateur d'un mot. A voir ...
*)
on trimSpaces(myText)
	set myList to every word of myText
	set myTrimedText to myList as text
	return myTrimedText
end trimSpaces


(*
Remplace le caractère spécifié de la chaine passée en paramètres par un autre
this_text : chaine à modifier
old_char : le caractère à remplacer
new_char: le nouveau caractère 
retour : la chaîne modifiée
*)
on replace_char(this_text, old_char, new_char)
	set new_text to ""
	
	repeat with i from 1 to the length of the this_text
		set my_char to character i of this_text
		-- log my_char
		if my_char is equal to old_char then
			set new_text to new_text & new_char
		else
			set new_text to new_text & my_char
		end if
	end repeat
	return new_text
end replace_char



(*
Remplace le caractère spécifié de la chaine passée en paramètres par un autre
this_text : chaine à modifier
old_char : le caractère à remplacer
new_char: le nouveau caractère 
retour : la chaîne modifiée
*)
on replace_char2(this_text, old_char, new_char)
	set prevTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to old_char
	set s to text items of this_text
	set AppleScript's text item delimiters to new_char
	set s to s as text
	set AppleScript's text item delimiters to prevTIDs
	
	return s
end replace_char2


-- 2. GUI ------------------

(*
Fonction pour vérifier si "Activer l'accès pour les périphériques d'aide" est activé dans les préférences système > Accès Universel (ce qui permet d'utiliser les fonctionnalité de script GUI)
*)
on UIscript_check()
	-- get the system version
	set the hexData to system attribute "sysv"
	set hexString to {}
	repeat 4 times
		set hexString to ((hexData mod 16) as string) & hexString
		set hexData to hexData div 16
	end repeat
	set the OS_version to the hexString as string
	if the OS_version is less than "1030" then
		display dialog "This script requires the installation of Mac OS X 10.3 or higher." buttons {"Cancel"} default button 1 with icon 2
	end if
	-- check to see if assistive devices is enabled
	tell application "System Events"
		set UI_enabled to UI elements enabled
	end tell
	if UI_enabled is false then
		tell application "System Preferences"
			activate
			set current pane to pane "com.apple.preference.universalaccess"
			display dialog "This script utilizes the built-in Graphic User Interface Scripting architecture of Mac OS X which is currently disabled." & return & return & "You can activate GUI Scripting by selecting the checkbox \"Enable access for assistive devices\" in the Universal Access preference pane." with icon 1 buttons {"Cancel"} default button 1
		end tell
	end if
end UIscript_check



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
						--display dialog "coucou"
						tell menu menu_name
							--display dialog "coucou"
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
  Fonction pour atteindre un sous-menu d'une application

  app_name : nom de l'application
  menu_name : nom du menu qui contient le menu
  menu_item : le menu à atteindre
  submenu_item : le sous-menu visé
  
  exemple pour l'application Éditeur AppleScript:
  Menu Fichier > Ouvrir l'élément récent > Effacer le menu
  my do_submenu("Éditeur AppleScript", "Fichier", "Ouvrir l'élément récent", "Effacer le menu") 
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


-- Date -------------------------------
(*
Permet de récupérer les éléments de la date en français
1. Créer la date en français avec la méthode makeDateFr
2. appeler les propriétés jour_semaine, jour, mois, annee, heure, minute, seconde of monObjet DateFr

ex: 

set maDate to makeDateFr()
display alert jour_semaine of maDate & space & jour of maDate & space & mois of maDate & space & annee of maDate
*)

on makeDateFr()
	set mon_instant to ((current date) as string)
	script DateFr
		property date : mon_instant
		property jour_semaine : 1st word of mon_instant
		property jour : 2nd word of mon_instant
		property mois : 3rd word of mon_instant
		property annee : 4th word of mon_instant
		property heure : 5th word of mon_instant
		property minute : 6th word of mon_instant
		property seconde : 7th word of mon_instant
	end script
	return DateFr
end makeDateFr



-- Test si l'application "processName" est en lancée ou pas
-- Trois façons de faire

(*
-- La bonne manière : utiliser la propriété running de la classe application
if application "Preview" is running then
	display alert "Aperçu est déjà lancé"
else
	display alert "Aperçu n'est pas lancé." & return & "Lancement d'Aperçu"
	tell application "Preview" to run
end if
*)

(*
on test_process(processName)
	tell application "System Events"
		return (exists process processName)
	end tell
end test_process
*)
(*
on test_process(processName)
	tell application "System Events"
		set myList to (name of every process)
	end tell
	
	return (myList contains processName)
end test_process
*)
