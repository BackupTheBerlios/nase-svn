#!/usr/bin/perl -w
# $Header$


# CGI module
use CGI qw/:standard :html3 :netscape -no_debug/;
use CGI::Carp qw(fatalsToBrowser);
use File::Find;

$CGI::POSTMAX         = 1024; # maximal post is 1k
$CGI::DISABLE_UPLOADS =    1; # no uploads
import_names('P');


# NASE/MIND Settings
#$DOCDIR="/vol/neuro/nase";
#$CGIROOT="/vol/neuro/www/cgi-bin-neuro";
$DOCDIR="/mhome/saam/sim";
$CGIROOT="/usr/lib";

$INDEX="$CGIROOT/naseindex.tmp";



# global variables
$myurl = $0;
$myurl =~ s/$CGIROOT//;

# the directory we are currently
$sub = path_info();
if ($sub eq '') {$sub = '/'};
$fullurl = $myurl.$sub;



sub createRoutineIdx {

  find(\&appendFile, $DOCDIR);

   
  sub appendFile {
    if (-f && /\.pro$/i && ! /(CVS)|(RCS)/){
#      print;
      my $file = $File::Find::name;
      $file =~ s/$DOCDIR//; 
      $file =~ s/^(\/)+//; 
#      print "   ",$file, br;
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
  
  open(IN, "$file") || die "can't open $file";
  print "<PRE>";
  while (<IN>){
    last if (/;+/) 
  }
  while (<IN>){
    last if (/(;-)|(MODIFICATION HISTORY)|^[^;]/i);
    s/^;//;
    if (/NAME\s*:\s*(\w+)/i){
      print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1).".pro&mode=source>source</A> <A HREF=huhe2>modifications</A></FONT>");
    } else {
      print;
    }
  }
  print "</PRE>";
  close(IN) || die "can't close $file";
  
}


sub showsource {

  my $file = shift(@_);
  
  open(IN, "$file") || die "can't open $file";
  print "<PRE>";
  while (<IN>){
    if (/NAME\s*:\s*(\w+)/i){
      print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1).".pro&mode=header>header</A> <A HREF=huhe2>modifications</A></FONT>");
    }
    last if (/^[^;]/i);
  }
  while (<IN>){
    last if (/(PRO)|(FUNCTION)/i);
  }
  print;
  while (<IN>){
    print;
  }
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
    ($base) = split(/\./,$file);
    print img({src=>"/icons/text.gif",alt=>"[DIR]"});
    print a({href=>"$fullurl?file=$file&mode=header"}, "  $base"), br;
  }
}



print header;
print start_html('NASE/MIND Documentation System');
print start_body;


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
  print hr;
  print "<FONT SIZE=-1>last update: </FONT>, <A HREF=$myurl?mode=update>initiate update</A>";
}

print end_body;
print end_html;

exit 0;
