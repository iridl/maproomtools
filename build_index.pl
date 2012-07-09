#!/usr/bin/perl

# build up the index files from the mappage leaf pages
# run this in the ingrid/maproom dir
# output: generation of new index.html pages for levels above the leaf pages
# there are no arguments to this script

use File::Basename;
$maproomtoolsdir = dirname($0);


if (@ARGV > 0 ) {
	print "usage: build_index.pl with no arguments, in the dir called maproom with map pages below it, like ingrid/maproom\n";
	exit;
}

print "Building index.html files\n";

# copy the tab.xslt file from the maproomtools dir
system ("cp $maproomtoolsdir/tab.xslt ."); 

open IP, "grep xhtml maproomregistry.owl |";

while ( $ip = <IP> ) {
  chomp $ip;
# strip off the leading     <maproomregistry:importsRdfa rdf:resource="
  $ip =~ s/    <maproomregistry:importsRdfa rdf:resource=\"//;
# strip off the trailing "/>
  $ip =~ s/\"\/>//;
# create the html version of $ip
  $op = $ip;
  $op =~ s/xhtml/html/;
  $command = "java -jar /data/jdcorral/git_build/semantic_tools/libs/saxon-9.1.0.5.jar $ip tab.xslt > $op";
  print "$command \n";
  system ($command) == 0
     or die "system $command failed: $?";
}
# close
close IP;


