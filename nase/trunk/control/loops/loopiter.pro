;+
; NAME:               LoopIter
;
; PURPOSE:            Liefert die Zahl an Iteration, die in einer LoopStructure 
;                     definiert sind.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   Iter = LoopIter(LS, [/STRUCTURE])
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure bzw.
;                         die zugrundeliegende Struktur, wenn Keyword STRUCTURE
;                         gesetzt ist.
;
; KEYWORD PARAMETERS: STRUCTURE: Wenn gesetzt wird LS als allg. Struktur interpretiert.
;
; OUTPUTS:            Iter: die Zahl durchzufuehrender Iteration
;                              
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         print, LoopIter(LS)
;                         print, LoopIter(MeineParameter, /STRUCTURE)
;                    ScreenShot:
;                         4
;                         4
;      
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPING">Looping</A>, <A HREF="#LOOPVALUE">LoopValue</A>, <A HREF="#LOOPNAME">LoopName</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1997/11/26 10:02:28  saam
;           Behandlung normaler Structuren nun mit Keyword STRUCTURE moeglich
;
;     Revision 1.1  1997/11/26 09:48:56  saam
;           Urversion
;
;
;-
FUNCTION LoopIter, LS, STRUCTURE=structure

   iter = 1l
   IF NOT Keyword_Set(STRUCTURE) THEN BEGIN
      IF Contains(LS.Info,'Loop') THEN BEGIN
         FOR tag = 0, LS.n-1 DO BEGIN 
            iter = iter*LS.counter.maxCount(tag)
         END
         END ELSE Message, 'no valid loop structure passed'
   END ELSE BEGIN
      s = SIZE(LS)
      IF s(N_Elements(s)-2) NE 8 THEN Message, 'sorry, but function is only designed for structures'
      
      nTags = N_Tags(LS)
      FOR tag=0,nTags-1 DO BEGIN
         tagSize = Size(LS.(tag))
         iter = iter*tagSize(N_Elements(tagSize)-1)
      END
   END
   RETURN, iter

END
