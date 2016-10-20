(*
Nom du fichier :	soap.applescript
Auteur :			Bruno Boissonnet
Date :			jeudi 20 octobre 2016
Description :		Connexion à un service web SOAP.
Remarques :		
				1. Nécessite un service web (à trouver sur le net)
				2. testé sur Mac OS X 10.9 (Mavericks)
*)


(*
Procédure :

1. Récupérer une adresse de web service (ex : http://www.soapclient.com/xml/soapresponder.wsdl)
2. Ouvrir cette adresse dans un navigateur pour y récupérer :
	- targetNamespace 										=> method namespace uri
	- <s:element name="GetGeoIP">  							=> method name
	- targetNamespace + method name 						=> SOAPAction
	- <s:element ... name="IPAddress" type="s:string"/> 	=> parameters
3. À partir de ces données remplir les paramètres de la fonction "call soap"


Remarques : ATTENTION ! Il y a une restriction sur les paramètres due à un bug d'AppleScript.  (source : http://stackoverflow.com/questions/22296471/how-can-i-make-applescript-soap-work-with-existing-soap-webservices-e-g-w3scho)
	- Si on utilise un service web SOAP 1.1 (namespace http://schemas.xmlsoap.org/wsdl/soap/), il n'y a rien à faire.
	- Si on utilise un service web SOAP 1.2 (namespace http://schemas.xmlsoap.org/wsdl/soap12/), il faut modifier le paramètre pour l'entourer avec "|m:" et "|".		
*)
-- Pour tracer ce qui a été envoyé, utiliser la commande tcpdump suivante :
--    sudo tcpdump -i en1 -A -s 1024 -l "port 80" | tee dump.log


-- Exemple SOAP 1.1
-- 20 octobre 2016
-- Fonctionne
-- "Your input parameters are bubu and mama"

(*
tell application "http://www.soapclient.com/xml/soapresponder.wsdl"
	call soap {method name:"Method1", parameters:{bstrParam1:"bubu" as text, bstrParam2:"mama" as text}, method namespace uri:"http://www.SoapClient.com", SOAPAction:"http://www.SoapClient.com/Method1"}
end tell
*)


-- Exemple SOAP 1.2
-- 20 octobre 2016
-- Fonctionne
-- {returncodedetails:"Success", countrycode:"FRA", |ip|:"89.86.63.11", countryname:"France", returncode:"1"}
(*
tell application "http://www.webservicex.net/geoipservice.asmx?WSDL"
	call soap {method name:"GetGeoIP", parameters:{|m:IPAddress|:"89.86.63.11" as text}, method namespace uri:"http://www.webservicex.net/", SOAPAction:"http://www.webservicex.net/GetGeoIP"}
end tell
*)

-- Exemple SOAP 1.2
-- 20 octobre 2016
-- Fonctionne
-- "122"
(*
tell application "http://www.w3schools.com/xml/tempconvert.asmx?WSDL"
	call soap {method name:"CelsiusToFahrenheit", method namespace uri:"http://www.w3schools.com/xml/", parameters:{|m:Celsius|:50 as string}, SOAPAction:"http://www.w3schools.com/xml/CelsiusToFahrenheit"}
end tell
*)


-- Exemple SOAP 1.2
-- 20 octobre 2016
-- Fonctionne mais le service ne renvoie pas la bonne réponse : -1
(*
tell application "http://www.webservicex.net/CurrencyConvertor.asmx?WSDL"
	call soap {method name:"ConversionRate", parameters:{|m:FromCurrency|:"EUR" as text, |m:ToCurrency|:"USD" as text}, method namespace uri:"http://www.webserviceX.NET/", SOAPAction:"http://www.webserviceX.NET/ConversionRate"}
end tell
*)


-- Exemple SOAP 1.2
-- 20 octobre 2016
-- Fonctionne mais le service ne renvoie pas la bonne réponse : exception
tell application "http://www.webservicex.net/stockquote.asmx?WSDL"
	call soap {method name:"GetQuote", parameters:{|m:symbol|:"IBM"}, method namespace uri:"http://www.webserviceX.NET/", SOAPAction:"http://www.webserviceX.NET/GetQuote"}
end tell


