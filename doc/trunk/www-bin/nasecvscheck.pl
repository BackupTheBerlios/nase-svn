#!/usr/bin/perl -w 

use File::Basename;
use NASE::parse;

use diagnostics;
use strict;

my ($repository, @files) = @ARGV;
my $file;

foreach $file (@files){
  # just check IDL source files
  if ($file =~ /\.pro$/){
    print "$file: checking...\n";
    if (-r $file){
      # if file is not readable commit should probably remove the file, so we do not check it
      my %pro = scanFile(path=>dirname($file), file=>basename($file,""), test=>1);
      
      if ($pro{rname} =~ /_error/){
	print STDERR "$file: syntax error in documentation header\n";
	exit 1;
      } else {
	print "$file: syntax ok\n";
      }
    }
  }
}
exit 0;
  
