;+
; NAME:               FakeEach
;
; AIM:                fakes a loop, if you don't have one
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
; CALLING SEQUENCE:   FakeEach [,SKEL=skel]
;
; KEYWORD PARAMETERS: SKEL: iteration separator for filenames (default '_')
; 
; COMMON BLOCKS:      ATTENTION
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FOREACH>foreach</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2000/09/29 08:10:28  saam
;     added the AIM tag
;
;     Revision 1.3  2000/06/08 10:29:20  saam
;           + new keyword SKEL added
;
;     Revision 1.2  2000/04/12 13:30:44  saam
;           added the initialization of P.FILE and P.OFILE
;           here, so it is not in the master deffile any more.
;
;     Revision 1.1  1999/12/21 08:56:25  saam
;           nothing to comment
;
;
;-
PRO FakeEach, SKEL=skel
   
   COMMON ATTENTION

   IF ExtraSet(AP.SIMULATION, 'SKEL') THEN Default, skel, AP.SIMULATION.skel ELSE Default, skel, '_'
   Spawn, 'pwd', WorkDir
   WorkDir = WorkDir(0)
   AP.OFile = RealFileName(WorkDir+'/'+AP.SIMULATION.ver+'/')
   AP.File = RealFileName(WorkDir+'/'+AP.SIMULATION.ver+'/')

   P = AP
   P.file = Str(AP.FILE+skel)

END
