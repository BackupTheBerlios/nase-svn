;+
; NAME:
;  Noun()
;
; VERSION:
;  $Id$
;
; AIM:
;  returns nouns (e.g. for creating article titles with titeleize)
;
; PURPOSE:
;  returning nouns
;
; CATEGORY:
;  Help
;
; CALLING SEQUENCE:
;*result = noun()
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
;*>IDL/NASE> for i=0, 5 do print, noun()
;features
;neuron
;nerve cell
;simple cell
;invariance
;brain
;
; SEE ALSO:
;  <A>titeleize</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


Function noun;;;; not yet: , categories, exclude (prevent repetitions)
Common Common_Random, seed
   
   ;; categories:
   ;;
   ;; 0: neuro
   
   n_categories = 1
   
   nouns = ptrarr(n_categories, /Allocate_Heap)
   
   *(nouns[0]) = ["neuron", "spike", "nerve cell", "brain", "monkey", $
                  "barn owl", "human", "ferret", "cat", "ganglion cell", $
                  "simple cell", "complex cell", "synapse", "tea cup", "journal", $
                  "scientist", "wave", "inhibition", "context", "feature", "invariance"]
   
   
   
   cat = 0;; will be chosen randomly later
   
   n = n_elements(*(nouns[cat]))
   i = n*randomu(seed)
   
   result = (*(nouns[cat]))[i]

   ptr_free, nouns

   return,  result

End
