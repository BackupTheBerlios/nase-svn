#!/usr/bin/perl -w
#
# $Header$
#
use diagnostics;
use strict;

use CGI qw/:standard :html3 -debug/;
use CGI::Carp;
use File::Basename;

use NASE::globals;
use NASE::xref;
use NASE::parse;

local $SIG{__WARN__} = \&Carp::cluck;
my ($hostname, $DOCDIR, $DOCURL, $myurl, $fullurl, $sub, $lastmod, $relpath);

$CGI::POSTMAX         = 1024*100; # maximal post is 100k
#$CGI::DISABLE_UPLOADS =    1; # no uploads
import_names('P');


# global variables
($myurl = url(-absolute=>1)) =~ s,\/\.\/,,g;  # without the http://server/ stuff
($relpath = $myurl) =~ s,\/[^\/]+$,,i;
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
  my $DOCDIR = getDocDir();

  print "create HTML documentation...";
  `$DOCDIR/doc/www-bin/automakedoc`;
  print "...done</PRE>";

}











###################################################################################
###################################################################################
###################################################################################
sub showdir {
  my ($mydir, $targetdir, $level, $reldir, @sdir, @file, $tmprep);
  my $DOCDIR = getDocDir();

  ($mydir, $targetdir, $level) = @_;
  $mydir     =~ s,\/$,,g;
  $targetdir =~ s,\/$,,g;
  ($reldir = $mydir) =~ s,.*\/,,;

  # display yourself
  print a({href=>getBaseURL()."/$mydir?mode=dir",target=>"_top"}, img({src=>"/icons/folder.gif",alt=>"[DIR]",border=>"0"})."$reldir"), br;
  

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

    foreach (sort @sdir){
      showdir("$mydir/$_", $targetdir, $level+1);
    }
    foreach (sort @file) {
      s/\.pro//i;
      print a({href=>getBaseURL()."/$mydir?file=$_&show=header&mode=text",target=>"text"}, img({src=>"/icons/text.gif",alt=>"[DIR]",border=>"0"})."  $_"), br;
    }

    print "</BLOCKQUOTE>" if $level;
  }
}





###################################################################################
###################################################################################
###################################################################################
#print "Content-Type: text/html\n\n", '<HTML>
#<HEAD>
#  <meta http-equiv="expire" content="0">
#  <meta http-equiv="refresh" content="0; URL=http://www.physik.uni-marburg.de/neuro/frames/index.html target=main" >
#</HEAD>
#<body>
#UMLEITUNG
#</body>
#</HTML>';
#exit 0;
print "Content-Type: text/html\n\n";
if ($P::mode){
  $_ = $P::mode;
 TRUNK: {
    /update/i && do { print myHeader();
		      updatedoc();
		      last TRUNK;};
    /list/i   && do { print myHeader(), myBody();
		      print 
			'<TABLE cellspacing=5 border=0><TR><TD>',
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=center><TR><TD>',
			     img({src=>"$DOCURL/doc/www-doc/snasedoc.gif",alt=>"[LOGO]",border=>"0"}),
			  "</TD></TR></TABLE>\n",
			"</TD></TR><TR><TD>\n",
			  '<TABLE cellpadding=1 cellspacing=0 border=0 width="200" align=center>',
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
			      "<LI>routines by ", a({href=>getBaseURL()."?show=rbyn&mode=text", target=>"text"}, "name"), "</LI>",
			      "<LI>routines by ", a({href=>getBaseURL()."?show=rbyc&mode=text", target=>"text"}, "category"), "</LI>",
#			      "<LI>keywords by ", a({href=>$DOCURL.KeyByNameHTML(), target=>"text"}, "name"), "</LI>",
#			      "<LI>keywords by ", a({href=>$DOCURL.KeyByCountHTML(), target=>"text"}, "count"), "</LI>  ",
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
#			    "<LI>",a({href=>getBaseURL()."?mode=update", target=>"_new"}, "update now"), "</LI>", 
			    "<LI>",a({href=>"$relpath/nasenews.pl", target=>"text"}, "Add news"), "</LI>",
			    '<LI>$Id$ </LI>',
			  "</TD></TR></TABLE>",
			"</TD></TR>",
			"</TABLE>";
		      last TRUNK;};
    /text/i   && do { 
		      if ($P::file){if ($P::show eq "header") { print myHeader(), myBody(); showHeader(key=>$P::file); };
				    if ($P::show eq "source") { print myHeader(), myBody(); showSource($P::file); };
				    if ($P::show eq "log"   ) { print myHeader(), myBody(); showLog($P::file);    };
		      } else {
			
			if ($P::show eq "rbyn"  ) { print myHeader(), myBody(); RoutinesByName(); } else {
			  if ($P::show eq "rbyc" ) { print myHeader(), myBody(); RoutinesByCat(); } else {
			    if (($sub eq '/')||($sub eq '/nase')||($sub eq '/mind')){
#			      open(IDX, "<".$DOCDIR."/doc/www-doc/mainpage.sql");
#			      while(<IDX>){print;};
#			      close(IDX) || die "can't close index: $!\n";
			      print '<HEAD><meta http-equiv="expire" content="0"><meta http-equiv="refresh" content="0; URL=/nase/doc/www-doc/mainpage.sql">';
			    } else {
			      print myHeader(), myBody(); DirAim($sub);
			    }
			  }
			}
		      }
		      last TRUNK;
		    };
    /search/i   && do { print myHeader(), myBody();
			quickSearch($P::QuickSearch, param('sfields'));
			last TRUNK;
                      };
    /check/i    && do {
			print myHeader(), myBody();
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
    /dir/i   && do { print myHeader(), '<frameset cols="250,*">';
		     print frame({src=>"$fullurl?mode=list", name=>"list"});
		     print frame({src=>"$fullurl?mode=text&show=aim", name=>"text"});
		     print '</frameset>';
		     print myBody(), "i cant handle frames!!";
		     last TRUNK;
		   }
  }
} else {
  print myHeader(), '<frameset cols="250,*">';
  print frame({src=>"$fullurl?mode=list", name=>"list"});
  print frame({src=>"$fullurl?mode=text", name=>"text"});
  print '</frameset>';
  print myBody(), "i cant handle frames!!";
};



print end_html;

exit 0;
