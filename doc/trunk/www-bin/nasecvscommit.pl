#!/usr/bin/perl -w 

use File::Basename;
use NASE::parse;

use diagnostics;
use strict;

my ($dir, @files) = split(" ", $ARGV[0]);
my $file;
my $pwd = $ENV{"PWD"};

my $cut = $pwd;
while ($cut =~ /(nase)|(mind)/){
  $cut =~ s/\/[^\/]*$//;
}
$pwd =~ s/$cut//;
$pwd =~ s/\/$//g;
$pwd =~ s/^\///g;


foreach $file (@files){
  # just work on IDL source files
  if ($file =~ /\.pro$/){
    if (-r $file){
      scanFile(skel=>$cut, path=>$pwd, file=>basename($file,""));
      print STDERR "$file: updated/inserted using $pwd/$file\n";
    } else {
      deleteFile(file=>basename($file,""));
      print STDERR "$file: deleted\n";
    }    
  }
}
exit 0;
