#
# $Header$
#
package NASE::globals;

use strict;
use MLDBM qw(DB_File Storable);
use Fcntl;
use LockFile::Simple qw(lock trylock unlock);
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %hdata @hentry);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(setIndexDir getIndexDir setDocDir getDocDir setBaseURL getBaseURL setSubDir getSubDir checkH openHwrite closeHwrite openHread closeHread KeyByNameHTML KeyByCountHTML RoutinesHTML RoutinesCatHTML KeyByName KeyByCount parseAim getDocURL %hdata @hentry myHeader myBody);
$VERSION = '1.1';


# Preloaded methods go here.
my ($DOCURL, $hostname);
my ($INDEXDIR, $DOCDIR, $BASEURL, $SUBDIR, $_parseAim, $lockmgr, $CVSROOT);

## just default settings (START) ##
# CVSROOT: the location of the repository, if unset no checkout will be performed
# IDXDIR : several index files are written to this location
# DOCDIR : the www-copy of the NASE/MIND/DOC repository is checked out 
#          to this location
# DOCURL : specifies the URL to docdir with trailing slash, please! 


BEGIN {
  chop ($hostname = `uname -a`);
  {
      $hostname =~ /neuro/i && do {$CVSROOT="/vol/neuro/nase/IDLCVS"; 
    			       $DOCDIR="/vol/neuro/nase/www-nase-copy"; 
    			       $DOCURL="http://neuro.physik.uni-marburg.de/nase/";
       			       $INDEXDIR="$DOCDIR"};
    
#    			       last;};
#    $DOCDIR="/mhome/saam/sim"; 
#    $DOCURL="http://localhost/nase/"; 
#    $INDEXDIR="/tmp";
  }
  
  $BASEURL  = "http://neuro.physik.uni-marburg.de/cgi-bin-neuro/nasedocu.pl";
  $SUBDIR   = "/";
  $_parseAim = 0;
  ## just default settings (END) ##

  # configure file locking policy
  $lockmgr = LockFile::Simple->make(-nfs=>1, -stale=>1, -hold=>600);

}



sub setIndexDir { $INDEXDIR = shift @_; }
sub getIndexDir { return $INDEXDIR; }
sub setDocDir { $DOCDIR = shift @_; }
sub getDocDir { return $DOCDIR; }
sub getDocURL { return $DOCURL; }
sub setBaseURL { $BASEURL = shift @_; }
sub getBaseURL { return $BASEURL; }
sub setSubDir { $SUBDIR = shift @_; }
sub getSubDir { return $SUBDIR; }



sub parseAim        { if ($#_ ge 0) { $_parseAim = shift @_;  } else { return $_parseAim; } }
sub KeyByNameHTML   { return "keywords-by-name.html"; } 
sub KeyByCountHTML  { return "keywords-by-count.html"; }
sub RoutinesHTML    { return "routines-by-name.html"; } 
sub RoutinesCatHTML { return "routines-by-cat.html"; } 
sub KeyByName       { return getIndexDir()."keywords-by-name"; }
sub KeyByCount      { return getIndexDir()."keywords-by-count"; }


##
## implement a simple locking, persistent hash
##
## %hdata is a hash of lists, the key is the filename 
## the lists has the following organization [dir, name, aim, catlist ]
my $hfiler = "/tmp/nasedocu.db";
my $hfilew = "/tmp/nasedocu.new.db";
@hentry = ();

sub openHwrite {
  $lockmgr->lock ($hfilew) || die "can't get lock for $hfilew: $!\n";
  tie (%hdata, 'MLDBM', $hfilew, O_CREAT | O_RDWR, 0666) || die "can't tie to $hfilew: $!\n";
  print STDERR "tied $hfilew for write\n";
}

sub closeHwrite {
  untie(%hdata) || die "can't untie $hfilew: $!\n";
  $lockmgr->unlock($hfilew) || die "can't unlock $hfilew: $!\n"; 
  print STDERR "untied $hfilew\n";

  $lockmgr->lock ($hfiler) || die "can't get lock for $hfiler: $!\n";
  `cp $hfilew $hfiler`;
  unlink ($hfilew);
  $lockmgr->unlock ($hfiler);
}


sub checkH {
  my $lastmod = (stat($hfiler))[9] || return;
  return localtime($lastmod);
}


sub openHread {
  $lockmgr->lock ($hfiler) || die "can't get lock for $hfiler: $!\n";
  tie (%hdata, 'MLDBM', $hfiler, O_CREAT | O_RDWR, 0666) || die "can't tie to $hfiler: $!\n";
  print STDERR "tied $hfiler for read\n";
}

sub closeHread {
  untie(%hdata) || die "can't untie $hfiler: $!\n";
  $lockmgr->unlock($hfiler) || die "can't unlock $hfiler: $!\n"; 
  print STDERR "untied $hfiler\n";
}

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
