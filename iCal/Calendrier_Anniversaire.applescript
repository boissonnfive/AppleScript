(*
Crée un calendrier "Anniversaires", de couleur "Rouge" à partir des dates d'anniversaire des contacts du carnet d'adresse
Chaque événement a:
 - une alarme qui s'affiche à 12h10 (ET qui sonne!)
 - une alarme mail envoyée 1 jour avant
 
Ajoute 2 alarmes mail pour sa copine (si le champ girlFriendName est renseigné):
 - une alarme 15 jours avant à 7h30
 - une alarme 7 jours avant à 7h30
*)

set calendarName to "Anniversaires_AS"
--log calendarName
set girlFriendName to "Marine Coite"
set the_current_year to year of (current date)
--log the_current_year

tell application "Calendar"
	if exists calendar calendarName then
		delete calendar calendarName
	end if
	make new calendar at end of calendars with properties {name:calendarName, description:"Anniversaires de mes contacts du carnet d'adresses"}
	set the color of calendar calendarName to {65535, 0, 0}
	-- couleur: Rouge, Vert, Bleu
end tell


tell application "Contacts" to repeat with i in (get people whose birth date is not missing value)
	--log i
	tell i to set {the_birthday, the_name} to {birth date, name}
	set the_age to the_current_year - (year of the_birthday)
	tell the_birthday to set year to the_current_year
	-- Si la date est passée on crée un anniversaire pour l'an prochain (sinon problème de gestion des récurrences)
	if the_birthday is less than (current date) then
		tell the_birthday to set year to the_current_year + 1
		set the_age to the_age + 1
	end if
	--log "Nom: " & the_name & return & "Anniversaire: " & the_birthday
	my makeEvents(calendarName, the_birthday, "" & the_name & " a " & the_age & " ans")
end repeat

my addMailAlarms(calendarName, girlFriendName)

(*
Crée un événement anniversaire dans le calendrier
c: nom du calendrier
d: date d'anniversaire
t: description de l'événement
*)
on makeEvents(c, d, t)
	tell application "Calendar"
		set NewEvent to (make new event at end of events of calendar c with properties ¬
			{summary:t, start date:d, allday event:true, recurrence:"FREQ=YEARLY;INTERVAL=1"})
		tell NewEvent
			-- Affiche une alarme qui sonne à 12h10
			make new sound alarm at end with properties {trigger interval:730, sound name:"Basso"}
			-- Création de l'alarme mail 1 jour avant
			set alarmTime to (start date) - 1 * days + 7 * hours
			
			-- Ajout de l'alarme mail à l'événement
			make new mail alarm at end with properties {trigger date:alarmTime}
		end tell
	end tell
end makeEvents

(*
Ajoute des alarmes mail pour sa petite amie
c: calendar name
g: girlfriend name
*)
on addMailAlarms(c, g)
	tell application "Calendar"
		tell calendar c
			repeat with myEvent in every event
				set mySummary to summary of myEvent
				if mySummary contains g then
					display dialog "Evénement trouvé:" & return & mySummary buttons {"OK"} default button 1
					
					-- Création des alarmes (15 jours et 7 jours avant à 7h00)
					set birthdayDate to start date of myEvent
					set alarmTime1 to birthdayDate - 15 * days + 7 * hours
					set alarmTime2 to birthdayDate - 7 * days + 7 * hours
					
					-- Ajout des 2 alarmes mail à l'événement
					make new mail alarm at end of mail alarms of myEvent with properties {trigger date:alarmTime1}
					make new mail alarm at end of mail alarms of myEvent with properties {trigger date:alarmTime2}
				end if
			end repeat
		end tell
	end tell
	return null
end addMailAlarms