<% response.ContentType="application/json"

'http://code.google.com/p/jquery-spellchecker/
'http://code.google.com/p/aspjson/
'http://spellchecker.jquery.badsyntax.co.uk/checkspelling.php?text=test&engine=google&lang=en
' base on http://forums.devx.com/showthread.php?t=166324

	q = request.form("text")
	If (q = "") Then
		q = Request.QueryString("text")
	End If
	
	response.write RequestXML(q)
	
	
	

Function RequestXML(q)
	Dim xmlDoc
	Dim xmlHTTP 
	
	Set xmlDoc = CreateObject("Microsoft.XMLDOM")
	
	'if q not equal to custom dictionary then ...   'check database for custom dictionary
	
	xmlDoc.async = False
	taux= "<spellrequest textalreadyclipped=""0"" ignoredups=""1"" ignoredigits=""1"" ignoreallcaps=""0"">" & _
	                "<text>" & q & "</text>" & _
	                "</spellrequest>"
	
	xmlDoc.loadXML (taux) 'loads the XML from string

 	'depending on the server you are hosting this code, it could be "Microsoft.XMLHttp" or "MSXML2.ServerXMLHTTP"
	'Set xmlHTTP = CreateObject("Microsoft.XMLHttp")
	Set xmlHTTP = CreateObject("MSXML2.ServerXMLHTTP")	

	'xmlHTTP.Open "POST","http://www.google.com/tbproxy/spell?lang=en&hl=en", False 	
	xmlHTTP.Open "POST","https://www.google.com/tbproxy/spell?lang=en&hl=en", False 	
	xmlHTTP.send xmlDoc.xml 'do the HTTP post out to google

	Output_XML = xmlHTTP.responseXML.xml
	'<?xml version="1.0"?>
	'<spellresult error="0" clipped="0" charschecked="3"><c o="0" l="3" s="0">Tet	teat	tent	test	yet</c></spellresult>
	'response.write Output_XML 'c o="0" is the characters from the start to where the word is
	

	'first word will be always be the one you need, ignore the rest
 	'now all you need to do is parsing the XML response as normally
	'you will probably start with something like:

	Set objXMLDoc = Server.CreateObject("Msxml2.FreeThreadedDOMDocument")
	objXMLDoc.async = false
	objXMLDoc.validateOnParse = False
	
	objxmldoc.loadXML (xmlHTTP.responseXML.xml)

	if objxmldoc.parseError.errorcode<>0 then
		response.write "Prase Error " & objxmldoc.parseError.errorcode 'error handling code
	else ' proceed
	'do the parsing here for each <c> ... </c> node
	
		Output_PlainText = ""
		Output_JSON = ""
		for each c in objxmldoc.documentElement.childNodes
			'RequestXML = c.getAttribute("L")
			'RequestXML = c.nodeValue
			If Output_PlainText <> "" Then
				Output_PlainText = Output_PlainText & """,""" & c.text
			Else
				Output_PlainText = c.text
			End If
			'response.write Output_PlainText

		next
		
		
			If Trim(Output_PlainText) <> "" Then
				Output_JSON = Output_JSON & "[""" & Replace(trim(Output_PlainText),"	",""",""") & """]"
			Else
				Output_JSON = Output_JSON & "[]"
			End If
	end if
	
RequestXML = Output_JSON

	set objxmldoc=nothing
	set xmlHTTP=nothing
	set xmlDoc=nothing

End Function
	
%>