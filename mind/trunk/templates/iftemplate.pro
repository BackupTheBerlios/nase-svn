;+
; NAME:               IFTEMPLATE
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
;
; CATEGORY:           MIND INPUT TEMPLATES 
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFTemplate( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,/WRAP]
;                                              [,FILE=file]
;                                              {various filter options} )
;
;                     newPattern = IFTemplate( [MODE=1], PATTERN=pattern )
;                     ignore_me  = IFTemplate( MODE=[2|3] )
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
;     $Log$
;     Revision 1.8  2000/07/04 09:01:02  saam
;           added WRAP and FILE identical to IFtemplate2
;
;     Revision 1.7  2000/01/27 10:50:30  saam
;           delete modification history from doc header
;
;     Revision 1.6  2000/01/26 16:21:08  alshaikh
;           print,message -> console
;
;     Revision 1.5  2000/01/19 09:10:38  saam
;           + returns on error now
;           + removed redundant references to keywords during step (MODE=1)
;           + removed side effect of keyword PATTERN
;
;     Revision 1.4  2000/01/18 14:00:20  saam
;           + supports plot as MODE=3
;           + doc header updated and bugfixed
;
;     Revision 1.3  2000/01/14 15:12:27  saam
;           + DocHeader rewritten
;           + default return pattern is !NONE now
;
;     Revision 1.2  2000/01/14 14:08:45  alshaikh
;           bugfix
;
;     Revision 1.1  2000/01/14 10:35:02  alshaikh
;           done
;
;


FUNCTION IFtemplate, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, WRAP=wrap, FILE=file

 COMMON terminal, output

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   Default, wrap, 0
   Default, file, ''
   
   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN                  
         TV =  {                    $
                delta_t  : delta_t ,$
                sim_time : .0d      $
               }
         console,output,'initialized','iftemplate',/msg         
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
      END
      
      ; FREE
      2: BEGIN
         console,output,'done','iftemplate',/msg
      END 

      ; PLOT
      3: BEGIN
         console,output, 'display mode not implemented, yet','iftemplate',/warning
      END
      ELSE: BEGIN
         console,output, 'unknown mode','iftemplate',/fatal
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
