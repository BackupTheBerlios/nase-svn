#!/usr/bin/perl -w

use strict;
use Parse::Lex;

my (@token, $lexer, $token);

sub _UCsymbol {
  return uc($_[1]);
}

@token = (
          "DOCSTART" => ';\+',
	  "DOCEND"   => ';-',
          "CVSTAG"   => '\$[^\$]*\$',
	  "NAME"     => '[Nn][Aa][Mm][Ee]\s*:[ \t]*' => \&_UCsymbol,
	  "AIM"      => '[Aa][Ii][Mm]\s*:[ \t]*' => \&_UCsymbol,
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
	  "URLSTARTL" => '<A\s+HREF=',
	  "URLSTART" => '<A[^>]*>',
	  "URLEND"   => '</A>',
	  "LANK"     => '<',
	  "RANK"     => '>',
	  "WS"       => '[\t ]+',
	  "PRE"      => '^;\*',
	  "COMMENT"  => '^;',
	  "LBRACE"   => '\(',
	  "RBRACE"   => '\)',
	  "EOL"      => '\n',
	  "COLON"    =>  ":",
	  "TEXT"     => '[^ :\n\t<>\(\)]+(\s*\(\s*\))?'
	 );

$lexer = Parse::Lex->new(@token);
$lexer->skip('');

if (defined $ARGV[0]){
  open(IDLSOURCE, $ARGV[0]) or die "$!\n";
  $lexer->from(\*IDLSOURCE);
}

while (($token = $lexer->next()) ne $Parse::Token::EOI){
  print $token->name(), ": >", $token->text(), "<\n";
#  print $token->text();
}

close(IDLSOURCE);
exit 0;
