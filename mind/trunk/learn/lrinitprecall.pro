;+
; NAME:
;  LRInitPrecall
;
; AIM: MIND wrapper for <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#INITPRECALL>InitPrecall</A>.
;  
; PURPOSE:
;  This is the MIND version of the routine <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#INITPRECALL>InitPrecall</A>.
;  It can be used as the 'INIT' part of an 'EXTERN'al learning rule
;  that needs to evaluate time differences between pre- and
;  postsynaptic spikes.  
;  
; CATEGORY:
;  MIND / LEARNING ROUTINES
;  
; CALLING SEQUENCE:
;  win = LRInitPrecall(DW=dw, LW=lw, LEARNFUNC=learnfunc)
;
; INPUTS:
;  dw: A DelayWeigh structure containing connection information.
;  lw: A Layer structure. (This is not used in the call to InitPrecall
;      but has to be present for compatibility.)
;  learnfunc: Array containing the learning function with the
;             following structure:
;             learnfunc=[tmaxpre,tmaxpost,deltapre,deltanull,deltapost]
;             See <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#INITPRECALL>InitPrecall</A> for details.
;
;  Note that dw and lw are provided by the MIND simulation, the only
;  real input the user has to care about is learnfunc.
;
; OUTPUTS:
;  win: A precall structure containing information about pre- and
;       postsynaptic spike timing.
;  
; PROCEDURE:
;  Call InitPrecall with appropriate inputs.
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
; SEE ALSO:
;  <A HREF="#LRTOTALPRECALL">LRTotalPrecall</A>, <A HREF="#LRDELAYS">LRDelays</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#TOTALPRECALL>TotalPrecall</A>, 
;  <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#INITPRECALL>InitPrecall</A>.
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/08/11 13:43:34  thiel
;            A new external learning rule.
;
;



FUNCTION LRInitPrecall, DW=dw, LW=lw, LEARNFUNC=learnfunc

   win = InitPrecall(dw, learnfunc)

   Return, win

END 
