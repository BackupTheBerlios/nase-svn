;+
; NAME: Faceit_Rename
;
; PURPOSE: Benennt die Files in einem Verzeichnis um und ersetzt auch in deren
;          Programmtext das Vorkommen der alten Filenamen durch neue. Dies
;          ist hilfreich, wenn man eine Kopie der <A HREF="../graphic/widgets/#FACEIT">FaceIt</A>-Gerüst-Routinen in 
;          eine eigene Simulation umbauen will. 
;
; CATEGORY: MISCELLANOUS
;
; CALLING SEQUENCE: Faceit_Rename, dir, oldname, newname
;
; INPUTS: dir: Das Directory, in dem sich die Routinen befinden, die umbenannt
;              werden sollen.
;         oldname: Der Name der bisherigen Simulation.
;         newname: Der Name der neuen Simulation.
;
; (SIDE) EFFECTS: Im angegebenen Verzeichnis wird jedes Vorkommen von 'oldname'
;                 durch 'newname' ersetzt, und zwar sowohl im Filenamen wie
;                 auch im Programmtext.
;
; PROCEDURE: Verzeichnis wechseln, dann zwei Perl-Anweisungen mit 
;            Parameterübergabe und zurück ins alte Verzeichnis.
;
; EXAMPLE: FaceIt_Rename, '~/mein/simulations/verzeichnis', 'haus2_', 'myhaus_'
;
; SEE ALSO: <A HREF="../graphic/widgets/#FACEIT">FaceIt</A>, <A HREF="../graphic/widgets/faceit_demo">FaceIt-Demo</A>. 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/09/13 15:16:08  kupper
;        Cosmetic change: Now using PUSHD/POPD.
;
;        Revision 1.1  1999/09/07 16:20:13  thiel
;            Wrapper for two helpful perl-statements.
;
;-



PRO Faceit_Rename, dir, oldname, newname

   pushd, dir                   ;change to dir and store old dir on stack

   Message, /INFO, 'Executing perl commands.'

   Spawn, "perl -e 's/"+oldname+"/"+newname+"/gi' -p -i *.pro"

   Spawn, "perl -e 'while (<*.pro>) {$n=$_; s/"+oldname+"/"+newname+"/gi; rename $n, $_}'"


   popd                         ;return to old dir

   Message, /INFO, 'Renamed files in '+dir+' from '+oldname+ $
    '* to '+newname+'* and substituted occurences of '+oldname+ $
    ' to '+newname+'.'

END
