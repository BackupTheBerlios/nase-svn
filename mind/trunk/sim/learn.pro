;+
; NAME:                Learn
;
; PURPOSE:             Learns connections in an arbitrary network. This routine
;                      is called from SIM. It makes nearly no sense to call it directly.
;
; CATEGORY:            MIND SIM INTERNAL
;
; COMMON BLOCKS:
;                      ATTENTION
;                      SH_LEARN  : shares sheets with INITLEARN
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#INITLEARN>initlearn</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#FREELEARN>freelearn</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2000/01/26 16:19:51  alshaikh
;           print,message -> console
;
;     Revision 1.3  2000/01/26 10:42:29  alshaikh
;          + new learning rule : EXTERN
;          + EXTERN still doesn't work with delayed connections
;
;     Revision 1.2  2000/01/14 11:02:02  saam
;           changed dw structures to anonymous/handles
;
;     Revision 1.1  1999/12/10 09:36:48  saam
;           * hope these are all routines needed
;           * no test, yet
;
;
;-

;
;            ABS_RATE      : 0.0d  ,$ ; learning rate
;            ABS_LEARN     : 0.0d  ,$ ; if membrane potential >= L_ABS_LEARN                  then w=w+L_ABS_RATE
;            ABS_DELEARN   : 0.0d  ,$ ; if L_ABS_DELEARN <= membrane potential <= L_ABS_LEARN then w=w-L_ABS_RATE 
;            ABS_MAXW      : 0.0d   } ; if w > L_ABS_MAXW then w=L_ABS_MAXW
;
; COMMON TAGS:
; ------------
;               RULE    : learning rule specified below ['NONE', 'LHLP2', 'LHLP4', 'BIPOO']
;               WIN     : learning window type          ['NONE', 'ALPHA', 'EXPO']
;               CONTROL : learning control system       ['NONE', 'MEANWEIGHTS']
;               DW      : index to Matrix to be learned
;               RECCON  : check,plot & save convergence of learning every RECCON's timestep
;               SHOWW   : showweights every SHOWW ms
;               ZOOM    : showweights zoom
;               TERM    : terminate if a weight exceeds TERM
;               NOMERCY : show no mercy after NOMERCY ms (0: disabled)
;
; RULE='LHLP2':
; -------------
;               alpha : delearning ratio
;               gamma : maximal weight change per learning event
; RULE='LHLP4':
; -------------
; RULE='BIPOO':
; -------------
;               v_pre    : amplification &
;               tau_pre  : time constant for postsynaptic spike precedes presynaptic spike (delearn)
;               v_post   : amplification &
;               tau_post : time constant for presynaptic spike precedes postsynaptic spike (learn)
;
; RULE='EXTERN':
; --------------
;        Definition-Syntax :
;                 RULE  : 'EXTERN'  ,$
;                 INIT  : {$
;                          NAME   :'e.g. lrinithebblp2' ,$
;                          PARAMS : {EXPO : [1.0,10.0] } }, $   ; directly passed to lrinithebblp2
;                 STEP   : { $
;                          NAME : 'e.g. lrprochebblp2' ,$
;                          PARAMS: {void : 0} },$               ; directly passed to lrprochebblp2
;                 EXEC   : { $
;                          NAME : 'e.g. lrhebblp2' ,$           ;   "         "
;                          PARAMS : { $
;                                     ALPHA : 0.25 ,$
;                                     GAMMA : 0.0001, $
;                                     MAXIMUM : 0.003 $
;                                    } $
;                          } ,$
;                         ...
;  






;             
; WIN='ALPHA':
; ------------
;               tau_inc : time constant for increase in ms
;               tau_dec : time constant for decrease in ms
; WIN='EXPO':
; -----------
;               tau     : time constant for decrease in ms
;
;
; CONTROL='MEANWEIGHTS': (at the moment only for RULE='BIPOO')
; ----------------------       
;               diff    : differential control (REGLER)
;               int     : integral control (REGLER)
;               prop    : proportional control (REGLER)
;               change  : factor between correction calculated by REGLER and delearning change

PRO Learn, L, CON, _LS, t, _EXTRA=e

   COMMON ATTENTION
   COMMON SH_LEARN
   COMMON terminal,output
   
   Handle_Value, _LS, LS, /NO_COPY
   curDW = Handle_Val(P.DWW(LS.DW))


   CASE LS.TYPE OF
      1 : BEGIN
         TotalRecall, LS._WIN, CON(LS.DW)
         LearnHebbLP2, CON(LS.DW), LS._win, Target_CL=L(curDW.TARGET), ALPHA=LS.alpha, GAMMA=LS.gamma
      END
      2 : BEGIN
         TotalRecall, LS._WIN, CON(LS.DW)
         LearnHebbLP4, CON(LS.DW), LS._win, Target_CL=L(curDW.TARGET), ALPHA=LS.alpha, GAMMA=LS.gamma
      END
      3 : BEGIN
         TotalPrecall, LS._win, CON(LS.DW), L(curDW.TARGET)
         LearnBiPoo, CON(LS.DW), LS._win, LS._win2
      END

      4 : BEGIN 
         name_of_step = LS.step.name
         step_params = LS.step.params
         name_of_exec = LS.exec.name
         exec_params = LS.exec.params
         CALL_PROCEDURE,name_of_step,win=LS._win,con=CON(LS.DW),target_l=L(curDW.TARGET),_EXTRA=step_params
         CALL_PROCEDURE,name_of_exec,CON=CON(LS.DW),WIN=LS._win,TARGET_CL=L(curDW.TARGET) ,_EXTRA=exec_params


         END 


      ELSE: Message, 'this shouldnt happen'
   END


   ;----------> SHOWWEIGHTS IF WANTED
   IF (t MOD LS.SHOWW) EQ 0 THEN BEGIN
       OpenSheet, LEARN_2(LS.index)
      ShowWeights, CON(LS.DW), /TOS, /NOWIN, ZOOM=LS.ZOOM
      CloseSheet, LEARN_2(LS.index)
   END


   IF ((t MOD LS.RECCON) EQ 0) THEN BEGIN
      ;------------> DETERMINE MAX&MEAN OF LEARNING MATRICES
      Maxw  = MaxWeight(CON(LS.DW))
      MeanW = MeanWeight(CON(LS.DW))
      OpenSheet, LEARN_1, LS.index
      Plotcilloscope, LS._PCW, [MeanW, MaxW]
      CloseSheet, LEARN_1, LS.index


      ;-------------> LOOP CONTROL
      CASE LS.CTYPE OF 
         1: BEGIN
            FUCK = LS._CONTROLLER
            correction = Regler(FUCK, MeanW, LS._CONT_MW, D=-LS.DIFF, P=LS.PROP, I=LS.INT)
            LS._CONTROLLER = FUCK
            CASE LS.TYPE OF
               3: BEGIN
                  LS._win2(2:LS._win2(0)+2) = LS._win2(2:LS._win2(0)+2) + LS.CHANGE*correction
                  OpenSheet, LEARN_4(LS.index)
                  Plotcilloscope, LS._PCLC, [ LS._CONT_MW-MeanW, correction]
                  CloseSheet, LEARN_4(LS.index)
                  OpenSheet, LEARN_3(LS.index)
                  xax=indgen(n_elements(LS._WIN2)-2)-LS._WIN2(0)-1
                  plot, xax, LS._WIN2(2:n_elements(LS._WIN2)-2), XSTYLE=1, TITLE='Learning '+curDW.NAME+': BiPoo'
                  CloseSheet, LEARN_3(LS.index)
               END
            END
         END
         ELSE: dummy = 1
      END



      ;-------------> RECORD MATRIX PROPERTIES
      DM = LS._distMat
      Handle_Value, DM, tmp, /NO_COPY
      dist = TwoDimEuklidNorm(Weights(CON(LS.index))-tmp)
      dummy = CamCord(LS._vidDist, [DOUBLE(dist)/DOUBLE(LS.RECCON), MeanW, MaxW])
      Handle_Value, DM, Weights(CON(LS.index)), /SET
      LS._distMAT = DM
   END

   Handle_Value, _LS, LS, /NO_COPY, /SET
END
