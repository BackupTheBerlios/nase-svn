#!/usr/bin/perl -w
#
# $Header$
#


# CGI module
use CGI qw/:standard :html3 :netscape -no_debug/;
use CGI::Carp qw(fatalsToBrowser);
use File::Find;
use File::Basename;

$CGI::POSTMAX         = 1024; # maximal post is 1k
$CGI::DISABLE_UPLOADS =    1; # no uploads
import_names('P');


# NASE/MIND Settings
#$DOCDIR="/vol/neuro/nase";
#$CGIROOT="/vol/neuro/www/cgi-bin-neuro";
$DOCDIR="/mhome/saam/sim";
$CGIROOT="/usr/lib";

$INDEX="/tmp/nase-routineindex";



# global variables
$myurl = $0;
$myurl =~ s/$CGIROOT//;

# the directory we are currently
$sub = path_info();
if ($sub eq '') {$sub = '/'};
$fullurl = $myurl.$sub;



# fix hyperlinks for a list of strings
sub fixhl { 
  @lines = @_;
  @ridx = readRoutineIdx();
  foreach (@lines){
    s/<[^<>]*>//g; # remove HTML stuff
    s/\s+//g;      # remove whitespaces    
    my @url = split(',', $_);
    foreach my $routine (@url){
      @res = grep { /\/$routine\.pro/i  } @ridx; 
      $routine = ($res[0] ? "<A HREF=$myurl/".dirname($res[0])."?file=".lc($routine)."&mode=header>$routine</A>" : $routine);
    }
    push(@fixed, join(', ', @url));
  }
  return @fixed;
}

sub readRoutineIdx {

  createRoutineIdx() unless -r $INDEX;
  open (IDX, "<$INDEX") || die "can't open $INDEX for read: $!\n";
  @ridx = <IDX>; chomp @ridx;
  close (IDX) || die "can't close $INDEX, $!\n";

  return @ridx;
}


sub createRoutineIdx {

  open (IDX, ">$INDEX") || die "can't open $INDEX for write: $!\n";
  find(\&appendFile, $DOCDIR);
  close (IDX) || die "can't close $INDEX: $!\n";
   

  sub appendFile {
    if (-f && /\.pro$/i && ! /(CVS)|(RCS)/){
      my $file = $File::Find::name;
      $file =~ s/$DOCDIR//; 
      $file =~ s/^(\/)+//; 
      print IDX "$file\n";
    }
# to output directories as status 
#    else {
#      -d && ! /(CVS)|(RCS)/ && print $File::Find::name, br;
#    }

  }
}


sub updatedoc {
  print h1("updating documentation...");
  print h2("checking out sources...");
  print h2("generating routine index...");
  createRoutineIdx();
  print h2("updating hyperlinks...");
  print h1("...done <FONT SIZE=-1><A HREF=$myurl>start over</A></FONT>");


}

sub showheader {

  my $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  
  open(IN, "$file") || die "can't open $file";
  print "<PRE>";
  while (<IN>){
    last if (/;+/) 
  }
  while (<IN>){
    last if (/(;-)|(MODIFICATION HISTORY)|^[^;]/i);
    s/^;//;

    {
      /NAME\s*:\s*(\w+)/i && do {if (! $namefound){ print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1)."&mode=source>source</A> <A HREF=huhe2>modifications</A></FONT>"); $namefound=1; } else {print;};  last;};
      /(SEE\s+ALSO\s*:\s+)(.*)/i && do {print $1, fixhl($2); last; };
      print;
    }
  }
  print "</PRE>";
  close(IN) || die "can't close $file";
  
}


sub showsource {

  my $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  
  open(IN, "$file") || die "can't open $file";
  print "<PRE>";
  while ($line = <IN>){
    if ((! $namefound) && ($line =~ /NAME\s*:\s*(\w+)/i)){
      print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1)."&mode=header>header</A> <A HREF=huhe2>modifications</A></FONT>");
      $namefound = 1;
    }
    last if ($line =~ /^[PRO|FUNCTION]/i);
  }
  print $line;
  while (<IN>){print;}
  print "</PRE>";
  close(IN) || die "can't close $file";
  
}


sub ddot {
  my (@dir,$path);
  ($path) = @_;

  @dir = split('/', $path);
  pop @dir;
  return  join('/',@dir);
}

sub showdirs {
  my ($reldir, $fulldir, @ndir);
  ($reldir) = @_;
  $fulldir = "$DOCDIR$reldir";

  # display non-dot dirs 
  opendir(DIR, $fulldir) || print "can't opendir $fulldir: $!\n";
  @ndir = grep { /^[^\.]/ && -d "$fulldir/$_" } readdir(DIR);
  closedir DIR;      

  print h2($reldir);

  if ($reldir ne '/'){ 
    print img({src=>"/icons/back.gif",alt=>"[DIR]"});
    print a({href=>$myurl.ddot($reldir)}, "  parent dir"), br;
  }
  foreach $ndir (sort @ndir) {
    if (($ndir ne "CVS") && ($ndir ne "RCS")){
      print img({src=>"/icons/folder.gif",alt=>"[DIR]"});
      print a({href=>"$fullurl/$ndir"}, "  $ndir"), br;
    }
  }
}


sub showfiles {
  my ($reldir, $fulldir, $fif, @fif, @ndir);
  ($reldir) = @_;
  $fulldir = "$DOCDIR$reldir";

  # scan for pro files
  opendir(DIR, $fulldir) || die "can't opendir $fulldir: $!";
  @file = sort grep { /\.[Pp][Rr][Oo]$/ && -f "$fulldir/$_" } readdir(DIR);
  closedir DIR;  

  foreach $file (sort @file) {
    $file =~ s/\.pro//i;
    ($base) = split(/\./,$file);
    print img({src=>"/icons/text.gif",alt=>"[DIR]"});
    print a({href=>"$fullurl?file=$file&mode=header"}, "  $base"), br;
  }
}



print header;
print start_html('NASE/MIND Documentation System');
print start_body;


if (! -r $INDEX){
  createRoutineIdx();
}
if ($P::mode eq "update"){
  updatedoc();
} else {
  print '<TABLE BORDER=0 WIDTH="100%" HEIGHT="80%">';
  print '<TD ALIGN=LEFT VALIGN=TOP WIDTH="40%">';
  showdirs($sub);
  showfiles($sub);
  print '</TD>';
  print '<TD VALIGN=TOP>';
  if ($P::file){
    if ($P::mode eq "header") { showheader($DOCDIR."/".$sub."/".$P::file); }
    if ($P::mode eq "source") { showsource($DOCDIR."/".$sub."/".$P::file); }
  }
  print '</TD>';
  print '</TABLE>';
  $lastmod = (stat($INDEX))[9] || die "can't stat() $INDEX: $!\n";
  print "<FONT SIZE=-1>last update: ".localtime($lastmod)."</FONT>, <A HREF=$myurl?mode=update>initiate update</A>";
  print hr;
  print "<FONT SIZE=-1>$Id$</FONT>";
}

print end_body;
print end_html;

exit 0;
