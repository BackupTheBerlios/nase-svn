#!/usr/bin/perl -w
#
# $Header$
#


use CGI qw/:standard :html3 :netscape -debug/;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
use NASE::globals;
use NASE::parse;
use NASE::xref;
use strict;

my ($hostname, $CVSROOT, $DOCDIR, $CGIROOT, $IDXDIR, $INDEXURL, $myurl, $fullurl, $sub, $lastmod);

$CGI::POSTMAX         = 1024; # maximal post is 1k
$CGI::DISABLE_UPLOADS =    1; # no uploads
import_names('P');

# NASE/MIND Settings
chop ($hostname = `uname -a`);
{
  $hostname =~ /SMP/i && do {$CVSROOT="/vol/neuro/nase/IDLCVS"; 
			     $DOCDIR="/vol/neuro/nase/nasedocu"; 
			     $CGIROOT="/vol/neuro/www";
			     $IDXDIR="$DOCDIR";
			     last;};
  $DOCDIR="/mhome/saam/sim"; 
  $CGIROOT="/usr/lib"; 
  $IDXDIR="/tmp";
}


$INDEXURL="$DOCDIR/nindex.html";

# global variables
($myurl = $0) =~ s/$CGIROOT//;
setIndexDir($IDXDIR);
setDocDir($DOCDIR);
setBaseURL($myurl);

# the directory we are currently
$sub = path_info();
$fullurl = "$myurl/$sub";





###################################################################################
###################################################################################
###################################################################################
#sub fixhl { 
#  my (@lines, @ridx, @url, $routine, @res, @fixed);
  
#  @lines = @_;
#  @ridx = readRoutineIdx($DIRINDEX);
#  foreach (@lines){
#    s/<[^<>]*>//g; # remove HTML stuff
#    s/\s+//g;      # remove whitespaces    
#    s,\(.*?\),,g;  # remove braces like routine()
#    @url = split(',', $_);
#    foreach $routine (@url){
#      @res = grep { /\/$routine\.pro/i  } @ridx; 
#      $routine = ($res[0] ? "<A HREF=$myurl/".dirname($res[0])."?file=".lc($routine)."&mode=text&show=header>$routine</A>" : $routine);
#    }
#    push(@fixed, join(', ', @url));
#  }
#  return @fixed;
#}





###################################################################################
###################################################################################
###################################################################################
#sub readRoutineIdx{

#  my ($file) = @_;

#  createRoutineIdx() unless -r $DIRINDEX;
#  open (IDX, "<$file") || die "can't open $file for read: $!\n";
#  my @ridx = <IDX>; chomp @ridx;
#  close (IDX) || die "can't close $file, $!\n";
  
#  return @ridx;
#}





####################################################################################
####################################################################################
####################################################################################
#sub createRoutineIdx {

#  my %alpha;
  
#  open (IDX, ">$DIRINDEX") || die "can't open $DIRINDEX for write: $!\n";
#  find(\&appendFile, $DOCDIR);
#  close (IDX) || die "can't close $DIRINDEX: $!\n";
   
#  open (IDX, ">$ALPHINDEX") || die "can't open $ALPHINDEX for write: $!\n";
#  foreach (sort keys %alpha){
#    print IDX "$alpha{$_}\n";
#  }
#  close (IDX) || die "can't close $ALPHINDEX: $!\n";

#  sub appendFile {
#    if (-f && /\.pro$/i && ! /(CVS)|(RCS)/){
#      my $file = $File::Find::name;
#      $file =~ s/$DOCDIR//; 
#      $file =~ s/^(\/)+//; 
#      print IDX "$file\n";
#      $alpha{basename($file)} = $file;
#    }
#  }
#}





###################################################################################
###################################################################################
###################################################################################
sub updatedoc {
  my (@projects,@stat);

  print h1("updating documentation...");
  print "<PRE>\n";
  
  if ($CVSROOT){ 
    print "CVSROOT is set to    ... $CVSROOT\n";

    opendir(DIR, $CVSROOT) || print "can't opendir $CVSROOT: $!\n";
    @projects = grep { /^[^\.]/ && -d "$CVSROOT/$_" && ! /CVS|RCS/i } readdir(DIR);
    closedir DIR;      
    print "looking for projects ... ", join(" ",@projects), "\n";
    print "DOCDIR is set to     ... $DOCDIR\n";
    
    `rm -Rf $DOCDIR/*`;
    foreach (@projects){
      `cd $DOCDIR; /usr/bin/cvs -d $CVSROOT checkout $_`;
      print "checking out $_ ... done\n";
    }
        
  } else {print "CVSROOT: not set   ... ignoring checkout\n"; };


  print "generating routine index...";
  createRoutineIdx();
  print "...done</PRE>";
}





###################################################################################
###################################################################################
###################################################################################
sub showlog {

  my ($file,$name);

  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  $name = basename($file);
  $name =~ s,\.pro$,,;
  
  print h1("$name <FONT SIZE=-1><A HREF=$fullurl?file=".lc($name)."&mode=text&show=header>header</A> <A HREF=$fullurl?file=".lc($name)."&mode=text&show=source>source</A> ".showedit($file)."</FONT>"); 
  
  open (CMD, "cd ".dirname($file)."; cvs log ".basename($file)."|") || warn "can't open pipe: $!\n";
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
sub showheader {

  my ($namefound, $file);

  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  
#  open(IN, "$file") || die "can't open $file";
#  print "<PRE>";
#  while (<IN>){
#    last if (/;+/) 
#  }
#  while (<IN>){
#    last if (/(;-)|(MODIFICATION HISTORY)|^[^;]/i);
#    s/^;//;

#    {
#      /NAME\s*:\s*(\w+)/i && do {if (! $namefound){ print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1)."&mode=text&show=source>source</A> <A HREF=$fullurl?file=".lc($1)."&mode=text&show=log>modifications</A> ".showedit($file)."</FONT>"); $namefound=1; } else {print;};  last;};
#      /(SEE\s+ALSO\s*:\s+)(.*)/i && do {print $1, fixhl($2); last; };
#      print;
#    }
#  }
#  print "</PRE>";
#  close(IN) || die "can't close $file";
  parseHeader($file);
  
}





###################################################################################
###################################################################################
###################################################################################
sub showsource {

  my ($file, $namefound, $line, $keyword);
  my @keywords = qw (AND BEGIN CASE COMMON DO ELSE END ENDCASE ENDELSE ENDFOR
		     ENDIF ENDREP ENDWHILE EQ FOR FUNCTION GE GOTO GT IF INHERITS
		     LE LT MOD NE NOT OF ON_IOERROR OR PRO REPEAT THEN UNTIL WHILE XOR
		     RETURN);




  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  
  open(IN, "$file") || die "can't open $file";
  print "<PRE>";
  while ($line = <IN>){
    if ((! $namefound) && ($line =~ /NAME\s*:\s*(\w+)/i)){
      print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1)."&mode=text&show=header>header</A> <A HREF=$fullurl?file=".lc($1)."&mode=text&show=log>modifications</A> ".showedit($file)."</FONT>");
      $namefound = 1;
    }
    last if ($line =~ /^[PRO|FUNCTION]/i);
  }
  print $line;
  {
    local $/;
    $_ = <IN>;
#    s/\"([^\"]*)\"/\"<FONT COLOR=green>$1<\/FONT>\"/gi;
#    s/\'([^\']*)\'/\'<FONT COLOR=green>$1<\/FONT>\'/gi;
    foreach $keyword (@keywords){
      s/(\s)$keyword(\s)/$1<FONT COLOR="red">$keyword<\/FONT>$2/gi;
    }
#    s/;(.*)\n/<FONT COLOR="blue">;$1<\/FONT>\n/gi;
    print;
  }

    print "</PRE>";
    close(IN) || die "can't close $file";
  
}





###################################################################################
###################################################################################
###################################################################################
sub showdir {
  my ($mydir, $targetdir, $level, $reldir, @sdir, @file, $tmprep);

  ($mydir, $targetdir, $level) = @_;
  $mydir     =~ s,\/$,,g;
  $targetdir =~ s,\/$,,g;
  ($reldir = $mydir) =~ s,.*\/,,;

  # display yourself
  print a({href=>"$myurl/$mydir?mode=list",target=>"list"}, img({src=>"/icons/folder.gif",alt=>"[DIR]",border=>"0"})."$reldir"), br;
  

  # if you are the target path display all, otherwise do nothing
  ($tmprep = $mydir) =~ s,\+,\\\+,;
  if ((!$mydir) || ($targetdir =~ m,$tmprep,)){
    # search for non-dot subdirs and IDL files
    opendir(DIR, "$DOCDIR/$mydir") || print "can't opendir $mydir: $!\n";
    @sdir = grep { /^[^\.]/ && -d "$DOCDIR/$mydir/$_" && ! /(CVS)|(RCS)/ } readdir(DIR);
    rewinddir(DIR);
    @file = sort grep { /\.pro$/i && -f "$DOCDIR/$mydir/$_" } readdir(DIR);
    closedir DIR;      
    
    print "<BLOCKQUOTE>" if $level;

    foreach (@sdir){
      showdir("$mydir/$_", $targetdir, $level+1);
    }
    foreach (sort @file) {
      s/\.pro//i;
      print a({href=>"$myurl/$mydir?file=$_&show=header&mode=text",target=>"text"}, img({src=>"/icons/text.gif",alt=>"[DIR]",border=>"0"})."  $_"), br;
    }

    print "</BLOCKQUOTE>" if $level;
  }
}





###################################################################################
###################################################################################
###################################################################################
print header;
#print start_html('NASE/MIND Documentation System'); # places body before frameset (netscape hates this!)
print "<HTML><HEAD><TITLE>NASE/MIND Documentation System</TITLE></HEAD>";

$lastmod = checkRoutineIdx();
if ($P::mode){
  $_ = $P::mode;
 TRUNK: {
    /update/i && do { updatedoc();
		      last TRUNK;};
    /list/i   && do { print img({src=>"/icons/snase.gif",alt=>"[LOGO]",border=>"0"}),br;
		      showdir("/",$sub, 0);
		      print font({size=>"-2"}, 
				 hr,
				 "last update: $lastmod, ",
				 a({href=>"$myurl?mode=update", target=>"_new"}, "update now")), br,
		      font({size=>"-2"}, 
			   '$Id$ ');
		      last TRUNK;};
    /text/i   && do { if ($P::file){if ($P::show eq "header") { showheader($DOCDIR."/".$sub."/".$P::file); };
				    if ($P::show eq "source") { showsource($DOCDIR."/".$sub."/".$P::file); };
				    if ($P::show eq "log"   ) { showlog($DOCDIR."/".$sub."/".$P::file);    };
				  } else {
				    open(IDX, "<$INDEXURL") || die "can't open $INDEXURL: $!\n";
				    while(<IDX>){print;};
				  };
		      
		      last TRUNK;};
  }
} else {
  print '<frameset cols="180,*">';
  print frame({src=>"$fullurl?mode=list", name=>"list"});
  print frame({src=>"$fullurl?mode=text", name=>"text"});
  print '</frameset>';
  print "<BODY>i cant handle frames!!";
};



print end_html;

exit 0;
