;+
; NAME:
;  newPTVS
;
; VERSION:
;  $Id$
;
; AIM:
;  
;
; PURPOSE:
;  (When referencing this very routine in the text as well as all IDL
;  routines, please use <C>RoutineName</C>.)
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
;*result = FunctionName( par [,optpar] [,/SWITCH] [,KEYWORD=...] )
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>newPTV</A>
;-

PRO newPTVS, first, second, third, _EXTRA=_extra

   mif = Min(first, MAX=maf)
   Default, legmin, Str(mif, FORMAT='(G0.0)')
   Default, legmax, Str(maf, FORMAT='(G0.0)')

   a = Scl(first, [0, !TOPCOLOR])

   CASE N_Params() OF
      1: newPTV, a, LEGMIN=legmin, LEGMAX=legmax, _EXTRA=_extra
      2: newPTV, a, second, LEGMIN=legmin, LEGMAX=legmax, _EXTRA=_extra
      3: newPTV, a, second, third, LEGMIN=legmin, LEGMAX=legmax, _EXTRA=_extra
      ELSE: Console, /FATAL, 'Wrong number of arguments.'
   ENDCASE

END

