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

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw( makeURL readRoutineIdx createRoutineIdx showedit checkRoutineIdx createAim keylista getKEYA getKEYO getROUTINES);

$VERSION = '1.1';


# Preloaded methods go here.

###################################################################################
###################################################################################
###################################################################################
my($INDEXDIR, $DIRINDEX, $ALPHINDEX, $KEYINDEX, $KEYOCCINDEX, @ridx, %keywords, %routines, $KEYA, $FKEYA,
   $hostname, $HTDOCS, $KEYO, $FKEYO, $RINDEX, $FRINDEX); 

# NASE/MIND Settings
chop ($hostname = `uname -a`);
{
  $hostname =~ /SMP/i && do { $HTDOCS="/vol/neuro/www/htdocs/nase";
			      last;};
  $HTDOCS="/var/www/nase";
}

$INDEXDIR=getIndexDir();
$DIRINDEX="$INDEXDIR/index-by-dir";
$ALPHINDEX="$INDEXDIR/index-by-name";
$KEYINDEX="$INDEXDIR/keywords-by-name";
$KEYA="keywords-by-name.html";
$FKEYA="$HTDOCS/$KEYA";
$KEYO="keywords-by-count.html";
$FKEYO="$HTDOCS/$KEYO";
$KEYOCCINDEX="$INDEXDIR/keywords-by-count";
$RINDEX="routines-by-name.html";
$FRINDEX="$HTDOCS/$RINDEX";
checkRoutineIdx();



###################################################################################
###################################################################################
###################################################################################
sub getKEYA { return $KEYA; }
sub getKEYO { return $KEYO; }
sub getROUTINES { return $RINDEX; }

###################################################################################
###################################################################################
###################################################################################
sub makeURL { 
  my ($routine, $text, @res, $target);
  
  $text = shift(@_);
  ($routine = shift (@_) ) =~ s,\(.*?\),,g;  # remove braces like routine()
  $routine .= ".pro" unless $routine =~ /\.pro$/i;

  $target = shift (@_);

  @res = grep { m,\/$routine,i  } @ridx; 
  $routine =~ s,\.pro$,,i;
  if ($target){
    $routine = ($res[0] ? '<A HREF="'.getBaseURL()."/".dirname($res[0]).'?file='.lc($routine).'&mode=text&show=header" TARGET="'.$target.'">'.$text.'</A>' : $routine);
  } else {
    $routine = ($res[0] ? '<A HREF="'.getBaseURL()."/".dirname($res[0]).'?file='.lc($routine).'&mode=text&show=header">'.$text.'</A>' : $text);
  }
  return $routine;
}


###################################################################################
###################################################################################
###################################################################################
sub checkRoutineIdx {
  my $lastmod; 

  if ((! -r $DIRINDEX)||(! -r $ALPHINDEX)){
    createRoutineIdx();
  }
  if (!@ridx) {readRoutineIdx($DIRINDEX);};
  $lastmod = (stat($DIRINDEX))[9] || die "can't stat() $DIRINDEX: $!\n";
  localtime($lastmod);
}


###################################################################################
###################################################################################
###################################################################################
sub readRoutineIdx{

  my ($file) = @_;

  createRoutineIdx() unless -r $DIRINDEX;
  open (IDX, "<$file") || die "can't open $file for read: $!\n";
  @ridx = <IDX>; chomp @ridx;
  close (IDX) || die "can't close $file, $!\n";
}


###################################################################################
###################################################################################
###################################################################################
sub keylista {
  my (@cols, @index, $lastkey, $file);

  open (IDX, ">$FKEYA") || die "can't open $FKEYA for write: $!\n";

  print IDX "<HTML><HEAD><TITLE>Keywords by name</TITLE></HEAD><BODY>";
  print IDX "<A NAME=top><FONT SIZE=+2>";
  foreach ('A'..'Z','_'){
    print IDX "<A HREF=#$_>$_</A> ";
  }
  print IDX "</FONT></A>";

  print IDX "<TABLE COLS=3>"; 

  $lastkey = "1";
  open(FILE,$KEYINDEX); 
  while (<FILE>){ 
    @cols = split(" ", $_);
    
    if (uc(substr($cols[0], 0, 1)) ne $lastkey){
      $lastkey = uc(substr($cols[0], 0, 1));  
      print IDX "<TR><TD><BR><BR><FONT SIZE=+2><A NAME=$lastkey>$lastkey</A></FONT><FONT SIZE=-1> <A HREF=#top>top</A></FONT></TD></TR>";
    }
    print IDX "<TR><TD>", shift(@cols), "</TD><TD>", shift(@cols), "</TD><TD>";
#    print IDX @cols;
    map {print IDX " ".makeURL($_, $_, "pro")} @cols;
    print IDX "</TD></TR>\n";
  }; 
  close(FILE); 
  print IDX "</TABLE></BODY></HTML>";

  close (IDX) || die "can't close $FKEYA, $!\n";








  open (IDX, ">$FKEYO") || die "can't open $FKEYO for write: $!\n";

  print IDX "<HTML><HEAD><TITLE>Keywords by count</TITLE></HEAD><BODY>";

  print IDX "<TABLE COLS=3>"; 

  open(FILE,$KEYOCCINDEX); 
  while (<FILE>){ 
    @cols = split(" ", $_);
    
    print IDX "<TR><TD>", shift(@cols), "</TD><TD>", shift(@cols), "</TD><TD>";
    #    print IDX @cols;
    map {print IDX " ".makeURL($_, $_, "pro")} @cols;
    print IDX "</TD></TR>\n";
  }; 
  close(FILE); 
  print IDX "</TABLE></BODY></HTML>";

  close (IDX) || die "can't close $FKEYA, $!\n";





  open (IDX, ">$FRINDEX") || die "can't open $FRINDEX for write: $!\n";

  print IDX "<HTML><HEAD><TITLE>Routines by name</TITLE></HEAD><BODY>";
  print IDX "<A NAME=top><FONT SIZE=+2>";
  foreach ('_','A'..'Z'){
    print IDX "<A HREF=#$_>$_</A> ";
  }
  print IDX "</FONT></A>";

  print IDX "<TABLE COLS=2>"; 

  $lastkey = "1";
  open(FILE,$ALPHINDEX); 
  while (<FILE>){ 
    @cols = split(" ", $_);
    $file = basename(shift(@cols));
    $file =~ s/\.pro//i;
    
    if (uc(substr($file, 0, 1)) ne $lastkey){
      $lastkey = uc(substr($file, 0, 1));  
      print IDX "<TR><TD><BR><BR><FONT SIZE=+2><A NAME=$lastkey>$lastkey</A></FONT><FONT SIZE=-1> <A HREF=#top>top</A></FONT></TD></TR>";
    }
    print IDX "<TR><TD>", makeURL($file, $file, "pro"), "</TD><TD>", join(" ",@cols), "</TD></TR>\n";
  }; 
  close(FILE); 
  print IDX "</TABLE></BODY></HTML>";

  close (IDX) || die "can't close $FKEYA, $!\n";






}

###################################################################################
###################################################################################
###################################################################################
sub createAim {
  my ($key, $count, %count);

  (my $mydir) = @_;

  createAimAndKeylist($mydir);
  if ($mydir eq "/"){
    open(FILE, ">$KEYINDEX") || die "can't open $KEYINDEX for read: $!\n";
    foreach $key (sort keys %keywords){
      print FILE "$key $keywords{$key}$routines{$key}\n";
    }
    close(FILE) || die "can't close $KEYINDEX: $!\n";
    open(FILE, ">$KEYOCCINDEX") || die "can't open $KEYOCCINDEX for read: $!\n";

    foreach (values %keywords) {
      $count{$_} = "dummy";
    }
    foreach $key (sort {$b <=> $a} keys %count) {
      foreach (sort grep {$key == $keywords{$_}} keys %keywords){
	print FILE "$_ $key$routines{$_}\n";
      }
    }
    close(FILE) || die "can't close $KEYOCCINDEX: $!\n";
  }

}


sub createAimAndKeylist {
  my ($mydir, $reldir, $DOCDIR, @sdir, @file, $tmprep, $file, $file2, $aim, $found, @args);

  ($mydir) = @_;
  $mydir     =~ s,\/$,,g;
  $mydir     =~ s,^\/,,g;
  ($reldir = $mydir) =~ s,.*\/,,;
  $DOCDIR = getDocDir();

  checkRoutineIdx();
  # search for non-dot subdirs and IDL files
  if (opendir(DIR, "$DOCDIR/$mydir")){
    @sdir = grep { /^[^\.]/ && -d "$DOCDIR/$mydir/$_" && ! /(CVS)|(RCS)/ } readdir(DIR);
    rewinddir(DIR);
    @file = sort grep { /\.pro$/i && -f "$DOCDIR/$mydir/$_" } readdir(DIR);
    closedir DIR;      
    
    foreach (@sdir){
      createAim("$mydir/$_");
    }

    if (open (AIM, ">$DOCDIR/$mydir/index.html")){
      #	  print AIM header;
      print AIM start_html('NASE/MIND Documentation System'); 
      print AIM h1($mydir);
      print AIM "<TABLE COLS=2>";
      foreach $file (sort @file) {
	($file2 = $file) =~ s/\.pro$//i;
	print AIM "<TR><TD>".makeURL($file2,$file2)."</TD><TD>";
	$aim = 0;
	open(FILE, "$DOCDIR/$mydir/$file") || die "can't open $DOCDIR/$mydir/$file for read: $!\n";
	# create aim
	while (<FILE>){	  
	  last if (/(;-)|(MODIFICATION HISTORY)|^[^;]/i);
	  s/^;//;
	  {
	    ($aim && /([a-zA-Z0-9_][^\n]+)/i) && do { print AIM $1; $aim=0; last;};
	    /AIM\s*:\s*\n/i && ($aim = 1); 
	    /AIM\s*:[ \t\n;]*([a-zA-Z0-9_][^\n]+)/i && do {print AIM $1; $aim=0; last;};
	  }
	}
	$found = 0;
	while (<FILE>){	  
	  {
	    if ($found || /^\s*(PRO|FUNCTION)/i){
	      $found = 1;
	      foreach (split(",",$_)) {
		if (m,(\w+)\s*=\s*\w+,){ $keywords{uc($1)}++; $routines{uc($1)} .= " $file"; };
	      }
	      if (! /\$\s*$/i){ $found = 0; }
	    }
	  }
	}
	close(FILE) || die "can't close $DOCDIR/$mydir/$file: $!\n";
	print AIM "</TD></TR>\n";
		
      }
      print AIM "</TABLE>";
      print AIM end_html;
      close (AIM) || warn "can't close $DOCDIR/$mydir/index.html: $!\n";
    } else { print "error processing $DOCDIR/$mydir/index.html: $!\n"; }
  } else { print "error processing $DOCDIR/$mydir: $!\n"; }
}


###################################################################################
###################################################################################
###################################################################################
sub createRoutineIdx {

  my %alpha;
  my %aim;
  
  open (IDX, ">$DIRINDEX") || die "can't open $DIRINDEX for write: $!\n";
  find(\&appendFile, getDocDir());
  close (IDX) || die "can't close $DIRINDEX: $!\n";
   
  open (IDX, ">$ALPHINDEX") || die "can't open $ALPHINDEX for write: $!\n";
  foreach (sort keys %alpha){
    print IDX "$alpha{$_} $aim{$_}\n";
  }
  close (IDX) || die "can't close $ALPHINDEX: $!\n";
  readRoutineIdx($DIRINDEX);

  sub appendFile {
    my $DOCDIR=getDocDir();
    my $aim;

    if (-f && /\.pro$/i && ! /(CVS)|(RCS)/){
      my $file = $File::Find::name;
      $file =~ s/$DOCDIR//; 
      $file =~ s/^(\/)+//; 
      print IDX "$file\n";
      $alpha{basename($file)} = $file;


      open(FILE, "$DOCDIR/$file") || die "can't open $DOCDIR/$file for read: $!\n";
      # create aim
      while (<FILE>){	  
	last if (/(;-)|(MODIFICATION HISTORY)|^[^;]/i);
	s/^;//;
	{
	  ($aim && /([a-zA-Z0-9_][^\n]+)/i) && do { $aim{basename($file)}=$1; $aim=0; last;};
	  /AIM\s*:\s*\n/i && ($aim = 1); 
	  /AIM\s*:[ \t\n;]*([a-zA-Z0-9_][^\n]+)/i && do {$aim{basename($file)}=$1; $aim=0; last;};
	}
      }

    }
  }
}

###################################################################################
###################################################################################
###################################################################################
sub showedit {
  my ($res, $file, $name);

  $file = shift(@_);
  $file .= ".pro" unless $file =~ /\.pro$/i;
  $name = basename($file);
  $name =~ s,\.pro$,,;
  
  
  open (CMD, "cd ".dirname($file)."; cvs editors ".basename($file)."|") || warn "can't open pipe: $!\n";
  $res = '';
  while (<CMD>){
    if (m,^$name.pro\s+(\w+)\s+(.*GMT),){$res = "currently edited by $1 since $2";}

  }
  close(CMD) || warn "can't close pipe: $!\n";
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

Mirko Saam, mirko@physik.uni-marburg.de

=head1 SEE ALSO

perl(1).

=cut
