;+
; NAME:
;  LoopIter()
;
; VERSION:
;  $Id$ 
;
; AIM:
;  returns the number of iterations, defined in a loop-structure
;
; PURPOSE:
;  returns the number of iterations, defined in a loop-structure
;                         
; CATEGORY:
;  ExecutionControl
;
; CALLING SEQUENCE:
;* iter = LoopIter(LS [,tagiter] [,/STRUCTURE])
;
; INPUTS:
;  LS:: a loop structure that was previously initialized with
;       <A>InitLoop</A>, or a structure conforming to the loop
;       conventions (set <*>/STRUCTURE</*> for this option).
;
; INPUT KEYWORDS: 
;  STRUCTURE:: <*>LS</*> will be interpreted as general loop structure
;
; OUTPUTS:
;  iter:: die Zahl durchzufuehrender Iteration
;                              
; OPTIONAL OUTPUTS:
;  tagiter:: array, containing the loop values for the current
;            iterations
;
; EXAMPLE:
;*mypara={ a: 0.5, b:1.5432, $
;*         c:[1,2], $
;*         d:['A','C'] }
;*LS = InitLoop(mypara)
;*print, LoopIter(LS, tagiter)
;*print, LoopIter(mypara, /STRUCTURE), tagiter
;results in the following output  
;*;    4
;*;    4
;*;    2 2
;      
; SEE ALSO:
;  <A>InitLoop</A>, <A>Looping</A>, <A>LoopValue</A>, <A>LoopName</A>
;  and <A>ForEach</A> as a high level approach to using general loops.
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
      END ELSE Console, 'no valid loop structure passed', /FATAL
   END ELSE BEGIN
      s = SIZE(LS)
      IF s(N_Elements(s)-2) NE 8 THEN Console, 'sorry, but function is only designed for structures', /FATAL
      
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
