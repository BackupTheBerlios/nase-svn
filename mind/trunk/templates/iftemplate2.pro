;+
; NAME:               IFTEMPLATE2
;
; PURPOSE:            This is a prototype for an IFfilter. These functions are normally
;                     called by input.pro (MIND), but you can also you them by hand.
;                     This template realizes a filter for the genertion of a vertical bar.
;                     You can use the file as prototype for new filter functions. These
;                     should be located in $MINDDIR/input and should have the prefix 'IF'
;                     if the filter returns continous values and 'SIF' if it returns spike
;                     (binary) output.
;                     The Keywords already provided MUST NOT BE CHANGED, but you could 
;                     add various new ones to specify your filter options.
;                     in addition to IFTEMPLATE, this template provides the LOGIC-keyword 
;
; CATEGORY:           MIND INPUT TEMPLATES 
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFTemplate2( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width]
;                                              [,HEIGHT=height]
;                                              [,DELTA_T=delta_t]
;                                              [,/WRAP]
;                                              [,FILE=file]
;                                              [,LOGIC=logic] 
;                                              {various filter options} )
;
;                     newPattern = IFTemplate2( [MODE=1], PATTERN=pattern )
;                     ignore_me  = IFTemplate2( MODE=[2|3] )
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
;                                 (default: no)
;                     LOGIC     : logical operation :
;                                 NEW_INPUT = OLD_INPUT #LOGIC# HERE_GENERATED_INPUT 
;                                 valid values can be found <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#OPID>here</A>
;
;                     {various filter options}: to be added by the author
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
;     Revision 1.11  2000/08/11 14:24:20  thiel
;         Contains WRAP and FILE keywords now.
;
;     Revision 1.10  2000/06/29 14:57:52  saam
;           + added defaults for wrap and file
;
;     Revision 1.9  2000/06/29 14:55:21  saam
;           + corrected console output
;           + new keywords WRAP, FILE
;
;     Revision 1.8  2000/06/27 17:00:16  saam
;          + now frees memory after usage
;
;     Revision 1.7  2000/06/27 16:12:17  saam
;           + changed from print to console
;
;     Revision 1.6  2000/01/27 10:50:30  saam
;           delete modification history from doc header
;
;     Revision 1.5  2000/01/22 19:04:23  saam
;           updated doc header
;
;     Revision 1.4  2000/01/21 12:46:25  saam
;           extracted the logic implementation to opID and operator
;
;     Revision 1.3  2000/01/20 18:13:12  saam
;           doc header updated
;
;     Revision 1.2  2000/01/20 10:37:02  alshaikh
;           changes in header
;
;     Revision 1.1  2000/01/20 10:31:37  alshaikh
;           initial version... keyword LOGIC
;
;


FUNCTION IFtemplate2, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, WRAP=wrap, FILE=file, $
                      LOGIC=op

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
            
         TV =  {                      $
                delta_t  : delta_t   ,$
                sim_time : .0d       ,$
                myop     : opID(op)   $
               }
         console, 'initialized'         
      END
      
      ; STEP
      1: BEGIN                             
         R = pattern
         FOR x=0,TV.h-1 DO BEGIN   ; e.g. draw a vertical bar
            FOR y=TV.w/2-3,TV.w/2+3 DO BEGIN 
               R(y,x) = 1.0
            ENDFOR
         endfor 
         TV.sim_time =  TV.sim_time + TV.delta_t
         
         R = Operator(TV.myop, pattern, R)
      END
      
      ; FREE
      2: BEGIN
;          Handle_Free, _TV
          console, 'done'
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
