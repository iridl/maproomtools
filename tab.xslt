<xsl:stylesheet version="2.0"
            xmlns="http://www.w3.org/1999/xhtml"
            xmlns:html="http://www.w3.org/1999/xhtml"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	    xmlns:maproomregistry="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#"
            xmlns:maproom="http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#"
	    xmlns:vocab="http://www.w3.org/1999/xhtml/vocab#"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
	    xmlns:iriterms="http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#">
<xsl:output method="xhtml" indent="yes" encoding="utf-8" doctype-system="about:legacy-compat" />
<xsl:param name="topdir" />
<xsl:param name="metadata" />
<xsl:variable name="language" select="/html:html/html:body/@xml:lang | /html:html/@xml:lang"/> <!-- LANG OF PAGE WE ARE ON -->
<xsl:variable name="defaultlanguage" select="'en'"/> <!-- DEFAULT LANG FOR SECTIONS -->
<xsl:variable name="tabs" select="document($metadata)"/> <!-- WHERE ALL THE RDF IS STORED -->

    <xsl:template match="@*|node()"> <!-- COPY CONTENTS OF XHTML FILE AS IS -->
      <xsl:copy>
           <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match="*[@class='rightcol tabbedentries']"> <!-- EXPAND THE CONTENT IN THE TABBEDENTRIES SECTION -->
      <!-- FIND THE PAGE WE ARE ON ( WHICH IS ALSO THE SECTION) AND SET UP NAVIGATION -->
      <xsl:variable name="pageloc" select="./@about" />
      <xsl:variable name="pageuri" select="concat('file://',./@about)" />
      <xsl:variable name="pageuri1" select="replace($pageuri,'/$','/index.html')" />
      <xsl:variable name="pageuri2" select="replace($pageuri,'/index.html$','/')" />
      <xsl:variable name="pageuri3" select="concat('file://',$topdir,replace($pageuri1,'file://',''))" />
      <xsl:variable name="pagedir" select="concat('file://',$topdir,replace(./@about,'/[^/]+\.html$','/'))" />
      <div class="rightcol">        
      <div class="ui-tabs">
         <ul class="ui-tabs-nav">
            <xsl:for-each select="*[attribute::rel='maproom:tabterm']">
                 <xsl:variable name="hr" select="@href"/>
                 <xsl:element name="li">
		 <xsl:if test="./@class">
		 <xsl:attribute name="class">
		 <xsl:value-of select="./@class" />
		 </xsl:attribute>
		 </xsl:if>
		 <a href="#tabs-{position()}">
		 <xsl:call-template name="asLangGroup">
			<xsl:with-param name="grp" select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdfs:label" />
			</xsl:call-template>
                 </a>
		 </xsl:element>
            </xsl:for-each>
         </ul>
                    <!-- BUILD LIST OF SUB-SECTION URLS -->
                    <xsl:variable name="subsectionurls" as="xs:string*">
                       <xsl:sequence 
                          select="$tabs/rdf:RDF/rdf:Description[(@rdf:about=$pageuri1) or (@rdf:about=$pageuri2) or (@rdf:about=$pageuri3)]/vocab:section/@rdf:resource[1]"/>
                    </xsl:variable>
                      <!-- <div class="subsectionurls">
                      <xsl:value-of select="$subsectionurls" />
                      </div> -->

      <!-- BEGIN FILLING OUT THE INDIVIDUAL MAPPAGE INFORMATION, BY LOOKING AT EACH TABTERM AND FINDING THE 
      MATCHING MAPPAGES IN THE TABS.XML RDF FILE -->

         <xsl:choose>
         <xsl:when test="*[attribute::rel='maproom:tabterm']">
         <xsl:for-each select="*[attribute::rel='maproom:tabterm']"> <!-- FOR EACH TABTERM -->
            <xsl:sort select="."/>
            <xsl:variable name="hr" select="@href"/> <!-- GET THE HREF FOR THE TABTERM -->
            <div id="tabs-{position()}" class="ui-tabs-panel">
            <!-- THE LABEL OF EACH TABTERM GROUP -->
            <xsl:variable name="group">
		 <xsl:call-template name="asLangGroup">
			<xsl:with-param name="grp" select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdfs:label" />
			</xsl:call-template>
            </xsl:variable> 
            <div class="itemGroup"><xsl:value-of select="$group" disable-output-escaping="no" /></div>
                    <xsl:for-each select="$tabs/rdf:RDF/rdf:Description[index-of($subsectionurls,@rdf:about) > 0]">
                    <xsl:sort select="(maproom:Sort_Id | @rdf:about[not(../maproom:Sort_Id)])[1]"/>
		    <xsl:variable name="canonicalelement">
                              <xsl:value-of select="."/>
			      </xsl:variable>
		    <xsl:variable name="canonicalurl">
		            <xsl:choose>
			    <xsl:when test="contains(@rdf:about,$pagedir)">
                              <xsl:value-of select="substring-after(@rdf:about,$pagedir)"/>
			    </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@rdf:about"/>
                            </xsl:otherwise>
                          </xsl:choose>
		    </xsl:variable>
<!-- figure out the file url use the hasFile that matches the current language, or use the first File  -->
                     <xsl:variable name="fileurl">
		       <xsl:choose>
                          <xsl:when test="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource]/iriterms:title[@xml:lang=$language]">
                                   <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource][iriterms:title/@xml:lang=$language]/@rdf:about" />
			  </xsl:when>
			  <xsl:otherwise>
			  <xsl:choose>
                          <xsl:when test="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource]/iriterms:title[@xml:lang=$defaultlanguage]">
                                   <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource][iriterms:title/@xml:lang=$defaultlanguage]/@rdf:about" />
			  </xsl:when>
			  <xsl:otherwise>
			     <xsl:value-of select="maproomregistry:hasFile[1]/@rdf:resource" />
			  </xsl:otherwise>
                       </xsl:choose>
			  </xsl:otherwise>
                       </xsl:choose>
		     </xsl:variable>
                     <xsl:variable name="fileelement" select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$fileurl]" />
		     <xsl:variable name="titleclass" >
			  <xsl:choose>
                          <xsl:when test="$fileelement/iriterms:title[@xml:lang=$language]">
			     <xsl:text>carryLanguage carry titleLink</xsl:text>
			     </xsl:when>
			     <xsl:otherwise>
			      <xsl:text>carry titleLink</xsl:text>
			     </xsl:otherwise>
			      </xsl:choose>
		     </xsl:variable>
                      <xsl:if test="$fileelement/maproomregistry:tabterm/@rdf:resource = $hr"> <!-- MAKE SURE THE MAPPAGE IS IN THE CURRENT TABTERM GROUP (THIS IS EFFECTIVELY THE INNER LOOP FOR A GROUP)-->
                            <div class="item"><div class="itemTitle"><a class="{$titleclass}" href="{$canonicalurl}">
			    <xsl:call-template name="asLangGroup">
			<xsl:with-param name="grp" select="$fileelement/iriterms:title" />
			</xsl:call-template>
                            </a></div>
                            <xsl:choose><!-- CHECK ICON; IF local, USE LOCAL PATH, if otherwise file:///, start with / , otherwise full url -->
                              <xsl:when test="contains($fileelement/iriterms:icon/@rdf:resource,$pagedir)">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl}"><img class="itemImage" src="{substring-after($fileelement/iriterms:icon/@rdf:resource,$pagedir)}"/></a></div>
                              </xsl:when>
                              <xsl:when test="contains($fileelement/iriterms:icon/@rdf:resource,'file://')">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl}"><img class="itemImage" src="{substring-after($fileelement/iriterms:icon/@rdf:resource,'file://')}"/></a></div>
                              </xsl:when>
                              <xsl:when test="$fileelement/iriterms:icon">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl}"><img class="itemImage" src="{$fileelement/iriterms:icon/@rdf:resource}"/></a></div>
                              </xsl:when>
                            </xsl:choose>                            
                            <div class="itemDescription">
			    <xsl:call-template name="asLangGroup">
			<xsl:with-param name="grp" select="$fileelement/iriterms:description" />
			</xsl:call-template>
</div>
                            <div class="itemFooter"></div>
                            </div>
                    </xsl:if> <!-- MEMBER OF THE GROUP -->
                  </xsl:for-each> 
            </div>
         </xsl:for-each> <!-- TABTERM -->
         </xsl:when>
	 <xsl:otherwise>
			            <div class="ui-tabs-panel">
                    <xsl:for-each select="$tabs/rdf:RDF/rdf:Description[index-of($subsectionurls,@rdf:about) > 0]">
                    <xsl:sort select="(maproom:Sort_Id | @rdf:about[not(../maproom:Sort_Id)])[1]"/>
		    <xsl:variable name="canonicalelement">
                              <xsl:value-of select="."/>
			      </xsl:variable>
		    <xsl:variable name="canonicalurl">
		            <xsl:choose>
			    <xsl:when test="contains(@rdf:about,$pagedir)">
                              <xsl:value-of select="substring-after(@rdf:about,$pagedir)"/>
			    </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@rdf:about"/>
                            </xsl:otherwise>
                          </xsl:choose>
		    </xsl:variable>
<!-- figure out the file url use the hasFile that matches the current language, or use the first File  -->
                     <xsl:variable name="fileurl">
		       <xsl:choose>
                          <xsl:when test="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource]/iriterms:title[@xml:lang=$language]">
                                   <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource][iriterms:title/@xml:lang=$language]/@rdf:about" />
			  </xsl:when>
			  <xsl:otherwise>
			  <xsl:choose>
                          <xsl:when test="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource]/iriterms:title[@xml:lang=$defaultlanguage]">
                                   <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource][iriterms:title/@xml:lang=$defaultlanguage]/@rdf:about" />
			  </xsl:when>
			  <xsl:otherwise>
			     <xsl:value-of select="maproomregistry:hasFile[1]/@rdf:resource" />
			  </xsl:otherwise>
                       </xsl:choose>
			  </xsl:otherwise>
                       </xsl:choose>
		     </xsl:variable>
                     <xsl:variable name="fileelement" select="$tabs//rdf:RDF/rdf:Description[@rdf:about=current()/maproomregistry:hasFile/@rdf:resource]" />
		     <xsl:variable name="titleclass" >
			  <xsl:choose>
                          <xsl:when test="$fileelement/iriterms:title[@xml:lang=$language]">
			     <xsl:text>carryLanguage carry titleLink</xsl:text>
			     </xsl:when>
			     <xsl:otherwise>
			      <xsl:text>carry titleLink</xsl:text>
			     </xsl:otherwise>
			      </xsl:choose>
		     </xsl:variable>
                            <div class="item"><div class="itemTitle"><a class="{$titleclass}" href="{$canonicalurl}">
			    <xsl:call-template name="asLangGroup">
			<xsl:with-param name="grp" select="$fileelement/iriterms:title" />
			</xsl:call-template>
                            </a></div>
                            <xsl:choose><!-- CHECK ICON; IF local, USE LOCAL PATH, if otherwise file:///, start with / , otherwise full url -->
                              <xsl:when test="contains(($fileelement/iriterms:icon/@rdf:resource)[1],$pagedir)">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl}"><img class="itemImage" src="{substring-after(($fileelement/iriterms:icon/@rdf:resource)[1],$pagedir)}"/></a></div>
                              </xsl:when>
                              <xsl:when test="contains(($fileelement/iriterms:icon/@rdf:resource)[1],'file://')">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl}"><img class="itemImage" src="{substring-after(($fileelement/iriterms:icon/@rdf:resource)[1],'file://')}"/></a></div>
                              </xsl:when>
                              <xsl:when test="$fileelement/iriterms:icon">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl}"><img class="itemImage" src="{($fileelement/iriterms:icon/@rdf:resource)[1]}"/></a></div>
				</xsl:when>
                            </xsl:choose>                            
                            <div class="itemDescription">
			    <xsl:call-template name="asLangGroup">
			<xsl:with-param name="grp" select="$fileelement/iriterms:description" />
			</xsl:call-template>
</div>
                            <div class="itemFooter"></div>
                            </div>
                  </xsl:for-each> 
		  </div>
	 </xsl:otherwise>
         </xsl:choose>
    </div>
    </div>
    </xsl:template>
    <xsl:template name="asLangGroup" match="iriterms:description|iriterms:title|rdfs:label">
<xsl:param name="grp" />
    		  <xsl:choose>
	  <xsl:when test="$language">
                            <xsl:value-of select="($grp[@xml:lang=$language],$grp[@xml:lang=$defaultlanguage],$grp[1])[1]" disable-output-escaping="no"/>		  </xsl:when>
		  <xsl:otherwise>
		     <xsl:element name="span">
		     <xsl:attribute name="class">langgroup</xsl:attribute>
		     <xsl:for-each select="$grp">
		     <xsl:sort select="./@xml:lang" />
		     <xsl:element name="span">
		     <xsl:if test="./@xml:lang">
		     <xsl:attribute name="lang"><xsl:value-of select="./@xml:lang" /></xsl:attribute>
		     </xsl:if><xsl:value-of select="." />
		     </xsl:element>
		     </xsl:for-each>
		     </xsl:element>
		     </xsl:otherwise>
		     </xsl:choose>
</xsl:template>
    <xsl:template name="shutSaxonUp" match="html:Nothing">
</xsl:template>
</xsl:stylesheet>



