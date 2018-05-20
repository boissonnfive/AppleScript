---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    Modele.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Modèle, squelette, qui doit servir de base à tout script..
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				    - remarque 1
--				    - remarque 2
--				    - testé sur Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------




(*
Nom			: run 
Description	: Fonction appelée lorsque le script est lancé
argv        	: les arguments du script
retour		: le retour de la dernière instruction
*)
on run argv
	
	repeat with argument in argv
		creeDossier(argument, path to documents folder)
	end repeat
	--creeDossierDansFinder("ASDossier")
	--creeDossier("ASDossier", path to documents folder)
	
end run


(*
Nom				: open
Description		: Fonction appelée quand on dépose un élément sur le script
elementsDeposes	: liste des éléments déposés sur le script
*)
on open elementsDeposes
	
	-- On fait des vérifications sur la liste des objets déposés	
	if (depotEstAutorise(elementsDeposes)) then
		display dialog "Vous avez déposés " & (count of elementsDeposes) & " éléments sur moi."
	end if
	
end open



-----------------------------------------------------------------------------------------------------------
--                                                     FONCTIONS
-----------------------------------------------------------------------------------------------------------


(*
Nom						: depotEstAutorise
Description				: Vérifie que ce qui est déposé sur le script est autorisé
listeAliasElementsDeposes 	: liste des alias des éléments déposés sur le script
return					: True si le dépôt est autorisé, False sinon
Restrictions				:
				1. On ne peut déposer qu'un seul élément
				2. L'élément déposé doit être un fichier (pas un dossier)
				3. Le nom de l'élément ne doit pas contenir d'espace
				4. Le nom de l'élément ne doit pas contenir d'accents
*)
on depotEstAutorise(listeAliasElementsDeposes)
	set resultat to true
	
	-- 1. On vérifie si l'objet déposé est unique
	
	if (listeAliasElementsDeposes's length > 1) then
		display alert "Erreur : On ne peut déposer qu'un seul élément!" & return & return & "(" & (listeAliasElementsDeposes as string) & ")"
		set resultat to false
	else
		
		-- 2. On vérifie si l'objet déposé est un fichier
		
		if folder of (info for item 1 of listeAliasElementsDeposes) then
			display alert "Erreur : on ne peut pas déposer de dossier!" & return & return & "(" & (item 1 of listeAliasElementsDeposes as string) & ")"
			set resultat to false
		else
			
			-- 3. On vérifie si le nom de l'objet contient des espaces
			
			-- récupération du nom du fichier
			tell application "Finder" to set nomFichier to name of (item 1 of listeAliasElementsDeposes as alias)
			
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
Nom                	: creeDossier 
Description       	: Crée un dossier
nomDossier 		: nom du dossier à créer
aliasDestination 	: alias vers l'endroit où créer le dossier
retour			: alias vers le dossier créé
*)
on creeDossier(nomDossier, aliasDestination)
	tell application "Finder"
		set monDossier to make new folder at aliasDestination with properties {name:nomDossier}
	end tell
	return monDossier as alias
end creeDossier



-----------------------------------------------------------------------------------------------------------
--                                                     FIN
-----------------------------------------------------------------------------------------------------------
