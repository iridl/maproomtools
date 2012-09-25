#!/usr/bin/perl -w

# parse a single file for rdfa

if ($#ARGV != 0 ) {
	print "usage: rdfalint.pl filename or url\neg: rdfalint.pl CMAP_climo.html.en\n";
	exit;
}
  @args = ("xsltproc", "--novalid", "http://iridl.ldeo.columbia.edu/ontologies/xslt/RDFa2RDFXML.xsl", $ARGV[0]);
  system(@args) == 0 or die "system call failed: $?";




