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
;  ucv means UnitConvert and converts value/s between inch, feet, 
;  millimeter and centimeter 
; 
;
; CATEGORY:
;  Help
;  Math
;
; CALLING SEQUENCE:
;*result = ucv( value, SOURCE=source, TARGET=target )
;
; INPUTS:
;  value:: value/array of values to convert (Default: 1.0)
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  SOURCE:: string, specifying source unit (Default: mm) [in, ft, mm, cm]
;  TARGET:: string, specifying target unit (Default: mm) [in, ft, mm, cm]  
;
; OUTPUTS:
;  result:: value converted from source-unit to target-unit
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
;  be careful with very large or very small values,
;  because conversion is done via 'millimeter' as internal format
;
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*> pagewidth_in_cm = ucv(10,SOURCE="in",TARGET="cm")
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
