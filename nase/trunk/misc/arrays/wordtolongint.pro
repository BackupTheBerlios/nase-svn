;+
; NAME:
;  WordToLongInt()
;
; VERSION:
;  $Id$
;
; AIM:
;  convert a four byte data word to long int
;
; PURPOSE:
;  convert a four byte data word to long int
;
; CATEGORY:
;  Array
;  Math
;
; CALLING SEQUENCE:
;*result = WordToLongInt(four_byte_array)
;
; INPUTS:
;  four_byte_array:: array of four bytes
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
;*a = bytarr(4) 
;*help, a
;*>A               BYTE      = Array[4]
;*a[0]=3 
;*a[1]=20 
;*a[2]=2 
;*a[3]=7 
;*print, wordtolongint(a) 
;*>   117576707
; SEE ALSO:
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function WordToLongInt, w
return, w[0] + 256L*w[1] + 256L*256L*w[2] + 256L*256L*256L*w[3]
end
