<xsl:stylesheet version="2.0"
            xmlns="http://www.w3.org/1999/xhtml"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	    xmlns:maproomregistry="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#"
            xmlns:maproom="http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#"
	    xmlns:vocab="http://www.w3.org/1999/xhtml/vocab#"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
	    xmlns:iriterms="http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#">
<xsl:output method="xhtml" indent="yes" encoding="utf-8" doctype-system="about:legacy-compat" />

<xsl:variable name="language" select="//@xml:lang"/> <!-- LANG OF PAGE WE ARE ON -->
<xsl:variable name="defaultlanguage" select="'en'"/> <!-- DEFAULT LANG FOR SECTIONS -->
<xsl:variable name="tabs" select="document('tabs.xml')"/> <!-- WHERE ALL THE RDF IS STORED -->

    <xsl:template match="@*|node()"> <!-- COPY CONTENTS OF XHTML FILE AS IS -->
      <xsl:copy>
           <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match="*[@class='rightcol tabbedentries']"> <!-- EXPAND THE CONTENT IN THE TABBEDENTRIES SECTION -->
      <!-- FIND THE PAGE WE ARE ON ( WHICH IS ALSO THE SECTION) AND SET UP NAVIGATION -->
      <xsl:variable name="pageloc" select="./@about" />
      <div class="rightcol">
      <div class="ui-tabs">
         <ul class="ui-tabs-nav">
            <xsl:for-each select="*[attribute::rel='maproom:tabterm']">
                 <xsl:variable name="hr" select="@href"/>
                 <li><a href="#tabs-{position()}">
                     <xsl:choose> <!-- CHECK FOR LANGUAGE MATCH FOR TAB LABEL -->
                       <xsl:when test="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdf:label[@xml:lang=$language]">
                         <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdf:label[@xml:lang=$language]"/>
                       </xsl:when>
                       <xsl:otherwise> <!-- USE .EN -->
                         <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdf:label[@xml:lang='en']"/>
                       </xsl:otherwise> 
                     </xsl:choose>
                 </a></li>
            </xsl:for-each>
         </ul>

      <!-- <div>
      <xsl:value-of select="$pageloc" />
      </div> -->
                    <!-- BUILD LIST OF SUB-SECTION URLS -->
                    <xsl:variable name="subsectionurls" as="xs:string*">
                       <xsl:sequence 
                          select="$tabs/rdf:RDF/rdf:Description[ends-with(replace(@rdf:about,'index\.html.*',''),$pageloc)]/vocab:section/@rdf:resource[1]"/>
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
            <xsl:choose>
              <xsl:when test="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdf:label[@xml:lang=$language]" > <!-- WHEN LANG TAG MATCHES -->
                <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdf:label[@xml:lang=$language]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$tabs//rdf:RDF/rdf:Description[@rdf:about=$hr]/rdf:label[@xml:lang='en']"/> <!-- OTHERWISE USE EN (BE CAREFUL ABOUT THIS CONDITION) -->
              </xsl:otherwise>
            </xsl:choose>
            </xsl:variable> 
            <div class="itemGroup"><xsl:value-of select="$group" disable-output-escaping="no" /></div>
                    <xsl:for-each select="$tabs/rdf:RDF/rdf:Description[index-of($subsectionurls,@rdf:about) > 0]">
                    <xsl:sort select="(maproom:Sort_Id | @rdf:about[not(../maproom:Sort_Id)])[1]"/>
		    <xsl:variable name="canonicalelement">
                              <xsl:value-of select="."/>
			      </xsl:variable>
		    <xsl:variable name="canonicalurl">
		            <xsl:choose>
			    <xsl:when test="contains(@rdf:about,$pageloc)">
                              <xsl:value-of select="substring-after(@rdf:about,$pageloc)"/>
			    </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@rdf:about"/>
                            </xsl:otherwise>
                          </xsl:choose>
		    </xsl:variable>
                    <!-- Repeat test to make sure there are no repeated elements in @rdf:about, and strip leading slash of $pageloc -->
		    <xsl:variable name="canonicalurl2">
		            <xsl:choose>
			    <xsl:when test="contains($canonicalurl,substring($pageloc,2))">
                              <xsl:value-of select="substring-after($canonicalurl,substring($pageloc,2))"/>
			    </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$canonicalurl"/>
                            </xsl:otherwise>
                          </xsl:choose>
		    </xsl:variable>
<!-- figure out the file url use the hasFile that matches the current language, or use the first File  -->
                     <xsl:variable name="fileurl">
		       <xsl:choose>
                          <xsl:when test="maproomregistry:hasFile[ends-with(@rdf:resource,$language)]">
                                   <xsl:value-of select="maproomregistry:hasFile[ends-with(@rdf:resource,$language)][1]/@rdf:resource" />
			  </xsl:when>
			  <xsl:otherwise>
			  <xsl:choose>
                          <xsl:when test="maproomregistry:hasFile[ends-with(@rdf:resource,$defaultlanguage)]">
                                   <xsl:value-of select="maproomregistry:hasFile[ends-with(@rdf:resource,$defaultlanguage)][1]/@rdf:resource" />
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
                          <xsl:when test="ends-with($fileurl,$language)">
			     <xsl:text>carryLanguage carry titleLink</xsl:text>
			     </xsl:when>
			     <xsl:otherwise>
			      <xsl:text>carry titleLink</xsl:text>
			     </xsl:otherwise>
			      </xsl:choose>
		     </xsl:variable>
                      <xsl:if test="$fileelement/maproomregistry:tabterm/@rdf:resource = $hr"> <!-- MAKE SURE THE MAPPAGE IS IN THE CURRENT TABTERM GROUP (THIS IS EFFECTIVELY THE INNER LOOP FOR A GROUP)-->
                            <div class="item"><div class="itemTitle"><a class="{$titleclass}" href="{$canonicalurl2}">
                            <xsl:value-of select="$fileelement/iriterms:title"/>
                            </a></div>
                            <xsl:choose><!-- CHECK ICON; IF FILE:///, USE LOCAL PATH -->
                              <xsl:when test="contains($fileelement/iriterms:icon/@rdf:resource,'http:')">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl2}"><img class="itemImage" src="{$fileelement/iriterms:icon/@rdf:resource}"/></a></div>
                              </xsl:when>
                              <xsl:otherwise>
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl2}"><img class="itemImage" src="{substring-after($fileelement/iriterms:icon/@rdf:resource,$pageloc)}"/></a></div>
                              </xsl:otherwise>
                            </xsl:choose>                            
                            <div class="itemDescription">
                            <xsl:value-of select="$fileelement/iriterms:description" disable-output-escaping="no"/></div>
                            <div class="itemFooter"></div>
                            </div>
                    </xsl:if> <!-- MEMBER OF THE GROUP -->
                  </xsl:for-each> 
            </div>
         </xsl:for-each> <!-- TABTERM -->
         </xsl:when>
	 <xsl:otherwise>
                    <xsl:for-each select="$tabs/rdf:RDF/rdf:Description[index-of($subsectionurls,@rdf:about) > 0]">
                    <xsl:sort select="(maproom:Sort_Id | @rdf:about[not(../maproom:Sort_Id)])[1]"/>
		    <xsl:variable name="canonicalelement">
                              <xsl:value-of select="."/>
			      </xsl:variable>
		    <xsl:variable name="canonicalurl">
		            <xsl:choose>
			    <xsl:when test="contains(@rdf:about,$pageloc)">
                              <xsl:value-of select="substring-after(@rdf:about,$pageloc)"/>
			    </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@rdf:about"/>
                            </xsl:otherwise>
                          </xsl:choose>
		    </xsl:variable>
               <!-- Repeat test to make sure there are no repeated elements in @rdf:about, and strip leading slash of $pageloc -->
		    <xsl:variable name="canonicalurl2">
		            <xsl:choose>
			    <xsl:when test="contains($canonicalurl,substring($pageloc,2))">
                              <xsl:value-of select="substring-after($canonicalurl,substring($pageloc,2))"/>
			    </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$canonicalurl"/>
                            </xsl:otherwise>
                          </xsl:choose>
		    </xsl:variable>
<!-- figure out the file url use the hasFile that matches the current language, or use the first File  -->
                     <xsl:variable name="fileurl">
		       <xsl:choose>
                          <xsl:when test="maproomregistry:hasFile[ends-with(@rdf:resource,$language)]">
                                   <xsl:value-of select="maproomregistry:hasFile[ends-with(@rdf:resource,$language)][1]/@rdf:resource" />
			  </xsl:when>
			  <xsl:otherwise>
			  <xsl:choose>
                          <xsl:when test="maproomregistry:hasFile[ends-with(@rdf:resource,$defaultlanguage)]">
                                   <xsl:value-of select="maproomregistry:hasFile[ends-with(@rdf:resource,$defaultlanguage)][1]/@rdf:resource" />
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
                          <xsl:when test="ends-with($fileurl,$language)">
			     <xsl:text>carryLanguage carry titleLink</xsl:text>
			     </xsl:when>
			     <xsl:otherwise>
			      <xsl:text>carry titleLink</xsl:text>
			     </xsl:otherwise>
			      </xsl:choose>
		     </xsl:variable>
                            <div class="item"><div class="itemTitle"><a class="{$titleclass}" href="{$canonicalurl2}">
                            <xsl:value-of select="$fileelement/iriterms:title"/>
                            </a></div>
                            <xsl:choose><!-- CHECK ICON; IF FILE:///, USE LOCAL PATH -->
                              <xsl:when test="contains($fileelement/iriterms:icon/@rdf:resource,'http:')">
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl2}"><img class="itemImage" src="{$fileelement/iriterms:icon/@rdf:resource}"/></a></div>
                              </xsl:when>
                              <xsl:otherwise>
                                <div class="itemIcon"><a class="{$titleclass}" href="{$canonicalurl2}"><img class="itemImage" src="{substring-after($fileelement/iriterms:icon/@rdf:resource,$pageloc)}"/></a></div>
                              </xsl:otherwise>
                            </xsl:choose>                            
                            <div class="itemDescription">
                            <xsl:value-of select="$fileelement/iriterms:description" disable-output-escaping="no"/></div>
                            <div class="itemFooter"></div>
                            </div>
                  </xsl:for-each> 
	 </xsl:otherwise>
         </xsl:choose>
    </div>
    </div>
    </xsl:template>
    
</xsl:stylesheet>



