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

print ("Running CONSTRUCT query for tabs.xml\n");

system("rdfcache -cache=newmaproomcache -construct=/data/jdcorral/git_build/ingrid/maproomtools/maproom_section_index.serql -constructoutput=./tabs.nt file:///$pwd/maproomregistry.owl > constructlog.`date --iso-8601=minutes`");

#convert tabs.nt to tabs.xml
system("rapper -q -i ntriples -o rdfxml-abbrev tabs.nt > tabs.xml");

system("date --iso-8601=minutes\n");
