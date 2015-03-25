# jquery-spellchecker-asp
Automatically exported from code.google.com/p/jquery-spellchecker-asp

THIS CODE IS REDUNDENT!

Description

This ASP engine is designed for http://code.google.com/p/jquery-spellchecker/.

Instead of using PHP, this engine uses VB Script/ASP server side language.

Google Spell checker service - Google Toolbar Spell Check API.

Does not use SOAP so you do not need an API key.

Documentation

Server script

The ASP script currently supports only google's spell checking services. Google requires minimal server adjustments.

Checking is done with an HTTP post to http://www.google.com/tbproxy/spell?lang=en&hl=en

The xml structure looks like this...

 
<?xml version="1.0" encoding="utf-8" ?> 
 

<spellrequest textalreadyclipped="0" ignoredups="0" ignoredigits="1" ignoreallcaps="1"> 

    <text>Ths is a tst</text> 

</spellrequest> 

The response look like ...

 
<?xml version="1.0" encoding="UTF-8"?>
 

<spellresult error="0" clipped="0" charschecked="12"> 

    <c o="0" l="3" s="1">This Th's Thus Th HS</c> 

    <c o="9" l="3" s="1">test tat ST St st</c> 

</spellresult> 



Tag	Description
o	the offset from the start of the text of the word
l	length of misspelled word
s	Confidence of the suggestion
text	tab delimited list of suggestions
