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
;*
;*>
;
; SEE ALSO:
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function WordToLongInt, w
return, w[0] + 256L*w[1] + 256L*256L*w[2] + 256L*256L*256L*w[3]
end
