---------------------------------------------------------------------------------------------------------------------------
-- File name	:	meteo.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description :	Retrieve weather and temperature from Yahoo weather site's source code.
---------------------------------------------------------------------------------------------------------------------------
-- Remarks	:
--				- You'll have to change weatherURL to match your country URL
--				- You'll have to change temperatureScale to match your country temperature scale
--				- If Yahoo change its web site, you'll have to find the new boundaries
--				- From idea of Curtranhome of macscripter.net
--				- tested on Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------

# Variables depending on your country
property weatherURL : "https://fr.news.yahoo.com/meteo"
property temperatureScale : "�C"

# Boundaries to find what is usefull for us in the page (weather full contents)
property PageWeatherMinBoundary : "<div class=\"temperature"
property PageWeatherMaxBoundary : "<div class=\"credit"

# Boundaries to find weather contents
property weatherMinBoundary : "<span class=\"description Va(m) Px(2px) Fz(1.3em)--sm Fz(1.6em)\" data-reactid=\"26\">"
property weatherMaxBoundary : "</span></div><div class=\"high-low"

# Boundaries to find temperature contents
property temperatureMinBoundary : "<span class=\"Va(t)\" data-reactid=\"37\">"
property temperatureMaxBoundary : "</span><span class=\"Va(t) Fz(.7em) Lh(1em)\" data-reactid=\"38\">"


-----------------------------------------------------------------------------------------------------------
--                                                     MAIN PROGRAM
-----------------------------------------------------------------------------------------------------------
on run
	
	set weatherPageFullContents to retrieveHTMLContents from weatherURL
	
	set weatherPageSpecificContents to retrieveText of weatherPageFullContents from PageWeatherMinBoundary to PageWeatherMaxBoundary
	
	set currentTemperature to retrieveText of weatherPageSpecificContents from temperatureMinBoundary to temperatureMaxBoundary
	
	set currentWeather to retrieveText of weatherPageSpecificContents from weatherMinBoundary to weatherMaxBoundary
	
	display notification (currentWeather & " (" & currentTemperature & temperatureScale & ")") �
		with title ("Weather of the day")
	
	(*
	# You can also use a dialog
display dialog (currentWeather & " (" & currentTemperature & "�C)") �
		with title ("Weather of the day") �
		with icon note �
		buttons {"OK"} default button 1
*)
	
end run

-----------------------------------------------------------------------------------------------------------
--                                                     FUNCTIONS
-----------------------------------------------------------------------------------------------------------

(*
Nom			: retrieveHTMLContents 
Description	: Retrieve source code of web page
pageURL		: URL of the web page
return		: the source code of the web page
*)
to retrieveHTMLContents from pageURL
	
	set myResult to ""
	
	tell application "Safari"
		
		#activate
		set myDoc to make new document with properties {URL:pageURL}
		set myWindow to window 1
		set visible of myWindow to false
		
		repeat
			set docstate to (do JavaScript "document.readyState" in myDoc)
			if docstate is "complete" then
				exit repeat
			end if
		end repeat
		
		delay 1
		
		set myResult to source of document of myWindow
		close document of myWindow
		
	end tell
	
	return myResult
	
end retrieveHTMLContents


(*
Nom					: retrieveText 
Description			: Retrieve  a text from a text document located between two boundaries
textDocument			: document to search
minBoundaryString	: the searched text is located after the minimum boundary
maxBoundaryString	: the searched text is located before the maximum boundary
return				: the text found
*)
on retrieveText of textDocument from minBoundaryString to maxBoundaryString
	
	set myResult to ""
	
	try
		
		set borneInfOffset to (offset of minBoundaryString in textDocument) + (length of minBoundaryString)
		set borneSupOffset to (offset of maxBoundaryString in textDocument) - 1
		
		set myResult to (text borneInfOffset through borneSupOffset of textDocument) as text
		
	on error
		display alert "Unable to retrieve text from given offsets"
	end try
	
	return myResult
	
end retrieveText




-----------------------------------------------------------------------------------------------------------
--                                                     FIN
-----------------------------------------------------------------------------------------------------------
(*
set fichierMeteo to open for access POSIX file "/Users/bruno/Desktop/meteo2.txt" with write permission
	write websitesource to the fichierMeteo
	close access the fichierMeteo
*)


