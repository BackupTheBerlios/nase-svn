;+
; NAME:
;  ucv()
;
; VERSION:
;  $Id$
;
; AIM:
;  converts value/s between inch, feet, millimeter and centimeter 
;
; PURPOSE:
;  converts value/s between inch, feet, millimeter and centimeter 
; 
;
; CATEGORY:
;  Help
;  Math
;
; CALLING SEQUENCE:
;*result = FunctionName( value, SOURCE=source, TARGET=target )
;
; INPUTS:
;  VALUE:: value/array of values to convert (Default: 1.0)
;  SOURCE:: source unit (Default: mm) [in, ft, mm, cm]
;  TARGET:: target unit (Default: mm) [in, ft, mm, cm]
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  value converted from source-unit to target-unit
;
; OPTIONAL OUTPUTS:
;  none
;
; COMMON BLOCKS:
;  none
;
; SIDE EFFECTS:
;  none
;
; RESTRICTIONS:
;  be careful with very large or very small values,
;  because conversion is done via 'millimeter' as internal format
;
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*> pagewidth_in_cm = (10,SOURCE="in",TARGET="cm")
;
; SEE ALSO:
;
;-


function ucv, value,SOURCE=source,TARGET=target
   
   Default, value,1.0
   Default, source,"mm"
   Default, target,"mm"

   value =  value + 0. ; float conversion
   metrics = ["in","ft","mm", "cm"]
   conv2mm   = [25.4,300.,1., 10.]
   
   if source ne "mm" then begin
      sidx = where(source eq metrics,c)
      if c ne 1 then console,"check source parameter",/FATAL
      result = conv2mm(sidx(0))*value
   end else result = value
   
   
   if target ne "mm" then begin
      sidx = where(target eq metrics,c)
      if c ne 1 then console,"check target parameter",/FATAL
      result = (1./conv2mm(sidx(0)))*result
   end
   
   return, result
end


