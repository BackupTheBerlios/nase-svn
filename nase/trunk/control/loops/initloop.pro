;+
; NAME:               
;   InitLoop()
;
; VERSION:
;   $Id$
;
; AIM:  
;   initializes a LOOP. That is a structure for handling general loops.
;
; PURPOSE:            
;   The loop routines are designed to process various loop
;   hierarchies. The idea is the following:
;   You store all relevant parameters in a structure.
;   If a tags contains an array of values, the loop routines
;   will iterate across each of it. The loop routine <A>LoopValue</A>
;   provides a structure where all tags are set to the current
;   iteration. This loop structure will subsequently be set to each
;   value of cartesian product of all arrays. 
;
;   <A>InitLoop</A> will initialize
;   the loop, <A>LoopValue</A> returns the current value of the loop,
;   <A>LoopName</A> returns a name to use as file skeleton,
;   <A>Looping</A> proceeds to the next parameter combination and 
;   <A>LoopIter</A> returns the total number of iterations.
; 
;   Depending on the dimension of the tag values, the loops show
;   a different behaviour:
;   
;*   MyParameters = {
;*                    scalar            : 5.
;*                    one-dimensional   : Indgen(20)
;*                    multi-dimensional : Indgen(4,5,6)
;*                  }
; 
;    scalar            :: leaves the parameter as it is
;    one-dimensional   :: subsequently chooses one value of of the array
;    multi-dimensional :: the first index is used to iterate over (4
;                         iterations), the temporary structure tag
;                         subsequently contains a (5,6) array
;    
;    This sample loop will therefore have 20 * 4 iterations.
;   
; CATEGORY:           
;*   CONTROL
;*   NASE
;
; CALLING SEQUENCE:
;*   LS = InitLoop(S)
;
; INPUTS:
;*   S :: an anonymous structure (as explained above)
;
; OUTPUTS:
;*   LS :: LoopStructure 
;
; EXAMPLE:
;
;  The following code defines two loops: the tag c should have the
;  values 1 and 2, while d should be A and C. This will result in
;  2 * 2 iterations.
;
;*  MyParameters={ a : 0.5       ,$
;*                 b : 1.5432    ,$
;*                 c : [1,2]     ,$
;*                 d : ['A','C'] }
;*  LS = InitLoop(MyParameters)
;*  REPEAT BEGIN
;*    tmpStruc = LoopValue(LS)
;*    help, tmpStruc, /STRUCTURE
;*    dummy = Get_Kbrd(1)
;*    Looping, LS, dizzy
;*  END UNTIL dizzy
;*
;
;  results in:
;
;* >** Structure <40004208>, 4 tags, length=32, refs=1:
;* >  A               FLOAT          0.500000
;* >  B               FLOAT           1.54320
;* >  C               INT              1
;* >  D               STRING    'A'
;* >** Structure <40004388>, 4 tags, length=32, refs=1:
;* >  A               FLOAT          0.500000
;* >  B               FLOAT           1.54320
;* >  C               INT              1
;* >  D               STRING    'C'
;* >** Structure <40004208>, 4 tags, length=32, refs=1:
;* >  A               FLOAT          0.500000
;* >  B               FLOAT           1.54320
;* >  C               INT              2
;* >  D               STRING    'A'
;* >** Structure <40004388>, 4 tags, length=32, refs=1:
;* >  A               FLOAT          0.500000
;* >  B               FLOAT           1.54320
;* >  C               INT              2
;* >  D               STRING    'C'
;      
; SEE ALSO:          <A>Looping</A>, <A>LoopName</A>, <A>LoopValue</A>
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
