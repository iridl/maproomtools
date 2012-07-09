#!/usr/bin/perl

# build a new maproom registry, gather the rdfa triples from the new maproom pages,
# and build the index pages for the dirs above the mappages.
# 
# run  in the maproom directory. 

$maproom=0;
$dir = `pwd`;
if ($dir =~ m/maproom$/) { 
  print $dir,"\n";
  $maproom=1; 
}
use File::Basename;
$maproomtoolsdir = dirname($0);

    if ($maproom) {
      system("$maproomtoolsdir/gen_registry.pl") == 0
         or die "system failed: $?";
      system("$maproomtoolsdir/runnewmaproom.pl") == 0
         or die "system failed: $?";
      system("$maproomtoolsdir/gen_maproomtop.pl") == 0
         or die "system failed: $?";
      system("$maproomtoolsdir/build_index.pl") == 0
         or die "system failed: $?";
      print "Updated new maproom\n";
    } else {
      print "You need to run this in a maproom directory.\n";
    }
