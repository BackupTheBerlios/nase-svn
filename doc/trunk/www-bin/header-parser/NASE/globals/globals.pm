#
# $Header$
#
package NASE::globals;

#use diagnostics;
#use strict;
use CGI::Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK @hentry %pro %catl $dbh);
use DBI;
use Tie::DBI;

use Env qw(HTTPS);

use constant DATABASE => 'nase';
use constant AUSER    => 'chiefnase';
use constant APASSWD  => 'misfitme';

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(setIndexDir getIndexDir setDocDir getDocDir setBaseURL getBaseURL setSubDir getSubDir KeyByNameHTML KeyByCountHTML KeyByName KeyByCount getDocURL @hentry myHeader myBody getCVS setCVS %pro %catl $dbh createTablesIfNotExist ); 
$VERSION = '1.1';


# Preloaded methods go here.
my ($DOCURL, $hostname);
my ($INDEXDIR, $DOCDIR, $BASEURL, $SUBDIR, $CVSROOT); #, $lockmgr

## just default settings (START) ##
# CVSROOT: the location of the repository, if unset no checkout will be performed
# IDXDIR : several index files are written to this location
# DOCDIR : the www-copy of the NASE/MIND/DOC repository is checked out 
#          to this location
# DOCURL : specifies the URL to docdir with trailing slash, please! 



###################################################################################
###################################################################################
###################################################################################
sub createTablesIfNotExist {
  my ($sql, $sth);
  my @cats = ("Algebra", "Animation", "Array", "Color", "CombinationTheory", "Connections", "DataStorage", "DataStructures", "Demonstration", 
	      "Dirs", "ExecutionControl", "Files", "Fonts", "Graphic", "Help", "Image", "Input", "Internal",
	      "IO", "Layers", "Math", "MIND", "NASE", "NumberTheory", "Objects", "OS", "Plasticity", "Startup", "Statistics", "Signals",
	      "Simulation", "Strings", "Structures", "Widgets", "Windows", "_Error");
  # _Error is an internal category that contains doc headers with errors

  if (not grep(/^pro$/, $dbh->func('_ListTables'))){
    $dbh->do ( qq{
		  CREATE TABLE pro
		  (  fname   CHAR(80) NOT NULL PRIMARY KEY,
		     rname   CHAR(80) NOT NULL,
		     aim     TEXT,
		     dir     CHAR(255) NOT NULL,
		     header  TEXT
		  )
		 }
	     );
  }
  die "create table routines: $DBI::errstr\n" if $DBI::err;


  if (not grep(/^catl$/, $dbh->func('_ListTables'))){
    $dbh->do ( qq{
		  CREATE TABLE catl
		  (  cname   CHAR(80) NOT NULL PRIMARY KEY
		  )
		 }
	     );
    
    $sql = "INSERT INTO catl VALUES (?)";
    $sth = $dbh->prepare($sql);
    die "$DBI::errstr\n" if $DBI::err;
    foreach (@cats){
      $sth->execute($_);
      warn "$DBI::errstr\n" if $DBI::err;
    }      
    $sth->finish();
  }
  die "create table error: $DBI::errstr\n" if $DBI::err;


  if (not grep(/^cat$/, $dbh->func('_ListTables'))){
    $dbh->do ( qq{
		  CREATE TABLE cat
		  (  fname   CHAR(80) NOT NULL,  # points to fname in pro
		     cname   CHAR(80) NOT NULL,  # points to cname in catl
		     PRIMARY KEY (fname, cname)		   
		  )
		 }
	     );
  }
  die "create table cat: $DBI::errstr\n" if $DBI::err;
}



BEGIN {
  chop ($hostname = `uname -a`);
  {
   $CVSROOT="/vol/neuro/nase/IDLCVS"; 
   $DOCDIR="/vol/neuro/nase/www-nase-copy"; 

   if($HTTPS =~ /on/ ){
     $DOCURL="https://neuro.physik.uni-marburg.de/nase/";
   }else{
     $DOCURL="http://neuro.physik.uni-marburg.de/nase/";
   }
   $INDEXDIR="$DOCDIR"; #should be unused
    
#    $DOCDIR="/mhome/saam/sim"; 
#    $DOCURL="http://localhost/nase/"; 
#    $INDEXDIR="/tmp";
  }
  

  if($HTTPS =~ /on/ ){
    $BASEURL  = "https://neuro.physik.uni-marburg.de/perl/nasedocu.pl";
  }else{
    $BASEURL  = "http://neuro.physik.uni-marburg.de/perl/nasedocu.pl";
  }
    
  $SUBDIR   = "/";
  ## just default settings (END) ##


  # manage database
  $dbh = DBI->connect("DBI:mysql:database=".DATABASE, AUSER, APASSWD);
  die "connect error: $DBI::errstr\n" if $DBI::err;
  # create tables if not existent
  createTablesIfNotExist();
  # tie to tables
  tie %pro, 'Tie::DBI', {
			 db       => "dbi:mysql:database=" . DATABASE,
			 table    => 'pro',
			 key      => 'fname',
			 user     => AUSER,
			 password => APASSWD,
			 CLOBBER  => 2
			}
    || die "can't tie to database: $!\n";

  tie %catl, 'Tie::DBI', {
			 db       => "dbi:mysql:database=" . DATABASE,
			 table    => 'catl',
			 key      => 'cname',
			 user     => AUSER,
			 password => APASSWD,
			 CLOBBER  => 0
			}
    || die "can't tie to database: $!\n";

}

END {
  untie %pro;
  untie %catl;
  $dbh->disconnect();
}



sub setIndexDir { $INDEXDIR = shift @_; }
sub getIndexDir { return $INDEXDIR; }
sub setCVS { $CVSROOT = shift @_; }
sub getCVS { return $CVSROOT; }
sub setDocDir { $DOCDIR = shift @_; }
sub getDocDir { return $DOCDIR; }
sub getDocURL { return $DOCURL; }
sub setBaseURL { $BASEURL = shift @_; }
sub getBaseURL { return $BASEURL; }
sub setSubDir { $SUBDIR = shift @_; }
sub getSubDir { return $SUBDIR; }



sub KeyByNameHTML   { return "keywords-by-name.html"; } 
sub KeyByCountHTML  { return "keywords-by-count.html"; }
sub KeyByName       { return getIndexDir()."keywords-by-name"; }
sub KeyByCount      { return getIndexDir()."keywords-by-count"; }

# globally used to transfer data from IDLparser.pm (IDLparser.y) to parse.pm
@hentry = ();

sub myHeader {
  return join("\n", ( "<HTML><HEAD><TITLE>NASE/MIND Documentation System</TITLE>" 
	          , '<LINK REL="STYLESHEET" HREF="'.$DOCURL.'/doc/www-doc/shtml.css">'
		  , '</HEAD>'));
}

sub myBody {
#  return "<BODY bgcolor=#FFFFFF text=#000000 link=#AA5522 vlink=#772200 alink=#000000>";
  return "<BODY bgcolor=#FFFFFF text=#000000>";
}


# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

NASE::globals - Perl extension for blah blah blah

=head1 SYNOPSIS

  use NASE::globals;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for NASE::globals was created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head1 AUTHOR

A. U. Thor, a.u.thor@a.galaxy.far.far.away

=head1 SEE ALSO

perl(1).

=cut
