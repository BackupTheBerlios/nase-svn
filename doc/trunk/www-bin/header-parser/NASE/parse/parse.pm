package NASE::parse;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Parse::YYLex;
use NASE::xref;
use NASE::IDLparser;

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw( parseHeader );
$VERSION = '0.01';


# Preloaded methods go here.
my @token;

@token = (
          "DOCSTART" => ';\+',
	  "DOCEND"   => ';-',
          "CVSTAG"   => '\$[^\$]*\$',
	  "NAME"     => '[Nn][Aa][Mm][Ee]\s*:[ \t]*' => \&_UCsymbol,
	  "AIM"      => '[Aa][Ii][Mm]\s*:[ \t]*' => \&_UCsymbol,
	  "VERSION"  => '[Vv][Ee][Rr][Ss][Ii][Oo][Nn]\s*:[ \t]*' => \&_UCsymbol,
	  "PURP"     => '[Pp][Uu][Rr][Pp][Oo][Ss][Ee]\s*:[ \t]*' => \&_UCsymbol,
	  "CAT"      => '[Cc][Aa][Tt][Ee][Gg][Oo][Rr][Yy]\s*:[ \t]*' => \&_UCsymbol,
	  "CALLSEQ"  => '[Cc][Aa][Ll][Ll][Ii][Nn][Gg] [Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee]\s*:[ \t]*' => \&_UCsymbol,
	  "OPTINP"   => '[Oo][Pp][Tt][Ii][Oo][Nn][Aa][Ll] [Ii][Nn][Pp][Uu][Tt][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "INP"      => '[Ii][Nn][Pp][Uu][Tt][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "KEYS"     => '[Kk][Ee][Yy][Ww][Oo][Rr][Dd] [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Er][Rr][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "OPTOUT"   => '[Oo][Pp][Tt][Ii][Oo][Nn][Aa][Ll] [Oo][Uu][Tt][Pp][Uu][Tt][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "OUT"      => '[Oo][Uu][Tt][Pp][Uu][Tt][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "COMBLO"   => '[Cc][Oo][Mm][Mm][Oo][Nn] [Bb][Ll][Oo][Cc][Kk][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "SIDEFF"   => '[Ss][Ii][Dd][Ee] [Ee][Ff][Ff][Ee][Cc][Tt][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "RESTR"    => '[Rr][Ee][Ss][Tt][Rr][Ii][Cc][Tt][Ii][Oo][Nn][Ss]\s*:[ \t]*' => \&_UCsymbol,
	  "PROCED"   => '[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]\s*:[ \t]*' => \&_UCsymbol,
	  "EXAMP"    => '[Ee][Xx][Aa][Mm][Pp][Ll][Ee]\s*:[ \t]*' => \&_UCsymbol,
	  "SEEALSO"  => '[Ss][Ee][Ee] [Aa][Ll][Ss][Oo]\s*:[ \t]*' => \&_UCsymbol,
	  "AUTHOR"   => '[Aa][Uu][Tt][Hh][Oo][Rr]\s*:[ \t]*' => \&_UCsymbol,
	  "MODHIST"  => '[Mm][Oo][Dd][Ii][Ff][Ii][Cc][Aa][Tt][Ii][Oo][Nn] [Hh][Ii][Ss][Tt][Oo][Rr][Yy]\s*:[ \t]*' => \&_UCsymbol,
          "DEFAULT"  => '[Dd][Ee][Ff][Aa][Uu][Ll][Tt]\s*:',
	  "URLSTARTL" => '<[Aa]\s+[Hh][Rr][Ee][Ff]=',
	  "URLSTART" => '<[Aa][^>]*>',
	  "URLEND"   => '</[Aa]>',
	  "LANK"     => '<',
	  "RANK"     => '>',
	  "WS"       => '[\t ]+',
	  "PRE"      => '^;\*',
	  "COMMENT"  => '^;',
	  "LBRACE"   => '\(',
	  "RBRACE"   => '\)',
	  "CLBRACE"   => '{',
	  "CRBRACE"   => '}',
	  "EOL"      => '\n',
	  "COLON"    =>  ":",
	  "TEXT"     => '[^ :\n\t<>\(\)]+(\s*\(\s*\))?'
	 );

sub parseHeader {
  my ($file, $lexer, $parser, $token);
  
  $file = shift @_;

  open(IDLSOURCE, $file) or die "can't open file $file: $!\n";

  Parse::YYLex->ytab("IDLparser.ph");
  $lexer = Parse::YYLex->new(@token);
  $lexer->skip('');
  $lexer->from(\*IDLSOURCE);
    
  $parser = IDLparser->new($lexer->getyylex, &_yyerror, 0);
  $parser->yyparse(\*IDLSOURCE);

  close(IDLSOURCE);
}
  
  

# üprivate routines
sub _yyerror { print STDERR "$.: $@\n"; }      

sub _UCsymbol {
  return uc($_[1]);
}



# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

NASE::parse - Perl extension for blah blah blah

=head1 SYNOPSIS

  use NASE::parse;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for NASE::parse was created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head1 AUTHOR

A. U. Thor, a.u.thor@a.galaxy.far.far.away

=head1 SEE ALSO

perl(1).

=cut
