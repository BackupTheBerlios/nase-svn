;+
; NAME:
;  LRTotalPrecall
;
; AIM: MIND wrapper for <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#TOTALPRECALL>TotalPrecall</A>. 
;  
; PURPOSE:
;  This is the MIND version of the routine <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#TOTALPRECALL>TotalPrecall</A>.
;  It can be used as the 'STEP' part of an 'EXTERN'al learning rule
;  that needs to evaluate time differences between pre- and
;  postsynaptic spikes.  
;  
; CATEGORY:
;  MIND / LEARNING ROUTINES
;  
; CALLING SEQUENCE:
;  LRTotalPrecall, WIN=win, CON=con, TARGET_L=target_l
;  
; INPUTS:
;  win: A <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#INITPRECALL>precall</A> structure. 
;  con: A DelayWeigh structure containing connection information. 
;  target_l: Postsynaptic layer of neurons.
;
;  Note that all inputs are provided by the MIND simulation,
;  LRTotalPrecall accepts no additional parameters.
;
; SIDE EFFECTS:
;  The precall structure is changed. (Not actually a side effect but the
;  purpose of the routine.)
;  
; PROCEDURE:
;  Call TotalPrecall with the given parameters.
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
;  <A HREF="#LRINITPRECALL">LRInitPrecall</A>, <A HREF="#LRDELAYS">LRDelays</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/plasticity#TOTALPRECALL>TotalPrecall</A>, 
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



PRO LRTotalPrecall, WIN=win, CON=con, TARGET_L=target_l

   TotalPRecall, win, con, target_l

END
