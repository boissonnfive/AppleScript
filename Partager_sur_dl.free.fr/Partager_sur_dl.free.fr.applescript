(*
Nom du fichier:	Partager_sur_dl.free.fr.applescript
Auteur:			Bruno Boissonnet
Date:			samedi 5 mars 2016
Description:	Ce script permet de téléverser un fichier sur le site FTP dl.free.fr et d'envoyer un mail d'information.
Remarques:		
				1. Nécessite un compte (gratuit) chez free (adresse@free.fr)
				2. Le fichier à télécharger peut être déposé sur le script
				3. Ne fonctionne qu'avec un fichier (pas un dossier)
				4. Le nom du fichier ne doit pas contenir d'espace ni d'accents
				5. L'application Mail doit être configurée avec un compte
				6. testé sur Mac OS X 10.8 et macOS 10.12.6
*)


property identifiantFTP : "boissonnfive@free.fr"
property motDePasseFTP : "secret"
property serveurFTP : "ftp://dl.free.fr/"
--property nomFichierConfigFTP : ".netrc"
property machineFTP : "dl.free.fr"
property objetMail : "J'ai partagé un fichier sur dl.free.fr : "
property messageLienFichier : "Lien vers le fichier: "
property messageLienSupprimerFichier : "Lien pour supprimer le fichier: "
property salutations1 : "Bonjour,
"
property salutations2 : "Cordialement.
Bruno"



(*
Cette fonction est utile pour 2 raisons:
- si on lance le script sans rien déposer dessus, cette fonction explique le rôle du script et propose de choisir le fichier que l'on va utiliser
- si on veut tester le script, sans avoir à créer une application
*)

(*
Nom          : run
Description : Fonction appelée quand on lance le script
Remarques :
			  Cette fonction est utile pour 2 raisons:
			    - si on lance le script sans rien déposer dessus, cette fonction explique le rôle du script et propose de choisir le fichier que l'on va utiliser
                     	- si on veut tester le script, sans avoir à créer une application
*)
on run
	choose file with prompt "Choisissez un fichier à déposer sur le serveur FTP de free (dl.free.fr)"
	open {result}
end run


(*
Nom                 : open
Description        : Fonction appelée quand on dépose un élément sur le script
elementsDeposes : liste des éléments déposés sur le script
*)
on open elementsDeposes
	
	-- On fait des vérifications sur la liste des objets déposés	
	if (depotEstAutorise(elementsDeposes)) then
		
		-- Envoi du fichier par FTP
		set retourCommande to envoiParFTPAvecCurl(item 1 of elementsDeposes)
		
		-- Filtre le retour de la commande pour récupèrer une liste des liens vers le fichier
		set retourFiltre to filtreRetourCommande(retourCommande)
		
		-- Récupère le nom du fichier
		tell application "Finder" to set nomFichier to name of (item 1 of elementsDeposes as alias)
		
		-- Crée un mail
		if (count of retourFiltre) > 0 then
			set objetMail to objetMail & nomFichier
			set contenuMessage to messageLienFichier & item 1 of retourFiltre & return & messageLienSupprimerFichier & item 2 of retourFiltre & return
			
			creeMail(objetMail, contenuMessage, "")
		end if
	end if
end open

(*
Nom                    : depotEstAutorise
Description           : Vérifie que ce qui est déposé sur le script est autorisé
_elementsDeposes : liste des éléments déposés sur le script
return                  : True si le dépôt est autorisé, False sinon
Restrictions         :
				1. On ne peut déposer qu'un seul élément
				2. L'élément déposé doit être un fichier (pas un dossier)
				3. Le nom de l'élément ne doit pas contenir d'espace
				4. Le nom de l'élément ne doit pas contenir d'accents
*)
on depotEstAutorise(_elementsDeposes)
	set resultat to true
	
	-- 1. On vérifie si l'objet déposé est unique
	
	if (_elementsDeposes's length > 1) then
		display alert "Erreur : On ne peut déposer qu'un seul élément!" & return & return & "(" & (_elementsDeposes as string) & ")"
		set resultat to false
	else
		
		-- 2. On vérifie si l'objet déposé est un fichier
		
		if folder of (info for item 1 of _elementsDeposes) then
			display alert "Erreur : on ne peut pas déposer de dossier!" & return & return & "(" & (item 1 of _elementsDeposes as string) & ")"
			set resultat to false
		else
			
			-- 3. On vérifie si le nom de l'objet contient des espaces
			
			-- récupération du nom du fichier
			tell application "Finder" to set nomFichier to name of (item 1 of _elementsDeposes as alias)
			
			-- Le nom du fichier ne peut contenir d'espace
			if nomFichier contains " " then
				display alert "Erreur : le nom du fichier ne peut pas contenir d'espace !" & return & return & "(" & nomFichier & ")"
				set resultat to false
			else
				
				-- 3. On vérifie si le nom de l'objet contient des accents
				
				-- Le nom du fichier ne peut contenir d'accents
				if contientAccent(nomFichier) is not "" then
					display alert "Erreur : le nom du fichier ne peut pas contenir d'accents !" & return & return & "(" & nomFichier & ")"
					set resultat to false
				end if
			end if
			
			
		end if
	end if
	
	return resultat
end depotEstAutorise


(*
Nom          : envoiParFTPAvecCurl
Description  : Envoi le fichier passé en paramètre par FTP sur dl.free.fr avec la commande curl
fichier      : fichier à envoyer
return       : L'affichage de la commande curl
*)
on envoiParFTPAvecCurl(fichier)
	
	set retCommande to ""
	
	-- récupération du chemin POSIX du dossier contenant le fichier
	tell application "Finder" to set cheminDossierParent to POSIX path of (container of fichier as alias)
	
	-- récupération du nom du fichier
	tell application "Finder" to set nomFichier to name of (fichier as alias)
	
	set commande1 to "cd " & quoted form of (cheminDossierParent as string)
	
	set commande2 to "curl -v -q -T " & quoted form of nomFichier & " -u " & identifiantFTP & ":" & motDePasseFTP & " ftp://dl.free.fr/ 2>&1"
	
	set retCommande to do shell script commande1 & ";" & commande2
	
	return retCommande
	
end envoiParFTPAvecCurl


(*
Nom          : envoiParFTPAvecPython
Description  : Envoi le fichier passé en paramètre par FTP sur dl.free.fr avec la commande curl
fichier      : fichier à envoyer
return       : L'affichage de la commande curl
*)
on envoiParFTPAvecPython(fichier)
	
	set retCommande to ""
	
	-- récupération du chemin POSIX du dossier contenant le fichier
	tell application "Finder" to set cheminDossierParent to POSIX path of (container of fichier as alias)
	
	-- récupération du nom du fichier
	tell application "Finder" to set nomFichier to name of (fichier as alias)
	
	--set commande1 to ("cd \"" & cheminDossierParent as string) & "\""
	set commande1 to "cd " & quoted form of (cheminDossierParent as string)
	
	-- FTP via python
	
	set commande2 to "echo \"import os, ftplib, sys
try:
    free=ftplib.FTP('" & machineFTP & "','" & identifiantFTP & "','" & motDePasseFTP & "')
    print free.getwelcome()
    result=free.storbinary('STOR " & nomFichier & "', open('" & nomFichier & "', 'rb'))
    free.close()                                                             
    print result                                                             
except Exception, err:                                                   
    print err \" | python - "
	
	set retCommande to do shell script commande1 & ";" & commande2
	
	return retCommande
	
end envoiParFTPAvecPython


(*
Nom                 : filtreRetourCommande
Description        : Récupère les liens internet de la chaîne passée en paramètre (un par ligne)
retourCommande : chaîne qui contient des liens internet
return               : Une liste qui contient tous les liens trouvés ou une liste vide.
*)
on filtreRetourCommande(retourCommande)
	set retourFiltre to {}
	
	repeat with i in paragraphs of retourCommande
		set myOffset to (offset of "http://" in i) -- recherche des liens
		if myOffset ≠ 0 then
			set maLigne to text myOffset thru (length of i) of i
			set end of retourFiltre to maLigne
		end if
	end repeat
	
	return retourFiltre
	
end filtreRetourCommande


(*
Nom                  : creeMail
Description         : Crée un mail avec l'application Mail
objet               : Objet du message
contenuMessage : Contenu du message
destinataires    : Liste des destinataires du message

*)
on creeMail(objet, contenuMessage, destinataires)
	
	tell application "Mail"
		set nouveauMessage to make new outgoing message
		tell nouveauMessage
			set subject to objet
			set content to salutations1 & return & contenuMessage & return & return & salutations2
			set visible to true -- Affiche le message à l'écran.
		end tell
		activate
	end tell
	
end creeMail


(*
Nom         : contientAccent
Description : Détermine si la chaîne contient au moins un accent.
chaine      : chaine à tester
return        : le premier accent trouvé ou une chaîne vide.
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


