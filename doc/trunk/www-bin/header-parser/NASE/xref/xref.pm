#
# $Header$
#
package NASE::xref;

use strict;
use CGI qw/:standard :html3 :netscape -debug/;
use File::Basename;
use File::Find;
use NASE::globals;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use locale;

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw( makeURL readRoutineIdx createRoutineIdx checkRoutineIdx RoutinesByName RoutinesByCat showedit );

$VERSION = '1.1';


# Preloaded methods go here.

###################################################################################
###################################################################################
###################################################################################
my($INDEXDIR, $DIRINDEX, $ALPHINDEX, @ridx, %aim, %alpha); 


$INDEXDIR=getIndexDir();
$DIRINDEX="$INDEXDIR/index-by-dir";
$ALPHINDEX="$INDEXDIR/index-by-name";




###################################################################################
###################################################################################
###################################################################################
# returns a <A HREF=arg2>arg1</A> 
# arg1: routine name for link
# arg2: optional text to display
#
# relies on %hdata
###################################################################################
sub makeURL { 
  my ($routine, $text, $target, $show) = @_;
  my ($dir, $rname, $link);  

  ($routine = lc($routine) ) =~ s,\(.*?\),,g;  # remove braces like routine() and lc
  $routine =~ s,[\"\'],,g;

  $routine .= ".pro" unless $routine =~ /\.pro$/i;
  ($dir,$rname) = @{$hdata{$routine}} if exists $hdata{$routine} ;
  $routine =~ s,\.pro$,,i;

  $link = $routine;
  if ($rname){
    $link  = '<A HREF="'.getBaseURL()."/$dir?file=".lc($routine).'&mode=text&show=';
    $link .= ($show ? $show : "header");
    $link .= '"';
    $link .= ' TARGET="'.$target.'"' if $target;
    $link .= ">";
    $link .= ($text ? $text : $rname).'</A>'
  } 
  return $link;
}


###################################################################################
###################################################################################
###################################################################################
# create file index on disk
###################################################################################
#sub createRoutineIdx {
#  undef %alpha;
#  undef %aim;
  
#  open (IDX, ">$DIRINDEX") || die "can't open $DIRINDEX for write: $!\n";
#  find(\&appendFile, getDocDir());
#  close (IDX) || die "can't close $DIRINDEX: $!\n";
   
#  open (IDX, ">$ALPHINDEX") || die "can't open $ALPHINDEX for write: $!\n";
#  foreach (sort keys %alpha){
#    print IDX "$alpha{$_} $aim{$_}\n";
#  }
#  close (IDX) || die "can't close $ALPHINDEX: $!\n";
#  readRoutineIdx($DIRINDEX);

#}

#sub appendFile {
#  my $DOCDIR=getDocDir();
#  my $aim;
  
#  if (-f && /\.pro$/i && ! /(CVS)|(RCS)/){
#    my $file = $File::Find::name;
#    $file =~ s/$DOCDIR//; 
#    $file =~ s/^(\/)+//; 
#    print IDX "$file\n";
#    $alpha{basename($file)} = $file;
    
    
#    open(FILE, "$DOCDIR/$file") || die "can't open $DOCDIR/$file for read: $!\n";
#    # create aim
#    while (<FILE>){	  
#      last if (/(;-)|(MODIFICATION HISTORY)|^[^;]/i);
#      s/^;//;
#      {
#	($aim && /([a-zA-Z0-9_][^\n]+)/i) && do { $aim{basename($file)}=$1; $aim=0; last;};
#	/AIM\s*:\s*\n/i && ($aim = 1); 
#	/AIM\s*:[ \t\n;]*([a-zA-Z0-9_][^\n]+)/i && do {$aim{basename($file)}=$1; $aim=0; last;};
#      }
#    }
    
#  }
#}
####################################################################################
####################################################################################
####################################################################################
## read file-index from disk into memory
##   _calls index creation routine if not on disk
####################################################################################
#sub readRoutineIdx{
#  my ($file) = @_;

#  createRoutineIdx() unless -r $DIRINDEX;
#  open (IDX, "<$file") || die "can't open $file for read: $!\n";
#  @ridx = <IDX>; chomp @ridx;
#  close (IDX) || die "can't close $file, $!\n";
#}


###################################################################################
###################################################################################
###################################################################################
# check if file-index is in memory
#   _calls read routine if not
#
# returns string of last update
###################################################################################
sub checkRoutineIdx {
  my $lastmod; 

#  if ((! -r $DIRINDEX)||(! -r $ALPHINDEX)){
#    createRoutineIdx();
#  }
#  if (!@ridx) {readRoutineIdx($DIRINDEX);};
#  $lastmod = (stat($DIRINDEX))[9] || die "can't stat() $DIRINDEX: $!\n";
#  localtime($lastmod);
  return checkH();
}


###################################################################################
###################################################################################
###################################################################################
# creates HTML files with routines by-name, keywords by-name and by-count
###################################################################################
#  open (IDX, ">".getDocDir()."/".KeyByNameHTML()) || die "can't open ".getDocDir()."/".KeyByNameHTML()." for write: $!\n";

#  print IDX "<HTML><HEAD><TITLE>Keywords by name</TITLE></HEAD><BODY>";
#  print IDX "<A NAME=top><FONT SIZE=+2>";
#  foreach ('A'..'Z','_'){
#    print IDX "<A HREF=#$_>$_</A> ";
#  }
#  print IDX "</FONT></A>";

#  print IDX "<TABLE COLS=3>"; 

#  $lastkey = "1";
#  open(FILE, KeyByName()); 
#  while (<FILE>){ 
#    @cols = split(" ", $_);
    
#    if (uc(substr($cols[0], 0, 1)) ne $lastkey){
#      $lastkey = uc(substr($cols[0], 0, 1));  
#      print IDX "<TR><TD><BR><BR><FONT SIZE=+2><A NAME=$lastkey>$lastkey</A></FONT><FONT SIZE=-1> <A HREF=#top>top</A></FONT></TD></TR>";
#    }
#    print IDX "<TR><TD>", shift(@cols), "</TD><TD>", shift(@cols), "</TD><TD>";
##    print IDX @cols;
#    map {print IDX " ".makeURL($_, $_, "pro")} @cols;
#    print IDX "</TD></TR>\n";
#  }; 
#  close(FILE); 
#  print IDX "</TABLE></BODY></HTML>";

#  close (IDX);








#  open (IDX, ">".getDocDir()."/".KeyByCountHTML()) || die "can't open ".getDocDir()."/".KeyByCountHTML()." for write: $!\n";

#  print IDX "<HTML><HEAD><TITLE>Keywords by count</TITLE></HEAD><BODY>";

#  print IDX "<TABLE COLS=3>"; 

#  open(FILE,KeyByCount()); 
#  while (<FILE>){ 
#    @cols = split(" ", $_);
    
#    print IDX "<TR><TD>", shift(@cols), "</TD><TD>", shift(@cols), "</TD><TD>";
#    #    print IDX @cols;
#    map {print IDX " ".makeURL($_, $_, "pro")} @cols;
#    print IDX "</TD></TR>\n";
#  }; 
#  close(FILE); 
#  print IDX "</TABLE></BODY></HTML>";

#  close (IDX);



####################################################################################
####################################################################################
####################################################################################
# Creates a HTML with ROUTINES sorted by NAME
####################################################################################
####################################################################################
####################################################################################
sub RoutinesByName {
  my ($lastkey, $key);

  open (IDX, ">".getDocDir()."/".RoutinesHTML()) || die "can't open ".getDocDir()."/".RoutinesHTML()." for write: $!\n";

  print IDX myHeader(), myBody(),
            h1("Routines by Name"),p,
            "<A NAME=top><FONT SIZE=+2>";

  foreach ('_','A'..'Z'){
    print IDX "<A HREF=#$_>$_</A> ";
  }
  print IDX "</FONT></A>";

  print IDX '<TABLE COLS=2>'; 

  $lastkey = "1";
  openHread(); 
  foreach $key (sort keys %hdata){ 
    # print the new leading character
    if (uc(substr($key, 0, 1)) ne $lastkey){
      $lastkey = uc(substr($key, 0, 1));  
      print IDX "<TR><TD><BR><BR><FONT SIZE=+2><A NAME=$lastkey>$lastkey</A></FONT><FONT SIZE=-1> <A HREF=#top>top</A></FONT></TD></TR>";
    }
    print IDX '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
              makeURL($key, undef, "routidx"),
              '</TD><TD CLASS="xplcode" VALIGN=TOP>',
              @{$hdata{$key}}[2],
              "</TD></TR>\n";
  }; 
  closeHread(); 
  print IDX "</TABLE>", end_html;

  close (IDX);
}



####################################################################################
####################################################################################
####################################################################################
# Creates a HTML with ROUTINES sorted by CATEGORY
####################################################################################
####################################################################################
####################################################################################
sub RoutinesByCat {
  my ($key, $cat, $data, %cat, $count);

  open (IDX, ">".getDocDir()."/".RoutinesCatHTML()) || die "can't open ".getDocDir()."/".RoutinesCatHTML()." for write: $!\n";

  print IDX myHeader(), myBody(),
            h1("Routines by Category"),p,
            "<A NAME=top><FONT SIZE=+2>";

  # create unique list of categories
  openHread(); 
  while ((undef, $data) = each %hdata){
    foreach (split(",",@{$data}[3])){
      $cat{$_}++;
    }
  }
  

  print IDX '<TABLE COLS=5><TR>'; 
  $count = 0;
  foreach (sort keys %cat){    
    print IDX '<TD CLASS="xmpcode" VALIGN=TOP>', "<A HREF=#$_>$_</A>", "</TD>\n";
    if (($count % 5) == 4){ print IDX "</TR><TR>"; }
    $count++;
  }
  print IDX "</TR></TABLE></FONT></A>";


  # now output all cats and routines
  print IDX '<TABLE COLS=2>'; 
  
  foreach $cat (sort keys %cat){ 
    # print the new leading category
    print IDX "<TR><TD><BR><BR><H2><A NAME=$cat>$cat</A><FONT SIZE=-2><A HREF=#top>top</A></FONT></H2></TD></TR>";
    
    while (($key, $data) = each %hdata){
      if (@{$data}[3] =~ /$cat/){
	print IDX '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
                  makeURL($key, undef, "routidx"),
                  '</TD><TD CLASS="xplcode" VALIGN=TOP>',
                  @{$data}[2],
                  "</TD></TR>\n";
      }
    }
  }
  closeHread(); 
  print IDX "</TABLE>", end_html;
  
  close (IDX);
}




###################################################################################
###################################################################################
###################################################################################
# calls cvs and look if a file is currently edited
#
# arg1: filepath for .pro file 
# ret : string containing who edits since when or '' if none
###################################################################################
sub showedit {
  my ($res, $file, $name);

  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  $name = basename($file);
  $name =~ s,\.pro$,,;
  
  
  open (CMD, "cd ".dirname($file)."; cvs editors ".basename($file)."|") || warn "xref/showedit: cvs editors failed: $!\n";
  $res = '';
  while (<CMD>){
    if (m,^$name.pro\s+(\w+)\s+(.*GMT),){$res = "currently edited by $1 since $2";}

  }
  close(CMD) || warn "xref/showedit: can't close pipe: $!\n";
  return $res;
}







# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

NASE::xref - Perl extension for blah blah blah

=head1 SYNOPSIS

  use NASE::xref;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for NASE::xref was created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head1 AUTHOR

Mirko Saam, Mirko.Saam@physik.uni-marburg.de

=head1 SEE ALSO

perl(1).

=cut
