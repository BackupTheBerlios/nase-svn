#
# $Header$
#
package NASE::xref;

use diagnostics;
use strict;
use CGI qw/:standard :html3 :netscape -debug/;
use CGI::Carp;
use File::Basename;
use File::Find;
use NASE::globals::globals;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use locale;

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw( makeURL RoutinesByName RoutinesByCat showedit );

$VERSION = '1.1';


# Preloaded methods go here.


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

  if (exists $pro{$routine}) {
    $dir = $pro{$routine}->{'dir'};
    $rname = $pro{$routine}->{'rname'};
  }
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



####################################################################################
####################################################################################
####################################################################################
# Creates a HTML with ROUTINES sorted by NAME
####################################################################################
####################################################################################
####################################################################################
sub RoutinesByName {
  my ($lastkey, $key);

  print myHeader(), myBody(),
  h1("Routines by Name"),p,
  "<A NAME=top><FONT SIZE=+2>";
  
  foreach ('_','A'..'Z'){
    print "<A HREF=#$_>$_</A> ";
  }
  print "</FONT></A>";

  print '<TABLE><COLGROUP SPAN=2></COLGROUP>'; 

  $lastkey = "1";

  foreach $key (sort keys %pro){ 
    # print the new leading character
    if (uc(substr($key, 0, 1)) ne $lastkey){
      $lastkey = uc(substr($key, 0, 1));  
      print '<TR CLASS="title"><TD CLASS="title" ALIGN="LEFT">',br,a({-name=>"$lastkey"}, $lastkey), "</TD>",
      '<TD CLASS="ltitle" VALIGN="BOTTOM">', a({-href=>"#top"}, "top"), "</TD></TR>\n";
    }
    print  '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
           makeURL($key, undef, "routidx"),
           '</TD><TD CLASS="xplcode" VALIGN=TOP>',
           $pro{$key}->{aim},
           "</TD></TR>\n";
  }; 
  print "</TABLE>", end_html;

}



####################################################################################
####################################################################################
####################################################################################
# Creates a HTML with ROUTINES sorted by CATEGORY
####################################################################################
####################################################################################
####################################################################################
sub RoutinesByCat {
  my ($cat, @cat, $count); 
  my ($sql, @pro, $pro);

  print myHeader(), myBody(),
        h1("Routines by Category"),p,
        "<A NAME=top><FONT SIZE=+2>";

  # create unique list of categories
  $sql = "SELECT DISTINCT cname FROM cat";
  @cat = @{$dbh->selectcol_arrayref($sql)};
  warn "$DBI::errstr\n" if $DBI::err;
  die "create table error: $DBI::errstr\n" if $DBI::err;

  print '<TABLE><TR>'; 
  $count = 0;
  foreach (@cat){    
    print '<TD CLASS="xmpcode" VALIGN=TOP>', "<A HREF=#$_>$_</A>", "</TD>\n";
    if (($count % 5) == 4){ print "</TR><TR>"; }
    $count++;
  }
  print "</TR></TABLE></FONT></A>";


  # now output all cats and routines
  print '<TABLE><COLGROUP SPAN=2></COLGROUP>'; 
  
  foreach $cat (@cat){ 
    # print the new leading category
    print '<TR CLASS="title"><TD CLASS="title" ALIGN="LEFT">',br,a({-name=>"$cat"}, $cat), "</TD>",
          '<TD CLASS="ltitle" VALIGN="BOTTOM">', a({-href=>"#top"}, "top"), "</TD></TR>\n";

    # get routines matching latest category
    $sql = 'SELECT fname FROM cat WHERE cname like "'.$cat.'"';
    @pro = @{$dbh->selectcol_arrayref($sql)};
    warn "$DBI::errstr\n" if $DBI::err;
    die "create table error: $DBI::errstr\n" if $DBI::err;

    foreach $pro (@pro){
      print '<TR><TD CLASS="xmpcode" VALIGN=TOP>',
            makeURL($pro, undef, "routidx"),
            '</TD><TD CLASS="xplcode" VALIGN=TOP>',
            $pro{$pro}->{aim},
            "</TD></TR>\n";
    }
  }
  print "</TABLE>", end_html;
  
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
