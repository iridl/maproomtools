#!/usr/bin/perl

# build up the index files from the mappage leaf pages
# run this in the ingrid/maproom dir
# output: generation of new index.html pages for levels above the leaf pages
# there are no arguments to this script
# added the creation of a .gitignore file in the maproom git root dir

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

# create .gitignore file in maproom git root dir
open GI, ">../.gitignore" or die $!;

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
  print GI "maproom\/$op\n";
  $command = "saxon_transform $ip tab.xslt > $op";
  print "$command \n";
  system ($command) == 0
     or die "system $command failed: $?";
}
# close input
close IP;

# finish writing the other filenames to .gitignore
print GI "maproom\/canonical_imports.serql\n";
print GI "maproom\/maproom_section_index.serql\n";
print GI "maproom\/maproomregistry.owl\n";
print GI "maproom\/maproomtop.owl\n";
print GI "maproom\/newmaproomcache\/\n";
print GI "maproom\/tab.xslt\n";
print GI "maproom\/tabs.nt\n";
print GI "maproom\/tabs.xml\n";
print GI "maproom\/top.nt\n";
print GI "maproom\/top.xml\n";
print GI "maproom\/version.xml\n";
print GI "build.tag\n";
print GI "*~\n";

close GI;


