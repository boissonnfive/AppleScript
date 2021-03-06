(*
	Liste de fonctions utiles :

		1. String
		2. GUI
		3. Date
		4. Logs
		5. Dialogs
		6. Processus
		7. Système
		8. Fichiers/Dossiers
		9. Mail
*)


--------------------------------------------------------------------------------------------------------------
-- 									STRING
--------------------------------------------------------------------------------------------------------------

(*
Nom			: majuscule 
Description	: Mets les caractères de la chaîne spécifiée en majuscules
chaine		: chaîne à mettre en majuscules
retour		: la chaîne en majuscules
*)
on majuscule(s)
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
end majuscule


(*
Nom			: minuscule 
Description	: Mets les caractères de la chaîne spécifiée en minuscules
chaine		: chaîne à mettre en minuscules
retour		: la chaîne en minuscules
*)
on minuscule(s)
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
end minuscule


(*
Nom			: sousChaine
Description	: Récupère le texte entre les bornes spécifiées
chaine		: chaine à utiliser
debut		: l'indice de début du texte dans la chaîne (doit être >=1)
fin			: l'indice de fin du texte dans la chaîne (doit être <= longueur de la chaîne)
retour		: la sous-chaîne entre les bornes spécifiées ou la chaîne si les bornes sont incorrectes
Remarque 	: 
		   Il est possible de récupérer une sous-chaîne en partant de la fin. Il suffit de donner des valeurs négatives.
		  ex: sub_string(maPhrase, -1, -9) récupère les 9 derniers caractères de la chaîne maPhrase
*)
on sousChaine(chaine, debut, fin)
	try
		return (text (debut) thru (fin) of chaine)
	on error
		return chaine
	end try
end sousChaine



(*
Nom			: SupprimeCaractere
Description	: Supprime le caractère spécifié de la chaine passée en paramètres
chaine		: chaine à modifier
caractere		: le caractère à supprimer
retour		: la chaîne sans le caractère
*)
on SupprimeCaractere(chaine, caractere)
	set nouvelleChaine to ""
	
	repeat with i from 1 to the length of the chaine
		set unCaractere to character i of chaine
		-- log my_char
		if unCaractere is not equal to caractere then
			set nouvelleChaine to nouvelleChaine & unCaractere
		end if
	end repeat
	return nouvelleChaine
end SupprimeCaractere

(*
Nom			: SupprimeCaractere2
Description	: Supprime le caractère spécifié de la chaine passée en paramètres
chaine		: chaine à modifier
caractere		: le caractère à supprimer
retour		: la chaîne sans le caractère
*)
on SupprimeCaractere2(chaine, caractere)
	set prevTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to caractere
	set s to text items of chaine
	set AppleScript's text item delimiters to ""
	set s to s as text
	set AppleScript's text item delimiters to prevTIDs
	
	return s
end SupprimeCaractere2

(*
Nom			: SupprimeLesEspaces
Description	: Une fonction pour supprimer tous les espaces dans une chaîne de caractères
chaine		: le texte contenant des espaces à supprimer
retour		: le texte sans les espaces
Remarque	: l'espace n'est pas toujours le séparateur d'un mot. A voir ...
*)
on SupprimeLesEspaces(chaine)
	set listeDeMots to every word of chaine
	set nouvelleChaine to listeDeMots as text
	return nouvelleChaine
end SupprimeLesEspaces


(*
Nom				: RemplaceCaractere
Description		: Remplace le caractère spécifié de la chaine passée en paramètres par un autre
chaine			: chaine à modifier
ancienCaractere	: le caractère à remplacer
nouveauCaractere	: le nouveau caractère 
retour 			: la chaîne modifiée
*)
on RemplaceCaractere(chaine, ancienCaractere, nouveauCaractere)
	set nouvelleChaine to ""
	
	repeat with i from 1 to the length of the chaine
		set unCaractere to character i of chaine
		-- log my_char
		if unCaractere is equal to ancienCaractere then
			set nouvelleChaine to nouvelleChaine & nouveauCaractere
		else
			set nouvelleChaine to nouvelleChaine & unCaractere
		end if
	end repeat
	return nouvelleChaine
end RemplaceCaractere



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



(*
Nom			: contientAccent
Description	: Détermine si la chaîne contient au moins un accent.
chaine		: chaine à tester
return		: le premier accent trouvé ou une chaîne vide.
*)
on contientAccent(chaine)
	
	set accents to {"à", "á", "â", "ã", "ä", "ç", "è", "é", "ê", "ë", "ì", "í", "î", "ï", "ñ", "ò", "ó", "ô", "õ", "ö", "ù", "ú", "û", "ü", "ý", "ÿ", "À", "Á", "Â", "Ã", "Ä", "Ç", "È", "É", "Ê", "Ë", "Ì", "Í", "Î", "Ï", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "Ù", "Ú", "Û", "Ü", "Ý"}
	
	set ret to ""
	
	repeat with unAccent in accents
		if chaine contains unAccent then
			set ret to unAccent
			exit repeat
		end if
	end repeat
	
	return ret
	
end contientAccent


(*
Nom			: supprimeAccents
Description	: Remplace les caractères accentués par le même caractère non accentué
s			: chaine à utiliser
return		: la chaîne sans accents
*)
on supprimeAccents(s)
	set accents to "àáâãäçèéêëìíîïñòóôõöùúûüýÿÀÁÂÃÄÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ"
	set sansAccents to "aaaaaceeeeiiiinooooouuuuyyAAAAACEEEEIIIINOOOOOUUUUY"
	considering case
		repeat with i from 1 to count of accents
			set AppleScript's text item delimiters to character i of accents
			set s to text items of s
			set AppleScript's text item delimiters to character i of sansAccents
			set s to s as text
		end repeat
	end considering
	set AppleScript's text item delimiters to ""
	return s
end supprimeAccents

(*
Nom			: aLEnvers
Description	: Renvoie la chaîne avec les caractères dans l'ordre inverse
chaine		: chaine à utiliser
return		: la chaîne avec les caractères dans l'ordre inverse
Exemple		: maChaine => eniahCam
*)
on aLEnvers(chaine)
	return (reverse of (characters of chaine)) as text
end aLEnvers

--------------------------------------------------------------------------------------------------------------
-- 									GUI
--------------------------------------------------------------------------------------------------------------

(*
Nom			: UIscript_check
Description	: Vérifie si "Activer l'accès pour les périphériques d'aide" est activé dans les préférences système > Accès Universel (ce qui permet d'utiliser les fonctionnalité de script GUI)
retour		: RIEN
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
Nom			: do_menu
Description	: Clique un menu d'une application
app_name	: nom de l'application
menu_name	: nom exact du menu
menu_item	: nom exact du sous-menu
Remarques	:  
 			exemple pour l'application Éditeur AppleScript:
 			Menu Présentation > Masquer la barre de navigation
 			my do_menu("Présentation", "Masquer la barre de navigation") 
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
Nom				: do_submenu
Description		: Clique un sous-menu d'une application
app_name		: nom de l'application
menu_name		: nom exact du menu
menu_item		: nom exact du sous-menu
submenu_item 	: nom exact du sous-menu visé
Remarques 		:
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


(*
Nom								: clicEnregisterSous10_12
Description						: Manipule la fenêtre « Enregistrer sous » de macOS 10.12 .
nomApplication					: Nom de l'application dont on doit manipuler la fenêtre « Enregistrer sous ».
nomEnregistrement				: Nom sous lequel on foit faire l'enregistrement.
cheminPOSIXDossierEnregistrement	: Chemin POSIX du dossier dans lequel on doit faire l'enregistrement.
nomNouveauDossier				: Nom du nouveau dossier à créer
Résultat							: RIEN.
*)
on clicEnregisterSous10_12(nomApplication, nomEnregistrement, cheminPOSIXDossierEnregistrement, nomNouveauDossier)
	
	-- bring the target application to the front
	tell application nomApplication
		activate
	end tell
	tell application "System Events"
		tell process nomApplication
			
			-- 1°) On affiche la fenêtre « Enregistrer sous » maximale
			
			set triangleDExpansion to item 1 of ((every UI element of sheet 1 of window 1) whose role is "AXDisclosureTriangle")
			
			if value of triangleDExpansion is 0 then
				click triangleDExpansion
			end if
			
			
			-- 2°) On rempli le champ "Enregistrer sous : "
			
			if nomEnregistrement is not "" then
				set value of (UI element 7 of sheet 1 of window 1) to nomEnregistrement
			end if
			
			-- 3°) On sélectionne le dossier d'enregistrement (Le bureau par défaut)
			
			if cheminPOSIXDossierEnregistrement is "" then
				set cheminPOSIXDossierEnregistrement to POSIX path of (path to desktop)
			end if
			
			keystroke "g" using {command down, shift down}
			-- Impossible d'avoir accès à la feuille ?
			keystroke cheminPOSIXDossierEnregistrement
			keystroke return -- ou space ou tab
			
			
			-- 4°) On crée un nouveau dossier s'il le faut
			
			if nomNouveauDossier is not "" then
				-- button "Nouveau dossier" of sheet 1 of window "Contacts" of application process "Contacts" of application "System Events"
				click (UI element 3 of sheet 1 of window 1)
				set value of (UI element 1 of window 1) to nomNouveauDossier
				click (UI element 2 of window 1)
			end if
			
			
			-- 5°) On clique sur le bouton "Enregistrer"
			
			--click button "Enregistrer" of sheet 1 of window 1
			click UI element 1 of sheet 1 of window 1
			
		end tell
	end tell
	
end clicEnregisterSous10_12


--------------------------------------------------------------------------------------------------------------
-- 									DATE
--------------------------------------------------------------------------------------------------------------

(*
Nom			: makeDateFr
Description	: Permet de récupérer les éléments de la date en français
Remarques 	:
				1. Créer la date en français avec la méthode makeDateFr
				2. appeler les propriétés jour_semaine, jour, mois, annee, heure, minute, seconde of monObjet DateFr
Exemple		:
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


--------------------------------------------------------------------------------------------------------------
-- 									LOGS
--------------------------------------------------------------------------------------------------------------


(*
Nom			: creerUnCheminDeFichierLog
Description	: Renvoi un chemin vers un fichier de log dans ~/Library/Logs/
retour		: Un chemin vers un fichier de log dans ~/Library/Logs/.
Remarques	: Le nom du fichier de log est nom-du-script-sans-extension.log
			  Le nom complet est donc : ~/Library/Logs/nom-du-script-sans-extension.log
*)

on creerUnCheminDeFichierLog()
	set libAlias to path to library folder from user domain
	return ((POSIX path of libAlias) as text) & "Logs/" & nomSansExtension(path to me) & ".log"
end creerUnCheminDeFichierLog


(*
Nom			: traceDansFichier
Description	: Écrit une ligne (en UTF-8) à la fin du fichier referenceVersFichierLog.
ligne			: le texte à écrire dans le fichier.
retour		: RIEN.
*)
on traceDansFichier(ligne)
	
	set fichierLogPOSIX to (POSIX file creerUnCheminDeFichierLog())
	
	set ligne to ligne & return
	
	try
		set referenceVersFichierLog to open for access fichierLogPOSIX with write permission
		write ligne to referenceVersFichierLog starting at eof as «class utf8»
		close access referenceVersFichierLog
	on error errStr number errorNumber
		display alert errStr & " (" & errorNumber & ")"
		try
			close access referenceVersFichierLog
		end try
	end try
	
end traceDansFichier


--------------------------------------------------------------------------------------------------------------
-- 									Dialogs
--------------------------------------------------------------------------------------------------------------

(*
Nom			: demandeInfo
Description	: Affiche une boîte de dialogue qui permet de rentrer du texte
question		: Question pour demander le texte.
proposition	: Suggestion de texte à écrire.
Résultat		: Le texte entré par l'utilisateur.
*)
on demandeInfo(question, proposition)
	set reponse to ""
	repeat while reponse = ""
		set reponse to text returned of ¬
			(display dialog (question) ¬
				default answer (proposition) ¬
				buttons {"Annuler", "Continuer"} ¬
				default button ("Continuer") ¬
				giving up after 295)
	end repeat
	return reponse
end demandeInfo


(*
Nom			: demandeMotDePasse
Description	: Affiche une boîte de dialogue qui permet de rentrer un mot de passe (caché)
question		: Question pour demander le mot de passe.
Résultat		: Le mot de passe entré par l'utilisateur.
*)
on demandeMotDePasse(question)
	set reponse to ""
	set bouton to "OK"
	repeat while reponse = "" -- or _button is not equal to "Annuler"
		set listeReponse to ¬
			(display dialog (question) ¬
				default answer ("") ¬
				buttons {"Annuler", "Continuer"} ¬
				default button ("Continuer") ¬
				giving up after 295 ¬
				with hidden answer)
		set reponse to text returned of listeReponse
		set bouton to button returned of listeReponse
	end repeat
	return reponse
end demandeMotDePasse


--------------------------------------------------------------------------------------------------------------
-- 									PROCESSUS
--------------------------------------------------------------------------------------------------------------


(*
Nom			: processusEstLance
Description	: Test si l'application "processName" est lancée ou pas
processName	: Nom de l'application
Résultat		: True si l'application est lancée, False sinon.
*)
on processusEstLance(processName)
	return application processName is running
end processusEstLance


(*
on processusEstLance(processName)
	tell application "System Events"
		return (exists process processName)
	end tell
end processusEstLance
*)


--------------------------------------------------------------------------------------------------------------
-- 									SYSTÈME
--------------------------------------------------------------------------------------------------------------

(*
Nom			: nomOrdinateur
Description	: Renvoi le nom de l'ordinateur
Résultat		: Le nom de l'ordinateur.
*)
on nomOrdinateur()
	system info
	return computer name of result
end nomOrdinateur


(*
Nom			: nomUtilisateur
Description	: Renvoi le nom de l'utilisateur
Résultat		: Le nom de l'utilisateur.
*)
on nomUtilisateur()
	system info
	return short user name of result
end nomUtilisateur


(*
Nom			: nomUtilisateurComplet
Description	: Renvoi le nom complet de l'utilisateur
Résultat		: Le nom complet de l'utilisateur.
*)
on nomUtilisateurComplet()
	system info
	return long user name of result
end nomUtilisateurComplet


(*
Nom			: versionSysteme
Description	: Renvoi la version du système
Résultat		: La version du système.
Exemple		: 10.12.6
*)
on versionSysteme()
	system info
	return system version of result
end versionSysteme


(*
Nom			: versionSystemeCourte
Description	: Renvoi seulement les deux premiers nombres de la version du système
Résultat		: La version coute du système.
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
Nom                	: versionApplication 
Description       	: Renvoi la version de l'application
aliasApplication 	: alias vers l'application
retour			: chaine contenant le numéro de version de l'application
*)
on versionApplication(aliasApplication)
	return do shell script "defaults read " & quoted form of ((POSIX path of aliasApplication) & "Contents/Info.plist") & " CFBundleShortVersionString"
end versionApplication


(*
Nom			: adresseIP
Description	: Renvoi l'adresse IP en cours
Résultat		: L'adresse IP en cours.
*)
on adresseIP()
	system info
	return IPv4 address of result
end adresseIP


--------------------------------------------------------------------------------------------------------------
-- 									FICHIERS/DOSSIERS
--------------------------------------------------------------------------------------------------------------


(*
Nom			: POSIXVersAlias 
Description	: Renvoi un alias à partir d'un chemin POSIX
cheminPOSIX : chaîne contenant un chemin complet POSIX sur un fichier/dossier
retour		: un alias vers le fichier/dossier
*)
on POSIXVersAlias(cheminPOSIX)
	return (POSIX file cheminPOSIX) as alias
end POSIXVersAlias


(*
Nom       		: aliasVersPOSIX 
Description 	: Renvoi un chemin POSIX à partir d'un alias
cheminAlias	: alias vers un fichier/dossier
retour 		: chaine contenant un chemin POSIX vers le fichier/dossier
*)
on aliasVersPOSIX(cheminAlias)
	return POSIX path of cheminAlias
end aliasVersPOSIX

(*
Nom			: nomSansExtension
Description	: Renvoi le nom du fichier sans extension.
Résultat		: Le nom du fichier sans extension.
Exemple		: Facture_00471.pdf => Facture_00471
*)
on nomSansExtension(aliasFichier)
	info for aliasFichier
	set nomFichier to name of result
	set ATID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "."
	set s to text items of nomFichier -- {nom, extension}
	set nomFichier to item 1 of s
	set AppleScript's text item delimiters to ATID
	return nomFichier
end nomSansExtension


(*
Nom                	: dossierParent 
Description       	: Renvoi le dossier parent de l'élément passé en paramètre
aliasElement 		: alias vers l'élément
retour			: alias vers le dossier parent
*)
on dossierParent(monAlias)
	tell application "Finder" to set dossier to container of monAlias
	return (dossier as alias)
end dossierParent


(*
Nom				: creeDossier
Description		: Crée un dossier à l'endroit indiqué
nomDossier		: Nom du dossier à créer
aliasDestination	: alias vers l'endroit où créer le nouveau dossier
Résultat			: un alias du nouveau dossier
Remarque		: Si le dossier existe déjà, une fenêtre de dialogue s'ouvre et on renvoie un alias vers cet élément.
*)
on creeDossier(nomDossier, aliasDestination)
	tell application "Finder"
		try
			set retour to make new folder at aliasDestination with properties {name:nomDossier}
		on error
			display alert "Le dossier " & nomDossier & " existe déjà!"
			set retour to folder nomDossier of aliasDestination
		end try
	end tell
	return retour
end creeDossier


(*
Nom                	: creeAlias 
Description       	: Crée un raccourci (alias) vers un élément
aliasElement 		: alias vers l'élément
aliasDestination 	: alias vers l'endroit où créer le raccourci
retour			: alias vers le raccourci créé
*)
on creeAlias(aliasElement, aliasDestination)
	tell application "Finder"
		set monAlias to make new alias at aliasDestination to aliasElement
	end tell
	return monAlias as alias
end creeAlias


(*
Nom                	: copieDansDossier 
Description       	: Copie un élément à l'endroit indiqué
aliasACopier 		: alias vers l'élément à copier
aliasDestination 	: alias vers l'endroit où copier l'élément
retour			: alias vers l'élément copié
*)
on copieElement(aliasElement, aliasDestination)
	tell application "Finder"
		set fichierCopie to duplicate aliasElement to aliasDestination
	end tell
	return fichierCopie as alias
end copieElement


(*
Nom				: deplaceElement
Description		: Déplace un élément à l'endroit indiqué
nomDossier		: alias de l'élément à déplacer
aliasDossierParent	: alias du dossier qui va contenir l'élément
Résultat			: un alias vers l'élément déplacé
Remarque		: Si un élément portant le même nom existe déjà, une fenêtre de dialogue s'ouvre et on renvoie un alias vers cet élément.
*)
on deplaceElement(aliasElement, aliasDestination)
	tell application "Finder"
		try
			set retour to move aliasElement to aliasDestination
		on error
			display alert "Impossible de déplacer ce dossier, car un dossier du même nom existe déjà."
			
			set nomElement to name of aliasElement
			set nomCompletElement to (aliasDestination as text) & nomElement
			set retour to nomCompletElement as alias
		end try
	end tell
	return retour
end deplaceElement


(*
Nom             : supprimeElement 
Description     : Supprime un élément
aliasElement 	: alias vers l'élément à supprimer
retour			: RIEN
*)
on supprimeElement(aliasElement)
	tell application "Finder" to delete aliasElement
end supprimeElement


(*
Nom					: elementExiste
Description			: Détermine si un élément existe ou pas
cheminPOSIXElement	: chemin POSIX de l'élément
Résultat				: true si l'élément existe, false sinon.
Remarque			: Créer un alias sur un élément qui n'existe pas provoque une exception.
*)
on elementExiste(cheminPOSIXElement)
	try
		set retour to (POSIX file cheminPOSIXElement) as alias
		set retour to true
	on error
		set retour to false
	end try
	return retour
end elementExiste

(*
on elementExiste(aliasElement)
	tell application "Finder"
		set retour to exists aliasElement
	end tell
	return retour
end elementExiste
*)


(*
Nom                	: renommeElement 
Description       	: Renomme un élément du Finder (fichier/dossier/alias)
aliasElement 		: alias vers l'élément
nouveauNom	 	: nouveau nom de l'élément
retour			: RIEN
*)
on renommeElement(aliasElement, nouveauNom)
	tell application "Finder" to set name of aliasElement to nouveauNom
end renommeElement


(*
Nom                	: renommeApplication 
Description       	: Renomme une application du Finder
aliasElement 		: alias vers l'application
nouveauNom	 	: nouveau nom de l'application
retour			: RIEN
*)
on renommeApplication(aliasElement, nouveauNom)
	tell application "Finder"
		set name of aliasElement to nouveauNom & ".app"
	end tell
end renommeApplication



(*
Nom					: cheminDeLaRessource
Description			: Récupère l'alias de la ressource dont le nom est spécifié
nomDeLaRessource	: le nom de la ressource (fichier).
retour				: l'alias vers la ressource.
*)

on aliasDeLaRessource(nomDeLaRessource)
	
	set aliasScriptBash to missing value
	# Récupération du chemin du script bash qui récupère le menu du jour
	# En mise au point on demande le fichier à l'utilisateur
	# En production on utilise un chermin relatif vers le dossier "Resources"
	set cheminASScript to (path to me) as text
	--traceDansFichier("Chemin du script AS   : " & POSIX path of cheminASScript)
	
	if cheminASScript contains "Applications" then
		set aliasScriptBash to (path to resource nomScriptBash)
	else
		--set aliasCheminScriptBash to choose file with prompt "Indiquez le script cantine.sh"
		--set cheminScriptBash to POSIX path of aliasCheminScriptBash --"/Users/bruno/Desktop/Bash/cantine.sh"
		set aliasScriptBash to choose file with prompt "Indiquez le script cantine.sh"
	end if
	
	return aliasScriptBash
	
end aliasDeLaRessource


--------------------------------------------------------------------------------------------------------------
-- 									MAIL
--------------------------------------------------------------------------------------------------------------




(*
Nom       			: envoieAvecMail 
Description 		: Crée et envoie un mail avec Mail
adresseExpediteur	: L'adresse de l'expéditeur au format "Description <adresse@mail.com>"
listeDestinataires	: Liste contenant des adresses de destinataires ("adresse@mail.com")
sujetMessage		: Sujet du message
contenuMessage	: Contenu du message
listeAliasPJ		: Liste contenant des alias vers les pièces jointes à ajouter au message
nomSignature		: Nom de la signature à ajouter
envoi			: indique si on envoie le mail ou pas
retour 			: true if sending was successful, false if not
Remarque		: La fenêtre du mail doit être affichée.
*)
on envoieAvecMail(adresseExpediteur, listeDestinataires, sujetMessage, contenuMessage, listeAliasPJ, nomSignature, envoi)
	
	(*
         Impossible d'ajouter la signature avant la pièce jointe,
         sinon elle est supprimée ou considérée comme du texte
         et non plus comme une signature (elle est même soulignée).
         
         Pour répondre à ce problème, j'ajoute la pièce jointe,
         j'attends 5 secondes et j'ajoute la signature à la fin
         (via l'interface graphique).
         *)
	
	set retour to false
	set messageVisible to true -- Obligatoire pour utiliser le GUI Scripting pour la signature
	
	tell application "Mail"
		
		activate
		
		set nouveauMessage to make new outgoing message with properties {sender:adresseExpediteur, subject:sujetMessage, visible:messageVisible, content:contenuMessage}
		
		tell nouveauMessage
			
			repeat with adresseDestinataire in listeDestinataires
				make new recipient at end of to recipients with properties {address:adresseDestinataire}
			end repeat
			
			if listeAliasPJ is not missing value then
				repeat with aliasPJ in listeAliasPJ
					make new attachment with properties {file name:aliasPJ} -- inséré à la fin du message
					delay 1
				end repeat
			end if
			
		end tell
		
		activate
		
		(* Insère la signature par GUI Scripting *)
		
		if nomSignature is not missing value then
			my ajouteSignatureDansMail(nomSignature)
		end if
		
		if envoi then
			set retour to send nouveauMessage
		end if
		
	end tell
	
	return retour
	
end envoieAvecMail


(*
Nom       		: ajouteSignatureDansMail 
Description 	: Ajoute une signature au mail en cours par GUI Scripting
nomSignature	: Le nom de la signature à ajouter
retour 		: RIEN
Remarque	: La fenêtre du mail doit être affichée.
*)
on ajouteSignatureDansMail(nomSignature)
	tell application "System Events"
		tell process "Mail"
			--delay 1.3
			tell window 1
				--get every UI element
				tell pop up button 2
					click
					click menu item nomSignature of menu 1
				end tell
			end tell
			
		end tell
	end tell
end ajouteSignatureDansMail
