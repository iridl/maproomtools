#!/usr/bin/perl
# local version, all maproom pages have relative paths. this must be run in the directory that has all the maproom subdirs, like /data/jdcorral/iri_html/ingrid/maproom
use Cwd;

my $ruleset = "owl-max-optimized";
if ($#ARGV+1 > 0) {
   $ruleset = $ARGV[0];
}

system("date");
my $pwd = cwd();
print "Setting '$pwd/newmaproomcache' directory\n";
system("rm -rf newmaproomcache");
system("mkdir -p newmaproomcache");

print "Gathering rdfa triples\n";
system("rdfcache -ruleset='$ruleset' -cache=newmaproomcache file://$pwd/maproomregistry.owl >>newmaproomcache/rdfcachelog.txt");

print ("Running CONSTRUCT query for tabs.xml\n");
#use trig file in newmaproomcache
open IP, ">maproom_section_index.serql";
print IP <<EOQ;
construct {indexpage} vocab:section {canonical} maproomregistry:hasFile{mappage}
iriterms:description {description}; 
iriterms:title {title},
[{canonical} maproom:Sort_Id {sortid}],
[{mappage} iriterms:icon {icon}],
[{mappage} maproomregistry:tablabel {lbl};
maproomregistry:tabterm {tabterm},
{tabterm} rdfs:label {lbl},
{tabterm} iriterms:gloss {gloss}],
{mappage} iriterms:isDescribedBy {sem}
 from
{indexpage} vocab:section {mappage},
{mappage} iriterms:description {description};
iriterms:title {title},
{mappage} vocab:canonical {canonical},
[{mappage} maproom:Sort_Id {sortid}],
[{mappage} iriterms:icon {icon}],
    [{indexpage} maproom:tabterm {tabterm}, {mappage} iriterms:isDescribedBy {tabterm} iriterms:label {lbl},[{tabterm} iriterms:gloss {gloss}]
WHERE lang(title)=lang(lbl) ],
[{mappage} iriterms:isDescribedBy {sem}]
USING NAMESPACE
maproomregistry = <http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#>,
vocab = <http://www.w3.org/1999/xhtml/vocab#>,
iriterms = <http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#>,
maproom = <http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#>
EOQ
close IP;
system("rdfcache -ruleset='$ruleset' -cache=newmaproomcache -construct=maproom_section_index.serql -constructoutput=./tabs.nt file://$pwd/maproomregistry.owl >>newmaproomcache/rdfcachelog.txt");

print ("Converting tabs.nt to tabs.xml\n");
system("rapper -q -i ntriples -o rdfxml-abbrev -f 'xmlns:terms=\"http://iridl.ldeo.columbia.edu/ontologies/iriterms.owl#\"' -f 'xmlns:reg=\"http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#\"' -f 'xmlns:map=\"http://iridl.ldeo.columbia.edu/ontologies/maproom.owl#\"' -f 'xmlns:gaz=\"http://iridl.ldeo.columbia.edu/ontologies/iri_gaz.owl#\"' -f 'xmlns:vocab=\"http://www.w3.org/1999/xhtml/vocab#\"' tabs.nt > tabs.xml");

system("date");
