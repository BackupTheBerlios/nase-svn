#!/bin/ksh
DIR=$1
rm -f  $DIR/aindex.html     
echo > /tmp/alphrout.html
echo ' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"> 
<HTML> 
<HEAD> 
   <TITLE>IDL-Documenation</TITLE> 
   <META NAME="GENERATOR" CONTENT="Mozilla/3.0Gold (X11; I; Linux 2.0.30 alpha) [Netscape]"> 
   <META NAME="Author" CONTENT="Mirko Saam"> 
</HEAD> 
<BODY TEXT="#000000" BGCOLOR="#FFFFFF" LINK="#0000EE" VLINK="#551A8B" ALINK="#FF0000"> 
<P><!-- Changed by: saam, 23-May-1996 --><NEXTID N=A12> 
<HR></P> 
<H1>Alphabetical List of Routines</H1><P><UL>' > $DIR/aindex.html

for i in $(find $DIR -name "*.html") ; do
if [ ! $i = $DIR/aindex.html -a ! $i = $DIR/index.html  ] ; then
PFAD=$(echo $i | sed "s/\//\\\\\//g" )
grep HREF $i | grep -v Routine  | grep -v ";  " | sed "s/.*<A //g" | sed 's/">.*$//g'  \
| sed "s/#.*$/${PFAD}&\">###&<\/A>/g" | sed "s/####//g" | sed "s/^/<A /g" | sed "s/$/<BR>/g" \
 >>/tmp/alphrout.html
fi
done
sort -d -f -u -k 2 -t '#'  /tmp/alphrout.html  >>  $DIR/aindex.html
echo "</UL></P><HR></BODY></HTML>" dynamical created at $(date) >> $DIR/aindex.html
#rm -f /tmp/alphrout.html

