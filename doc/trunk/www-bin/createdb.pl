#!/usr/bin/perl -w
#
# deletes and recreates complete nase database
# if -u is specified only an update is performed
#
use diagnostics;
use strict;

use File::Basename;
use Getopt::Std;

use NASE::globals;
use NASE::xref;
use NASE::parse;


use vars qw( $opt_u );
getopts("u");

deleteDB() if not defined $opt_u;


#my $CVSROOT = "/vol/neuro/nase/IDLCVS";
my $CVSROOT;
my (@projects);

if (defined $CVSROOT){ 
  print "CVSROOT is set to    ... $CVSROOT\n";
  
  opendir(DIR, $CVSROOT) || print "can't opendir $CVSROOT: $!\n";
  @projects = grep { /^[^\.]/ && -d "$CVSROOT/$_" && ! /CVS|RCS/i && ! /doc/ } readdir(DIR);
  closedir DIR;      
} else {
  print "CVSROOT: not set   ... ignoring checkout, assuming modules nase and mind\n"; 
  @projects = ("nase", "mind");
};

print "looking for projects ... ", join(" ",@projects), "\n";
foreach (@projects){
  updateDB($_);
}

exit 0;
