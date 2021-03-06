---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    comment_line.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Commente la ligne où se trouve le curseur dans l'Éditeur de script.
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				    - Le commentaire se fait en ajoutant un "#" au début de la ligne.
--				    - Ne fonctionne que dans l'Éditeur de script.
--				    - testé sur Mac OS X 10.12.6 .
---------------------------------------------------------------------------------------------------------------------------


tell application "System Events"
	
	tell process "Script Editor"
		
		delay 0.3 -- pour attendre que l'utilisateur relève les doigts du clavier
		key code 53 -- Esc (pour sortir du raccourci clavier qui a appelé le script)
		key code 123 using command down -- ⌘ ← : reviens au début de la ligne
		key code 124 using option down -- ⌥ → : met le curseur après le premier mot
		key code 123 using option down -- ⌥ ← : met le curseur avant le premier mot
		keystroke "-- " -- Ajoute le signe de commentaire
		delay 0.1
		keystroke "k" using {command down} -- Compile le fichier
		log "bubu " & tab & space & return & linefeed -- return 
		
		display dialog "coucou"
		
	end tell
	
	
end tell