print '<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:maproomregistry ="http://iridl.ldeo.columbia.edu/maproom/maproomregistry.owl#">',"\n",
    "<owl:Ontology rdf:about=\"\">\n";
foreach $vval (@ARGV){
    if($vval =~ /.*\.owl$/){
    print "<owl:imports rdf:resource=\"$vval\" />\n";
    }
    else {
    print "<maproomregistry:importsRdfa rdf:resource=\"$vval\" />\n";
    }
}
print "</owl:Ontology></rdf:RDF>\n"
