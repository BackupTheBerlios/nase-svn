;+
; NAME:                Bar
;
; AIM:                 creates a horizontal continuous/split bar
;
; PURPOSE:             Creates a horizontal bar centered in an array with a variable
;                      gap in the middle. The array elements containing a part of the
;                      bar are set to 1.0 and 0.0 else.
;
; CATEGORY:            MIND INPUT
;
; CALLING SEQUENCE:    b = BAR( WIDTH=width ,HEIGHT=height [,GAP=gap] [,/LEFT] [,/RIGHT] $
;                               [,BARWIDTH=barwidth] [,BARHEIGHT=barheight] [,/NASE] [,RANDU=randu]
;
; KEYWORD PARAMETERS:  width/
;                      height    : width and height of the layer containing the bar
;                      gap       : the gap between left and right part of the broken bar,
;                                  default is no gap (GAP=0)
;                      left/
;                      right     : only return the left/right part of the broken bar
;                      barwidth/
;                      barheight : width and height of the complete bar (left&right part glued
;                                  together). Default: barwidth=5, barheight=2
;                      NASE      : handles nase arrays correctly
;                      randu     : uniformly distributed noise with amplitude randu (-randu..0..randu),
;                                  negative results are set to zero
;
; OUTPUTS:             b         : array containing the (broken) bar
;
; EXAMPLE:
;                      for i=0,10 DO plottvscl, bar(width=40, height=20, GAP=i, BARWIDTH=10, BARHEIGHT=5)
;                      for i=0,10 DO plottvscl, bar(width=40, height=20, GAP=i, BARWIDTH=10, BARHEIGHT=5, /RIGHT)
;
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 1.3  2000/09/29 08:10:34  saam
;      added the AIM tag
;
;      Revision 1.2  2000/01/05 13:49:10  saam
;            doc-minus was missing
;
;      Revision 1.1  1999/12/10 09:48:40  saam
;            + at the moment needed by initinput.pro
;            + imported from ~/sim/idl/input
;
;-
FUNCTION Bar, WIDTH=w, HEIGHT=h, GAP=GAP, LEFT=left, RIGHT=right, BARWIDTH=BARWIDTH, BARHEIGHT=BARHEIGHT, NASE=NASE, $
              RANDU=randu
            
   ;
   ; SET DEFAULT BEHAVIOUR
   ;
   Default, BarWidth , 5
   Default, BarHeight, 2
   Default, GAP      , 0
   Default, RANDU    , 0.0
   IF NOT (Keyword_Set(LEFT) OR Keyword_Set(RIGHT)) THEN BEGIN
      left = 1
      right = 1
   END

   _BarHeight = MIN([BarHeight-1, h-1])
   _BarWidth  = MIN([BarWidth-1, w-1])
   ;
   ; CREATE INPUT
   ;
   In = FltArr(w,h)
   IF (_barwidth GE 0) AND (_barheight GE 0) THEN BEGIN
      IF Keyword_Set(LEFT) THEN In(w/2-_barwidth/2-(GAP+1)/2:w/2-(GAP+1)/2,h/2-_BarHeight/2:h/2-_BarHeight/2+_BarHeight) = 1.
      IF Keyword_Set(RIGHT) THEN In(w/2+1+(GAP/2):w/2+1+_barwidth/2+GAP/2,h/2-_BarHeight/2:h/2-_BarHeight/2+_BarHeight) = 1.
   END
   
   ;
   ; UNIFORMLY DISTRIBUTED NOISE FOR EACH ENTRY BUT SET NEGATIVE VALUES TO ZERO
   ;
   In = (In + 2*RandU*(0.5-RandomU(seed, w,h))) >  0
   

   IF Keyword_Set(NASE) THEN In =  TRANSPOSE(In)

   RETURN, In
END
