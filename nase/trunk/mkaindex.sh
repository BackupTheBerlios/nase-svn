#!/usr/ax1301/apps/bash
DIR=$1
echo > /tmp/alphrout.html
for i in $(find $DIR -name "*.html") ; do
if [ ! $i = $DIR/aindex.html  ] ; then
PFAD=$(echo $i | sed "s/\//\\\\\//g" )
grep HREF $i | grep -v Routine | grep  "#" | sed "s/.*<A //g" \
| tr '[:lower:]' '[:upper:]'\
| sed "s/#/${PFAD}&/g" | sed "s/^/<P><A /g" | sed "s/$/<\/P>/g" \
 >>/tmp/alphrout.html
fi
done
sort -t '#' -k 2 /tmp/alphrout.html | uniq > $DIR/aindex.html
echo "<HR>" dynamical created at $(date) >> $DIR/aindex.html
rm -f /tmp/alphrout.html

