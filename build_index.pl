#!/usr/bin/perl

# build up the index files from the mappage leaf pages
# run this in the ingrid/maproom dir
# output: generation of new index.html pages for levels above the leaf pages
# there are no arguments to this script
# added the creation of a .gitignore file in the maproom git root dir

use File::Basename;
$maproomtoolsdir = dirname($0);

print "Building index.html files\n";

# copy the tab.xslt file from the maproomtools dir
system ("cp $maproomtoolsdir/tab.xslt ."); 

system ("cp ../.gitignore.orig ../.gitignore");

open IP, "grep xhtml maproomregistry.owl |";

# append to .gitignore file in maproom git root dir
open GI, ">>../.gitignore" or die $!;

while ( $ip = <IP> ) {
  chomp $ip;
# strip off the leading     <maproomregistry:importsRdfa rdf:resource="
  $ip =~ s/    <maproomregistry:importsRdfa rdf:resource=\"//;
# strip off the trailing "/>
  $ip =~ s/\"\/>//;
# create the html version of $ip
  $op = $ip;
  $op =~ s/xhtml/html/;
# send html version filenames to a .gitignore file
  print GI "/maproom/$op\n";
  $command = "saxon_transform $ip tab.xslt > $op";
  print "$command \n";
  system ($command) == 0
     or die "system $command failed: $?";
}
# close input
close IP;
# close .gitignore
close GI;
# sort .gitignore and remove duplicates
system ("LC_ALL=c sort -u <../.gitignore >../.gitignore.tmp");
system ("mv -f ../.gitignore.tmp ../.gitignore");

