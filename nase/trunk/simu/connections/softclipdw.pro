;+
; NAME:
;  SoftClipDW
;
; AIM: Smooth clipping of neuronal weights.
;  
; PURPOSE:
;   The function applies a sigmoid transfer function to the weights
;   contained in a DW or SDW structure: <BR>
;*
;*                          out
;*                           ^
;*                           |
;*                        top+                         oooooo
;*                           |                o
;*                           |            o
;*    ---               upper+         o
;*     ^                     |       o
;*     |                     |     o
;*   linear                  |   o
;*   range                   | o
;*     |   ------------------o-------------------------> in
;*     v                   o |
;*    ---                o   +lower
;*                    o      |
;*    oooooo                 +bottom
;*                           |
;*                           |
;*                           |
;*
;   1. Values in the range <*>[lower,upper]</*> are passed without
;      modification. <BR> 
;   2. Values in the range <*>(upper,oo)</*> are squashed to <*>(upper,top)</*> by
;      the upper half of a fermi function. (See <A>Fermi()</A>.) <BR> 
;   3. Values in the range <*>(-oo,lower)</*> are squashed to <*>(bottom,lower)</*>
;      by the lower half of a fermi function. <BR>
;
;   For a detailed description of the transfer function used, please
;   refer to the documentation of <A>SoftClip()</A>. <BR>
;   Note that only weights are clipped, not delays.
;
; CATEGORY:
;  Connections
;  Math
;  Simulation
;  
; CALLING SEQUENCE:
;* SoftClip, DW, {  UPPER=.., TOP=..
;*                | LOWER=.., BOTTOM=..
;*                | UPPER=.., TOP=.., LOWER=.., BOTTOM=..
;*               }
;                          
; INPUTS:
;  DW:: The (S)DW weight matrix to be clipped.
;  
; INPUT KEYWORDS:
;  UPPER, LOWER, TOP, BOTTOM::
;    The resulting values are restricted to the range <*>(BOTTOM,TOP)</*>. <BR>
;    Values in the range <*>[LOWER,UPPER]</*> stay unchanged. <BR>
;    Values in the range <*>(UPPER,oo)</*> are squashed to <*>(UPPER,TOP)</*>. <BR>
;    Values in th range <*>(-oo,LOWER)</*> are squashed to <*>(BOTTOM,LOWER)</*>. <BR>
;
;  If <*>BOTTOM</*> and <*>LOWER</*> are not specified, they default to <*>-oo</*>. <BR>
;  If <*>TOP</*> and <*>UPPER</*> are not specified, they default to <*>+oo</*>.
;  
; RESTRICTIONS:
;* TOP > UPPER
;* BOTTOM < LOWER
;  
; PROCEDURE:
;  Extract weights and pass through <A>SoftClip</A>.
;  
; SEE ALSO:
;  <A>SoftClip()</A>.
;  
;-

Pro SoftClipDW, _DW, $
                UPPER=upper, TOP=top, LOWER=lower, BOTTOM=bottom

   TestInfo, _DW, "DW"          ;Ist es überhaupt eine DW oder SDW?

   ;;------------------> SDW - This is easy!
   If contains(Info(_DW), "SDW") then begin 
      Handle_Value, _DW, DW, /NO_COPY
      DW.W = SoftClip(DW.W, UPPER=upper, TOP=top, LOWER=lower, BOTTOM=bottom)
      ;; shame we can't use Temporary here, for ot is contained inside
      ;; a struct...
      Handle_Value, _DW, DW, /NO_COPY, /SET
      
      return
   Endif
   ;;--------------------------------

   ;;------------------> It's DW, so restore !NONEs afterwards...
   Handle_Value, _DW, DW, /NO_COPY
   count = 0
   nones = Where(DW.Weights eq !NONE, count)
   If count ne 0 then begin
      DW.Weights(nones) = 0           ;Set Nones to 0
   Endif
   ;; shame we can't use Temporary here, for ot is contained inside
   ;; a struct...
    DW.Weights = SoftClip(DW.Weights, UPPER=upper, TOP=top, LOWER=lower, BOTTOM=bottom)
    ;; NONES will be squashed by gthis call, so:
   If count ne 0 then DW.Weights(nones) = !NONE ;restore NONEs
   Handle_Value, _DW, DW, /NO_COPY, /SET
   ;;--------------------------------

END
