#!/usr/bin/perl -w
#Tool to generate the emulation graph of constraints
use strict;

my %prevs;
my %nexts;

my %cstrs;

sub isStandalone($) {
    my ($cstr) = @_;
    return (!$prevs{$cstr} && !$nexts{$cstr});
}

sub label($) {
    my ($f) = @_;
    my @arr = split(/\,/,$f);
    return join("_PLUS_",@arr);
}

sub toDot ($){
    my ($output) = @_;
    open DOT,">$output";
    print  DOT "digraph g {\n";
    #Vertexes
    foreach (keys(%cstrs)) {
	if (!isStandalone($_)) {
	    print DOT "\t".$_."\n";
	}
    }
    foreach (keys(%nexts)) {
	my $cstr = $_;
	#For each emulation
	for my $with (keys(%{$nexts{$cstr}})) {
	    print $cstr." " .$with ." " .label($with)."\n"; 
	    if ($cstr =~ /\,/) {
		print DOT label($cstr). " [label=\"+\",shape=diamond]\n";
		foreach(split(/\,/,$cstr)) {
		    print DOT "$_ -> ".label($cstr)."\n";
		}
	    }
	    print DOT label($cstr)."  -> ".label($with)."\n";
	}
    }
    
    print  DOT "}";
    close DOT;
}

sub generate($) {
    my ($out) = @_;
    toDot(".pure.dot");
    system("tred .pure.dot >.reduced.dot");
    system("dot -x -Tsvg -o $out .reduced.dot");
}

sub prettyDeps {
    foreach (keys(%cstrs)) {
	print $_.":\n";
	my $cstr = $_;
	print "reformulation(s):";
	if ($prevs{$cstr}) {
	    print "\n";
	    for my $with  (keys (%{$prevs{$cstr}})) {
		my %rules = %{$prevs{$cstr}{$with}};
		print "\t$rules{from} -> $rules{to}\n";
	    }
	} else {
	    print "-\n";
	}

	print "specialization(s):";
	if ($nexts{$cstr}) {
	    print "\n";
	    for my $with  (keys (%{$nexts{$cstr}})) {
		my %rules = %{$nexts{$cstr}{$with}};
		print "\t$rules{from} -> $rules{to}\n";
	    }
	} else {
	    print "-\n";
	}
    }
}
sub parseFile {
    my ($file) = @_;
    open FP, $file or die("Unable to open '$file'");
    my @prev=();
    while (my $line = <FP>) {
	#Get every constraint, even those without any specialization
	if (my ($cstr) = $line =~ /classification\{(.+)\}\{.+\}\{.+\}\{/) {
	    $cstrs{$cstr} = 1;
	}

	#Get inheritance relationships and rewriting rules
	if (my ($cstr, $with,$from,$to) = $line =~ /emulatedWith\{(.+)\}\{(.+)\}\{(.+)\}\{(.+)\}/) {
	    print "$file: Matched $cstr emulated with $with\n";
	    $prevs{$cstr}{$with} = {from => $from, to => $to};
	    $nexts{$with}{$cstr} = {to => $from, from => $to};

	}
    }
    close FP;
}


sub InheritancesToLatex() {
    unlink("_all_.inh");
    open Y,">>_all_.inh";
    foreach (keys(%cstrs)) {
	if (!isStandalone($_)) {
	    open X, ">$_.inh";
	    
	    print Y "\\subsection{".ucfirst($_)."}\n";
	    my $buf = InheritanceToLatex($_);
	    print X $buf;
	    print Y $buf;
	    close X;
	}
    }
    close(Y);
}

sub prettyLabels($) {
    my ($buf) = @_;
    my (@arr) = split(",",$buf);
    for (my $i = 0; $i < @arr; $i++) {
	$arr[$i] = "\\cstrref{$arr[$i]}";
    }
    return join("+",@arr);
}

sub InheritanceToLatex($) {
	my ($cstr) = @_;
	my $buf = "";
	if ($prevs{$cstr}) {
	    $buf .="\\subsubsection{Reformulation(s)}";
	    $buf .= "\n\\begin{itemize}\n";
	    for my $with  (keys (%{$prevs{$cstr}})) {
		my %rules = %{$prevs{$cstr}{$with}};
		$buf .= "\\item Using ".prettyLabels($with).": $rules{from} \\myEquiv\ $rules{to}\n";
	    }
	    $buf .= "\\end{itemize}\n";
	} 
	if ($nexts{$cstr}) {
	    $buf .= "\\subsubsection{Specialization(s)}";
	    $buf .= "\n\\begin{itemize}\n";
	    for my $with  (keys (%{$nexts{$cstr}})) {
		my %rules = %{$nexts{$cstr}{$with}};
		$buf .= "\\item To ".prettyLabels($with).": $rules{from} \\myEquiv\ $rules{to}\n";
	    }
	    $buf .= "\\end{itemize}\n";
	} 
	return $buf;
}

#Parsing
foreach (@ARGV) {
    parseFile($_);
}

#prettyDeps();
#Store the big diagram
#my $output = "";

generate("../svg/inheritance.svg");
InheritancesToLatex();

