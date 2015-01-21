#!
# suppresses output files (html from xhtml)
open filelist,"find -L . -regex '.*\\.x*html[^~]*\$' |";
#open filelist,"find -L . -name '.*\\.x?html[^~]*\$' |";
while(<filelist>){
    chop;
    if(/^(.+).xhtml(\..+)?$/){
	$out = "$1.html$2";
	$output{"$out"} = "1";
	$hasoutput{"$_"} = "1";
    $all{"$out"}="1";
    }
    push @files, $_;
    $all{"$_"}="1";
}
close filelist;
if($ARGV[0] eq 'src'){
# src -- outputs source xhtml/html files
    foreach $vval (@files){
	if(!$output{$vval}){
	    print "$vval\n";
	}
    }
}
elsif($ARGV[0] eq 'bld') {
# bld -- outputs target (to be build from xhtml) html files
    foreach $vval (sort keys %output){
	if($output{$vval}){
	    print "$vval\n";
	}
    }
}
elsif($ARGV[0] eq 'out') {
# out -- outputs final file list (omits source xhtml files)
    foreach $vval (sort keys %all){
	if(!$hasoutput{$vval}){
	    print "$vval\n";
	}
    }
}
elsif($ARGV[0] eq 'bldlang') {
    $mydir = $ARGV[1];
# bldlang directories that need index.tex files or build index file
    foreach $vval (sort keys %all){
	if($vval =~ /^(.+)\/([^\/]+)\.html\.(.+)$/){
	    $cdir = $1;
	    $fname = $2;
	    $lang = $3;
	    if(!$done{$1}){
		print "$1/index.tex\n";
		$done{$1}="1";
	    }
	}
    }
}
elsif($ARGV[0] eq 'bldlangindex') {
    $mydir = $ARGV[1];
# build index file
    if($mydir =~ /(.*)\/index.tex/){
	$mycdir = $1;
	print '\begin{ingrid}',"\n";
	foreach $vval (sort keys %all){
	    if($vval =~ /^(.+)\/([^\/]+)\.html\.(.+)$/){
		$cdir = $1;
		$fname = $2;
		$lang = $3;
		$fnames{$fname}="1"
	    }
	}
	foreach $fname (sort keys %fnames){
	    print "/$fname.html { PickLanguage:\n";
	    foreach $vval (sort keys %all){
		if($vval =~ /^(.+)\/([^\/]+)\.html\.(.+)$/){
		    $cdir = $1;
		    $fname = $2;
		    $lang = $3;
		    if($cdir eq $mycdir){
			print "/$lang /$fname.html.$lang\n";
		    }
		}
	    }
	    print ":PickLanguage stop}def\n";
	    
	}
	print '\end{ingrid}',"\n";
    }
}

