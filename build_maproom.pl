#!/usr/bin/perl

# build a new maproom registry, gather the rdfa triples from the new maproom pages,
# and build the index pages for the dirs above the mappages.
# 
# run on a machine that has git and a saxon jar file and 64-Bit java and in
# the maproom directory. right now it is using ~jdcorral/xmldocs/workspace/olfs/lib/saxon-9.1.0.5.jar

# make sure that we are using 64-bit java and that we are in a maproom dir
$java64=0;
$maproom=0;
my @result = `java -version 2>&1`;
foreach (@result) {
  if ($_ =~ m/64-Bit/i) { 
    $java64=1;
  }
}
$dir = `pwd`;
if ($dir =~ m/maproom$/) { 
  print $dir,"\n";
  $maproom=1; 
}

if ($java64) {
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
      print "You need to run this with 64-Bit java\n";
}
