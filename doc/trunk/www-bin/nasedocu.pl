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

$CGI::POSTMAX         = 1024*100; # maximal post is 100k
#$CGI::DISABLE_UPLOADS =    1; # no uploads
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
#      `cd $DOCDIR; /usr/bin/cvs -d $CVSROOT checkout $_`;
#      print "checking out $_ ... done\n";
#    }
        
  } else {
    print "CVSROOT: not set   ... ignoring checkout, assuming modules nase and mind\n"; 
    @projects = ("nase", "mind");
  };
  print "DOCDIR is set to ... $DOCDIR\n";
  print "looking for projects ... ", join(" ",@projects), "\n";


#  print "generating routine index..."; 
#  createRoutineIdx();
#  print "...done\n";


  createAim(@projects);

  print "generating routines by name...";
  RoutinesByName();
  print "...done</PRE>";

  print "generating routine by category...";
  RoutinesByCat();
  print "...done</PRE>";

#  print "generating keyword lists...";
#  keylista();
#  print "...done</PRE>";

  print "create HTML documentation...";
  `$DOCDIR/doc/www-bin/automakedoc`;
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
    
    print '<BLOCKQUOTE>' if $level;

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
		      print 
			'<TABLE cellspacing=5 border=0><TR><TD>',
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=center><TR><TD>',
			     img({src=>"$DOCURL/doc/www-doc/snasedoc.gif",alt=>"[LOGO]",border=>"0"}),
			  "</TD></TR></TABLE>\n",
			"</TD></TR><TR><TD>\n",
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=center><TR><TD>',
			  '<TR CLASS="title"><TD CLASS="title">Directories</TD></TR>',
			    '<TR><TD CLASS="left">';
		      showdir("/",$sub, 0);
		      print 
			  "</TD></TR></TABLE>\n",
			"</TD></TR><TR><TD>\n",
  			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=left>',
			    '<TR CLASS="title"><TD CLASS="title">Indices</TD></TR>',
			    '<TR><TD CLASS="left">',
			      "<LI>", a({href=>"/nase.list/", target=>"text"}, "mailing list"), "</LI>",
			      "<LI>routines by ", a({href=>$DOCURL.RoutinesHTML(), target=>"text"}, "name"), "</LI>",
			      "<LI>routines by ", a({href=>$DOCURL.RoutinesCatHTML(), target=>"text"}, "category"), "</LI>",
			      "<LI>keywords by ", a({href=>$DOCURL.KeyByNameHTML(), target=>"text"}, "name"), "</LI>",
			      "<LI>keywords by ", a({href=>$DOCURL.KeyByCountHTML(), target=>"text"}, "count"), "</LI>  ",
			  "</TD></TR></TABLE>",
			"</TD></TR><TR><TD>",
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=left>',
			    '<TR CLASS="title"><TD CLASS="title">Search</TD></TR>',
			    '<TR><TD CLASS="left">',
			    start_multipart_form(-target=>"text"),
			    textfield(-name=>'QuickSearch', -size=>15, -maxlength=>80),
			#		        hidden(-name=>'mode', -value=>'search'), doesn't work inserts $P::MODE
			    '<INPUT NAME="mode" VALUE="search" TYPE=HIDDEN>',
			    checkbox_group(-name=>'sfields',
				       -values=>['name','aim'],
				       -defaults=>['name']),
		    	    endform,
			  "</TD></TR></TABLE>",
			"</TD></TR><TR><TD>",
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=left>',
			    '<TR CLASS="title"><TD CLASS="title">Check Headers</TD></TR>',
			    '<TR><TD CLASS="left">',
			    "Test the format of your documentation header before checking in!",
			    start_multipart_form(-target=>"text"),
			    filefield(-name=>'filename',-size=>5),
			    '<INPUT NAME="mode" VALUE="check" TYPE=HIDDEN>',
			    submit(-name=>'Check'),
			    endform,
			  "</TD></TR></TABLE>",
			"</TD></TR><TR><TD>",
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=left>',
			  '<TR CLASS="title"><TD CLASS="title">Update</TD></TR>',
			  '<TR><TD CLASS="left">',
			    "<LI>last update: $lastmod</LI>",
			    "<LI>",a({href=>"$myurl?mode=update", target=>"_new"}, "update now"), "</LI>", 
			    '<LI>$Id$ </LI>',
			  "</TD></TR></TABLE>",
			"</TD></TR>",
			"</TABLE>";
		      last TRUNK;};
    /text/i   && do { print myBody();
		      if ($P::file){if ($P::show eq "header") { showHeader(key=>$P::file); };
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
    /search/i   && do { print myBody();
			quickSearch($P::QuickSearch, param('sfields'));
			last TRUNK;
                      };
    /check/i    && do {
			print myBody();
			chomp (my $chkfile = `/bin/mktemp /tmp/nasedocu_checkXXXXXX`);
			open (CHK, ">$chkfile") || die "can't open $chkfile: $!\n";
                        my $filename = param('filename');
			while (<$filename>) {
			  print CHK $_;
			}
			close (CHK) || die "can't close $chkfile: $!\n";
			close ($filename) || die "can't close nsform: $!\n";
			showHeader(file=>$chkfile);
			unlink $chkfile || die "can't unlink $chkfile: $!\n";
                        last TRUNK;
                      };
    /dir/i   && do { print '<frameset cols="250,*">';
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
