---------------------------------------------------------------------------------------------------------------------------
-- File name	:	sounds.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description :	List of all system sounds to make a choice and return the tried ones.
---------------------------------------------------------------------------------------------------------------------------
-- Remarks	:
--				- From ideas of McUsr, Mr. Science and Nigel Garvey of macscripter.net
--				- tested on Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------


# Main handler
on run
	set linesOfSelectedFiles to ""
	
	# We get the list of system sound as alias
	set mySystemSoundAliasList to getSystemSoundsAliasList()
	
	# We build a list of system sound file name to choose from
	set mySystemSoundNameList to {}
	repeat with i in mySystemSoundAliasList
		set end of mySystemSoundNameList to displayed name of (info for i)
	end repeat
	
	repeat
		
		# We ask the user to pick a sound file
		set selectedSoundFileName to choose from list mySystemSoundNameList Â
			with title ("Play system sounds") Â
			with prompt ("Select a sound to play")
		
		if selectedSoundFileName is false then exit repeat
		
		if linesOfSelectedFiles is not "" then set linesOfSelectedFiles to linesOfSelectedFiles & return
		
		repeat with i in mySystemSoundAliasList
			if displayed name of (info for i) is equal to (selectedSoundFileName as text) then
				repeat 2 times
					playSound(i as alias)
				end repeat
				set linesOfSelectedFiles to linesOfSelectedFiles & POSIX path of i
				exit repeat
			end if
		end repeat
	end repeat
	
	return linesOfSelectedFiles
	
end run


-----------------------------------------------------------------------------------------------------------
--                                                     FUNCTIONS
-----------------------------------------------------------------------------------------------------------

(*
Nom			: getSystemSoundsAliasList 
Description	: returns a list of alias of system sound files
return		: a list of alias of system sound files
*)
on getSystemSoundsAliasList()
	
	set aliasList to {}
	
	set aliasSystemFolder to path to library folder from system domain
	set aliasSystemSoundsFolder to ((aliasSystemFolder as text) & "Sounds") as alias
	
	tell application "Finder" to set nameList to name of every item of aliasSystemSoundsFolder
	
	repeat with i in nameList
		set end of aliasList to ((aliasSystemSoundsFolder as text) & (i as text)) as alias
	end repeat
	
	
	set mySNDS to paragraphs of (do shell script "find '/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds' \\( -type f -not -name '.*' \\)")
	
	repeat with i in mySNDS
		set end of aliasList to (POSIX file (i as text)) as alias
	end repeat
	
	
	return aliasList
	
end getSystemSoundsAliasList

(*
Nom				: playSound 
Description		: play the sound file in parameter
aliasSoundFile		: an alias of the sound file to play
return			: NOTHING (the sound is played)
*)
on playSound(aliasSoundFile)
	do shell script ("/usr/bin/afplay " & quoted form of (POSIX path of aliasSoundFile) as text)
end playSound