#!/usr/bin/perl

# build a new maproom registry, gather the rdfa triples from the new maproom pages,
# and build the index pages for the dirs above the mappages.
# 
# run  in the maproom directory. It must have tab.xslt in that dir

$maproom=0;
$dir = `pwd`;
if ($dir =~ m/maproom$/) { 
  print $dir,"\n";
  $maproom=1; 
}

if (-e 'tab.xslt') {
    if ($maproom) {
#      system("git pull");
      system("/data/jdcorral/git_build/ingrid/maproomtools/gen_registry.pl");
      system("/data/jdcorral/git_build/ingrid/maproomtools/runnewmaproom");
      system("/data/jdcorral/git_build/ingrid/maproomtools/build_index.pl");
      print "Updated new maproom\n";
    } else {
      print "You need to run this in a maproom directory.\n";
    }
} else {
      print "You need to run this with the file tab.xslt(found in maproomtools) in the current directory\n";
}
