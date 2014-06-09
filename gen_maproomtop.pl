#!/usr/bin/perl
# maproomtop.owl based on relative file names from maproom/maproom/
# run this in the maproom/maproom dir
# there are no arguments to this script
# you must have rdfcache in your path
use File::Basename;
use Cwd;

my $ruleset = "owl-max-optimized";
if ($#ARGV+1 > 0) {
   $ruleset = $ARGV[0];
}

# run SeRQL CONSTRUCT with maproomregistry.owl as the starting point
# pulls out the canonical urls of all the importsRdfa files
open IP, ">canonical_imports.serql";
print IP <<EOQ;
construct distinct
{<http://iridl.ldeo.columbia.edu/proto/maproom/maproomtop.owl>} rdf:type {owl:Ontology} ; 
owl:imports {<http://iridl.ldeo.columbia.edu/ontologies/iridlcontent.owl>}; maproomregistry:importsRdfa {y} 
from
{} maproomregistry:importsRdfa {x} vocab:canonical {y}
USING NAMESPACE
vocab=<http://www.w3.org/1999/xhtml/vocab#>,
maproomregistry=<http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#>
EOQ
    close IP;
my $pwd = cwd();
print "Generating maproomtop.owl In $pwd\n";

system("rdfcache -ruleset='$ruleset' -cache=newmaproomcache -construct=canonical_imports.serql -constructoutput=./top.nt file:///$pwd/maproomregistry.owl >>newmaproomcache/rdfcachelog.txt");

# convert ntriples to rdfxml

system("rapper -q -i ntriples -o rdfxml-abbrev -f 'xmlns:terms=\"http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#\"' -f 'xmlns:reg=\"http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#\"' -f 'xmlns:map=\"http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#\"' -f 'xmlns:owl=\"http://www.w3.org/2002/07/owl#\"' -f 'xmlns:vocab=\"http://www.w3.org/1999/xhtml/vocab#\"' top.nt > top.xml");

# read from top.xml and add necessary content to make maproomtop.owl

open MP, "<./top.xml" or die "Can't open top.xml: $!\n";
open OP, ">./maproomtop.owl" or die "Can't open maproomtop.owl: $!\n";

# prepare top of owl file

print OP <<"EOH";
<?xml version="1.0"?>
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:xhtml="http://www.w3.org/1999/xhtml/vocab#"
  xmlns:rdfcache="http://iridl.ldeo.columbia.edu/ontologies/rdfcache.owl#"
  xmlns:cross="http://iridl.ldeo.columbia.edu/ontologies/iricrosswalk.owl#"
  xmlns:reg ="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#">
  <owl:Ontology rdf:about="">
EOH
# read through and copy top.xml
 if( -f "Imports/moremetadata.owl" ){
print OP ("  <owl:imports rdf:resource=\"Imports/moremetadata.owl\"/>\n");
}

while ( $mp = <MP> ) {
    if($mp =~ /importsRdfa/){
	$mp =~ s/rdf:resource="file:[^ "]+\/maproom\/([^ "]+)"/rdf:resource="\1"/;
	if($mp =~ /\"([^ ]+\/)index.html\"/){
	print OP "<reg:importsRdfa>";
	    print OP "<rdf:Description rdf:about=\"$1index.html\">\n<xhtml:alternate rdf:resource=\"$1\" /></rdf:Description>";
	print OP "</reg:importsRdfa>\n";
	}
	else {
	print OP "$mp";
	}
    }
}
close MP;

# prepare end of owl file
print OP ("  </owl:Ontology>\n");
print OP << 'EOR';
 <owl:ObjectProperty rdf:about="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#importsRdfa">
        <rdfs:range rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#RdfaType"/>
        <rdfs:subPropertyOf rdf:resource="http://www.w3.org/2002/07/owl#imports"/>
        <rdfs:isDefinedBy rdf:resource=""/>

    </owl:ObjectProperty>
     <owl:ObjectProperty rdf:about="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#leadsTo">
        <rdfs:range rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#RdfaType"/>
        <rdfs:isDefinedBy rdf:resource=""/>
    </owl:ObjectProperty>
     <owl:ObjectProperty rdf:about="http://www.w3.org/1999/xhtml/vocab#section">
        <rdfs:subPropertyOf rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#leadsTo"/>
     </owl:ObjectProperty>
     <owl:ObjectProperty rdf:about="http://www.w3.org/1999/xhtml/vocab#alternate">

        <rdfs:subPropertyOf rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#leadsTo"/>
     </owl:ObjectProperty>
    <owl:ObjectProperty rdf:about="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#hasFigure">
    <rdfs:subPropertyOf rdf:resource="http://iridl.ldeo.columbia.edu/ontologies/rdfcache.owl#dependsOn"/>
     </owl:ObjectProperty>

  <owl:Class rdf:about="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#RdfaType">
    <rdfs:subClassOf>
      <owl:Restriction>
        <owl:onProperty rdf:resource="http://iridl.ldeo.columbia.edu/ontologies/rdfcache.owl#hasXslTransformToRdf"/>
        <owl:hasValue>
          <rdfcache:XslTransform rdf:about="http://iridl.ldeo.columbia.edu/ontologies/xslt/RDFa2RDFXML.xsl"><rdfs:label>RDFa2RDFXML</rdfs:label>

	  </rdfcache:XslTransform>
        </owl:hasValue>
      </owl:Restriction>
    </rdfs:subClassOf>
    <rdfs:subClassOf>
      <owl:Restriction>
        <owl:onProperty rdf:resource="http://www.w3.org/1999/xhtml/vocab#alternate"/>
        <owl:allValuesFrom rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#RdfaType" />
      </owl:Restriction>
    </rdfs:subClassOf>
    <rdfs:subClassOf>
      <owl:Restriction>
        <owl:onProperty rdf:resource="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#hasFigure"/>
        <owl:allValuesFrom rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#RdfaType" />
      </owl:Restriction>
    </rdfs:subClassOf>
    <cross:makesThesePropertiesEquivalent rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#leadsTo" />
    <cross:makesThesePropertiesEquivalent rdf:resource="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#importsRdfa" />
  </owl:Class>

  <owl:Class rdf:about="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#map_page">
    <rdfs:subClassOf>
      <owl:Restriction>
        <owl:onProperty rdf:resource="http://www.w3.org/1999/xhtml/vocab#alternate"/>
        <owl:allValuesFrom rdf:resource="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#map_page" />
      </owl:Restriction>
    </rdfs:subClassOf>
    <rdfs:subClassOf>
      <owl:Restriction>

        <owl:onProperty rdf:resource="http://www.w3.org/1999/xhtml/vocab#section"/>
        <owl:allValuesFrom rdf:resource="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#map_page" />
      </owl:Restriction>
    </rdfs:subClassOf>
  </owl:Class>
<rdfcache:ConstructRule ID="map2rss">
 <rdfcache:serql_text rdf:datatype="http://www.w3.org/2001/XMLSchema#;string">
CONSTRUCT DISTINCT {canonicalurl} rss:link {fn:cast(canonicalurl,xsd:string)}
    FROM {map} vocab:canonical {canonicalurl}, 
    [{canonicalurl} rss:link {rsslink}]
    WHERE rsslink=NULL
USING NAMESPACE
 fn = &lt;import:opendap.semantics.IRISail.RepositoryFunctions#&gt;,   
map2serf = &lt;http://iridl.ldeo.columbia.edu/ontologies/map2serf.owl#&gt;,
iridl = &lt;http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#&gt;,
rss = &lt;http://purl.org/rss/1.0/&gt;,
vocab=&lt;http://www.w3.org/1999/xhtml/vocab#&gt;,
xsd=&lt;http://www.w3.org/2001/XMLSchema#&gt;
</rdfcache:serql_text>
</rdfcache:ConstructRule>
EOR
print OP ("</rdf:RDF>\n");


close OP;
