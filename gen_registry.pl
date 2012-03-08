#!/usr/bin/perl

# New maproom registry based on relative file names from ingrid/maproom/
# run this in the ingrid/maproom dir
# output is the owl file needed for generatentriples
# there are no arguments to this script

if (@ARGV > 0 ) {
	print "usage: gen_registry.pl with no arguments, in the dir called maproom with map pages below it\n";
	exit;
}

# check for files with rdfa  
system ('find ./ -exec grep -il rdfa "{}" \; | sort > newmaproom.prelist');

# files in this list that begin with <INGRID

open MP, "<./newmaproom.prelist" or die "Can't open newmaproom.prelist: $!\n";
open OP, ">./newmaproom.owl" or die "Can't open newmaproom.owl: $!\n";

# prepare top of owl file

print OP ("<?xml version=\"1.0\"?>\n");
print OP ("<rdf:RDF\n");
print OP ("  xmlns:rdf=\"http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#\"\n");
print OP ("  xmlns:rdfs=\"http:\/\/www.w3.org\/2000\/01\/rdf-schema#\"\n");
print OP ("  xmlns:owl=\"http:\/\/www.w3.org\/2002\/07\/owl#\"\n");
print OP ("  xmlns:rdfcache=\"http:\/\/iridl.ldeo.columbia.edu\/ontologies\/rdfcache.owl#\"\n");
print OP ("  xmlns:newmaproom =\"http:\/\/iri.columbia.edu\/~jdcorral/ingrid\/maproom\/newmaproom.owl#\">\n");
print OP ("  <owl:Ontology rdf:about=\"\">\n");


while ( $mp = <MP> ) {
  chomp $mp;
# strip off the leading ./
  $mp =~ s/.\///;
# open each file and check for string INGRID in 1st line
  open MP1, "<$mp" or die "Can't open $mp: $!\n";
  $mp1 = <MP1>;
  chomp $mp1;
  if ($mp1 =~ m/INGRID/i) {
    print ($mp1,"\n");
    $url = "http:\/\/iridl.ldeo.columbia.edu\/maproom\/".$mp;
    print OP ("    <newmaproom:importsRdfa rdf:resource=\"",$url,"\"\/>\n");
} else {
    print OP ("    <newmaproom:importsRdfa rdf:resource=\"",$mp,"\"\/>\n");
}
  close MP1;  
}
# close and remove temporary file
close MP;
system ('/bin/rm newmaproom.prelist');

# prepare end of owl file
print OP ("  <\/owl:Ontology>\n");
print OP ("    <owl:ObjectProperty rdf:ID=\"importsRdfa\">\n");
print OP ("        <rdfs:range rdf:resource=\"#RdfaType\"\/>\n");
print OP ("        <rdfs:subPropertyOf rdf:resource=\"http:\/\/www.w3.org\/2002\/07\/owl#imports\"\/>\n");
print OP ("        <rdfs:isDefinedBy rdf:resource=\"\"\/>\n");
print OP ("    <\/owl:ObjectProperty>\n");
print OP ("  <owl:Class rdf:about=\"#RdfaType\">\n");
print OP ("    <rdfs:subClassOf>\n");
print OP ("      <owl:Restriction>\n");
print OP ("        <owl:onProperty rdf:resource=\"http:\/\/iridl.ldeo.columbia.edu\/ontologies\/rdfcache.owl#hasXslTransformToRdf\"\/>\n");
print OP ("        <owl:hasValue>\n");
print OP ("          <rdfcache:XslTransform rdf:about=\"http:\/\/iridl.ldeo.columbia.edu\/ontologies\/xslt\/RDFa2RDFXML.xsl\"><rdfs:label>RDFa2RDFXML<\/rdfs:label>\n");
print OP ("	  <\/rdfcache:XslTransform>\n");
print OP ("        <\/owl:hasValue>\n");
print OP ("      <\/owl:Restriction>\n");
print OP ("    <\/rdfs:subClassOf>\n");
print OP ("  <\/owl:Class>\n");
print OP ("<\/rdf:RDF>\n");

close OP;
