;+
; NAME:               LoopIter
;
; PURPOSE:            Liefert die Zahl an Iteration, die in einer LoopStructure 
;                     definiert sind.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   Iter = LoopIter(LS)
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure
;
; OUTPUTS:            Iter: die Zahl durchzufuehrender Iteration
;                              
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         print, LoopIter(LS)
;
;                    ScreenShot:
;                         4
;      
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPING">Looping</A>, <A HREF="#LOOPVALUE">LoopValue</A>, <A HREF="#LOOPNAME">LoopName</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1997/11/26 09:48:56  saam
;           Urversion
;
;
;-
FUNCTION LoopIter, LS

   IF Contains(LS.Info,'Loop') THEN BEGIN
      
      iter = 1l
      FOR tag = 0, LS.n-1 DO BEGIN 
         iter = iter*LS.counter.maxCount(tag)
      END

      RETURN, iter

   END ELSE Message, 'no valid loop structure passed'

END
