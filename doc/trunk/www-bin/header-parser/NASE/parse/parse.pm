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
use locale;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw( parseHeader createAim showHeader showSource showLog quickSearch);
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
	    "CSTART"  => '<C>',
	    "CEND"    => '<\/C>',
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
  my ($dir, $key, @data, @subdir, $fh);
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
	push(@data, $key);
      }
    }
    
    if (open (AIM, ">$DOCDIR/$dir/index.html")){
      $fh = select(AIM);
      print 
	start_html('NASE/MIND Documentation System'),
	h1($dir);
      R2HTML(@data);
      select($fh);
      close (AIM);
    } else {
      print STDERR "can't open $DOCDIR/$dir/index.html for write: $!\n";
    }
  }
  closeHread();  
}


###################################################################################
###################################################################################
###################################################################################
# give him a list of routines and he will display it as  NAME:AIM 
#
# assumes that openHread is already called
sub R2HTML {

  print "<TABLE COLS=2>\n";
  foreach (@_){
    print 
      '<TR>',
      '<TD CLASS="xmpcode" VALIGN=TOP>', makeURL($_), '</TD>',
      '<TD CLASS="xplcode" VALIGN=TOP>', @{$hdata{$_}}[2], '</TD>',
      "</TR>\n";
  }
  print "</TABLE>\n", end_html;

}



###################################################################################
###################################################################################
###################################################################################
sub quickSearch {
  # just searches the routine names
  my $sstr = shift;
  my @results = ();
  my $key;

  openHread();
  while (defined ($key = each %hdata)){
    if ((grep (/name/, @_)) && (@{$hdata{$key}}[1] =~ /$sstr/i)){push (@results, $key); next};
    if ((grep (/aim/, @_)) && (@{$hdata{$key}}[2] =~ /$sstr/i)){push (@results, $key); next};
  }
 SWITCH: {
    if ($#results == -1){
      closeHread();
      print h2("Search Results");
      print h4("sorry, nothing found");
      print h4("try to refine your search");      
      last SWITCH;
    }
    if ($#results == 0){
      closeHread();
      showHeader(key=>$results[0]);
      last SWITCH;
    }
    print h2("Search Results");
    R2HTML(sort(@results));
    closeHread();
  }
}








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
      createDirHash("$mydir/$_");
    }

    foreach $file (sort @file) {
      print STDERR "$mydir/$file\n";
      @hentry = ();
      parseHeader("$DOCDIR/$mydir/$file"); # will modify @hentry
      $hentry[0] = $mydir;
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
  my %params = @_;
  my ($file, $key, @entry);

  openHread();

  if (defined $params{"key"}){
    $key = lc($params{"key"});
    $key .= ".pro" unless $key =~ /\.pro$/i;

    @entry = @{$hdata{$key}};
    
    $file = getDocDir()."/".$entry[0]."/".$key;

    print 
      h1( $entry[1], 
	  "<FONT SIZE=-1>",
	  makeURL($entry[1], "source", undef,"source"),
	  ", ", 
	  makeURL($entry[1], "modifications", undef,"log"),
	  showedit($file),
	  "</FONT>"), 
      "\n".'<TABLE VALIGN=TOP COLS=2 WIDTH="35%,65%">'."\n";  
    
    print 
      '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
      "LOCATION:",
      '</TD><TD CLASS="xplcode" VALIGN=TOP>',
      '<A TARGET="_top" HREF="'.getBaseURL()."/".@{$hdata{$key}}[0].'?mode=dir">',
      @{$hdata{$key}}[0],
      "</A></TD></TR>\n";
  } else {    
    $file = $params{"file"};

    print 
      h1("RoutineName (will be resoved later)"), 
      "\n".'<TABLE VALIGN=TOP COLS=2 WIDTH="35%,65%">'."\n";  
  }    


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
