;+
; NAME:                Maple
;
; PURPOSE:             Moeglichkeit zur "Kommunikation" mit dem Mathematik-
;                      Programm "MAPLE". Mit der Maple-Routine kann Maple
;                      remote Berechnungen durchfuehren. Dazu schreibt man
;                      alle Anweisungen in ein File und uebergibt es dieser
;                      Routine. Es ist moeglich IDL-Variablen/Strukturen in
;                      Maple bekannt zu machen. 
;                      Leider sehe ich noch keine Moeglichkeit
;                      wie Variablen aus MAPLE zurueckgegeben werden koennen.
;      
; CATEGORY:            MISC MAPLE
;
; CALLING SEQUENCE:    Maple, mfile [,OUTPUT=output] [,PARAS=paras] [,/VERBOSE] [,_EXTRA=e]
;
; INPUTS:              mfile: File mit Maple-Anweisungen
;
; KEYWORD PARAMETERS:  VERBOSE: geschwaetzig
;                      PARAS  : Struktur, die Variablen enthaelt, die in 
;                               Maple bekannt sein sollen
;                      _EXTRA : Alle unbekannten Keywords werden als
;                               Variablen an MAPLE uebergeben, d.h.
;                                 Maple, file, a=6, b=10 
;                                    ==> a:=6;b:=10; (in MAPLE) 
;                               Sind in _EXTRA und PARAS gleiche Variablennamen
;                               definiert, haben die in PARAS (wie bei _EXTRA
;                               ueblich) Prioritaet.
;
;                      ACHTUNG: Da Maple case-sensitive arbeitet, IDL aber nicht,
;                               muessen IDL-Variablen in MAPLE komplett klein
;                               geschrieben werden.
; 
; OPTIONAL OUTPUTS:   OUTPUT: alle Ausgaben von MAPLE sind hierin enthalten
;
; EXAMPLE:
;                     file.map:   sin(x);
;                     maple, 'file.map', x=3., OUTPUT=output
;                     print, OUTPUT
;                             |\^/|     Maple V Release 3 (RWTH Aachen) .
;                          _|\|   |/|_. Copyright (c) 1981-1994 by Waterloo Maple Software and the
;                          \  MAPLE  /  University of Waterloo. All rights reserved. Maple and Maple V
;                          <____ ____>  are registered trademarks of Waterloo Maple Software.       
;                               |       Type ? for help. 
;                          > x:=3.00000;
;                                        x := 3.00000  
;                          > sin(x);                                   
;                                        .1411200081  
;                          > quit;
;                          bytes used=112340, alloc=131048, time=0.03
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  1998/11/08 14:56:15  saam
;           improved RSH usage
;
;     Revision 1.4  1998/10/18 21:13:13  saam
;           now handles passing of string-variables correctly
;
;     Revision 1.3  1998/10/18 19:10:56  saam
;           new keyword VERBOSE
;
;     Revision 1.2  1998/10/18 19:03:38  saam
;           small docheader updates
;
;     Revision 1.1  1998/10/18 19:02:17  saam
;           initial revision
;
;
;-
PRO Maple, mfile, OUTPUT=output, PARAS=paras, VERBOSE=verbose, _EXTRA=e

host    = 'neuro'
maple   = '/vol/math/maple/bin/maple' 
cat     = '/bin/cat' 
rsh     = '/usr/bin/rsh' 
echo    = '/bin/echo' 
suff    = '.tmp' 

S = ''
IF Set(e) THEN BEGIN
   tagName  =  Tag_Names(e)
   tagCount = N_Elements(tagName)
   FOR i=0l,tagCount-1 DO BEGIN
      inf = SIZE(e.(i))
      IF inf(inf(0)+1) EQ 7 THEN tagVal = "`"+e.(i)+"`" $ ; hey, its a string 
      ELSE tagVal = e.(i)  
      S = S + STRLOWCASE(tagName(i)) + ':=' + STRCOMPRESS(tagVal,/REMOVE_ALL) + ';'
   END
END
IF Set(paras) THEN BEGIN
   tagName  =  Tag_Names(paras)
   tagCount = N_Elements(tagName)
   FOR i=0l,tagCount-1 DO BEGIN
      S = S + tagName(i) + ':=' + STRCOMPRESS(paras.(i),/REMOVE_ALL) + ';'
   END
END
IF S NE '' THEN BEGIN
   OpenW,lun, mfile+suff, /GET_LUN
   printf, lun, S
   Close, lun
END

IF Keyword_Set(VERBOSE) THEN Print, 'MAPLE: additional variables are ', S

IF FileExists(mfile) THEN BEGIN
   spawn, "hostname | cut -b 1-5", res
   IF res(0) NE host THEN BEGIN
      command = rsh+' '+host+" '(( "+cat+' '+mfile+suff+' '+mfile+';'+echo+' "quit;" ) | nice -10 '+maple+")'"
   END ELSE BEGIN
      command = "( "+cat+' '+mfile+suff+' '+mfile+';'+echo+' "quit;" ) | /usr/bin/nice -10 '+maple
   END      
   IF Keyword_Set(VERBOSE) THEN print, 'MAPLE: running MAPLE on '+host+'...'
   spawn, command, output
   IF Keyword_Set(VERBOSE) THEN BEGIN
      print, !KEY.UP, 'MAPLE: running MAPLE on '+host+'...done'
      print, 'MAPLE: '+STRCOMPRESS(N_ELEMENTS(OUTPUT),/REMOVE_ALL)+' lines of output'
   END
   spawn, 'rm '+mfile+suff
END ELSE Message, "file doesn't exist"


END
