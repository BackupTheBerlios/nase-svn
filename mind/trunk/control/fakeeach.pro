;+
; NAME:
;  FakeEach
;
; VERSION:
;  $Id$
;
; AIM:
;  Prepares a MIND simulation and fakes a loop if you don't have one.
;
; PURPOSE:
;  Nearly all MIND-routines use the <A>ForEach</A>-construction to
;  allow the handling of loops. Sometimes you don't have loops but
;  your routines still rely on the <A>ForEach</A>-construct to be
;  properly initialized. Then simply call <*>FakeEach</*> (for example
;  in your master file, after defining all central
;  structures). <*>FakeEach</*> will then set the working directory
;  and the <*>P</*> structure properly. It will also add the string
;  supplied in <*>SIMULATION.skel</*> to the names of all files used
;  to record the simulation results.
;
; CATEGORY:
;  ExecutionControl
;  MIND
;  Startup
;  Simulation
;
; CALLING SEQUENCE:
;  FakeEach
; 
; COMMON BLOCKS:
;  ATTENTION
;
; SEE ALSO:
;  <A>ForEach</A>, <A>Sim</A>.
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  2000/11/30 18:12:22  thiel
;         Removed SKEL and SEP from the documentation and added hint
;         to use SIMULATION.skel/sep instead.
;
;     Revision 1.5  2000/11/19 14:41:58  saam
;     added defualt SKEL as _
;
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



PRO FakeEach, SKEL=skel
   
; The following keyword has been removed from the documentation
; because it should be defined in the SIMULATION structure.
;  SKEL  :: string added to filename after iteration info (default '_')

   COMMON ATTENTION
   
   Default, SKEL, "_"
   IF ExtraSet(AP.SIMULATION, 'SKEL') THEN Default, skel, AP.SIMULATION.skel ELSE Default, skel, '_'
   Spawn, 'pwd', WorkDir
   WorkDir = WorkDir(0)
   AP.OFile = RealFileName(WorkDir+'/'+AP.SIMULATION.ver+'/')
   AP.File = RealFileName(WorkDir+'/'+AP.SIMULATION.ver+'/')

   P = AP
   P.file = Str(AP.FILE+skel)

END
