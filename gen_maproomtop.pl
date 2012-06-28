#!/usr/bin/perl

# maproomtop.owl based on relative file names from ingrid/maproom/
# run this in the ingrid/maproom dir
# there are no arguments to this script
# you must have rdfcache in your path

use File::Basename;

if (@ARGV > 0 ) {
	print "usage: gen_maproomtop.pl with no arguments, in the dir called maproom with map pages below it, like ingrid/maproom\n";
	exit;
}

# run SeRQL CONSTRUCT with maproomregistry.owl as the starting point

system('rdfcache -construct=/data/jdcorral/semantics/SeRQL/canonical_imports.serql -constructoutput=./top.nt -cache=maproomtopcache file:///data/jdcorral/git_projects/ingrid/maproom/maproomregistry.owl > maproomtoplog.`date --iso-8601=minutes`');

# convert ntriples to rdfxml

system('rapper -q -i ntriples -o rdfxml-abbrev top.nt > top.xml');

# read from top.xml and add necessary content to make maproomtop.owl

open MP, "<./top.xml" or die "Can't open top.xml: $!\n";
open OP, ">./maproomtop.owl" or die "Can't open maproomtop.owl: $!\n";

# prepare top of owl file

print OP ("<?xml version=\"1.0\"?>\n");
print OP ("<rdf:RDF\n");
print OP ("  xmlns:rdf=\"http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#\"\n");
print OP ("  xmlns:rdfs=\"http:\/\/www.w3.org\/2000\/01\/rdf-schema#\"\n");
print OP ("  xmlns:owl=\"http:\/\/www.w3.org\/2002\/07\/owl#\"\n");
print OP ("  xmlns:rdfcache=\"http:\/\/iridl.ldeo.columbia.edu\/ontologies\/rdfcache.owl#\"\n");
print OP ("  xmlns:maproomregistry =\"file:\/\/\/data\/jdcorral\/git_projects\/ingrid\/maproom\/maproomregistry.owl#\">\n");
print OP ("  <owl:Ontology rdf:about=\"\">\n");

# read through and copy top.xml  (there needs to be some editing here, but will be added later)

while ( $mp = <MP> ) {
  chomp $mp;
  print OP ("$mp\n");
}
close MP;

# prepare end of owl file
print OP ("  <\/owl:Ontology>\n");
print OP ("    <owl:ObjectProperty rdf:about=\"file:\/\/\/data\/jdcorral\/git_projects\/ingrid\/maproom\/maproomregistry.owl#importsRdfa\">\n");
print OP ("        <rdfs:range rdf:resource=\"file:\/\/\/data\/jdcorral\/git_projects\/ingrid\/maproom\/maproomregistry.owl#RdfaType\"\/>\n");
print OP ("        <rdfs:subPropertyOf rdf:resource=\"http:\/\/www.w3.org\/2002\/07\/owl#imports\"\/>\n");
print OP ("        <rdfs:isDefinedBy rdf:resource=\"\"\/>\n");
print OP ("    <\/owl:ObjectProperty>\n");
print OP ("  <owl:Class rdf:about=\"file:\/\/\/data\/jdcorral\/git_projects\/ingrid\/maproom\/maproomregistry.owl#RdfaType\">\n");
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
