;+
; NAME:               FakeEach
;
; PURPOSE:            Nearly all MIND-routines use the foreach-construction to allow
;                     the handling of loops. Sometimes you don't have loops but your 
;                     routines still rely on the foreach-construct to be properly initialized.
;                     Then simply call FakeEach (for example in your master file, after 
;                     defining all central structures). The default fileskeleton will be
;                     an underscore.
;
; CATEGORY:           MIND CONTROL
;
; CALLING SEQUENCE:   FakeEach
;
; COMMON BLOCKS:      ATTENTION
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FOREACH>foreach</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/12/21 08:56:25  saam
;           nothing to comment
;
;
;-
PRO FakeEach
   
   COMMON ATTENTION

   P = AP
   P.file = StrCompress(AP.FILE+'_', /REMOVE_ALL)

END
