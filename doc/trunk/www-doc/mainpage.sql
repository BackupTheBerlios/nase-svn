<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML><HEAD><TITLE>NASE/MIND Documentation System</TITLE>
<LINK REL="STYLESHEET" HREF="/nase/doc/www-doc/shtml.css">
</HEAD>

<BODY bgcolor=#FFFFFF text=#000000>

<IMG SRC="/nase/doc/www-doc/nasedoc.gif" HEIGHT=210 WIDTH=320 ALIGN=TEXTTOP>

<BR>
<BR>
<UL>
<LI> <A HREF="/nase/doc/standards/standards.html">NASE/MIND Standards</A> </LI>
<LI> <A HREF="/nase/doc/workshop/workshop.html">NASE Workshop - Schedule and Proceedings</A> </LI>
<LI> <A HREF="/nase/doc/workshop/todo.html">To-Do List</A> </LI>
</UL>

<BR>
<BR>
<BR>
<UL>
<LI> <A HREF="/nase/doc/standards/cvs.html">CVS Introduction</A> </LI>
<LI> <A HREF="/nase/doc/simulation/neurontypes.html">NASE Neuron Types</A> </LI>
</UL>
<BR>
<BR>
<BR>

<! SQL CONNECT localhost chiefnase misfitme>
<! SQL DATABASE nase >

<! SQL QUERY "select dayofmonth(date),monthname(date),news, (date > (DATE_SUB(now(),INTERVAL 31 day))) from news order by date desc" q1 >
<! SQL IF $NUM_ROWS != 0 >

<TABLE COLS=2><TR><TH ALIGN=LEFT WIDTH=130>Recent News</TH><TH WIDTH=400></TH>
<! SQL PRINT_ROWS q1 "<TR><TD CLASS='xmpcode' VALIGN=TOP>@q1.0 @q1.1</TD><TD CLASS="xplcode">@q1.2</TD></TR>\n" >
</TABLE>

<! sql close>



</BODY>
</HTML>
