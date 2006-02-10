#!/usr/bin/perl -w 

use lib "$ENV{NASEWWWCOPY}/doc/www-bin/header-parser";
use lib "$ENV{HOME}/AddPerl/Tie-DBI-1.01/lib";
use lib "$ENV{HOME}/AddPerl/ParseLex-2.15/lib";
use File::Basename;
use Switch;
use NASE::parse::parse;

use diagnostics;
use strict;

#my ($dir, @files) = split(" ", $ARGV[0]);

# my $fdir = "/vol/neuro/nase/www-nase-copy/$dir";
#my $fdir = "$ENV{NASEWWWCOPY}/wwwcopy/$dir";

#my $file;
#foreach $file (@files){
  # just work on IDL source files
#  if (($file =~ /\.pro$/) && !($dir =~ /neuro/)){
#    if (-r "$fdir/$file"){
#      scanFile(repdir=>$dir, filepath=>"$fdir/$file");
#      print STDERR "$file: updated/inserted using $dir/$file\n";
#    } else {
#      deleteFile(file=>basename($file,""));
#      print STDERR "$file: deleted\n";
#    }    
#  }
#}

my $line;
while (defined($line = <STDIN>)) {
  print STDOUT "Piped from svn update:\n $line\n";
  my @parts = split(" ", $line);
  switch ($parts[0]) {
    case "U" {
	      print "Update:\n";
	      my $path;
	      my $base;
	      my $type;
	      ($base,$path,$type) = fileparse($parts[1],qr/\.[^.]*/);
	      print "$path\n";
	      print "$base\n";
	      print "$type\n";
	      if ($type eq ".pro") {
#		scanFile(repdir=>$dir, filepath=>"$parts[1]");
		scanFile();#filepath=>"$parts[1]");
		print "$file: updated/inserted using $parts[1]\n";
	      } else {
		print "Not an IDL source file: $type.\n";
	      }
	     }
      else
	{ print "Unknown: $parts[0]\n"; }
  }  }

exit 0;
