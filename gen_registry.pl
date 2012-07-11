#!/usr/bin/perl

# maproom registry based on relative file names from ingrid/maproom/
# run this in the ingrid/maproom dir
# output is the owl file needed for generatentriples
# there are no arguments to this script

use File::Basename;

if (@ARGV > 0 ) {
	print "usage: gen_registry.pl with no arguments, in the dir called maproom with map pages below it, like ingrid/maproom\n";
	exit;
}

# check for files with rdfa content and are not backup files from emacs or being tagged
# (e.g. ends with .html or .en or .es or .xx, not .en~ or .en.20120506)

my @exts = qw(.en .es .fr .html .xhtml);

print "Building maproomregistry.\n";

system ('find ./ -exec grep -l XHTML+RDFa "{}" \; | sort > maproomregistry.prelist');

open MP, "<./maproomregistry.prelist" or die "Can't open maproomregistry.prelist: $!\n";
open OP, ">./maproomregistry.owl" or die "Can't open maproomregistry.owl: $!\n";

# prepare top of owl file

print OP ("<?xml version=\"1.0\"?>\n");
print OP ("<rdf:RDF\n");
print OP ("  xmlns:rdf=\"http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#\"\n");
print OP ("  xmlns:rdfs=\"http:\/\/www.w3.org\/2000\/01\/rdf-schema#\"\n");
print OP ("  xmlns:owl=\"http:\/\/www.w3.org\/2002\/07\/owl#\"\n");
print OP ("  xmlns:rdfcache=\"http:\/\/iridl.ldeo.columbia.edu\/ontologies\/rdfcache.owl#\"\n");
print OP ("  xmlns:maproomregistry =\"file:\/\/\/data\/jdcorral\/git_projects\/ingrid\/maproom\/maproomregistry.owl#\">\n");
print OP ("  <owl:Ontology rdf:about=\"\">\n");


while ( $mp = <MP> ) {
  chomp $mp;

$xvers = $mp;
$xvers =~ s/\.html/.xhtml/;
if ($xvers eq $mp || ! -f $xvers ){
# strip off the leading ./
  $mp =~ s/.\///;
# find the file extension
  my ($dir, $name, $ext) = fileparse($mp, @exts);
  if ($ext) {

# open each file and check for string INGRID in 1st line
    open MP1, "<$mp" or die "Can't open $mp: $!\n";
    $mp1 = <MP1>;
    chomp $mp1;
    if ($mp1 =~ m/INGRID/i) {
      print ($mp1,"\n");
      $url = "http:\/\/iridl.ldeo.columbia.edu\/maproom\/".$mp;
      print OP ("    <maproomregistry:importsRdfa rdf:resource=\"",$url,"\"\/>\n");
    } else {
      print OP ("    <maproomregistry:importsRdfa rdf:resource=\"",$mp,"\"\/>\n");
    }
    close MP1;
  }  
}
}
# close and remove temporary file
close MP;
system ('/bin/rm maproomregistry.prelist');

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
