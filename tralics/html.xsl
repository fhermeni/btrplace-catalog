<?xml version="1.0" encoding="iso-8859-15"?>
<xsl:stylesheet
   version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">

<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz_'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '" />

<!-- Hide errors -->
<xsl:template match="error">

</xsl:template>

<xsl:template match="/std">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template name="body.footer">
<div id="footer">last update: <xsl:value-of select="//date"/></div>
</xsl:template>

<xsl:template match="div0/p | div1/p | div2/p | div3/p | div4/p | listing|p">
<p>
<xsl:apply-templates/>
</p>
</xsl:template>

<xsl:template name="html.header">
	  <head>
	    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-15" />
	    <link rel="stylesheet" type="text/css" href="style.css"/>
	    <link href="atom.xml" type="application/atom+xml" rel="alternate" title="Sitewide ATOM Feed" />
	    <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-31187620-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
	    <title><xsl:value-of select="/std/title/text()"/></title>
	  </head>
</xsl:template>

<!-- floats -->
<xsl:template match="float[@type!='reconfiguration' and @type != 'reconfPlan']">
<xsl:element name="div">
  <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
    <xsl:apply-templates/>
    <p class="caption"><span class="float-label"><span class="float-name"><xsl:value-of select="@name"/><xsl:text> </xsl:text></span><span class="float-number"><xsl:value-of select="@id-text"/></span>:</span><xsl:text> </xsl:text><xsl:apply-templates select="p/caption"/></p>
</xsl:element>
</xsl:template>

<xsl:template match="float[@type='reconfPlan']">

<xsl:element name="div">
  <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
  <table class="event-plan">
  <xsl:for-each select="table/row">
    <tr>
    <td><xsl:value-of select="cell[1]"/></td>
    <td class="post"><xsl:value-of select="cell[2]"/></td>
    </tr>
  </xsl:for-each>
  </table>
<!--    <xsl:apply-templates/>-->
    <p class="caption"><span class="float-label"><span class="float-name"><xsl:value-of select="@name"/><xsl:text> </xsl:text></span><span class="float-number"><xsl:value-of select="@id-text"/></span>:</span><xsl:text> </xsl:text><xsl:apply-templates select="p/caption"/></p>
</xsl:element>
</xsl:template>

<xsl:template match="float[@type='reconfiguration']">
<xsl:element name="div">
  <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
  <div class="left-config">
    <xsl:apply-templates select="p/minipage[1]/listing"/>
  </div>
  <div class="arrow-reconfig">
    <img src="img/arrow_reconfiguration.png" width="90px" alt="arrow"/>
  </div>
  <div class="right-config">
    <xsl:apply-templates select="p/minipage[3]/listing"/>
  </div>
  <p class="caption"><span class="float-label"><span class="float-name">Figure<xsl:text> </xsl:text></span><span class="float-number"><xsl:value-of select="@id-text"/></span>:<xsl:text> </xsl:text></span><xsl:apply-templates select="p/caption"/></p>
</xsl:element>
</xsl:template>


<!-- To prevent to interpret <p> in the floats -->
<xsl:template match="float/ p[@rend='center']">
  <xsl:apply-templates select="figure|listing|minipage"/>
</xsl:template>

<!-- minipage -->
<xsl:template match="minipage">
<div class="minipage">
<xsl:apply-templates/>
</div>
</xsl:template>

<!-- Figure -->
<xsl:template match="figure">
  <xsl:element name="a">
    <xsl:attribute name="href"><xsl:value-of select="@file"/>.png</xsl:attribute>
    <xsl:attribute name="title">Click to enlarge</xsl:attribute>
    <xsl:element name="img">
      <xsl:attribute name="src"><xsl:value-of select="@file"/>.png</xsl:attribute>
      <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
      <xsl:attribute name="alt"><xsl:value-of select="@file"/></xsl:attribute>
    </xsl:element>
  </xsl:element>
</xsl:template>


<!-- section headers -->

<!-- New page per chapter -->
<xsl:template match="div0">
  <xsl:variable name="pagename"><xsl:value-of select="translate(head/text(),$uppercase,$lowercase)"/>.html</xsl:variable>
  <xsl:document href="{$pagename}"
		method="xml"
		version="1.0"
		encoding="iso-8859-1"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html>
      <xsl:call-template name="html.header"/>
	  <body>
	    <div id="content">
	    <div id="title"><xsl:value-of select="/std/title/text()"/></div>
	    <xsl:call-template name="chapters.banner"/>
	    <xsl:if test="contains(head,'Constraints')">
	      <xsl:call-template name="toc.constraints"/>	      
	    </xsl:if>
	    <xsl:if test="not(contains(head,'Constraints'))">
	      <xsl:call-template name="chapter.toc"/>
	    </xsl:if>
	    <xsl:apply-templates/>
	    	  
	    <xsl:if test="contains(head,'Constraints')">
	      <p>The current catalog is composed of <b><xsl:value-of select="count(div1)"/></b> constraints.</p>
	    </xsl:if>
	    <xsl:call-template name="body.footer"/>
	    </div>
	    <xsl:call-template name="page.footer"/>
	  </body>
	</html>
  </xsl:document>
</xsl:template>


<!-- new page per constraint -->
<xsl:template match="div1[../@id='cid3']">
  <xsl:variable name="pagename"><xsl:value-of select="translate(head/text(),$uppercase,$lowercase)"/>.html</xsl:variable>
  <xsl:document href="{$pagename}"
		method="xml"
		version="1.0"
		encoding="iso-8859-1"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html>
	  <xsl:call-template name="html.header"/>
	  <body>
	    <div id="content">
	    <div id="title"><xsl:value-of select="/std/title/text()"/></div>
	    <xsl:call-template name="chapters.banner"/>
	    <xsl:call-template name="toc.constraints"/>
	    <xsl:apply-templates/>
	    <xsl:call-template name="body.footer"/>
	    </div>
	    <xsl:call-template name="page.footer"/>

	  </body>
	</html>
  </xsl:document>
</xsl:template>

<!-- take care of the title level decrease by 1 if we are in the chapter 3-->

<xsl:template match="div0/head | div1/head[../../@id='cid3']">
<h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="div1/head[../../@id != 'cid3'] | div2/head[../../../@id='cid3']">
<xsl:element name="h2">
<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="div2/head[../../../@id != 'cid3'] | div3/head[../../../../@id='cid3']">
<xsl:element name="h3">
<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="div3/head[../../../../@id != 'cid3'] |div4/head[../../../../../@id='cid3']">
<xsl:element name="h4">
<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="div4/head">
<xsl:element name="h5">
<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>



<!-- list items -->
<xsl:template match="list">
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="item">
  <li><xsl:apply-templates/></li>
</xsl:template>


<!-- tables -->
<xsl:template match="table">

<table>
<xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="row">
<tr>
<xsl:apply-templates/>
</tr>
</xsl:template>

<xsl:template match="cell">

<td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="table/head">
  <caption><xsl:apply-templates/></caption>
</xsl:template>

<!-- listings -->
<xsl:template match="listing">
  <div class="listing">
    <xsl:apply-templates/>
  </div>
</xsl:template>


<!-- bibliography -->
<xsl:template match="biblio">
  <xsl:document href="references.html"
		method="xml"
		version="1.0"
		encoding="iso-8859-1"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html>
	  <xsl:call-template name="html.header"/>
	  <body>
	    <div id="content">
	    <div id="title"><xsl:value-of select="/std/title/text()"/></div>
	    <xsl:call-template name="chapters.banner"/>
	    <h1>References</h1>
	    <ol>
	      <xsl:apply-templates/>
	    </ol>
	    <xsl:call-template name="body.footer"/>
	    </div>
	    <xsl:call-template name="page.footer"/>

	  </body>
	</html>
  </xsl:document>
</xsl:template>


<xsl:template match="cit">[<xsl:element name="a">
<xsl:attribute name="href">references.html#<xsl:value-of select="ref/@target"/></xsl:attribute>
<!-- get the reference number -->
<xsl:variable name="target"><xsl:value-of select="ref/@target"/></xsl:variable>
<xsl:value-of select="count(//citation[@id=$target]/preceding-sibling::*) + 1"/>
</xsl:element>]</xsl:template>
<xsl:template match="citation">
  <xsl:element name="li">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  <xsl:apply-templates/>.
  </xsl:element>
</xsl:template>

<xsl:template match="btitle">
  <xsl:value-of select="text()"/>. 
</xsl:template>

<xsl:template match="bhowpublished">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="bauteurs">
  <xsl:for-each select="bpers">
    <xsl:apply-templates select="."/>
    <xsl:if test="position() &lt; last()">,<xsl:text> </xsl:text></xsl:if>
  </xsl:for-each>.
</xsl:template>

<xsl:template match="bpers">
  <xsl:value-of select="@prenom"/><xsl:text> </xsl:text> <xsl:value-of select="@nom"/>
</xsl:template>

<xsl:template match="bbooktitle">
  In <i><xsl:value-of select="text()"/></i>
</xsl:template>

<xsl:template match="bpages">
, pages <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="bmonth">
</xsl:template>
<xsl:template match="byear">
, <xsl:value-of select="."/>
</xsl:template>

<!-- font variant-->
<xsl:template match="hi[@rend='bold']">
<b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="hi[@rend='tt']">
<code><xsl:apply-templates/></code>
</xsl:template>


<!-- links -->
<xsl:template match="xref">
  <xsl:element name="a">
    <xsl:attribute name="href">
      <xsl:value-of select="@url"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="hyperref">
  <xsl:element name="a">
    <xsl:attribute name="href"><xsl:value-of select="@name"/>.html</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="ref[starts-with(@target,'cid')]">
  <xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>
  <xsl:variable name="ch"><xsl:value-of select="//div0[@id=$target]/head"/></xsl:variable>
  "<xsl:element name="a">
    <xsl:attribute name="href"><xsl:value-of select="translate($ch,$uppercase,$lowercase)"/>.html</xsl:attribute> 
    <xsl:value-of select="$ch"/>
  </xsl:element>"
</xsl:template>

<xsl:template match="ref[starts-with(@target,'uid')]">
  <xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>
  <xsl:variable name="x"><xsl:value-of select="//*[@id=$target]/@id-text"/></xsl:variable>
  <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:value-of select="$x"/></xsl:attribute> 
    <xsl:value-of select="$x"/>
  </xsl:element>
</xsl:template>

<!-- Constraints toc -->
<xsl:template name="toc.constraints">
<div id="toc-constraints">
<div class="title">Constraints</div>
  <ul>
    <xsl:for-each select="//div0/div1[contains(../head,'Constraints') and not(contains(../head,'Inheritance'))]">
      <li>
	<xsl:element name="a">
	  <xsl:attribute name="href"><xsl:value-of select="translate(head,$uppercase,$lowercase)"/>.html</xsl:attribute>
	  <xsl:value-of select="head/text()"/>
	</xsl:element>
      </li>
    </xsl:for-each>
  </ul>
</div>  
</xsl:template>

<!-- Constraint classification -->
<xsl:template match="cstrClassification">
<h3>Classification</h3>
<ul>
<li>
<b>Primary users</b>: 
<xsl:for-each select="cstrIndex[contains(@type,'By User')]">
  <xsl:element name="a">
    <xsl:attribute name="href">theindex.html?#<xsl:value-of select="@id"/></xsl:attribute>
    <xsl:value-of select="@id"/>
  </xsl:element>
  <xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each>
</li>
<li>
<b>Manipulated elements</b>: 
<xsl:for-each select="cstrIndex[contains(@type,'By Element')]">
  <xsl:element name="a">
    <xsl:attribute name="href">theindex.html?#<xsl:value-of select="@id"/></xsl:attribute>
    <xsl:value-of select="@id"/>
  </xsl:element>
  <xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each>
</li>

<li>
<b>Concerns</b>: 
<xsl:for-each select="cstrIndex[contains(@type,'By Concern')]">
  <xsl:element name="a">
    <xsl:attribute name="href">theindex.html?#<xsl:value-of select="@id"/></xsl:attribute>
    <xsl:value-of select="@id"/>
  </xsl:element>
  <xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each>
</li>
</ul>
</xsl:template>

<!-- Constraint index -->
<xsl:template match="cstrIndex">
</xsl:template>

<xsl:template match="theindex">
  <xsl:document href="theindex.html"
		method="xml"
		version="1.0"
		encoding="iso-8859-1"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html>
	  <xsl:call-template name="html.header"/>
	  <body>
	    <div id="content">
	    <div id="title"><xsl:value-of select="/std/title/text()"/></div>
	    <xsl:call-template name="chapters.banner"/>
	    <h1>Constraint Index</h1>
	    <xsl:for-each select="index">
	      <xsl:choose>
		<xsl:when test="@level='1'">
		  <h2><xsl:value-of select="text()"/></h2>
		</xsl:when>
		<xsl:when test="@level='2'">
		  <xsl:element name="div">
		    <xsl:attribute name="class">index-entry</xsl:attribute>
		    <xsl:attribute name="id"><xsl:value-of select="text()"/></xsl:attribute>
		      <span class="index-name"><xsl:value-of select="text()"/></span>
		      <xsl:variable name="key"><xsl:value-of select="text()"/></xsl:variable>
		      <!-- now we parse the whole document to get the associated constraints-->
		      <span class="index-values">
			<xsl:for-each select="//cstrIndex[@id=$key]">
			  <xsl:element name="a">
			    <xsl:attribute name="href"><xsl:value-of select="translate(text(),$uppercase,$lowercase)"/>.html</xsl:attribute>
			    <xsl:value-of select="text()"/>
			  </xsl:element>
			  <xsl:if test="position() &lt; last()"><xsl:text>, </xsl:text></xsl:if>
			</xsl:for-each>
		      </span>
		  </xsl:element>
		</xsl:when>
	      </xsl:choose>
	    </xsl:for-each>
	    <xsl:call-template name="body.footer"/>
	    </div>
	    <xsl:call-template name="page.footer"/>
	  </body>
	</html>
  </xsl:document>
</xsl:template>


<!-- Homepage -->
<xsl:template match="abstract">
  <xsl:document href="index.html"
		method="xml"
		version="1.0"
		encoding="iso-8859-1"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html>
	  <xsl:call-template name="html.header"/>
	  <body>
	    <div id="content">
	    <div id="title"><xsl:value-of select="/std/title/text()"/></div>
	    <xsl:call-template name="chapters.banner"/>
	    <h1>About this catalog</h1>
	    <xsl:apply-templates/>

	    <div class="download">
	    <input type="button" class="download-pdf" value="Download (PDF)" onclick="document.location.href='pdf/catalog-last.pdf';"/>
	    </div>
	    <h1>About this website</h1>
	    <p>This website provides the online version of the catalog for a more
	    confortable navigation. It is generated from the LaTeX sources of the catalog.
	    First, <a href="http://www-sop.inria.fr/marelle/tralics/">Tralics</a> translates the 
	    LaTeX sources into XML. The XML is then transformed into HTML using XSLT.
	    Images, originally in the SVG format, are converted into PNG using <a href="http://www.inkscape.org">Inkscape</a>.</p>
	    <xsl:call-template name="body.footer"/>
	    </div>
	    <xsl:call-template name="page.footer"/>

	  </body>
	</html>
  </xsl:document>
</xsl:template>


<!-- Chapters -->
<xsl:template name="chapter.toc">
<xsl:if test="count(div1) &gt; 0">
<div id="chapter-toc">
<div class="title">Summary</div>
<ul class="level-1">
    <xsl:for-each select="div1">
      <li>
	<xsl:element name="a">
	  <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
	  <xsl:value-of select="head/text()"/></xsl:element>
	  <xsl:if test="count(div2) &gt; 0">
	    <ul class="level-2">
	    <xsl:for-each select="div2">
	      <li>
		<xsl:element name="a">
		  <xsl:attribute name="href">#<xsl:value-of select="./@id"/></xsl:attribute>
		  <xsl:value-of select="head/text()"/>
		</xsl:element>
	      </li>
	    </xsl:for-each>
	    </ul>
	  </xsl:if>
      </li>
    </xsl:for-each>
</ul>
</div>
</xsl:if>

</xsl:template>

<xsl:template name="chapters.banner">
<div id="chapters-banner">
<ul id="banner.main">
<li><a href="index.html">Home</a></li>
<li><a href="preface.html">Preface</a></li>
<li><a href="virtualized_hosting_platforms.html">Virtualized Hosting Platforms</a></li>
<li><a href="notations.html">Notations</a></li>
<li><a href="references.html">References</a></li>
</ul>

<ul id="banner.constraints">
<li>Constraints:</li>
<li><a href="constraints.html">Summary</a></li>
<li><a href="theindex.html">Index</a></li>
<li><a href="constraint_reformulation.html">Reformulations</a></li>
</ul>
</div>
</xsl:template>

<xsl:template name="page.footer">
<div id="page-footer">
    <a href="http://validator.w3.org/check?uri=referer">
      <img src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0 Strict" height="31" width="88" />
    </a>
</div>
</xsl:template>

<xsl:template match="overline">
  <span class="oline"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="symbol">
  <xsl:choose>
    <xsl:when test="contains(@id,'checkmark')">
      <div class="c">&#x2713;</div>
    </xsl:when>
    <xsl:when test="contains(@id,'equivalent')">&#8596; </xsl:when>
    <xsl:when test="contains(@id,'forall')">&#8704;</xsl:when>
    <xsl:when test="contains(@id,'downarrow')">&#8595;</xsl:when>
    <xsl:when test="contains(@id,'uparrow')">&#8593;</xsl:when>
    <xsl:when test="contains(@id,'in')">&#8712; </xsl:when>
    <xsl:when test="contains(@id,'allNodes')"><span class="cursive">N</span></xsl:when>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>