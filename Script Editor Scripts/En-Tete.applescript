(*
Nom du fichier:	En-Tete.applescript
Auteur:			Bruno Boissonnet
Date:			Dimanche 09 mars 2014
Description:		Ce script insère un en-tête au début du script en cours,
				dans l' "Éditeur AppleScript".
Remarques:		
				1. Ce script devra être placé dans le dossier:
				/Library/Scripts/Script Editor Scripts
				2. Il suffira de faire un clic droit dans
				 l'"Éditeur AppleScript" pour sélectionner le script
				3. testé sur Mac OS X 10.8
*)

property scriptHeaderBeginning : "(*
Nom du fichier:	En-Tete.applescript
Auteur:			Bruno Boissonnet
Date:			"

property scriptHeaderEnd : "
Description:		Ce script insère un en-tête au début du script en cours,
				dans l' \"Éditeur AppleScript\".
Remarques:		
				1. Ce script devra être placé dans le dossier:
				/Library/Scripts/Script Editor Scripts
				2. Il suffira de faire un clic droit dans
				 l'\"Éditeur AppleScript\" pour sélectionner le script
				3. testé sur Mac OS X 10.8
*)

"

tell application "AppleScript Editor"
	tell front document
		
		set myHeader to scriptHeaderBeginning ¬
			& date string of (current date) ¬
			& scriptHeaderEnd
		
		make new word at beginning with data myHeader
		
	end tell
end tell
