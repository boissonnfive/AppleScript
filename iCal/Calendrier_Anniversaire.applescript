(*
Cr�e un calendrier "Anniversaires_AS", de couleur "Rouge" � partir des dates d'anniversaire des contacts du carnet d'adresse.

Chaque �v�nement a :

 - une alarme sonore qui s'affiche le jour m�me � 12h10 (voir soundAlarmTime)
 - une alarme mail envoy�e 1 jour avant � 7 heures (voir mailAlarmTime1 et mailAlarmDay1)
 
Ajoute 2 alarmes mail pour sa copine (si le champ girlFriendName est renseign�) :

 - une alarme 15 jours avant � 7 heures (voir mailAlarmDay2 et mailAlarmTime2)
 - une alarme 7 jours avant � 7 heures  (voir mailAlarmDay3 et mailAlarmTime3)
 
NOTES :

- Il faudra remplir plus bas les variables suivantes :

	+ calendarName : le nom du calendrier des anniversaires.
	+ calendarColor : la couleur du calendrier des anniversaires.
	+ calendarDescription : description du calendrier des anniversaires.
	+ girlFriendName : Le nom complet de sa petite amie.
	+ soundAlarmTime : Heure du rappel sonore le jour m�me (en minutes par rapport � minuit => 730 minutes = 12h10).
	+ soundAlarmSound : Musique du rappel sonore.
	+ mailAlarmTime1 : Heure du rappel par mail (en heure par rapport � minuit => 7 = 7 heures).
	+ mailAlarmDay1 : Nombre de jours avant l'�v�nement du rappel par mail (1 = 1 jour avant).
	+ mailAlarmTime2 : idem mailAlarmTime1 mais pour le premier  rappel de la copine.
	+ mailAlarmDay2 : idem mailAlarmDay1 mais pour le premier rappel de la copine.
	+ mailAlarmTime3 : idem mailAlarmTime1 mais pour le second  rappel de la copine.
	+ mailAlarmDay3 : idem mailAlarmDay1 mais pour le second rappel de la copine.
	 
 
*)

----------------------------------------------------------------------------


property calendarName : "Test_AS" -- Attention � ne pas mette le nom d'un calendrier qui existe (voir fonction creerCalendrier)
property calendarColor : {65535, 65535, 0} -- jaune    {Rouge, Vert, Bleu}
property calendarDescription : "Anniversaires de mes contacts"
property girlFriendName : "Marine Coite"
property soundAlarmTime : 730 -- rappel sonore le jour m�me � 12h10 (730 minutes = 12h10)
property soundAlarmSound : "Basso" -- musique du rappel sonore
property mailAlarmTime1 : 7 -- mail envoy� � 7 heures
property mailAlarmDay1 : 1 -- mail envoy� 1 jour avant
property mailAlarmTime2 : 7 -- mail envoy� � 7 heures
property mailAlarmDay2 : 15 -- mail envoy� 15 jours avant
property mailAlarmTime3 : 7 -- mail envoy� � 7 heures
property mailAlarmDay3 : 7 -- mail envoy� 7 jours avant

----------------------------------------------------------------------------

(* R�cup�ration de l'ann�e en cours *)

set currentYear to year of (current date)
--log currentYear


(* R�cup�ration des contacts qui ont une date d'anniversaire *)
(* On r�cup�re une liste {{date d'anniversaire, nom}, {date d'anniversaire, nom} ...} *)

set listeContactAnniversaire to my lireContactAnniversaire()
--log listeContactAnniversaire


(* Cr�ation du calendrier des anniversaires *)

my creerCalendrier(calendarName, calendarDescription, calendarColor)


(* Pour chaque �l�ment de la liste, on cr�e un �v�nement anniversaire avec rappel *)

repeat with i in listeContactAnniversaire
	--log i
	
	set contactBirthday to item 1 of i
	set contactName to item 2 of i
	
	(* On calcule l'�ge de chaque contact *)
	set contactAge to currentYear - (year of contactBirthday)
	
	(* La date de l'�v�nement est la date de la naissance *)
	(* Mais l'ann�e est l'ann�e en cours ... *)
	set eventDate to contactBirthday
	tell eventDate to set year to currentYear
	
	(* ... Ou l'ann�e prochaine si la date est d�j� pass�e (sinon probl�me avec les dates r�currentes) *)
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
  lireContactAnniversaire : R�cup�ration d'une liste {{date d'anniversaire, nom}, {date d'anniversaire, nom} ...}.
  
  1. Recherche dans l'application "Contacts" les personnes dont la date d'anniversaire est renseign�e. 
  2. Pour chaque personne, r�cup�re une liste {date d'anniversaire, nom}.
  3. Ajoute cette liste � la liste totale.
  
  return : liste {{date d'anniversaire, nom}, {date d'anniversaire, nom} ...} ou {}
  
*)
on lireContactAnniversaire()
	set _listeContactAnniversaire to {}
	
	tell application "Contacts"
		
		(* On recherche tous les contacts qui poss�dent une date de naissance *)
		repeat with i in (get people whose birth date is not missing value)
			--log i
			
			(* On r�cup�re la date de naissance et le nom de chaque contact *)
			tell i to set {contactBirthday, contactName} to {birth date, name}
			set end of _listeContactAnniversaire to {contactBirthday, contactName}
			--log _listeContactAnniversaire
			
		end repeat
		
	end tell
	
	return _listeContactAnniversaire
	
end lireContactAnniversaire



(*
  creerCalendrier : cr�ation du calendrier.
  
  1. Recherche dans l'application "Calendrier" un calendrier qui porte le nom "calendarName". 
  2. S'il existe, on l'efface.
  3. Sinon, on cr�er ce calendrier avec le nom et la couleur pass�s en param�tres.
  
  _calendarName : nom du calendrier � cr�er
 _calendarDescription : description du calendrier � cr�er
  _calendarColor : couleur du calendrier � cr�er
  
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
  creerEvtAnniversaire : Cr�e un �v�nement anniversaire dans le calendrier
  
  _calendarName : nom du calendrier  
  _birthdayDate : date de l'�v�nement
  _evtDescription : titre de l'�v�nement
*)
on creerEvtAnniversaire(_calendarName, _birthdayDate, _evtDescription)
	
	set _evtAnniversaire to missing value
	
	tell application "Calendar"
		set _evtAnniversaire to (make new event at end of events of calendar _calendarName with properties �
			{summary:_evtDescription, start date:_birthdayDate, allday event:true, recurrence:"FREQ=YEARLY;INTERVAL=1"})
	end tell
	
	return _evtAnniversaire
end creerEvtAnniversaire


(*
  ajouterAlarme : Ajoute une alarme sonore � l'�v�nement
  
  _evtAnniversaire : �v�nement anniversaire cr�� dans un calendrier
  _soundAlarmTime : heure du rappel le jour de l'�v�nement
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
  ajouterRappelMail : Ajoute un rappel par mail � l'�v�nement
  
  _evtAnniversaire : �v�nement anniversaire cr�� dans un calendrier
  _mailAlarmDay1 : nombre de jour avant l'�v�nement o� doit �tre envoy� le mail
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


