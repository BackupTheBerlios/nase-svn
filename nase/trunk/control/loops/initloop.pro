;+
; NAME:               InitLoop
;
; AIM: initializes a LOOP. that is a structure for handling general loops .
;
; PURPOSE:            Diese Routine dient zur Behandlung von allgemeinen
;                     Schleifen. Das Prinzip ist folgendes: Alle Parameter
;                     werden in einer beliebigen Struktur (oder Array) gespeichert.
;                     Besteht ein Tag aus einer Liste von mehreren Ein-
;                     traegen, so werden diese der Reihe nach abgearbeitet.
;                     Jeder Aufruf von Looping liefert eine temporaere
;                     Struktur zurueck, die jeweils eine Parameterkombination 
;                     enthaelt.....argh!!!.....bssss!!!....zischh!!!!!
;                     Schaut lieber das Beispiel an. 
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   LS = InitLoop(Struc)
;
; INPUTS:             Struc: eine anonyme Structure oder eine Liste
;
; OUTPUTS:            eine LoopStructure
;
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         REPEAT BEGIN
;                           tmpStruc = LoopValue(LS)
;                           help, tmpStruc, /STRUCTURE
;                           dummy = Get_Kbrd(1)
;                           Looping, LS, dizzy
;                         END UNTIL dizzy
;
;                    ScreenShot:
;                        ** Structure <40004208>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              1
;                           D               STRING    'A'
;                        ** Structure <40004388>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              1
;                           D               STRING    'C'
;                        ** Structure <40004208>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              2
;                           D               STRING    'A'
;                        ** Structure <40004388>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              2
;                           D               STRING    'C'
;      
; SEE ALSO:          <A HREF="#LOOPING">Looping</A>, <A HREF="#LOOPNAME">LoopName</A>, <A HREF="#LOOPVALUE">LoopValue</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.7  2000/10/03 13:29:18  saam
;     + extended to process several values simultaneously
;     + new syntax still undocumented
;     + just a test version
;
;     Revision 1.6  2000/09/28 13:24:43  alshaikh
;           added AIM
;
;     Revision 1.5  1997/11/26 09:21:39  saam
;           Update der Docu
;
;     Revision 1.4  1997/11/25 16:44:00  saam
;           Hyperlink-Update
;
;     Revision 1.3  1997/11/25 10:43:56  saam
;           a HTML-Bug
;
;     Revision 1.2  1997/11/25 10:27:49  saam
;           HRef-Syntax war falsch
;
;     Revision 1.1  1997/11/25 10:11:26  saam
;           IDL ist toll
;
;
;-
FUNCTION InitLoop, struct

   IF TypeOf(struct) EQ "STRUCT" THEN BEGIN

      ntags = N_Tags(struct)
      maxcount = LonArr(ntags)
      FOR tag=0,ntags-1 DO BEGIN
          st = SIZE((struct.(tag)))        ; size of the current tag
          IF st(0) EQ 0 THEN maxcount(tag) = 1 ELSE  maxcount(tag) = st(1) ; first dimension is always the number of iterations per loop digit 
      END
      LoopStruc = { info     : 'LoopStruc'          ,$
                    n        : ntags                ,$
                    counter  : InitCounter(MaxCount),$
                    struct   : struct               }
      RETURN, LoopStruc
      

  END ELSE BEGIN
      Console, "array handling has been disabled, to test if anyone is still using it", /FATAL
;      
;      MaxCount = N_Elements(struct)
;      LoopStruc = { info     : 'LoopArr'            ,$
;                    n        : 1                    ,$
;                    counter  : InitCounter(MaxCount),$
;                    struct   : {huhu:struct}        }
;      RETURN, LoopStruc

 
   END

END
