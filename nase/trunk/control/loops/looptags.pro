;+
; NAME:               LoopTags
;
; AIM: returns the number of tags contained in a loop (c.f. <A>looping</A>)
;
; PURPOSE:            Liefert die Zahl der Tags, die eine Schleife beinhalten.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   lTags = LoopTags(LS, TagIndices)
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure
;
; OUTPUTS:            lTags: die Anzahl an Schleifen in LS
;
; OPTIONAL OUTPUTS:   TagIndices: eine Liste der Tag-Indices, die Schleifen beinhalten
;                              
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         print, LoopTags(LS, TagIndices)
;                         print, TagIndices
;                    ScreenShot:
;                         2
;                         2 3
;      
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPING">Looping</A>, <A HREF="#LOOPVALUE">LoopValue</A>, <A HREF="#LOOPNAME">LoopName</A>, <A HREF="#LOOPITER">LoopIter</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/09/28 13:24:44  alshaikh
;           added AIM
;
;     Revision 1.1  1997/11/26 14:31:35  saam
;           Urversion
;
;
;-
FUNCTION LoopTags, LS, TagIndices

   IF Contains(LS.Info,'Loop') THEN BEGIN
      lTags = 0l
      FOR tag = 0, LS.n-1 DO BEGIN 
         IF LS.counter.maxCount(tag) GT 1 THEN BEGIN
            IF lTags EQ 0 THEN TagIndices = tag ELSE TagIndices = [TagIndices, tag]
            lTags = lTags + 1
         END
      END
   END ELSE Message, 'no valid loop structure passed'
   RETURN, lTags
END
