;+
; NAME:                DForEach
;
; PURPOSE:             Demo for FOREACH-function. This illustrates how foreach is used to
;                      vary two independent variables in the structure P.
;                       
; CATEGORY:            MIND DEMO
;
; CALLING SEQUENCE:    DForEach, [keyword list]
;
; KEYWORD PARAMETERS:  ============================
;                       Keywords passed to FOREACH
;                      ============================
;
; COMMON BLOCKS:       ATTENTION
;
; EXAMPLE:             DForEach, /W
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FOREACH>foreach</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/12/08 14:39:11  saam
;           a very simple demo for foreach
;
;
;-
PRO DForEach, _EXTRA=e

   COMMON ATTENTION, AP, P
   
   AP = { xxx   : 0.0                 ,$
          yyy   : 0.0                 ,$
          file  : ""                  ,$
          __TN0 : "yyy"               ,$
          __TV0 : [0, 1, 2, 3]        ,$
          __TN1 : "xxx"               ,$
          __TV1 : [1.5, 2., 3., 7.]    $
        }
   P = AP

   iter = ForEach("OUT", _EXTRA=e)

END


PRO OUT, _EXTRA=e

   COMMON ATTENTION, AP, P

   print, "filename: ", P.file

END

