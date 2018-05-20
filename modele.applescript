---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    Modele.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Mod�le, squelette, qui doit servir de base � tout script..
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				    - remarque 1
--				    - remarque 2
--				    - test� sur Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------




(*
Nom			: run 
Description	: Fonction appel�e lorsque le script est lanc�
argv        	: les arguments du script
retour		: le retour de la derni�re instruction
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
Description		: Fonction appel�e quand on d�pose un �l�ment sur le script
elementsDeposes	: liste des �l�ments d�pos�s sur le script
*)
on open elementsDeposes
	
	-- On fait des v�rifications sur la liste des objets d�pos�s	
	if (depotEstAutorise(elementsDeposes)) then
		display dialog "Vous avez d�pos�s " & (count of elementsDeposes) & " �l�ments sur moi."
	end if
	
end open



-----------------------------------------------------------------------------------------------------------
--                                                     FONCTIONS
-----------------------------------------------------------------------------------------------------------


(*
Nom						: depotEstAutorise
Description				: V�rifie que ce qui est d�pos� sur le script est autoris�
listeAliasElementsDeposes 	: liste des alias des �l�ments d�pos�s sur le script
return					: True si le d�p�t est autoris�, False sinon
Restrictions				:
				1. On ne peut d�poser qu'un seul �l�ment
				2. L'�l�ment d�pos� doit �tre un fichier (pas un dossier)
				3. Le nom de l'�l�ment ne doit pas contenir d'espace
				4. Le nom de l'�l�ment ne doit pas contenir d'accents
*)
on depotEstAutorise(listeAliasElementsDeposes)
	set resultat to true
	
	-- 1. On v�rifie si l'objet d�pos� est unique
	
	if (listeAliasElementsDeposes's length > 1) then
		display alert "Erreur : On ne peut d�poser qu'un seul �l�ment!" & return & return & "(" & (listeAliasElementsDeposes as string) & ")"
		set resultat to false
	else
		
		-- 2. On v�rifie si l'objet d�pos� est un fichier
		
		if folder of (info for item 1 of listeAliasElementsDeposes) then
			display alert "Erreur : on ne peut pas d�poser de dossier!" & return & return & "(" & (item 1 of listeAliasElementsDeposes as string) & ")"
			set resultat to false
		else
			
			-- 3. On v�rifie si le nom de l'objet contient des espaces
			
			-- r�cup�ration du nom du fichier
			tell application "Finder" to set nomFichier to name of (item 1 of listeAliasElementsDeposes as alias)
			
			-- Le nom du fichier ne peut contenir d'espace
			if nomFichier contains " " then
				display alert "Erreur : le nom du fichier ne peut pas contenir d'espace !" & return & return & "(" & nomFichier & ")"
				set resultat to false
			else
				
				-- 3. On v�rifie si le nom de l'objet contient des accents
				
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
Description	: Renvoi un alias � partir d'un chemin POSIX
cheminPOSIX : cha�ne contenant un chemin complet POSIX sur un fichier/dossier
retour		: un alias vers le fichier/dossier
*)

on POSIXVersAlias(cheminPOSIX)
	return (POSIX file cheminPOSIX) as alias
end POSIXVersAlias



(*
Nom       		: aliasVersPOSIX 
Description 	: Renvoi un chemin POSIX � partir d'un alias
cheminAlias	: alias vers un fichier/dossier
retour 		: chaine contenant un chemin POSIX vers le fichier/dossier
*)
on aliasVersPOSIX(cheminAlias)
	return POSIX path of cheminAlias
end aliasVersPOSIX


(*
Nom                	: dossierParent 
Description       	: Renvoi le dossier parent de l'�l�ment pass� en param�tre
aliasElement 		: alias vers l'�l�ment
retour			: alias vers le dossier parent
*)
on dossierParent(monAlias)
	tell application "Finder" to set dossier to container of monAlias
	return (dossier as alias)
end dossierParent


(*
Nom                	: creeDossier 
Description       	: Cr�e un dossier
nomDossier 		: nom du dossier � cr�er
aliasDestination 	: alias vers l'endroit o� cr�er le dossier
retour			: alias vers le dossier cr��
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
