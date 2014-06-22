(*

Ce script permet de remplir une facture ˆ partir d'un fichier modle excel.
Il demande :
	- le nom du client (pour chercher son adresse mail et son adresse)
	- la dure d'intervention
	- Le type d'intervention
	- de modifier ou non la date d'intervention

A partir de ces donnes, il cre une facture au format pdf (ˆ partir d'un
 fichier modle excel), sauvegarde dans un dossier factures.

Enfin, il envoie ce fichier au client par courrier lectronique.

NOTES:
- Il faudra remplir plus bas les variables suivante:
	+ cheminFichierModeleFactureExcel : le chemin du fichier modle excel
	 utilis pour crer la facture.
	+ chemindossierFactures : le chemin du dossier o sont archives toutes
	 les factures envoyes au client.
	+ cheminfichierFacture : le chemin o est enregistr la facture avant
	 d'tre insre dans le mail puis dplace dans le dossier Factures.
	C'est ˆ cet endroit que l'on peut retrouver une facture quand quelque
	chose n'a pas bien fonctionn.
	+ monAdresseCourrier : l'adresse utilise pour envoyer le mail.
	+ maSignature : la signature utilise pour envoyer le mail.
	+ monSujet : le sujet du mail.
- La facture :
	+ son nom a le format suivant : "Facture_" + numro ˆ 5 chiffres
	 prcds par des zros + ".pdf" (exemple: Facture_00123.pdf)
	+ son numro est incrment ˆ chaque nouvelle facture
	+ le numro de la facture est retrouv ˆ partir du nom de la dernire
	factures du dossier "Factures", incrment de 1.

*)

----------------------------------------------------------------------------

--property numeroFacture : 223  -- dsormais on retrouve le numro de
-- facture ˆ utiliser ˆ partir du nom de la dernire facture envoye.
property cheminFichierModeleFactureExcel : "/Users/bruno/Documents/binfoservice/Modele_Facture_v0_5.xltx"
property chemindossierFactures : "/Users/bruno/Documents/binfoservice/Factures/"
property cheminfichierFacture : "/Users/bruno/Desktop/.pdf"
property monAdresseCourrier : "binfoservice@gmail.com"
property maSignature : "Signature n¼1"
property monSujet : "Facture BInfoService"

----------------------------------------------------------------------------

(*
  list_position : renvoie la position d'un lment dans une liste.
 this_item : lment ˆ rechercher.
 this_list : liste dans laquelle on recherche.
 rsultat : 0 si non trouv, la position de l'lment
 dans la liste sinon.
*)
on list_position(this_item, this_list)
	
	local position
	set position to 0
	
	repeat with i from 1 to the count of this_list
		
		if item i of this_list is this_item then
			set position to i
		end if
		
	end repeat
	
	return position
	
end list_position


(*
 
  fenetreQuestion : affiche 2 types de fentre.
  
	+ type 1: une fentre qui pose une question ˆ laquelle
	on rpond par "OK" ou "Annuler".
	+ type 2: une fentre qui demande d'entrer un texte.
  
  Pour slectionner le type 1, on met "" dans le paramtre
  reponseProposee. Pour slectionner le type 2, on met une
  cha”ne non vide dans reponseProposee.
  
  La fentre affiche a un bouton "OK", un bouton "Annuler",
  une ic™ne "attention", un titre "Facture" et reste affiche
  300 secondes.
  
  question: une cha”ne de caractre qui correspond ˆ la question
  pose par la fentre.
  
  reponseProposee: un exemple de rponse affich dans un
  champ de texte modifiable. Mettre "" si pas de proposition.
  
  Rsultat: dpend de la forme de la question.
  {button returned: "OK"} pour une question,
  {text returned: "blabla", button returned: "OK"} pour une
  demande de rponse texte.
  
*)
on fenetreQuestion(question, reponseProposee)
	local reponse
	tell application "System Events"
		
		set reponse to missing value
		try
			-- Si on ne mets pas: Cancel button 1
			-- on obtient: error -1708
			if reponseProposee is equal to "" then
				set reponse to display dialog question Â
					buttons {"Annuler", "OK"} Â
					default button 2 Â
					cancel button 1 Â
					with icon caution Â
					with title "Facture" giving up after 300
			else
				set reponse to display dialog question Â
					default answer reponseProposee Â
					buttons {"Annuler", "OK"} Â
					default button 2 Â
					cancel button 1 Â
					with icon caution Â
					with title "Facture" giving up after 300
			end if
		on error errStr number errorNumber
			-- An unknown error occurred. Resignal, so the caller
			-- can handle it, or AppleScript can display the number.
			error errStr number errorNumber
			tell me to quit
		end try
		return reponse
		
	end tell -- application "System Events"
	
end fenetreQuestion

(*
  getDate : renvoie la date au format "lundi 31 mars 2014" ˆ partir
  			d'une date au format "31/03/2014".
 shortDate : date au format "JJ/MM/AAAA".
 rsultat : date au format "jour n¡ jour mois anne".
*)
on getDate(shortDate)
	set bubu to date shortDate
	log bubu
	
	set monInstant to bubu as string
	set mon_jour_semaine_fr to 1st word of monInstant
	set mon_jour_fr to 2nd word of monInstant
	set mon_mois_fr to 3rd word of monInstant
	set mon_annee_fr to 4th word of monInstant
	set mon_heure_fr to 5th word of monInstant
	set ma_minute_fr to 6th word of monInstant
	set ma_seconde_fr to 7th word of monInstant
	return mon_jour_semaine_fr & " " & mon_jour_fr & " " & mon_mois_fr & " " & mon_annee_fr
end getDate



(*
  getNumeroFacture : renvoie le numro de facture ˆ partir du nom du dernier fichier
  			         dans le dossier des factures (Facture_00212.pdf).
 dossierFactures :  dossier contenant les fichiers de facture.
 rsultat :         le numro de facture ˆ utiliser pour facturer.
*)
on getNumeroFacture(dossierFactures)
	
	set listeNomFichiers to {}
	
	tell application "Finder"
		set tousLesFichiers to every file of folder dossierFactures
		repeat with unFichier in tousLesFichiers
			set nomFichier to the name of unFichier
			--set end of listeNomFichiers to nomFichier
		end repeat
		set numeroFacture to text 11 through 13 of nomFichier
		
		return (numeroFacture as integer) + 1
	end tell
	
	
end getNumeroFacture

---------------------------------------------------------------

(* Rcupration du numro de facture *)
set dossierFacturesAlias to (POSIX file chemindossierFactures) as alias
set numeroFacture to getNumeroFacture(dossierFacturesAlias)

(* Validation du numro de facture *)
set message to "Validez-vous le numro de facture suivant ?"
set reponseNumeroFacture to my fenetreQuestion(message, numeroFacture)

if button returned of reponseNumeroFacture is not "OK" then
	
	return -- On quitte le programme

end if


set nomFichierFacture to "Facture_00" & (numeroFacture as string) & ".pdf"
set cheminfichierFacture to "/Users/bruno/Desktop/" & space & nomFichierFacture
set cheminFactureFinal to chemindossierFactures & nomFichierFacture
set signatureMessage to "Signature n¡1"
set contenuMessage1 to "Bonjour,

veuillez trouver ci-jointe la facture de l'intervention du "
set contenuMessage2 to ".

Cordialement.
Bruno.

---

"
set dateDuJourCourte to short date string of (current date) -- format JJ/MM/AAAA
set adresseCourrierClient to ""
set nomClient to ""
set typeIntervention to ""
set dureeIntervention to ""
set dateIntervention to ""
set formeJuridique to "Particulier"
set ficheClient to missing value
----------------------------------------------------------------------------

(* Rcupration du nom du client *)
set nomClient to text returned of my fenetreQuestion("Entrer le nom du client", "Boissonnet")


(* Cherche le client dans l'application Ç Contacts È *)
tell application "Contacts"
	
	(* Rcupration de la fiche client ˆ partir du nom *)
	
	-- Liste de toutes les personnes qui portent ce nom
	set ficheclientTrouvees to every person whose name contains nomClient
	
	if (count of ficheclientTrouvees) = 0 then
		
		(* Aucune personne ne porte ce nom, on dclenche une erreur	*)
		
		error "Aucun contact dont le nom de famille est " & Â
			nomClient & " n'a t trouv." & return & Â
			"Veuillez crer le contact d'abord et relancer le programme."
		
	else if (count of ficheclientTrouvees) = 1 then
		
		(* Une personne porte ce nom, on rcupre sa fiche. *)
		
		set ficheClient to first item of ficheclientTrouvees
		
	else if (count of ficheclientTrouvees) > 1 then
		
		(* 
		  Plusieurs personnes portent ce nom.
		  On met les noms complets (proprit name) dans une liste
		  et on demande ˆ l'utilisateur de slectionner la personne recherche.
		 *)
		
		set nomsClients to {}
		
		repeat with unClient in ficheclientTrouvees
			set end of nomsClients to name of unClient
		end repeat
		
		set listeReponse to choose from list nomsClients Â
			with title Â
			"Facture" with prompt "Il y a plus d'un contact qui porte le nom " & nomClient & return & Â
			"Choisissez dans la liste le contact que vous recherchez." OK button name Â
			"OK" cancel button name Â
			"Annuler" without multiple selections allowed
		
		set nomClient to item 1 of listeReponse
		
		(*
		  De la position du nom dans la liste,
		  on trouve la fiche dans la liste des clients
		*)
		set pos to my list_position(nomClient, nomsClients)
		set ficheClient to item pos of ficheclientTrouvees
		
	end if
	
	
	(* Rcupration du nom complet du client *)
	
	set nomClient to name of ficheClient
	
	(* Rcupration de la forme juridique *)
	if company of ficheClient is true then
		set formeJuridique to "Entreprise"
	end if
	
	
	(* Rcupration de l'adresse mail ˆ partir de la fiche client *)
	
	repeat
		set contactEmail to emails of ficheClient
		if contactEmail ­ {} then
			exit repeat
		else
			display dialog "Pas d'adresse mle trouve pour le client " & nomClient & Â
				return & "Fin du programme." & return Â
				with title Â
				"Facture" buttons {"Terminer"} cancel button "Terminer" default button "Terminer"
		end if
	end repeat
	if (count of contactEmail) > 1 then
		set theEmails to {}
		repeat with anEmail in contactEmail
			set end of theEmails to label of anEmail & ": " & value of anEmail
		end repeat
		set contactEmail to first item of (choose from list theEmails with prompt "Please select an email address:")
		set AppleScript's text item delimiters to ": "
		set adresseCourrierClient to text item -1 of contactEmail
		set AppleScript's text item delimiters to {""}
	else if (count of contactEmail) = 1 then
		set adresseCourrierClient to value of first item of contactEmail
	end if
	
	(* Rcupration de l'adresse ˆ partir de la fiche client *)
	
	set adresseClient to first item of address of ficheClient
	tell adresseClient
		set adresseClientFormatee to street & space & zip & space & city
	end tell
	
	quit
	
end tell -- application "Contacts"

(*

-- Si on est arriv ici, c'est que l'on a toutes les donnes du client
display alert "Nom du client : " & nomClient & return & Â
	"Adresse du client : " & adresseClientFormatee & return & Â
	"Adresse mail du client : " & adresseCourrierClient & return & Â
	"Forme juridique du client : " & formeJuridique
--return
*)



-- Rcupration du type d'intervention
tell application "System Events"
	set reponse to missing value
	try
		-- Si on ne mets pas: Cancel button "Annuler"
		-- on obtient: error -1708
		set reponse to display dialog Â
			"Entrer le type d'intervention" default answer Â
			"Rparation : reinstallation Portable ACER" buttons {"Annuler", "OK"} Â
			default button 2 Â
			cancel button Â
			"Annuler" with icon caution Â
			with title "Facture" giving up after 300
		set typeIntervention to text returned of reponse
	on error
		--display alert "mon erreur"
	end try
end tell

-- Rcupration de la dure de l'intervention
tell application "System Events"
	set reponse to missing value
	try
		-- Si on ne mets pas: Cancel button "Annuler"
		-- on obtient: error -1708
		set reponse to display dialog Â
			"Entrer la dure de l'intervention" default answer Â
			"1,5" buttons {"Annuler", "OK"} Â
			default button 2 Â
			cancel button Â
			"Annuler" with icon caution Â
			with title "Facture" giving up after 300
		set dureeIntervention to text returned of reponse as real
	on error
		--display alert "mon erreur"
	end try
end tell

-- Proposition de modification de la date d'intervention
tell application "System Events"
	set reponse to missing value
	try
		-- Si on ne mets pas: Cancel button "Annuler"
		-- on obtient: error -1708
		set reponse to display dialog Â
			"Valider ou modifier la date de l'intervention" default answer Â
			dateDuJourCourte buttons {"Annuler", "OK"} Â
			default button 2 Â
			cancel button Â
			"Annuler" with icon caution Â
			with title "Facture" giving up after 300
		set dateIntervention to text returned of reponse
	on error
		--display alert "mon erreur"
	end try
end tell


(*

-- Si on est arriv ici, c'est que l'on a toutes les donnes de l'intervention
display alert "Type d'intervention : " & typeIntervention & return & Â
	"Dure de l'intervention : " & dureeIntervention & return & Â
	"Date de l'intervention : " & dateIntervention
--return

*)



(* Cre un fichier excel ˆ partir d'un modle, le modifie en fonction des donnes entres et l'enregistre en pdf sur le bureau. 
Le fichier aura le nom: " Facture_00XXX.pdf" avec une espace devant ajoute automatiquement par excel qui concatne le nom du fichier avec le nom de la feuille de calcul.*)
tell application "Microsoft Excel"
	open cheminFichierModeleFactureExcel as POSIX file
	tell worksheet "Sheet1" of active workbook
		-- Mise ˆ jour du numro de facture (dans les 2 cellules!)
		set value of cell "D4" to numeroFacture
		set value of cell "B11" to numeroFacture
		-- Mise ˆ jour de la date
		set value of cell "B12" to dateDuJourCourte
		-- Mise ˆ jour du nom du client
		set value of cell "B14" to nomClient
		-- Mise ˆ jour de l'adresse du client
		set value of cell "B15" to adresseClientFormatee
		-- Mise ˆ jour de la forme juridique du client
		set value of cell "B16" to formeJuridique
		-- Mise ˆ jour du type d'intervention
		set value of cell "A21" to typeIntervention
		-- Mise ˆ jour de la dure de l'intervention
		set value of cell "C21" to dureeIntervention
		-- Mise ˆ jour du cot de l'intervention
		set value of cell "D21" to dureeIntervention * 20.0
	end tell --worksheet "Sheet1" of active workbook
	
	-- Une fois la facture remplie, on l'enregistre au format PDF
	set name of active sheet to "Facture_00" & (numeroFacture as string)
	tell active sheet to save as filename "Macintosh HD:Users:bruno:Desktop:.pdf" file format PDF file format
	quit without saving
end tell --application "Microsoft Excel"


(*
  On renome le fichier facture correctement (Impossible de le faire depuis Excel)
  et on le dplace dans le dossier des factures.
*)
tell application "Finder"
	
	set fichierFactureAlias to (POSIX file cheminfichierFacture) as alias
	set the name of fichierFactureAlias to nomFichierFacture
	set dossierFacturesAlias to (POSIX file chemindossierFactures) as alias
	try
		-- Si on dplace un fichier, il faut mettre ˆ jour la variable qui pointe dessus
		-- car sinon on ne peut plus l'utiliser
		set myNewFile to move fichierFactureAlias to dossierFacturesAlias
		
	on error
		display alert "Impossible de copier le fichier: " & Â
			cheminfichierFacture & return Â
			& "Un fichier portant le mme nom existe peut-tre djˆ." & return Â
			& "Opration de dplacement annule."
	end try
	
end tell

set dateInterventionFormatLong to getDate(dateIntervention)

(*
Cre le message contenant la facture ˆ envoyer au client.
Impossible d'ajouter la signature avant la pice jointe,
sinon elle est supprime ou considre comme du texte
et plus comme une signature (elle est mme souligne).

Pour rpondre ˆ ce problme, j'ajoute la pice jointe,
j'attends 5 secondes et j'ajoute la signature ˆ la fin
(via l'interface graphique).
*)
tell application "Mail"
	
	activate
	set contenuMessage to contenuMessage1 & dateInterventionFormatLong & contenuMessage2
	set nouveauMessage to make new outgoing message with properties {sender:monAdresseCourrier, subject:monSujet, visible:true, content:contenuMessage}
	
	tell nouveauMessage
		
		make new recipient at end of to recipients with properties {address:adresseCourrierClient}
		
		make new attachment with properties {file name:cheminFactureFinal} -- insr ˆ la fin du message
		delay 5
		
	end tell
	
	(* Insre la signature par GUI Scripting *)
	tell application "System Events"
		tell process "Mail"
			
			tell window 1
				click pop up button 1
				click menu item 3 of menu 1 of pop up button 1
			end tell
			
		end tell
	end tell
end tell


