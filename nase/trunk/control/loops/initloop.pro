;+
; NAME:               InitLoop
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
;                           tmpStruc = Looping(LS, dizzy)
;                           help, tmpStruc, /STRUCTURE
;                           dummy = Get_Kbrd(1)
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
; SEE ALSO:          <A HREF="#LOOPING>Looping</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1997/11/25 10:27:49  saam
;           HRef-Syntax war falsch
;
;     Revision 1.1  1997/11/25 10:11:26  saam
;           IDL ist toll
;
;
;-
FUNCTION InitLoop, struct

   s = SIZE(struct)
   IF s(N_Elements(s)-2) EQ 8 THEN BEGIN


      ntags = N_Tags(struct)
      maxcount = LonArr(ntags)
      FOR tag=0,ntags-1 DO BEGIN
         maxcount(tag) = N_Elements(struct.(tag))
      END
      LoopStruc = { info     : 'LoopStruc'          ,$
                    n        : ntags                ,$
                    counter  : InitCounter(MaxCount),$
                    struct   : struct               }
      RETURN, LoopStruc
      

   END ELSE BEGIN
      
      MaxCount = N_Elements(struct)
      LoopStruc = { info     : 'LoopArr'            ,$
                    n        : 1                    ,$
                    counter  : InitCounter(MaxCount),$
                    struct   : {huhu:struct}        }
      RETURN, LoopStruc

 
   END

END
