;+
; NAME:               LoopIter
;
; PURPOSE:            Liefert die Zahl an Iteration, die in einer LoopStructure 
;                     definiert sind.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   Iter = LoopIter(LS [,TagIter] [,/STRUCTURE])
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure bzw.
;                         die zugrundeliegende Struktur, wenn Keyword STRUCTURE
;                         gesetzt ist.
;
; KEYWORD PARAMETERS: STRUCTURE: Wenn gesetzt wird LS als allg. Struktur interpretiert.
;
; OUTPUTS:            Iter: die Zahl durchzufuehrender Iteration
;                              
; OPTIONAL OUTPUTS:   TagIter: ein Array, das die Einzeliterationen fuer jede Schleifen-
;                              variable enthaelt.
;
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         print, LoopIter(LS, tagIter)
;                         print, LoopIter(MeineParameter, /STRUCTURE), tagIter
;                    ScreenShot:
;                         4
;                         4
;                         2 2
;      
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPING">Looping</A>, <A HREF="#LOOPVALUE">LoopValue</A>, <A HREF="#LOOPNAME">LoopName</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  1997/12/02 10:11:47  saam
;           optionaler Output tagIter hinzugefuegt
;
;     Revision 1.2  1997/11/26 10:02:28  saam
;           Behandlung normaler Structuren nun mit Keyword STRUCTURE moeglich
;
;     Revision 1.1  1997/11/26 09:48:56  saam
;           Urversion
;
;
;-
FUNCTION LoopIter, LS, tagIter, STRUCTURE=structure

   iter = 1l
   tagIter = LonArr(127)
   dims = 0
   IF NOT Keyword_Set(STRUCTURE) THEN BEGIN
      IF Contains(LS.Info,'Loop') THEN BEGIN
         FOR tag = 0, LS.n-1 DO BEGIN 
            iter = iter*LS.counter.maxCount(tag)            
            IF LS.counter.maxCount(tag) GT 1 THEN BEGIN
               tagIter(dims) = LS.counter.maxCount(tag)
               dims = dims+1
            END
         END
      END ELSE Message, 'no valid loop structure passed'
   END ELSE BEGIN
      s = SIZE(LS)
      IF s(N_Elements(s)-2) NE 8 THEN Message, 'sorry, but function is only designed for structures'
      
      nTags = N_Tags(LS)
      FOR tag=0,nTags-1 DO BEGIN
         tagSize = Size(LS.(tag))
         iter = iter*tagSize(N_Elements(tagSize)-1)
         IF tagSize(N_Elements(tagSize)-1) GT 1 THEN BEGIN
            tagIter(dims) = tagSize(N_Elements(tagSize)-1)
            dims = dims+1
         END
      END
   END
   IF dims GT 0 THEN tagIter = tagIter(0:dims-1) ELSE tagIter = -1
   
   RETURN, iter

END
