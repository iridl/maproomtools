print '<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:vocab="http://www.w3.org/1999/xhtml/vocab#"
  xmlns:maproomregistry ="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#">',"\n",
    "<owl:Ontology rdf:about=\"\">\n";
foreach $vval (@ARGV){
    if($vval =~ /.*\.owl$/){
    print "<owl:imports rdf:resource=\"$vval\" />\n";
    }
    else {
    print "<maproomregistry:importsRdfa><rdf:Description rdf:about=\"$vval\"></rdf:Description></maproomregistry:importsRdfa>\n";
    }
}
print "</owl:Ontology>\n";
foreach $vval (@ARGV){
    if($vval =~ /\.x?html/){
	$fval = $vval;
	$fval =~ s/\.x?html.*/.html/;
	$uri = 'file:///' . $fval;
	$uri =~ s/^file:\/\/\/\.\//file:\/\/\//;
    print "<rdf:Description rdf:about=\"$vval\"><vocab:alternate rdf:resource=\"$uri\" /></rdf:Description>\n";
    if($fval =~ /index.html/){
	$fval =~ s/\.html.*$/.html/;
	$suri = $uri;
	$suri =~ s/index.html.*$//;
    print "<rdf:Description rdf:about=\"$uri\"><vocab:alternate rdf:resource=\"$suri\" /></rdf:Description>\n";
    }
    }
}
print "</rdf:RDF>\n"
