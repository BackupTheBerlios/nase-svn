#
# $Header$
#
package NASE::globals;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(setIndexDir getIndexDir setDocDir getDocDir setBaseURL getBaseURL setSubDir getSubDir );
$VERSION = '1.1';


# Preloaded methods go here.
my ($INDEXDIR, $DOCDIR, $BASEURL, $SUBDIR);

$INDEXDIR = "/tmp";
$BASEURL  = "http://neuro.physik.uni-marburg.de/cgi-bin-neuro/nasedocu.pl";
$DOCDIR   = "/mhome/saam/sim/nase";
$SUBDIR   = "/";

sub setIndexDir { $INDEXDIR = shift @_; }
sub getIndexDir { return $INDEXDIR; }
sub setDocDir { $DOCDIR = shift @_; }
sub getDocDir { return $DOCDIR; }
sub setBaseURL { $BASEURL = shift @_; }
sub getBaseURL { return $BASEURL; }
sub setSubDir { $SUBDIR = shift @_; }
sub getSubDir { return $SUBDIR; }



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
