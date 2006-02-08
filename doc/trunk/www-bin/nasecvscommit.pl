#!/usr/bin/perl -w 

use lib "$ENV{NASEWWWCOPY}/doc/www-bin/header-parser";
use File::Basename;
use NASE::parse;

use diagnostics;
use strict;

my ($dir, @files) = split(" ", $ARGV[0]);

# my $fdir = "/vol/neuro/nase/www-nase-copy/$dir";
my $fdir = "/home/groups/nase/htdocs/wwwcopy/$dir";

my $file;
foreach $file (@files){
  # just work on IDL source files
  if (($file =~ /\.pro$/) && !($dir =~ /neuro/)){
    if (-r "$fdir/$file"){
      scanFile(repdir=>$dir, filepath=>"$fdir/$file");
      print STDERR "$file: updated/inserted using $dir/$file\n";
    } else {
      deleteFile(file=>basename($file,""));
      print STDERR "$file: deleted\n";
    }    
  }
}
exit 0;
