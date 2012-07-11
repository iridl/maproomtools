#!/usr/bin/perl
# local version, all maproom pages have relative paths.
# this must be run in the directory that has all the maproom subdirs, like /data/jdcorral/iri_html/ingrid/maproom

use Cwd;

print "Gathering rdfa triples\n";

system("date --iso-8601=minutes");
system("/bin/rm -rf newmaproomcache/*");

my $pwd = cwd();
print " In $pwd\n";
system("rdfcache -cache=newmaproomcache file:///$pwd/maproomregistry.owl > newmaproomlog.`date --iso-8601=minutes`");

#use trig file in newmaproomcache
open IP, ">maproom_section_index.serql";
print IP <<EOQ;
construct {indexpage} vocab:section {canonical} maproomregistry:hasFile{mappage}
iriterms:description {description}; 
iriterms:title {title},
[{mappage} iriterms:icon {icon}],
[{mappage} maproomregistry:tablabel {lbl};
maproomregistry:tabterm {tabterm},
{tabterm} rdf:label {lbl}]
 from
{indexpage} vocab:section {mappage},
{mappage} iriterms:description {description};
iriterms:title {title},
{mappage} vocab:canonical {canonical},
[{mappage} iriterms:icon {icon}],
 [{indexpage} maproom:tabterm {tabterm}, {mappage} iriterms:isDescribedBy {tabterm} iriterms:label {lbl}
WHERE lang(title)=lang(lbl) ]
USING NAMESPACE
maproomregistry = <http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#>,
vocab = <http://www.w3.org/1999/xhtml/vocab#>,
iriterms = <http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#>,
maproom = <http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#>
EOQ
    close IP;

print ("Running CONSTRUCT query for tabs.xml\n");

system("rdfcache -cache=newmaproomcache -construct=maproom_section_index.serql -constructoutput=./tabs.nt file:///$pwd/maproomregistry.owl > constructlog.`date --iso-8601=minutes`");

#convert tabs.nt to tabs.xml
system("rapper -q -i ntriples -o rdfxml-abbrev tabs.nt > tabs.xml");

system("date --iso-8601=minutes\n");
