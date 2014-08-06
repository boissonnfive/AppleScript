(*
Crée un calendrier "Anniversaires_AS", de couleur "Rouge" à partir des dates d'anniversaire des contacts du carnet d'adresse.

Chaque événement a :

 - une alarme sonore qui s'affiche le jour même à 12h10 (voir soundAlarmTime)
 - une alarme mail envoyée 1 jour avant à 7 heures (voir mailAlarmTime1 et mailAlarmDay1)
 
Ajoute 2 alarmes mail pour sa copine (si le champ girlFriendName est renseigné) :

 - une alarme 15 jours avant à 7 heures (voir mailAlarmDay2 et mailAlarmTime2)
 - une alarme 7 jours avant à 7 heures  (voir mailAlarmDay3 et mailAlarmTime3)
 
NOTES :

- Il faudra remplir plus bas les variables suivantes :

	+ calendarName : le nom du calendrier des anniversaires.
	+ calendarColor : la couleur du calendrier des anniversaires.
	+ calendarDescription : description du calendrier des anniversaires.
	+ girlFriendName : Le nom complet de sa petite amie.
	+ soundAlarmTime : Heure du rappel sonore le jour même (en minutes par rapport à minuit => 730 minutes = 12h10).
	+ soundAlarmSound : Musique du rappel sonore.
	+ mailAlarmTime1 : Heure du rappel par mail (en heure par rapport à minuit => 7 = 7 heures).
	+ mailAlarmDay1 : Nombre de jours avant l'événement du rappel par mail (1 = 1 jour avant).
	+ mailAlarmTime2 : idem mailAlarmTime1 mais pour le premier  rappel de la copine.
	+ mailAlarmDay2 : idem mailAlarmDay1 mais pour le premier rappel de la copine.
	+ mailAlarmTime3 : idem mailAlarmTime1 mais pour le second  rappel de la copine.
	+ mailAlarmDay3 : idem mailAlarmDay1 mais pour le second rappel de la copine.
	 
 
*)

----------------------------------------------------------------------------


property calendarName : "Test_AS" -- Attention à ne pas mette le nom d'un calendrier qui existe (voir fonction creerCalendrier)
property calendarColor : {65535, 65535, 0} -- jaune    {Rouge, Vert, Bleu}
property calendarDescription : "Anniversaires de mes contacts"
property girlFriendName : "Marine Coite"
property soundAlarmTime : 730 -- rappel sonore le jour même à 12h10 (730 minutes = 12h10)
property soundAlarmSound : "Basso" -- musique du rappel sonore
property mailAlarmTime1 : 7 -- mail envoyé à 7 heures
property mailAlarmDay1 : 1 -- mail envoyé 1 jour avant
property mailAlarmTime2 : 7 -- mail envoyé à 7 heures
property mailAlarmDay2 : 15 -- mail envoyé 15 jours avant
property mailAlarmTime3 : 7 -- mail envoyé à 7 heures
property mailAlarmDay3 : 7 -- mail envoyé 7 jours avant

----------------------------------------------------------------------------

(* Récupération de l'année en cours *)

set currentYear to year of (current date)
--log currentYear


(* Récupération des contacts qui ont une date d'anniversaire *)
(* On récupère une liste {{date d'anniversaire, nom}, {date d'anniversaire, nom} ...} *)

set listeContactAnniversaire to my lireContactAnniversaire()
--log listeContactAnniversaire


(* Création du calendrier des anniversaires *)

my creerCalendrier(calendarName, calendarDescription, calendarColor)


(* Pour chaque élément de la liste, on crée un événement anniversaire avec rappel *)

repeat with i in listeContactAnniversaire
	--log i
	
	set contactBirthday to item 1 of i
	set contactName to item 2 of i
	
	(* On calcule l'âge de chaque contact *)
	set contactAge to currentYear - (year of contactBirthday)
	
	(* La date de l'événement est la date de la naissance *)
	(* Mais l'année est l'année en cours ... *)
	set eventDate to contactBirthday
	tell eventDate to set year to currentYear
	
	(* ... Ou l'année prochaine si la date est déjà passée (sinon problème avec les dates récurrentes) *)
	if eventDate is less than (current date) then
		tell eventDate to set year to currentYear + 1
		set contactAge to contactAge + 1
	end if
	
	--log "Nom: " & contactName & return & "Anniversaire: " & contactBirthday & return & "Age: " & contactAge
	
	set evtDescription to "" & contactName & " a " & contactAge & " ans"
	
	set evtAnniversaire to my creerEvtAnniversaire(calendarName, eventDate, evtDescription)
	
	my ajouterAlarme(evtAnniversaire, soundAlarmTime, soundAlarmSound)
	
	my ajouterRappelMail(evtAnniversaire, mailAlarmDay1, mailAlarmTime1)
	
	if girlFriendName is not equal to "" and contactName is equal to girlFriendName then
		
		my ajouterRappelMail(evtAnniversaire, mailAlarmDay2, mailAlarmTime2)
		my ajouterRappelMail(evtAnniversaire, mailAlarmDay3, mailAlarmTime3)
		--log "addMailAlarms : " & calendarName & ", " & girlFriendName
		
	end if
	
end repeat

(* FIN DU PROGRAMME *)
----------------------------------------------------------------------------


(*
  lireContactAnniversaire : Récupération d'une liste {{date d'anniversaire, nom}, {date d'anniversaire, nom} ...}.
  
  1. Recherche dans l'application "Contacts" les personnes dont la date d'anniversaire est renseignée. 
  2. Pour chaque personne, récupére une liste {date d'anniversaire, nom}.
  3. Ajoute cette liste à la liste totale.
  
  return : liste {{date d'anniversaire, nom}, {date d'anniversaire, nom} ...} ou {}
  
*)
on lireContactAnniversaire()
	set _listeContactAnniversaire to {}
	
	tell application "Contacts"
		
		(* On recherche tous les contacts qui possèdent une date de naissance *)
		repeat with i in (get people whose birth date is not missing value)
			--log i
			
			(* On récupère la date de naissance et le nom de chaque contact *)
			tell i to set {contactBirthday, contactName} to {birth date, name}
			set end of _listeContactAnniversaire to {contactBirthday, contactName}
			--log _listeContactAnniversaire
			
		end repeat
		
	end tell
	
	return _listeContactAnniversaire
	
end lireContactAnniversaire



(*
  creerCalendrier : création du calendrier.
  
  1. Recherche dans l'application "Calendrier" un calendrier qui porte le nom "calendarName". 
  2. S'il existe, on l'efface.
  3. Sinon, on créer ce calendrier avec le nom et la couleur passés en paramètres.
  
  _calendarName : nom du calendrier à créer
 _calendarDescription : description du calendrier à créer
  _calendarColor : couleur du calendrier à créer
  
*)
on creerCalendrier(_calendarName, _calendarDescription, _calendarColor)
	set _calendrierAnniversaire to missing value
	
	tell application "Calendar"
		if exists calendar _calendarName then
			delete calendar _calendarName
		end if
		set _calendrierAnniversaire to make new calendar at end of calendars with properties {name:_calendarName, description:_calendarDescription}
		set the color of _calendrierAnniversaire to _calendarColor
	end tell
	
	return _calendrierAnniversaire
end creerCalendrier


(*
  creerEvtAnniversaire : Crée un événement anniversaire dans le calendrier
  
  _calendarName : nom du calendrier  
  _birthdayDate : date de l'événement
  _evtDescription : titre de l'événement
*)
on creerEvtAnniversaire(_calendarName, _birthdayDate, _evtDescription)
	
	set _evtAnniversaire to missing value
	
	tell application "Calendar"
		set _evtAnniversaire to (make new event at end of events of calendar _calendarName with properties ¬
			{summary:_evtDescription, start date:_birthdayDate, allday event:true, recurrence:"FREQ=YEARLY;INTERVAL=1"})
	end tell
	
	return _evtAnniversaire
end creerEvtAnniversaire


(*
  ajouterAlarme : Ajoute une alarme sonore à l'événement
  
  _evtAnniversaire : événement anniversaire créé dans un calendrier
  _soundAlarmTime : heure du rappel le jour de l'événement
  _soundAlarmSound : son du rappel
*)
on ajouterAlarme(_evtAnniversaire, _soundAlarmTime, _soundAlarmSound)
	
	tell application "Calendar"
		
		tell _evtAnniversaire
			
			make new sound alarm at end with properties {trigger interval:_soundAlarmTime, sound name:_soundAlarmSound}
		end tell
		
	end tell
end ajouterAlarme


(*
  ajouterRappelMail : Ajoute un rappel par mail à l'événement
  
  _evtAnniversaire : événement anniversaire créé dans un calendrier
  _mailAlarmDay1 : nombre de jour avant l'événement où doit être envoyé le mail
  _mailAlarmTime1 : heure d'envoi du mail
*)
on ajouterRappelMail(_evtAnniversaire, _mailAlarmDay1, _mailAlarmTime1)
	
	tell application "Calendar"
		
		tell _evtAnniversaire
			
			set alarmTime to (start date) - _mailAlarmDay1 * days + _mailAlarmTime1 * hours
			make new mail alarm at end with properties {trigger date:alarmTime}
			
		end tell
		
	end tell
end ajouterRappelMail


