#!/usr/bin/perl

BEGIN {
  use CGI;
  $q = new CGI;
  $|=1; 
  if (!defined $q->param("_done")) {print "Content-Type: text/html\n\n";}
  open STDERR, ">&STDOUT";
}

use DBIx::HTMLView;

# Config
use naseconf;
my $script="nasenews.pl";

my $dbi=naseconf::dbi($q->param('_usr'), $q->param('_pw'));

require DBIx::HTMLView::CGIListView;
require DBIx::HTMLView::CGIQueryListView;
require DBIx::HTMLView::CGIReqEdit;

use NASE::globals;

my $act=$q->param('_Action');

# Update db as requested
if ($act eq 'update') {
  my $post=$dbi->tab($q->param('_Table'))->new_post($q);
  $post->update;
} elsif ($act eq "delete") {
  $dbi->tab($q->param('_Table'))->del($q->param('_id'));
}

# Jump to _done if defined
if (defined $q->param("_done")) {
        print "Location: " . $q->param("_done") . "\n\n";
        exit;
}

# Bring up the next editor page
if ($act eq 'edit') {
  my $post=$dbi->tab($q->param('_Table'))->get($q->param('_id'));
  $v=new DBIx::HTMLView::CGIReqEdit($script, $post, undef, $q);
} elsif ($act eq 'add') {
  my $post=$dbi->tab($q->param('_Table'))->new_post();
  $v=new DBIx::HTMLView::CGIReqEdit($script, $post, undef, $q);  
} elsif ($act eq 'show') {
  $v=$dbi->tab($q->param('_Table'))->get($q->param('_id'));
} elsif ($act eq 'query') {
  $v=new DBIx::HTMLView::CGIQueryListView($script, $dbi, $q);
} else {
  $v=new DBIx::HTMLView::CGIListView($script, $dbi, $q);
  #$v->rows(3);
}

print myHeader(), myBody();

print '<A HREF="/nase/doc/www-doc/mainpage.sql">MAINPAGE</A>';
print "<CENTER><H1>Edit News</H1></CENTER>\n";

print $v->view_html() . "\n";


print '<BR><BR><A HREF="/nase/doc/www-doc/mainpage.sql">MAINPAGE</A>';
print "</body></html>\n";

exit 0;
