(*
Nom du fichier:	Partager_sur_dl.free.fr.applescript
Auteur:			Bruno Boissonnet
Date:			samedi 5 mars 2016
Description:	Ce script permet de télécharger un fichier sur le site FTP de free :
                dl.free.fr .
Remarques:		
				1. Nécessite un compte (gratuit) chez free (adresse@free.fr)
				2. Le fichier à télécharger peut être déposé sur le script
				3. Ne fonctionne qu'avec un fichier (pas un dossier)
				4. testé sur Mac OS X 10.8
*)


(*

Ce script est une droplet qui permet de télécharger le fichier déposé dessus sur le site FTP de free : dl.free.fr .
Restrictions :
- Le fichier doit être un ... fichier (pas un dossier!)
- Le nom du fichier ne doit pas comporter d'espace
- Obligation de passer par le Terminal pour obtenir l'adresse du fichier

NOTE:
Il faut créer un fichier ".netrc" dans le dossier utilisateur ($HOME) qui contient les informations pour se connecter automatiquement en FTP:

	$ cat .netrc
	machine  dl.free.fr
	login    boissonnfive@free.fr
	password brunobo

	$ chmod go-r .netrc


*)



-- Une fonction pour atteindre le sous-menu d'une application
-- useful function to click an application sub-menu
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

-- Test si l'application "processName" est en lancée ou pas
on test_process(processName)
	tell application "System Events"
		set myList to (name of every process)
	end tell
	
	return (myList contains processName)
end test_process



on open the_Droppings
	
	set terminalRunning to false
	
	if (the_Droppings's length > 1) then -- on ne gère qu'un seul fichier
		display alert "Erreur : On ne peut déposer qu'un seul élément!" & return & return & "(" & (the_Droppings as string) & ")"
	else
		-- On ne gère que les fichiers, pas les dossiers
		if folder of (info for item 1 of the_Droppings) then
			display alert "Erreur : on ne peut pas déposer de dossier!" & return & return & "(" & (item 1 of the_Droppings as string) & ")"
			return
		else
			
			-- récupération du nom du fichier
			tell application "Finder" to set the_file to name of (item 1 of the_Droppings as alias)
			
			-- Le nom du fichier ne peut contenir d'espace
			if the_file contains " " then
				display alert "Erreur : le nom du fichier ne peut pas contenir d'espace !" & return & return & "(" & the_file & ")"
				return
			else
				
				-- récupération du chemin POSIX du dossier contenant le fichier
				tell application "Finder" to set the_folder to POSIX path of (container of item 1 of the_Droppings as alias)
				-- display dialog (the_file as string) & return & the_folder as string
				
				set commande1 to ("cd \"" & the_folder as string) & "\""
				-- display dialog commande1
				
				set commande2 to "ftp <<**" & return & "open dl.free.fr" & return & "bin" & return & "prompt" & return & "put \"" & the_file & "\"" & return & "bye" & return & "**" & return
				-- display dialog commande2
				
				-- Si le Terminal est déjà ouvert, on ouvre un nouvel onglet
				if test_process("Terminal") is true then
					--display dialog "On va ajouter un nouvel onglet dans Terminal " buttons {"OK"} default button 1
					do_menu("Terminal", "Shell", "Nouvel onglet")
					set terminalRunning to true
				end if
				
				
				-- On utilise le Terminal car la commande FTP est interactive
				tell application "Terminal"
					activate
					do script commande1 in window 1
					do script commande2 in window 1
					
					
					-- On a besoin de l'utilisateur pour nous dire quand la commande est terminée
					with timeout of 15000 seconds
						display alert "Appuyer sur OK quand la commande est terminée."
					end timeout
					
					
					-- On récupère le résultat de la commande en copiant toute la fenêtre du Terminal (problème de la commande interactive)
					tell front window
						set the clipboard to contents of last tab as text
					end tell
					
				end tell
				
				-- On ferme le Terminal ou l'onglet qu'on vient d'ouvrir
				if terminalRunning is true then
					do_menu("Terminal", "Shell", "Fermer l’onglet")
					--tell front window to close last tab
				else
					tell application "Terminal" to quit
				end if
				
				-- On récupère les liens contenu dans le résultat de la commande qu'on a copié dans le presse-papier
				set monText to ""
				set contenuPressePapier to the clipboard as text
				repeat with i in paragraphs of contenuPressePapier
					set myOffset to (offset of "http://" in i) -- recherche des liens
					if myOffset ≠ 0 then
						-- display alert i
						set maLigne to text myOffset thru (length of i) of i
						set monText to monText & maLigne & return
					end if
				end repeat
				
				set monSujet to "Lien vers fichier : " & the_file
				set contenuMessage to "Lien vers le fichier: " & paragraph 1 of monText & return & "Lien pour supprimer le fichier: " & paragraph 2 of monText & return
				
				tell application "Mail"
					set nouveauMessage to make new outgoing message
					tell nouveauMessage
						set subject to monSujet --(string) : Le sujet du message
						set content to contenuMessage --(string) : Le contenu du message
						set visible to true --(boolean) : Affiche le message à l'écran.		
					end tell
					activate
				end tell
				
			end if
		end if
	end if
end open


(*
Cette fonction est utile pour 2 raisons:
- si on lance le script sans rien déposer dessus, cette fonction explique le rôle du script et propose de choisir le fichier que l'on va utiliser
- si on veut tester le script, sans avoir à créer une application
*)
on run
	choose file with prompt "Choisissez un fichier à déposer sur le serveur FTP de free (dl.free.fr)"
	open {result}
end run