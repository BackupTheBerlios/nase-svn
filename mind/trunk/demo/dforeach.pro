;+
; NAME:
;  DForEach
;
; AIM:
;  demo to demonstrate the basic use of the <A>ForEach</A>
; 
; PURPOSE:
;  Demo for FOREACH-function. This illustrates how foreach is used to
;  vary two independent variables in the structure P.
;                       
; CATEGORY:
;  MIND / DEMO ROUTINES
;
; CALLING SEQUENCE:
;  DForEach, [keyword list]
;
; KEYWORD PARAMETERS:
;  All keywords are passed to FOREACH
;
; COMMON BLOCKS:
;  ATTENTION
;
; EXAMPLE:
;  DForEach, /W
;
; SEE ALSO:
;  <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FOREACH>foreach</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2000/09/29 08:10:31  saam
;     added the AIM tag
;
;     Revision 1.3  2000/08/14 14:38:12  thiel
;         Now also uses 'SEP'-keyword.
;
;     Revision 1.2  2000/08/11 10:25:53  thiel
;         Bugfix, SIMULATION-tag wasnt set.
;
;     Revision 1.1  1999/12/08 14:39:11  saam
;           a very simple demo for foreach
;



PRO DForEach, _EXTRA=e

   COMMON ATTENTION, AP, P
   
   AP = { SIMULATION : {VER    : '.', $
                        SKEL : '_skel', $
                        SEP : '_sep', $
                        TIME   : 100l, $
                        SAMPLE : 0.001 },  $
          xxx   : 0.0                 ,$
          yyy   : 0.0                 ,$
          file  : '', $ ; this must be present but is later overwritten
          __TNa : "yyy"               ,$
          __TVa : [0, 1, 2, 3]        ,$
          __TNb : "xxx"               ,$
          __TVb : [1.5, 2., 3., 7.]    $
        }
   P = AP

   iter = ForEach("OUT", _EXTRA=e)

END


PRO OUT, _EXTRA=e

   COMMON ATTENTION, AP, P

   Console, " filename: "+P.file

END

