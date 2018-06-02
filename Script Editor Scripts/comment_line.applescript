---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    comment_line.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Commente la ligne où se trouve le curseur dans l'Éditeur de script.
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				    - Le commentaire se fait en ajoutant un "#" au début de la ligne.
--				    - Ne fonctionne que l'Éditeur de script.
--				    - testé sur Mac OS X 10.12.6 .
---------------------------------------------------------------------------------------------------------------------------


tell application "System Events"
	
	tell process "Script Editor"
		
		key code 123 using command down -- ⌘ ← : reviens au début de la ligne
		key code 124 using option down -- ⌥ → : met le curseur après le premier mot
		key code 123 using option down -- ⌥ ← : met le curseur avant le premier mot
		keystroke "# " -- Ajoute le signe de commentaire
		
	end tell
	
	
end tell