#!/usr/bin/perl
# build a new maproom registry, gather the rdfa triples from the new maproom pages,
# and build the index pages for the dirs above the mappages.
# run  in the maproom directory. 
use File::Basename;
my $ruleset = "owl-max-optimized";
if ($#ARGV+1 > 0) {
   $ruleset = $ARGV[0];
}
$maproomtoolsdir = dirname($0);
print "Using ruleset '$ruleset'\n";
system("$maproomtoolsdir/gen_registry.pl") == 0 or die "system failed: $?";
system("$maproomtoolsdir/runnewmaproom.pl '$ruleset'") == 0 or die "system failed: $?";
system("$maproomtoolsdir/gen_maproomtop.pl '$ruleset'") == 0 or die "system failed: $?";
system("$maproomtoolsdir/build_index.pl") == 0 or die "system failed: $?";
print "Updated new maproom\n";
