package NASE::parse;

use diagnostics;
use strict;
use CGI qw/:standard :html3 :netscape -debug/;
use CGI::Carp;
use File::Basename;

# just for debug
#use Data::Dumper;

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
@EXPORT = qw( updateDB deleteDB showHeader showSource showLog quickSearch DirAim scanFile deleteFile );
$VERSION = '1.2';



my (@token, $lexer, $parser);



###################################################################################
###################################################################################
###################################################################################
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
	    "ALBRACE"  => '\[',
	    "ARBRACE"  => '\]',
	    "EOL"      => '\n',
	    "DCOLON"   => "::",
	    "COLON"    =>  ":",
	    "TEXT"     => '[^ :\n\t<>\(\)]+(\s*\(\s*\))?'
	   );
  Parse::YYLex->ytab("IDLparser.ph");
  $lexer = Parse::YYLex->new(@token);
  $lexer->skip('');
  $parser = IDLparser->new($lexer->getyylex, &_yyerror);

}


# Preloaded methods go here.
###################################################################################
###################################################################################
###################################################################################




sub updateDB {
  (my $mydir) = @_;

  createDirHash($mydir);
  createDirHash($mydir); # run twice to get MakeURL in AIM working
}


sub deleteDB {
  my $sql;

  $sql = "DROP TABLE catl\n";
  $dbh->do($sql);
  warn "$DBI::errstr\n" if $DBI::err;

  $sql = "DROP TABLE cat\n";
  $dbh->do($sql);
  warn "$DBI::errstr\n" if $DBI::err;

  $sql = "DROP TABLE pro\n";
  $dbh->do($sql);
  warn "$DBI::errstr\n" if $DBI::err;

  createTablesIfNotExist();
}



sub DirAim {
  my ($dir) = @_;
  $dir =~ s,^/,,g;
  $dir =~ s,/$,,g;

  my @data = tied(%pro)->select_where('dir like "'.$dir.'"');
  print 
    start_html('NASE/MIND Documentation System');
  R2HTML($dir, @data);
}


###################################################################################
###################################################################################
###################################################################################
# give him a list of routines and he will display it as  NAME:AIM 
###################################################################################
sub R2HTML {
  my $title = shift;

  print "<TABLE>\n<COLGROUP SPAN=2></COLGROUP>\n";
  print '<TR CLASS="title"><TH CLASS="title" COLSPAN=2 ALIGN="LEFT">',$title, "</TH></TR>\n";
  foreach (@_){
    print 
      '<TR>',
      '<TD CLASS="xmpcode" VALIGN=TOP>', makeURL($pro{$_}->{'fname'}), '</TD>',
      '<TD CLASS="xplcode" VALIGN=TOP>', $pro{$_}->{'aim'}, '</TD>',
      "</TR>\n";
  }
  print "</TABLE>\n", end_html;

}



###################################################################################
###################################################################################
###################################################################################
sub quickSearch {
  my $sstr = shift;
  my @results = ();
  my @tmpsearch = ();
  my $key;

  if (grep (/name/, @_)){ 
    @tmpsearch = tied(%pro)->select_where('rname like "%'.$sstr.'%"');
    if (@tmpsearch){ push(@results, @tmpsearch) };
  }
  if (grep ( /aim/, @_)){ 
    @tmpsearch = tied(%pro)->select_where('aim rlike "%'.$sstr.'%"');
    if (@tmpsearch){ push(@results, @tmpsearch) };
  }

 SWITCH: {
    if ($#results == -1){
      print h2("Search Results");
      print h4("sorry, nothing found");
      print h4("try to refine your search");      
      last SWITCH;
    }
    if ($#results == 0){
      showHeader(key=>$results[0]);
      last SWITCH;
    }
    R2HTML("Search Results", sort(@results));
  }
}





###################################################################################
###################################################################################
###################################################################################
# arg1: directory to scan recursively
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
#      print STDERR "processing $file\n";
      scanFile(file=>$file, path=>$mydir);
    }
  } #else { print STDERR "error processing $DOCDIR/$mydir: $!\n"; }
}



###################################################################################
###################################################################################
###################################################################################
sub showLog {

  my ($file, $key, %entry);
  
  $key = lc(shift(@_));
  $key .= ".pro" unless $key =~ /\.pro$/i;

  %entry = %{$pro{$key}};
  $file = getDocDir()."/".$entry{dir}."/".$key;

  print h1( $entry{rname}, 
	    "<FONT SIZE=-1>",
	    makeURL($entry{rname}, "header", undef, "header"),
	    ", ", 
	    makeURL($entry{rname}, "source", undef, "source"),
	    showedit($file),
	    "</FONT>"), 
        "\n";  

  
  open (CMD, "cd ".getDocDir()."/".$entry{dir}."; cvs log $file |") || warn "can't open pipe: $!\n";
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

  my ($file, $key, %entry);

  $key = lc(shift(@_));
  $key .= ".pro" unless $key =~ /\.pro$/i;

  %entry = %{$pro{$key}};
  $file = getDocDir()."/".$entry{dir}."/".$key;

  print h1( $entry{rname}, 
	    "<FONT SIZE=-1>",
	    makeURL($entry{rname}, "header", undef, "header"),
	    ", ", 
	    makeURL($entry{rname}, "modifications", undef,"log"),
	    showedit($file),
	    "</FONT>"), 
        "\n";  


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
  my ($file, $key, %entry);


  if (defined $params{"key"}){
    $key = lc($params{"key"});
    $key .= ".pro" unless $key =~ /\.pro$/i;

    %entry = %{$pro{$key}};

    $file = getDocDir()."/".$entry{dir}."/".$key;

    print 
      '<TABLE VALIGN=TOP>'."\n",
      '<TR CLASS="title"><TD CLASS="title">',$entry{rname},
      '</TD><TD VALIGN="BOTTOM" CLASS="ltitle">', 
      makeURL($entry{rname}, "source", undef,"source"), " ",
      makeURL($entry{rname}, "modifications", undef,"log"), " ",
      showedit($file),
      '</TD></TD>';
      

    
    print 
      '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
      "LOCATION:",
      '</TD><TD CLASS="xplcode" VALIGN=TOP>',
      '<A TARGET="_top" HREF="'.getBaseURL()."/".$entry{dir}.'?mode=dir">',
      $entry{dir},
      "</A></TD></TR>\n";
    print $entry{header};
  } else {    
    $file = $params{"file"};
    %entry = scanFile(path=>dirname($file), file=>basename($file,""), test=>1);

    print 
      h1($entry{rname}." (Check)"), 
      "\n".'<TABLE VALIGN=TOP><COLGROUP SPAN=2></COLGROUP>'."\n",
      $entry{header};
  }    

  print "</TABLE>\n";
}





###################################################################################
###################################################################################
###################################################################################
# updates database by one file or just checks syntax
###################################################################################
sub scanFile {
  
  my %p= (
	  skel => getDocDir(),
	  path => '',
	  file => 'header.pro',
	  test => 0,
	  @_
	 );
  
  my $filepath = $p{'path'}."/".$p{'file'};
  if (! $p{test}){ $filepath = $p{skel}."/".$filepath; };

  my $cat;
  my $ix = 0;
  my %FN = map { $ix++ => $_ } qw (dir rname aim catlist header);
  my $sql;
  

  # scan file with parser
  open(IDLSOURCE, $filepath) or die "can't open file $filepath: $!\n";
  $lexer->from(\*IDLSOURCE);
  eval {
    $parser->yyparse(\*IDLSOURCE);
  };
  # returns a defined hentry [,rname,aim,cat,header]
  if ($@) {
    @hentry = (undef, $p{'file'}, "_error", "_Error", "An error has occurred while parsing the doc header. Please check for correct syntax!");
  }

  close(IDLSOURCE);

  $hentry[0] = $p{'path'};


  if ($p{test}){
    foreach $cat (split (",",$hentry[3])) {
      if (! defined $catl{$cat}) {
	print STDERR "error: unknown category '$cat'\n";
	$hentry[2]="_error";
      } 
    }
    return ("dir"=>$hentry[0], "fname"=>$p{file}, "rname"=>$hentry[1], "aim"=>$hentry[2], "cats"=>$hentry[3], "header"=>$hentry[4]);
  } else {
    # insert routine into pro
    delete $pro{$p{'file'}} if exists $pro{$p{'file'}}; # next command is not atomar
    $pro{$p{'file'}} = { map { $FN{$_} => $hentry[$_] } (0,1,2,4) }  ;
    
    # delete old cats for routine
    $sql = 'DELETE FROM cat WHERE fname LIKE "'.$p{'file'}.'"'."\n";
    $dbh->do($sql);
    warn "$DBI::errstr\n" if $DBI::err;
    
    # insert new cats for routine
    foreach $cat (split (",",$hentry[3])) {
      if (defined $catl{$cat}) {
	$sql = 'INSERT INTO cat VALUES ("'.$p{'file'}.'", "'.($catl{$cat})->{'cname'}.'")'."\n";
	$dbh->do($sql);
	warn "$DBI::errstr\n" if $DBI::err;
      } else {print STDERR "unknown category: $cat\n";}
    }
  }
}





###################################################################################
###################################################################################
###################################################################################
# updates database by deleting one file
###################################################################################
sub deleteFile {
  
  my %p= (
	  file => 'header.pro',
	  @_
	 );
  
  
  # delete cats for routine
  my $sql = 'DELETE FROM cat WHERE fname LIKE "'.$p{'file'}.'"'."\n";
  $dbh->do($sql);
  warn "$DBI::errstr\n" if $DBI::err;
  
  # delete routine itself
  delete $pro{$p{'file'}} if exists $pro{$p{'file'}}; 
    
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
