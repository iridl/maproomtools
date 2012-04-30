<xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	    xmlns:owl="http://www.w3.org/2002/07/owl#"
	    xmlns:sesame="http://www.openrdf.org/schema/sesame#"
	    xmlns:maproomregistry="http://iri.columbia.edu/~jdcorral/ingrid/maproom/maproomregistry.owl#"
            xmlns:maproom="http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#"
	    xmlns:vocab="http://www.w3.org/1999/xhtml/vocab#"
	    xmlns:iriterms="http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#"
	    xmlns:iridl="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#"
	    xmlns:dc="http://purl.org/dc/elements/1.1/">
<xsl:output method="html" indent="yes" encoding="utf-8"/>

<xsl:variable name="language" select="//@xml:lang"/>
<xsl:variable name="mappages" select="document('mappages.xml')"/>

    <xsl:template match="/rdf:RDF" name="mappages">
      <xsl:for-each select="rdf:Description">
        <div class="mappage" href="{@rdf:about}" >
        <h2 align="center"  property="term:title" ><xsl:value-of select="dc:title"/></h2>
        <p align="left" property="term:description"><xsl:value-of select="dc:description"/></p>
        <xsl:for-each select="iriterms:isDescribedBy">
          <link rel="term:isDescribedBy" href="{@rdf:resource}" />
        </xsl:for-each>
        </div><xsl:text>&#xa;</xsl:text>
      </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
