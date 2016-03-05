(*
Nom du fichier:	Partager_sur_dl.free.fr.applescript
Auteur:			Bruno Boissonnet
Date:			samedi 5 mars 2016
Description:	Ce script permet de tlcharger un fichier sur le site FTP de free :
                dl.free.fr .
Remarques:		
				1. Ncessite un compte (gratuit) chez free (adresse@free.fr)
				2. Le fichier ˆ tlcharger peut tre dpos sur le script
				3. Ne fonctionne qu'avec un fichier (pas un dossier)
				4. test sur Mac OS X 10.8
*)


(*

Ce script est une droplet qui permet de tlcharger le fichier dpos dessus sur le site FTP de free : dl.free.fr .
Restrictions :
- Le fichier doit tre un ... fichier (pas un dossier!)
- Le nom du fichier ne doit pas comporter d'espace
- Obligation de passer par le Terminal pour obtenir l'adresse du fichier

NOTE:
Il faut crer un fichier ".netrc" dans le dossier utilisateur ($HOME) qui contient les informations pour se connecter automatiquement en FTP:

	$ cat .netrc
	machine  dl.free.fr
	login    boissonnfive@free.fr
	password brunobo

	$ chmod go-r .netrc


*)

property machine : "dl.free.fr"
property nomFichierConfigFTP : ".netrc"
property objetMail : "J'ai partag un fichier sur dl.free.fr : "
property messageLienFichier : "Lien vers le fichier: "
property messageLienSupprimerFichier : "Lien pour supprimer le fichier: "
property salutations1 : "Bonjour,
"
property salutations2 : "Cordialement.
Bruno"




on open the_Droppings
	
	--------------------------------------------------------------------------
	-- 1. Vrifie la prsence du fichier de config FTP
	--    S'il est absent, on le cre ˆ partir des rponses de l'utilisateur
	--------------------------------------------------------------------------
	
	set cheminFichierConfigFTP to (path to home folder as text) & nomFichierConfigFTP
	
	-- When you coerce a path to an "alias" it must exist otherwise you get an error.
	try
		cheminFichierConfigFTP as alias
		display dialog "it exists"
	on error
		creerFichierConfigFTP()
	end try
	
	
	----------------------------------------------------------------------
	-- 2. On vrifie si l'objet dpos est unique et est un fichier
	----------------------------------------------------------------------
	
	set terminalRunning to false
	
	if (the_Droppings's length > 1) then -- on ne gre qu'un seul fichier
		display alert "Erreur : On ne peut dposer qu'un seul lment!" & return & return & "(" & (the_Droppings as string) & ")"
	else
		-- On ne gre que les fichiers, pas les dossiers
		if folder of (info for item 1 of the_Droppings) then
			display alert "Erreur : on ne peut pas dposer de dossier!" & return & return & "(" & (item 1 of the_Droppings as string) & ")"
			return
		else
			
			----------------------------------------------------------------------
			-- 3. On vrifie si l'objet dpos est unique et est un fichier
			----------------------------------------------------------------------
			
			-- rcupration du nom du fichier
			tell application "Finder" to set the_file to name of (item 1 of the_Droppings as alias)
			
			-- Le nom du fichier ne peut contenir d'espace
			if the_file contains " " then
				display alert "Erreur : le nom du fichier ne peut pas contenir d'espace !" & return & return & "(" & the_file & ")"
				return
			else
				
				-- rcupration du chemin POSIX du dossier contenant le fichier
				tell application "Finder" to set the_folder to POSIX path of (container of item 1 of the_Droppings as alias)
				-- display dialog (the_file as string) & return & the_folder as string
				
				set commande1 to ("cd \"" & the_folder as string) & "\""
				-- display dialog commande1
				
				set commande2 to "ftp <<**" & return & "open dl.free.fr" & return & "bin" & return & "prompt" & return & "put \"" & the_file & "\"" & return & "bye" & return & "**" & return
				-- display dialog commande2
				
				-- Si le Terminal est djˆ ouvert, on ouvre un nouvel onglet
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
					
					
					-- On a besoin de l'utilisateur pour nous dire quand la commande est termine
					
					(*
with timeout of 15000 seconds
						display alert "Appuyer sur OK quand la commande est termine."
					end timeout
*)
					
					
					
					set finFTP to false
					
					repeat while finFTP = false
						
						-- On rcupre le rsultat de la commande en copiant toute la fentre du Terminal (problme de la commande interactive)
						tell front window
							set the clipboard to contents of last tab as text
						end tell
						
						set contenuPressePapier to the clipboard as text
						
						log contenuPressePapier
						delay 5
						
						if contenuPressePapier contains "221 Goodbye." then
							set finFTP to true
						end if
						
						
					end repeat
					
				end tell
				
				-- On ferme le Terminal ou l'onglet qu'on vient d'ouvrir
				
				if terminalRunning is true then
					do_menu("Terminal", "Shell", "Fermer lÕonglet")
					--tell front window to close last tab
				else
					tell application "Terminal" to quit
				end if
				
				
				-- On rcupre les liens contenu dans le rsultat de la commande qu'on a copi dans le presse-papier
				set monText to ""
				set contenuPressePapier to the clipboard as text
				repeat with i in paragraphs of contenuPressePapier
					set myOffset to (offset of "http://" in i) -- recherche des liens
					if myOffset ­ 0 then
						-- display alert i
						set maLigne to text myOffset thru (length of i) of i
						set monText to monText & maLigne & return
					end if
				end repeat
				
				-- set monSujet to "Lien vers fichier : " & the_file
				set objetMail to objetMail & the_file
				
				
				(*
set contenuMessage to "Lien vers le fichier: " & paragraph 1 of monText & return & "Lien pour supprimer le fichier: " & paragraph 2 of monText & return
*)
				
				set contenuMessage to messageLienFichier & paragraph 1 of monText & return & messageLienSupprimerFichier & paragraph 2 of monText & return
				
				
				
				tell application "Mail"
					set nouveauMessage to make new outgoing message
					tell nouveauMessage
						set subject to objetMail --(string) : Le sujet du message
						set content to salutations1 & return & contenuMessage & return & return & salutations2 --(string) : Le contenu du message
						set visible to true --(boolean) : Affiche le message ˆ l'cran.		
					end tell
					activate
				end tell
				
			end if
		end if
	end if
end open


(*
Cette fonction est utile pour 2 raisons:
- si on lance le script sans rien dposer dessus, cette fonction explique le r™le du script et propose de choisir le fichier que l'on va utiliser
- si on veut tester le script, sans avoir ˆ crer une application
*)
on run
	choose file with prompt "Choisissez un fichier ˆ dposer sur le serveur FTP de free (dl.free.fr)"
	open {result}
end run


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


-- Test si l'application "processName" est en lance ou pas
on test_process(processName)
	tell application "System Events"
		set myList to (name of every process)
	end tell
	
	return (myList contains processName)
end test_process


on creerFichierConfigFTP()
	
	set _login to demandeInfo("Entrez l'identifiant de connexion ˆ free.fr :", "machin@free.fr")
	
	set _password1 to "password1"
	set _password2 to "password2"
	
	repeat until _password1 = _password2
		
		set _password1 to demandeMotDePasse("Entrez le mot de passe :")
		set _password2 to demandeMotDePasse("Confirmez le mot de passe :")
		
	end repeat
	
	set _password to _password1
	
	do shell script "printf \"machine\\t _machine\\nlogin\\t_login\\npassword\\t_password\\n\" > $HOME/.netro & chmod go-r $HOME/.netro"
	
end creerFichierConfigFTP


on demandeInfo(question, proposition)
	set theResult to ""
	repeat while theResult = ""
		set theResult to text returned of Â
			(display dialog (question) Â
				default answer (proposition) Â
				buttons {"Annuler", "Continuer"} Â
				default button ("Continuer") Â
				giving up after 295)
	end repeat
	return theResult
end demandeInfo

on demandeMotDePasse(question)
	set _reponse to ""
	set _button to "OK"
	repeat while _reponse = "" -- or _button is not equal to "Annuler"
		set _listReponse to Â
			(display dialog (question) Â
				default answer ("") Â
				buttons {"Annuler", "Continuer"} Â
				default button ("Continuer") Â
				giving up after 295 Â
				with hidden answer)
		set _reponse to text returned of _listReponse
		set _button to button returned of _listReponse
	end repeat
	return _reponse
end demandeMotDePasse