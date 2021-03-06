#!/usr/bin/perl

# maproom registry based on relative file names from ingrid/maproom/
# run this in the ingrid/maproom dir
# output is the owl file needed for generatentriples
# there are no arguments to this script

use File::Basename;

print "Building maproomregistry.\n";

system ('find . -type f -exec grep -l XHTML+RDFa "{}" \; | sort > maproomregistry.prelist');

open MP, "<./maproomregistry.prelist" or die "Can't open maproomregistry.prelist: $!\n";
open OP, ">./maproomregistry.owl" or die "Can't open maproomregistry.owl: $!\n";

# prepare top of owl file

print OP ("<?xml version=\"1.0\"?>\n");
print OP ("<rdf:RDF\n");
print OP ("  xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n");
print OP ("  xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n");
print OP ("  xmlns:owl=\"http://www.w3.org/2002/07/owl#\"\n");
print OP ("  xmlns:rdfcache=\"http://iridl.ldeo.columbia.edu/ontologies/rdfcache.owl#\"\n");
print OP ("  xmlns:maproomregistry =\"http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#\">\n");
print OP ("  <owl:Ontology rdf:about=\"\">\n");
if( -f "Imports/moremetadata.owl" ){
print OP ("  <owl:imports rdf:resource=\"Imports/moremetadata.owl\"/>\n");
}
if( -f "Imports/maproom_bulletins.html" ){
print OP ("  <maproomregistry:importsRdfa rdf:resource=\"Imports/maproom_bulletins.html\"/>\n");
}


while ( $mp = <MP> ) {
  chomp $mp;

$xvers = $mp;
$xvers =~ s/\.html/.xhtml/;
if ($xvers eq $mp || ! -f $xvers ){
# strip off the leading ./
  $mp =~ s/.\///;
# find the file extension
  my ($dir, $name, $ext) = fileparse($mp, qr/\.x?html($|\.[^.]+[^~]$)/);
  if ($ext) {

# open each file and check for string INGRID in 1st line
    open MP1, "<$mp" or die "Can't open $mp: $!\n";
    $mp1 = <MP1>;
    chomp $mp1;
    if ($mp1 =~ m/INGRID/i) {
      print ($mp1,"\n");
      $url = "http://iridl.ldeo.columbia.edu/maproom/".$mp;
      print OP ("    <maproomregistry:importsRdfa rdf:resource=\"",$url,"\"/>\n");
    } else {
      print OP ("    <maproomregistry:importsRdfa rdf:resource=\"",$mp,"\"/>\n");
    }
    close MP1;
  }  
}
}
# close and remove temporary file
close MP;
system ('/bin/rm maproomregistry.prelist');

# prepare end of owl file
print OP ("  </owl:Ontology>\n");
print OP ("</rdf:RDF>\n");

close OP;
