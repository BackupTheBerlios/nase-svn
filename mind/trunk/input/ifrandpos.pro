;+
; NAME:               IFRandPos
;
; AIM:                shifts an arbitrary stimulus randomly to a set of positions (think of RFCine)
;
; PURPOSE:            Shifts a given stimulus to specified positions
;                     in random order. Every call of this function
;                     changes the position. All positions will be
;                     visited before one position is used twice.  
;
; CATEGORY:           MIND INPUT
;
; CALLING SEQUENCE:   
;                     ignore_me  = Ifrandpos( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,/WRAP]
;                                              [,FILE=file]
;
;                                              [,POS=pos]
;                                              [,STIM=stim]
;                                              [,/SAVE]
;                                               )
;
;                     newPattern = Ifrandpos( [MODE=1], PATTERN=pattern )
;                     ignore_me  = Ifrandpos( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     FILE      : provides a file skeleton (string) to save
;                                 data in an ordered way. 
;                     HEIGHT    : height of the input to be created
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;                     WRAP      : set, if the underlying layer has
;                                 toroidal boundary conditions
;                     LOGIC     : logical operation :
;                                 NEW_INPUT = OLD_INPUT #LOGIC# HERE_GENERATED_INPUT 
;                                 valid values can be found <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#OPID>here</A>
;
;                     STIM      : the stimulus as 2d array that will
;                                 be centered at the specified
;                                 positions. The stimulus is expected
;                                 to be centered in the STIM array. If
;                                 STIM is omitted, a delta function
;                                 will be used.
;                     POS       : a list of (1d) positions in the
;                                 layer. E.g., you can use <A
;                                 HREF="">grid</A> to subsample to
;                                 layer. If not given, all positions
;                                 in the array will be used. 
;                     SAVE      : If set (to 1), the randomly draw
;                                 layer positions will be written to a
;                                 file (as 2d coordinates).
;
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/29 08:10:35  saam
;     added the AIM tag
;
;     Revision 1.1  2000/06/29 15:19:40  saam
;           huiiiii
;
;
;


FUNCTION IFrandPos, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, LOGIC=op, WRAP=wrap, $
                    STIM=stim, POS=pos, FILE=file, SAVE=save, _EXTRA=e

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   Default, op  , 'ADD'
   Default, wrap, 0
   Default, file, ''

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
       ; INITIALIZE
       0: BEGIN      
           s = ''
           IF NOT (Set(STIM)) THEN BEGIN
               s = s + 'default stimulus, '
               stim = FltArr(h,w)
               stim(0,0)= 1.0
           END
           IF NOT (Set(POS)) THEN BEGIN
               s = s + 'each position, '
               pos = LIndGen(w*h)
           END ELSE s = s + STR(N_Elements(pos))+' positions, '

           
           V = !NONE
           IF Keyword_Set(SAVE) THEN V = InitVideo( LonArr(2), TITLE=File+'_randpos', /SHUTUP, /ZIPPED )

           TV =  {                               $                    
                   stim     : InsSubArray(FltArr(h,w), stim, /CENTER),$
                   pos      : subscript(FltArr(h,w),pos)             ,$
                   npos     : N_Elements(pos)   ,$
                   rand     : LonArr(N_Elements(pos)),$
                   randpos  : -1l               ,$
                   w        : w                 ,$
                   h        : h                 ,$
                   wrap     : wrap              ,$
                   V        : V                 ,$
                   delta_t  : delta_t           ,$
                   sim_time : .0d               ,$
                   myop     : opID(op)           $
                 }
           IF TV.wrap THEN s = s + 'wrap' ELSE s = s + 'no wrap'
           console, s     
       END
      
      ; STEP
      1: BEGIN                             
          IF TV.randpos LT 0 THEN BEGIN
              ; generate a new sequence of positions
              TV.rand    = All_Random(TV.npos)
              TV.randpos = TV.npos-1
          END
          
          IF TV.wrap $
            THEN R = Shift(TV.stim, TV.pos(TV.rand(TV.randpos),0) - TV.h/2, TV.pos(TV.rand(TV.randpos),1) - TV.w/2) $
            ELSE R = norot_Shift(TV.stim, TV.pos(TV.rand(TV.randpos),0) - TV.h/2, TV.pos(TV.rand(TV.randpos),1) - TV.w/2)
          IF TV.V NE !NONE THEN dummy = CamCord( TV.V, REFORM(TV.pos(TV.rand(TV.randpos),*)))
          TV.randpos = TV.randpos-1
          TV.sim_time =  TV.sim_time + TV.delta_t
          R = Operator(TV.myop, pattern, R)
      END
      
      ; FREE
      2: BEGIN
          IF TV.V NE !NONE THEN Eject, TV.V, /NOLABEL, /SHUTUP
          Handle_Free, _TV
          console, 'done'
          RETURN, R
      END 

      ; PLOT
      3: BEGIN
         console, 'display mode not implemented, yet'
      END
      ELSE: BEGIN
         console, 'unknown mode', /FATAL
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
