package NASE::parse;

use strict;
use CGI qw/:standard :html3 :netscape -debug/;
#use File::Basename;
use File::Find;

# just for debug
# use Data::Dumper;

use NASE::globals;
use NASE::xref;
use Parse::YYLex;
use NASE::IDLparser;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw( parseHeader createAim showHeader showSource showLog);
$VERSION = '1.2';



my (@token, $lexer, $parser, @subdir);



sub _yyerror { print STDERR "$.: $@\n"; }      
BEGIN {
  # initialize scanner and parser
  @token = (
	    "DOCSTART" => ';\+',
	    "DOCEND"   => ';-',
	    "CVSTAG"   => '\$[^\$]*\$',
	    "NAME"     => 'NAME\s*:[ \t]*',
	    "AIM"      => 'AIM\s*:[ \t]*',
	    "VER"      => 'VERSION\s*:[ \t]*',
	    "PURP"     => 'PURPOSE\s*:[ \t]*',
	    "CAT"      => 'CATEGORY\s*:[ \t]*',
	    "CALLSEQ"  => 'CALLING SEQUENCE\s*:[ \t]*',
	    "OPTINP"   => 'OPTIONAL INPUTS\s*:[ \t]*',
	    "INP"      => 'INPUTS\s*:[ \t]*',
	    "KEYS"     => 'INPUT KEYWORDS\s*:[ \t]*',
	    "OPTOUT"   => 'OPTIONAL OUTPUTS\s*:[ \t]*',
	    "OUT"      => 'OUTPUTS\s*:[ \t]*',
	    "COMBLO"   => 'COMMON BLOCKS\s*:[ \t]*',
	    "SIDEFF"   => 'SIDE EFFECTS\s*:[ \t]*',
	    "RESTR"    => 'RESTRICTIONS\s*:[ \t]*',
	    "PROCED"   => 'PROCEDURE\s*:[ \t]*',
	    "EXAMP"    => 'EXAMPLE\s*:[ \t]*',
	    "SEEALSO"  => 'SEE ALSO\s*:[ \t]*',
	    "AUTHOR"   => 'AUTHOR\s*:[ \t]*',
	    "SUPERCLASSES" => 'SUPERCLASSES\s*:[ \t]*',
	    "CONSTRUCTION" => 'CONSTRUCTION\s*:[ \t]*',
	    "DESTRUCTION" => 'DESTRUCTION\s*:[ \t]*',
	    "ABMETHODS" => 'ABSTRACT METHODS\s*:[ \t]*',
	    "METHODS" => 'METHODS\s*:[ \t]*',
	    "MODHIST"  => 'MODIFICATION HISTORY\s*:[ \t]*',
	    "DEFAULT"  => 'DEFAULT\s*:',
	    "URLSTARTL" => '<A\s+NREF=',
#	    "URLSTARTN" => '<A\s+HREF=[^>]*',
	    "URLSTART" => '<A( [^>]*)?>',
	    "URLEND"   => '</A>',
	    "TTSTART"  => '<\*>',
	    "TTEND"    => '<\/\*>',
	    "BSTART"  => '<B>',
	    "BEND"    => '<\/B>',
	    "ISTART"  => '<I>',
	    "IEND"    => '<\/I>',
	    "SUPSTART"  => '<SUP>',
	    "SUPEND"    => '<\/SUP>',
	    "SUBSTART"  => '<SUB>',
	    "SUBEND"    => '<\/SUB>',
	    "BREAK"    => '<BR>',
	    "LANK"     => '<',
	    "RANK"     => '>',
	    "WS"       => '[\t ]+',
	    "PRE"      => '^;\*',
	    "COMMENT"  => '^;',
	    "LBRACE"   => '\(',
	    "RBRACE"   => '\)',
	    "CLBRACE"  => '{',
	    "CRBRACE"  => '}',
	    "EOL"      => '\n',
	    "DCOLON"   => "::",
	    "COLON"    =>  ":",
	    "TEXT"     => '[^ :\n\t<>\(\)]+(\s*\(\s*\))?'
	   );
  Parse::YYLex->ytab("IDLparser.ph");
  $lexer = Parse::YYLex->new(@token);
  $lexer->skip('');
  $parser = IDLparser->new($lexer->getyylex, &_yyerror, 0);
}



# Preloaded methods go here.
###################################################################################
###################################################################################
###################################################################################




###################################################################################
###################################################################################
###################################################################################
# calls createAimandKeylist and writes index files if on top level dir
#
# arg1: directory to create aim for
###################################################################################
sub createAim {
  my ($key, $count, %count, $fh);

  (my $mydir) = @_;

  openHwrite();

  # pipe parser output to hell
  open(NULL, ">>/dev/null") || die "can't open /dev/null for write: $!\n";
  $fh = select(NULL);
  parseAim(1); # just parse the aim

  createDirHash($mydir);
  createDirHash($mydir); # run twice to get MakeURL in AIM working
  
  # restore STDOUT
  select($fh);
  close(NULL) || die "can't close /dev/null: $!\n";

  closeHwrite();
  Aim2Html($mydir);
}



###################################
## works only from createAim
###################################
sub Aim2Html {
  my ($mydir) = @_;
  my ($dir, $key, @data, @subdir);
  my $DOCDIR = getDocDir();

  
  sub wanted {
    push(@subdir, $File::Find::dir) if -d;
  }
  find(\&wanted, "$DOCDIR/$mydir");
  
  
  
  openHread();
  
  foreach $dir (@subdir){
    $dir =~ s,$DOCDIR/,,;
    print "processing $dir\n";
    @data = ();
    while (defined ($key = each %hdata)){
      if (@{$hdata{$key}}[0] eq $dir){
	push(@data, '<TR><TD CLASS="xmpcode" VALIGN=TOP>'.makeURL($key).'</TD><TD CLASS="xplcode" VALIGN=TOP>'.@{$hdata{$key}}[2]."</TD></TR>");
      }
    }
    
    if (open (AIM, ">$DOCDIR/$dir/index.html")){
      print AIM start_html('NASE/MIND Documentation System'), h1($dir), "<TABLE COLS=2>\n";
      print AIM join("\n", sort @data);
      print AIM "\n</TABLE>", end_html;
      close (AIM);
    } else {
      print STDERR "can't open $DOCDIR/$dir/index.html for write: $!\n";
    }
  }
  closeHread();  
}
#  if ($mydir eq "/"){
    #
    # write Keywords-By-Name index file
    #
#    open(FILE, ">".KeyByName()) || die "can't open ".KeyByName()." for write: $!\n";
#    foreach $key (sort keys %keywords){
#      print FILE "$key $keywords{$key}$routines{$key}\n";
#    }
#    close(FILE);

    #
    # write Keywords-By-Count index file
    #
#    open(FILE, ">".KeyByCount()) || die "can't open ".KeyByCount()." for write: $!\n";
#    foreach (values %keywords) {
#      $count{$_} = "dummy";
#    }
#    foreach $key (sort {$b <=> $a} keys %count) {
#      foreach (sort grep {$key == $keywords{$_}} keys %keywords){
#	print FILE "$_ $key$routines{$_}\n";
#      }
#    }
#    close(FILE);
#  }




###################################################################################
###################################################################################
###################################################################################
# recursively enlarges %hdata per directory 
# %hdata must be already tied
# called by createHash
#
# arg1: directory to scan
###################################################################################
sub createDirHash {
  my ($mydir, $DOCDIR, @sdir, @file, $file);

  $mydir = shift @_;
  $mydir =~ s,\/$,,g;
  $mydir =~ s,^\/,,g;
  $DOCDIR = getDocDir();

  # search for non-dot subdirs and IDL files
  if (opendir(DIR, "$DOCDIR/$mydir")){

    @sdir = grep { /^[^\.]/ && -d "$DOCDIR/$mydir/$_" && ! /(CVS)|(RCS)/ } readdir(DIR);
    rewinddir(DIR);
    @file = sort grep { /\.pro$/i && -f "$DOCDIR/$mydir/$_" } readdir(DIR);
    closedir DIR;      
    
    foreach (sort @sdir){
      if (($_ ne "alien") && ($_ ne "object")){ createDirHash("$mydir/$_"); }
    }

    foreach $file (sort @file) {
      @hentry = ();
      print STDERR "$mydir/$file\n";
      parseHeader("$DOCDIR/$mydir/$file"); # will modify @hentry
      unshift(@hentry, $mydir);
      $hdata{$file} = \@hentry;
    }
  } else { print STDERR "error processing $DOCDIR/$mydir: $!\n"; }
}



###################################################################################
###################################################################################
###################################################################################
sub showLog {

  my ($file, $key, @entry);
  
  $key = lc(shift(@_));
  $key .= ".pro" unless $key =~ /\.pro$/i;

  openHread();
  @entry = @{$hdata{$key}};
  $file = getDocDir()."/".$entry[0]."/".$key;

  print h1( $entry[1], 
	    "<FONT SIZE=-1>",
	    makeURL($entry[1], "header", undef, "header"),
	    ", ", 
	    makeURL($entry[1], "source", undef, "source"),
	    showedit($file),
	    "</FONT>"), 
        "\n";  

  closeHread();
  
  open (CMD, "cd ".getDocDir()."/".$entry[0]."; cvs log $file |") || warn "can't open pipe: $!\n";
  print "<PRE>";
  while (<CMD>){
    print;
  }
  print "</PRE>";
  close(CMD) || warn "can't close pipe: $!\n";
  
}




###################################################################################
###################################################################################
###################################################################################
sub showSource {

  my ($file, $key, @entry);

  $key = lc(shift(@_));
  $key .= ".pro" unless $key =~ /\.pro$/i;

  openHread();
  @entry = @{$hdata{$key}};
  $file = getDocDir()."/".$entry[0]."/".$key;

  print h1( $entry[1], 
	    "<FONT SIZE=-1>",
	    makeURL($entry[1], "header", undef, "header"),
	    ", ", 
	    makeURL($entry[1], "modifications", undef,"log"),
	    showedit($file),
	    "</FONT>"), 
        "\n";  

  closeHread();

  open(IN, "$file") || die "can't open $file";
  print "<PRE>\n";
  while (<IN>){
    print;
  }
  print "</PRE>\n";
  close(IN) || die "can't close $file";
  
}





###################################################################################
###################################################################################
###################################################################################
sub showHeader {

  my ($file, $key, @entry);

  $key = lc(shift(@_));
  $key .= ".pro" unless $key =~ /\.pro$/i;

  openHread();
  @entry = @{$hdata{$key}};
  $file = getDocDir()."/".$entry[0]."/".$key;

  print h1( $entry[1], 
	    "<FONT SIZE=-1>",
	    makeURL($entry[1], "source", undef,"source"),
	    ", ", 
	    makeURL($entry[1], "modifications", undef,"log"),
	    showedit($file),
	    "</FONT>"), 
            "\n".'<TABLE VALIGN=TOP COLS=2 WIDTH="35%,65%">'."\n";  

  print '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
        "LOCATION:",
        '</TD><TD CLASS="xplcode" VALIGN=TOP>',
        '<A TARGET="_top" HREF="'.getBaseURL()."/".@{$hdata{$key}}[0].'?mode=dir">',
        @{$hdata{$key}}[0],
        "</A></TD></TR>\n";
  
  parseAim(0); # parse the full header
  parseHeader($file);
  closeHread();
  
  print "</TABLE>\n";
}



###################################################################################
###################################################################################
###################################################################################
# initializes & calls the Parser
# @hentry  will be set if parseAIM is true
# parse results go to STDOUT
#
# arg1: file to scan
###################################################################################
sub parseHeader {
  my $file = shift;
  
  open(IDLSOURCE, $file) or die "can't open file $file: $!\n";
  $lexer->from(\*IDLSOURCE);
  $parser->yyparse(\*IDLSOURCE);
  close(IDLSOURCE);
}
  
  
  



# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

NASE::parse - Perl extension for parsing IDL files

=head1 SYNOPSIS

  use NASE::parse;

=head1 DESCRIPTION

Stub documentation for NASE::parse was created by h2xs. 

Blah blah blah.

=head1 AUTHOR

Mirko Saam, Mirko.Saam@physik.uni-marburg.de

=head1 SEE ALSO

NASE::xref, NASE::globals

=cut
