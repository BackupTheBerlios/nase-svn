#!/usr/bin/perl -w
#
# $Header$
#
use strict;

use CGI qw/:standard :html3 -debug/;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;

use NASE::globals;
use NASE::xref;
use NASE::parse;

my ($hostname, $CVSROOT, $DOCDIR, $DOCURL, $myurl, $fullurl, $sub, $lastmod);

$CGI::POSTMAX         = 1024; # maximal post is 1k
$CGI::DISABLE_UPLOADS =    1; # no uploads
import_names('P');


# global variables
($myurl = url(-absolute=>1)) =~ s,\/\.\/,,g;  # without the http://server/ stuff
setBaseURL($myurl);
$DOCURL = getDocURL();
$DOCDIR = getDocDir();


$sub = path_info();          # the directory we are currently to display aims and routines
$sub =~ s,\/\/,\/,gi;        # remove // artifacts 
setSubDir($sub);

$fullurl = "$myurl/$sub";    # still without the server stuff






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
    @projects = grep { /^[^\.]/ && -d "$CVSROOT/$_" && ! /CVS|RCS/i && ! /doc/ } readdir(DIR);
    closedir DIR;      
    
# this is hopefully done by loginfo from cvs directly
#    `rm -Rf $DOCDIR/*`;
#    foreach (@projects){
#      `cd $DOCDIR; /usr/bin/cvs -d $CVSROOT checkout $_; chmod -R g+w $_`;
#      print "checking out $_ ... done\n";
#    }
        
  } else {
    print "CVSROOT: not set   ... ignoring checkout, assuming modules nase and mind\n"; 
    @projects = ("nase", "mind");
  };
  print "DOCDIR is set to ... $DOCDIR\n";
  print "looking for projects ... ", join(" ",@projects), "\n";


  print "generating routine index..."; 
#  createRoutineIdx();
  print "...done\n";
  print "generating directory indices...";
  createAim(@projects)

  print "generating keyword lists...";
  keylista();
  print "...done</PRE>";
  print "create HTML documentation...";
#  `$DOCDIR/doc/www-bin/automakedoc`;
  print "...done</PRE>";
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
  print a({href=>"$myurl/$mydir?mode=dir",target=>"_top"}, img({src=>"/icons/folder.gif",alt=>"[DIR]",border=>"0"})."$reldir"), br;
  

  # if you are the target path display all, otherwise do nothing
  ($tmprep = $mydir) =~ s,\+,\\\+,;
  if ((!$mydir) || ($targetdir =~ m,$tmprep,)){
    # search for non-dot subdirs and IDL files
    opendir(DIR, "$DOCDIR/$mydir") || print "can't opendir $mydir: $!\n";
    @sdir = grep { /^[^\.]/ && -d "$DOCDIR/$mydir/$_" && ! /(CVS)|(RCS)/ && ! /doc/ } readdir(DIR);
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
print "Content-Type: text/html\n\n", myHeader();
$lastmod = checkRoutineIdx();
if ($P::mode){
  $_ = $P::mode;
 TRUNK: {
    /update/i && do { updatedoc();
		      last TRUNK;};
    /list/i   && do { print myBody();
		      print img({src=>"$DOCURL/doc/www-doc/snasedoc.gif",alt=>"[LOGO]",border=>"0"}),br;
		      showdir("/",$sub, 0);
		      print hr,
		      a({href=>"/nase.list/", target=>"text"}, "mailing list"), ", ",
		      a({href=>$DOCURL.RoutinesHTML(), target=>"text"}, "routine index"), ", ",
		      "keyword index (",a({href=>$DOCURL.KeyByNameHTML(), target=>"text"}, "name"), ", ",
		      a({href=>$DOCURL.KeyByCountHTML(), target=>"text"}, "count"), ")",
		      font({size=>"-2"}, 
			   hr,
			   "last update: $lastmod, ",
			   a({href=>"$myurl?mode=update", target=>"_new"}, "update now")), br,
		      font({size=>"-2"}, 
			   '$Id$ ');
		      last TRUNK;};
    /text/i   && do { print myBody();
		      if ($P::file){if ($P::show eq "header") { showHeader($P::file); };
				    if ($P::show eq "source") { showSource($P::file); };
				    if ($P::show eq "log"   ) { showLog($P::file);    };
				  } else {
#				    `cd $DOCDIR; /usr/bin/cvs -d $CVSROOT checkout doc/www-doc`;
				    if (($sub eq '/')||($sub eq '/nase')||($sub eq '/mind')){
				      open(IDX, "<".$DOCDIR."/doc/www-doc/mainpage.html");
				    } else {
				      open(IDX, "<".$DOCDIR."/".$sub."/"."index.html");
				    }
				    while(<IDX>){print;};
				    close(IDX) || die "can't close index: $!\n";
				    last TRUNK;};
				  };
    /dir/i   && do { print '<frameset cols="180,*">';
		     print frame({src=>"$fullurl?mode=list", name=>"list"});
		     print frame({src=>"$fullurl?mode=text&show=aim", name=>"text"});
		     print '</frameset>';
		     print myBody(), "i cant handle frames!!";
		     last TRUNK;
		   }
  }
} else {
  print '<frameset cols="250,*">';
  print frame({src=>"$fullurl?mode=list", name=>"list"});
  print frame({src=>"$fullurl?mode=text", name=>"text"});
  print '</frameset>';
  print myBody(), "i cant handle frames!!";
};



print end_html;

exit 0;
