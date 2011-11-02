<!--#include file="JSON_2.0.4.asp"-->
<!--#include file="JSON_UTIL_0.1.1.asp"-->
<% 'Requires ASP JSON - http://code.google.com/p/aspjson/



	
	q = request.form("q")
	'response.write q
	q = request.form("text")
	'response.write q
	If (q = "") Then
		q = Request.QueryString("q")
	End If
	'q = "manul"
	
	'q = Server.URLDecode(q)
	'q = Server.HtmlDecode(q)
	q = HTMLDecode(q)
	
	
	'put spaces in
	q = Replace(q, "</p>","</p> ")
	q = Replace(q, "<br />","<br /> ")
	q = Replace(q, "</div>","</div> ")
	q = Replace(q, "  "," ")
	
	q = Replace(q, "Â","") 'strip unknown characters
	
	q = stripHTML(q) ' strip html tags
	

	
	dataType = request.form("dataType")
	If (dataType = "") Then
		dataType = Request.QueryString("dataType")
	End If
	If (dataType = "") Then 'default
		'dataType = "Plain"
		dataType = "JSON"
		'dataType = "XML"
	End If
	
	'response.write q & "<br /><br/>" & RequestXML(q, dataType)
	'response.write "[""tet""]"
	'response.write q

	response.write RequestXML(q, dataType)
	
	










Function RequestXML(q, dataType)
	Dim xmlDoc
	Dim xmlHTTP 
	
	Set xmlDoc = CreateObject("Microsoft.XMLDOM")
	
	'response.write q & "<br /><br />"
	
	'if q not is customer dictionary then   'check database for custoemr dictionary
	
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
		word = ""
		suggestion = ""
		Dim json
		Set json = jsObject()

		for each x in objxmldoc.documentElement.childNodes
		  'response.write q & "<br />"
		  'response.write x.getAttribute("o") & "<br />"
		  'response.write x.getAttribute("l") & "<br />"
		  'response.write x.nodename
		  'response.write ": "
		  'response.write x.text & "<br /><hr />"
		  word = left(right(q,len(q)-x.getAttribute("o")),x.getAttribute("l"))
		  suggestion = x.text
		  
		  'Plain text
		  If Output_PlainText <> "" Then
			Output_PlainText = Output_PlainText & word & ": " & suggestion & vbcrlf
		  Else
			Output_PlainText = word & ": " & suggestion & vbcrlf
		  End If

		  'JSON
			Set json(Null) = jsObject()
			json(Null)("word") = word
			json(Null)("suggest") = suggestion


		  
		  
		next
		
		'for each c in objxmldoc.documentElement.childNodes
		'for each c in objxmldoc.documentElement.childNodes
			'RequestXML = c.getAttribute("L")
			'RequestXML = c.nodeValue

			
		'	response.write q & "<br />"
		'	response.write c.getAttribute("l") & "<br />"
		'	response.write c.text
		'	
		'	If suggestion <> "" Then
		'		suggestion = suggestion & "||" & c.text 
		'	Else
		'		suggestion = c.text
		'	End If
			
		'next
		
		'Output_PlainText = ""
		
	'for each c in xml.documentElement.childNodes
		'x=xmlDoc.getElementsByTagName("spellresult")
		'y=x.childNodes[0];
		'RequestXML = objxmldoc.documentElement.documentElement.nodeName
		'RequestXML = objxmldoc.documentElement.childNodes[0].nodeValue
		'xml.documentElement.childNodes.promo.getAttribute("title")
		'RequestXML = objxmldoc.documentElement.childNodes[1].nodeName	
	'Next
	end if
	

dataType = UCase(dataType)
If dataType = "XML" Then
	response.ContentType="text/xml"
	'response.write Output_XML
	RequestXML = Output_XML
ElseIf dataType = "JSON" Then
	response.ContentType="application/json"
	If Output_PlainText <> "" Then
	

		
		
		json.Flush
	End If
	'Output_JSON = jsObject()
	'RequestXML = Output_JSON
Else 'Plain Text
	response.ContentType="text/plain"
	RequestXML = Output_PlainText
	'response.write Output_PlainText
End If

	set objxmldoc=nothing
	set xmlHTTP=nothing
	set xmlDoc=nothing

End Function




'-------------------------------------------------------



'http://www.4guysfromrolla.com/webtech/042501-1.shtml
'Function stripHTML(strHTML)
'  'Strips the HTML tags from strHTML
'  Dim objRegExp, strOutput
'  Set objRegExp = New Regexp
'  objRegExp.IgnoreCase = True
'  objRegExp.Global = True
'  objRegExp.Pattern = "<(.|\n)+?>"
'  'Replace all HTML tag matches with the empty string
'  strOutput = objRegExp.Replace(strHTML, "")
'  'Replace all < and > with &lt; and &gt;
'  strOutput = Replace(strOutput, "<", "&lt;")
'  strOutput = Replace(strOutput, ">", "&gt;")
'  stripHTML = strOutput    'Return the value of strOutput
'  Set objRegExp = Nothing
'End Function

'The regular expression pattern and the Replace method do all the hard work for you - no need to do any messy string operations. If you would rather not use regular expressions you can use the split and join functions in this clever approach.

'http://www.4guysfromrolla.com/webtech/042501-1.shtml
Function stripHTML(strHTML)
'Strips the HTML tags from strHTML using split and join

  'Ensure that strHTML contains something
  If len(strHTML) = 0 then
    stripHTML = strHTML
    Exit Function
  End If

  dim arysplit, i, j, strOutput
  
  arysplit = split(strHTML, "<")
 
  'Assuming strHTML is nonempty, we want to start iterating
  'from the 2nd array postition
  if len(arysplit(0)) > 0 then j = 1 else j = 0

  'Loop through each instance of the array
  for i=j to ubound(arysplit)
     'Do we find a matching > sign?
     if instr(arysplit(i), ">") then
       'If so, snip out all the text between the start of the string
       'and the > sign
       arysplit(i) = mid(arysplit(i), instr(arysplit(i), ">") + 1)
     else
       'Ah, the < was was nonmatching
       arysplit(i) = "<" & arysplit(i)
     end if
  next

  'Rejoin the array into a single string
  strOutput = join(arysplit, "")
  
  'Snip out the first <
  strOutput = mid(strOutput, 2-j)
  
  'Convert < and > to &lt; and &gt;
  strOutput = replace(strOutput,">","&gt;")
  strOutput = replace(strOutput,"<","&lt;")

  stripHTML = strOutput
End Function	
	
	
	
'-------------------------------------------------------------------------------------------
	
Function URLDecode(sConvert) 'http://www.aspnut.com/reference/encoding.asp
    Dim aSplit
    Dim sOutput
    Dim I
    If IsNull(sConvert) Then
       URLDecode = ""
       Exit Function
    End If

    ' convert all pluses to spaces
    sOutput = REPLACE(sConvert, "+", " ")

    ' next convert %hexdigits to the character
    aSplit = Split(sOutput, "%")

    If IsArray(aSplit) Then
      sOutput = aSplit(0)
      For I = 0 to UBound(aSplit) - 1
        sOutput = sOutput & _
          Chr("&H" & Left(aSplit(i + 1), 2)) &_
          Right(aSplit(i + 1), Len(aSplit(i + 1)) - 2)
      Next
    End If

    URLDecode = sOutput
End Function


	Function URLDecode2(sDec)'http://bytes.com/topic/asp-classic/answers/127079-server-htmldecode
	dim objRE
	set objRE = new RegExp
	sDec = Replace(sDec, "+", " ")
	objRE.Pattern = "%([0-9a-fA-F]{2})"
	objRE.Global = True
	URLDecode = objRE.Replace(sDec, GetRef("URLDecodeHex"))
	End Function

	'// Replacement function for the above
	Function URLDecodeHex(sMatch, lhex_digits, lpos, ssource)
	URLDecodeHex = chr("&H" & lhex_digits)
	End Function

	Function HTMLDecode(sText)'http://www.aspnut.com/reference/encoding.asp
    Dim I
    sText = Replace(sText, "&quot;", Chr(34))
    sText = Replace(sText, "&lt;"  , Chr(60))
    sText = Replace(sText, "&gt;"  , Chr(62))
    sText = Replace(sText, "&amp;" , Chr(38))
    sText = Replace(sText, "&nbsp;", Chr(32))
    For I = 1 to 255
        sText = Replace(sText, "&#" & I & ";", Chr(I))
    Next
    HTMLDecode = sText
	End Function
	
 
	
  %>