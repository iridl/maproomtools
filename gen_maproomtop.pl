#!/usr/bin/perl

# maproomtop.owl based on relative file names from ingrid/maproom/
# run this in the ingrid/maproom dir
# there are no arguments to this script
# you must have rdfcache in your path

use File::Basename;
use Cwd;

if (@ARGV > 0 ) {
	print "usage: gen_maproomtop.pl with no arguments, in the dir called maproom with map pages below it, like ingrid/maproom\n";
	exit;
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
maproomregistry=<file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#>
EOQ
    close IP;
my $pwd = cwd();
print "Generating maproomtop.owl In $pwd\n";

system("rdfcache -cache=newmaproomcache -construct=canonical_imports.serql -constructoutput=./top.nt file:///$pwd/maproomregistry.owl > maproomtoplog.`date --iso-8601=minutes`");

# convert ntriples to rdfxml

system('rapper -q -i ntriples -o rdfxml-abbrev top.nt > top.xml');

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
  xmlns:rdfcache="http://iridl.ldeo.columbia.edu/ontologies/rdfcache.owl#"
  xmlns:cross="http://iridl.ldeo.columbia.edu/ontologies/iricrosswalk.owl#"
  xmlns:maproomregistry ="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#">
  <owl:Ontology rdf:about="">
EOH
# read through and copy top.xml 

while ( $mp = <MP> ) {
    if($mp =~ /importsRdfa/){
$mp =~ s/rdf:resource="file:[^ "]+\/maproom\/([^ "]+)"/rdf:resource="\1"/;
  print OP "$mp";
    }
}
close MP;

# prepare end of owl file
print OP ("  <\/owl:Ontology>\n");
print OP << 'EOR';
 <owl:ObjectProperty rdf:about="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#importsRdfa">
        <rdfs:range rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#RdfaType"/>
        <rdfs:subPropertyOf rdf:resource="http://www.w3.org/2002/07/owl#imports"/>
        <rdfs:isDefinedBy rdf:resource=""/>

    </owl:ObjectProperty>
     <owl:ObjectProperty rdf:about="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#leadsTo">
        <rdfs:range rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#RdfaType"/>
        <rdfs:isDefinedBy rdf:resource=""/>
    </owl:ObjectProperty>
     <owl:ObjectProperty rdf:about="http://www.w3.org/1999/xhtml/vocab#section">
        <rdfs:subPropertyOf rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#leadsTo"/>
     </owl:ObjectProperty>
     <owl:ObjectProperty rdf:about="http://www.w3.org/1999/xhtml/vocab#alternate">

        <rdfs:subPropertyOf rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#leadsTo"/>
     </owl:ObjectProperty>

  <owl:Class rdf:about="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#RdfaType">
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
        <owl:allValuesFrom rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#RdfaType" />
      </owl:Restriction>

      <owl:Restriction>
        <owl:onProperty rdf:resource="http://iridl.ldeo.columbia.edu/ontologies/iridl.owl#hasFigure"/>
        <owl:allValuesFrom rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#RdfaType" />
      </owl:Restriction>
    </rdfs:subClassOf>
    <cross:makesThesePropertiesEquivalent rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#leadsTo" />
    <cross:makesThesePropertiesEquivalent rdf:resource="file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl#importsRdfa" />
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
print OP ("<\/rdf:RDF>\n");


close OP;
