<p><strong>Server script</strong> </p><p>The ASP script currently supports only google's spell checking services. Google requires minimal server adjustments.</p>

<p>Checking is done with an HTTP post to <a href='http://www.google.com/tbproxy/spell?lang=en&hl=en'>http://www.google.com/tbproxy/spell?lang=en&amp;hl=en</a></p>
The xml structure looks like this...<br />
```xml


<?xml version="1.0" encoding="utf-8" ?>

<spellrequest textalreadyclipped="0" ignoredups="0" ignoredigits="1" ignoreallcaps="1">

<text>Ths is a tst

Unknown end tag for &lt;/text&gt;





Unknown end tag for &lt;/spellrequest&gt;


```
The response look like ...<br />
```xml


<?xml version="1.0" encoding="UTF-8"?>

<spellresult error="0" clipped="0" charschecked="12">

<c o="0" l="3" s="1">This Th's Thus Th HS

Unknown end tag for &lt;/c&gt;



<c o="9" l="3" s="1">test tat ST St st

Unknown end tag for &lt;/c&gt;





Unknown end tag for &lt;/spellresult&gt;


```
<br />


<table border='1'>
<tbody>
<tr>
<td>Tag</td>
<td>Description</td>
</tr>
<tr>
<td>o</td>
<td>the offset from the start of the text of the word</td>
</tr>
<tr>
<td>l</td>
<td>length of misspelled word</td>
</tr>
<tr>
<td>s</td>
<td>Confidence of the suggestion</td>
</tr>
<tr>
<td>text</td>
<td>tab delimited list of suggestions</td>
</tr>
</tbody>
</table>