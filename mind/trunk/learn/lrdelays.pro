;+
; NAME:
;  LRDelays
;
; AIM: MIND wrapper for <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity/#LEARNDELAYS>LearnDelays</A>. 
;  
; PURPOSE:
;  This is the MIND version of the routine <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity/#LEARNDELAYS>LearnDelays</A>.
;  It can be used as the 'EXEC' part of an 'EXTERN'al learning rule.
;  It evaluates time differences between pre- and postsynaptic spikes
;  as a basis for changing conduction delays between neurons.
;  
; CATEGORY:
;  MIND / LEARNING ROUTINES
;  
; CALLING SEQUENCE:
;  LRDelays, CON=con,WIN=win,LEARNFUNC=learnfunc,_EXTRA=_extra
;  
; INPUTS:
;  con: A DelayWeigh structure containing connection information. 
;  win: A <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#INITPRECALL>precall</A> structure. 
;  learnfunc: Array containing the learning function with the
;             following structure:
;             learnfunc=[tmaxpre,tmaxpost,deltapre,deltanull,deltapost]
;             See <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity/#INITPRECALL>InitPrecall</A> for details.
;
;  Note that con, win and _extra are provided by the MIND simulation,
;  the only real input the user has to care about is learnfunc.
;  
; PROCEDURE:
;  Call Learndelays.
;  
; EXAMPLE:
;  This is a possible LEARNW entry for delay learning in a file
;  describing a MIND simulation:
;
;   LEARNW(0) = Handle_Create(!MH, $
;      VALUE={INFO    :  'LEARN' ,$
;             INDEX   :   0      ,$
;             DW      :   0      ,$
;             RULE  : 'EXTERN'  ,$
;             INIT  : {NAME   :'lrinitprecall', $
;                      PARAMS : {LEARNFUNC : learnfunction}}, $
;             STEP  : {NAME : 'lrtotalprecall' ,$
;                      PARAMS : {void : 0} },$
;             EXEC  : {NAME : 'lrdelays' ,$
;                      PARAMS : {LEARNFUNC : learnfunction}} ,$
;             FREE  : {NAME : 'freerecall' ,$
;                      PARAMS : {void:0}} ,$
;             RECCON  : 10, $ 
;             SHOWW   : 100, $
;             DELAYS  : 1, $ 
;             ZOOM    : 10, $ 
;             NOMERCY :   0})
;  
;  
; SEE ALSO:
;  <A HREF="#LRINITPRECALL">LRInitPrecall</A>, <A HREF="#LRTOTALPRECALL">LRTotalPrecall</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity/#TOTALPRECALL>TotalPrecall</A>, 
;  <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity/#INITPRECALL>InitPrecall</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity/#LEARNDELAYS>LearnDelays</A>.
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  2000/09/15 15:20:05  thiel
;            Last SHUTUP removed from header.
;
;        Revision 1.3  2000/09/15 15:18:49  thiel
;            Hyperlinks & header updated.
;
;        Revision 1.2  2000/09/15 15:17:03  thiel
;            SHUTUP-Keyword removed.
;
;        Revision 1.1  2000/08/11 13:43:34  thiel
;            A new external learning rule.
;
;

PRO LRDelays, CON=con, WIN=win, LEARNFUNC=learnfunc $
              , _EXTRA=_extra


   LearnDelays, CON, WIN, learnfunc


END 
