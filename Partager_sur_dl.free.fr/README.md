# Partager_sur_dl.free.fr.applescript #

## Description ##

Ce script permet de télécharger un fichier sur le site FTP de free : dl.free.fr . (Vous devez avoir un compte chez free)

1. Lancer le script ou déposer un fichier sur le programme (script compilé)
2. Le script lance le Terminal pour envoyer le fichier par FTP
3. Quand l'envoi est terminé (cela peut prendre du temps en fonction de la taille du fichier), le script ouvre un message dans Mail avec le lien pour télécharger et le lien pour supprimer le fichier du serveur.


## Notes de version (à faire)

## A faire ##

- créer des fonctions pour le différentes étapes du script (ex : Récupérer une chaîne de caractère dont on connait le début).
- Mettre à jour les notes de version.

## Ce que j'ai appris avec "Partager_sur_dl.free.fr.applescript"

- Bien formater l'instruction `display dialog` en mettant les textes entre parenthèses.

		display dialog (question) ¬
						default answer ("") ¬
						buttons {"Annuler", "Continuer"} ¬
						default button ("Continuer") ¬
						giving up after 295


- Afficher une boite de dialog qui demande un mot de passe : `with hidden` :

		display dialog (question) ¬
						default answer ("") ¬
						buttons {"Annuler", "Continuer"} ¬
						default button ("Continuer") ¬
						giving up after 295 ¬
						with hidden answer

- Rechercher une chaîne dans du texte : `contains` :

		if contenuPressePapier contains "221 Goodbye." then

- Créer un fichier avec le terminal (pas avec le Finder) :

		do shell script "printf \"machine\\t _machine\\nlogin\\t_login\\npassword\\t_password\\n\" > $HOME/.netrc"

- Récupérer le presse papier :

		set contenuPressePapier to the clipboard as text

- Récupérer une chaîne de caractère dont on connait le début (http://) :

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

- Tester qu'un fichier existe :

		-- When you coerce a path to an "alias" it must exist otherwise you get an error.
		try
			cheminFichierConfigFTP as alias
			--display dialog "it exists"
		on error
			creerFichierConfigFTP()
		end try

- Créer un script « Droplet » :

		on open the_Droppings -- the_Droppings = liste d'objets déposés sur le script
		...
		end open