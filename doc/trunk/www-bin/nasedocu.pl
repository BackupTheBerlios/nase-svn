#!/usr/bin/perl -w
#
# $Header$
#


# CGI module
use CGI qw/:standard :html3 :netscape -debug/;
use CGI::Carp qw(fatalsToBrowser);
use File::Find;
use File::Basename;
#use strict;

$CGI::POSTMAX         = 1024; # maximal post is 1k
$CGI::DISABLE_UPLOADS =    1; # no uploads
import_names('P');

# NASE/MIND Settings
chop ($hostname = `uname -a`);
{
  $hostname =~ /SMP/i && do {$CVSROOT="/vol/neuro/nase/IDLCVS"; 
			     $DOCDIR="/vol/neuro/nase/nasedocu"; 
			     $CGIROOT="/vol/neuro/www";
			     last;};
  $DOCDIR="/mhome/saam/sim"; 
  $CGIROOT="/usr/lib"; 
}

$INDEX="$DOCDIR/index.routines";



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
    s,\(.*?\),,g;  # remove braces like routine()
    my @url = split(',', $_);
    foreach my $routine (@url){
      @res = grep { /\/$routine\.pro/i  } @ridx; 
      $routine = ($res[0] ? "<A HREF=$myurl/".dirname($res[0])."?file=".lc($routine)."&mode=text&show=header>$routine</A>" : $routine);
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


sub showedit {
  my ($res);

  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  $name = basename($file);
  $name =~ s,\.pro$,,;
  
  
  open (CMD, "cd ".dirname($file)."; cvs editors ".basename($file)."|") || die "can't open pipe: $!\n";
  $res = '';
  while (<CMD>){
    if (m,^$name.pro\s+(\w+)\s+(.*GMT),){$res = "currently edited by $1 since $2";}

  }
  close(CMD) || die "can't close pipe: $!\n";
  return $res;
}


sub showlog {

  my ($file,$name);

  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  $name = basename($file);
  $name =~ s,\.pro$,,;
  
  print h1("$name <FONT SIZE=-1><A HREF=$fullurl?file=".lc($name)."&mode=text&show=header>header</A> <A HREF=$fullurl?file=".lc($name)."&mode=text&show=source>source</A> ".showedit($file)."</FONT>"); 
  
  open (CMD, "cd ".dirname($file)."; cvs log ".basename($file)."|") || die "can't open pipe: $!\n";
  print "<PRE>";
  while (<CMD>){
    print;
  }
  print "</PRE>";
  close(CMD) || die "can't close pipe: $!\n";
  
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
      /NAME\s*:\s*(\w+)/i && do {if (! $namefound){ print h1("$1 <FONT SIZE=-1><A HREF=$fullurl?file=".lc($1)."&mode=text&show=source>source</A> <A HREF=$fullurl?file=".lc($1)."&mode=text&show=log>modifications</A> ".showedit($file)."</FONT>"); $namefound=1; } else {print;};  last;};
      /(SEE\s+ALSO\s*:\s+)(.*)/i && do {print $1, fixhl($2); last; };
      print;
    }
  }
  print "</PRE>";
  close(IN) || die "can't close $file";
  
}


sub showsource {

my @keywords = qw (AND BEGIN CASE COMMON DO ELSE END ENDCASE ENDELSE ENDFOR
		   ENDIF ENDREP ENDWHILE EQ FOR FUNCTION GE GOTO GT IF INHERITS
		   LE LT MOD NE NOT OF ON_IOERROR OR PRO REPEAT THEN UNTIL WHILE XOR
		   RETURN);


  my $file = shift(@_);
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
    foreach my $keyword (@keywords){
      s/(\s)$keyword(\s)/$1<FONT COLOR="red">$keyword<\/FONT>$2/gi;
    }
#    s/;(.*)\n/<FONT COLOR="blue">;$1<\/FONT>\n/gi;
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
  $fulldir = "$DOCDIR/$reldir";

  # display non-dot dirs 
  opendir(DIR, $fulldir) || print "can't opendir $fulldir: $!\n";
  @ndir = grep { /^[^\.]/ && -d "$fulldir/$_" } readdir(DIR);
  closedir DIR;      


  
  if ($reldir ne '/'){ 
    $reldir =~ s/^\/+//g;
    print font({size=>"+1"},$reldir),br;
    print a({href=>$myurl."/".ddot($reldir)."?mode=list"}, img({src=>"/icons/back.gif",alt=>"[DIR]",border=>"0"})."  parent dir"), br;
  }
  foreach $ndir (sort @ndir) {
    if (($ndir ne "CVS") && ($ndir ne "RCS")){
      print a({href=>"$fullurl/$ndir?mode=list",target=>"list"}, img({src=>"/icons/folder.gif",alt=>"[DIR]",border=>"0"})."  $ndir"), br;
    }
  }
}


sub showfiles {
  my ($reldir, $fulldir, $fif, @fif, @ndir);
  ($reldir) = @_;
  $fulldir = "$DOCDIR/$reldir";

  # scan for pro files
  opendir(DIR, $fulldir) || die "can't opendir $fulldir: $!";
  @file = sort grep { /\.[Pp][Rr][Oo]$/ && -f "$fulldir/$_" } readdir(DIR);
  closedir DIR;  

  foreach $file (sort @file) {
    $file =~ s/\.pro//i;
    ($base) = split(/\./,$file);
    print a({href=>"$fullurl?file=$file&show=header&mode=text",target=>"text"}, img({src=>"/icons/text.gif",alt=>"[DIR]",border=>"0"})."  $base"), br;
  }
}



print header;
#print start_html('NASE/MIND Documentation System'); # places body before frameset (netscape hates this!)
print "<HTML><HEAD><TITLE>NASE/MIND Documentation System</TITLE></HEAD>";

if (! -r $INDEX){
  createRoutineIdx();
}


if ($P::mode){
  $_ = $P::mode;
 TRUNK: {
    /update/i && do { updatedoc();
		      last TRUNK;};
    /list/i   && do { print img({src=>"/icons/snase.gif",alt=>"[LOGO]",border=>"0"}),br;
                      showdirs($sub);
		      showfiles($sub);
		      $lastmod = (stat($INDEX))[9] || die "can't stat() $INDEX: $!\n";
		      print font({size=>"-2"}, 
				 hr,
				 "last update: ".localtime($lastmod).", ",
				 a({href=>"$myurl?mode=update", target=>"_new"}, "update now")), br,
		      font({size=>"-2"}, 
			   '$Id$ ');
		      last TRUNK;};
    /text/i   && do { if ($P::file){if ($P::show eq "header") { showheader($DOCDIR."/".$sub."/".$P::file); };
				    if ($P::show eq "source") { showsource($DOCDIR."/".$sub."/".$P::file); };
				    if ($P::show eq "log"   ) { showlog($DOCDIR."/".$sub."/".$P::file);    };};
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
