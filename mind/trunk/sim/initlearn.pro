;+
; NAME:                InitLearn
;
; PURPOSE:             Prepares data structures for learning of connections. This routine
;                      is called from SIM. It makes nearly no sense to call it directly.
;
; CATEGORY:            MIND SIM INTERNAL
;
; COMMON BLOCKS:
;                      ATTENTION
;                      SH_LEARN  : shares sheets with LEARN
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#LEARN>learn</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#FREELEARN>freelearn</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.12  2000/01/28 15:16:44  saam
;           changend console call by putting the console
;           data from the common block into the ap structure
;
;     Revision 1.11  2000/01/28 14:29:27  alshaikh
;           fixed some /nographic-bugs
;
;     Revision 1.10  2000/01/27 17:47:56  alshaikh
;           new console-syntax
;
;     Revision 1.9  2000/01/27 10:49:42  saam
;           some calls of console were broken
;
;     Revision 1.8  2000/01/26 16:19:50  alshaikh
;           print,message -> console
;
;     Revision 1.7  2000/01/26 10:42:29  alshaikh
;          + new learning rule : EXTERN
;          + EXTERN still doesn't work with delayed connections
;
;     Revision 1.6  2000/01/26 10:02:26  alshaikh
;           bugfix
;
;     Revision 1.5  2000/01/26 09:58:24  alshaikh
;           + now initlearn is only called ONCE by sim
;           + allows multiple SHOWWEIGHTS-sheets
;
;     Revision 1.4  2000/01/20 14:34:43  saam
;           forgot to erase a debugging stop
;
;     Revision 1.3  2000/01/19 17:16:12  saam
;           + handles learning of non-delay weight matrices
;             for alpha learning (all other cases should be
;             handled equally)
;
;     Revision 1.2  2000/01/14 11:02:01  saam
;           changed dw structures to anonymous/handles
;
;     Revision 1.1  1999/12/10 09:36:47  saam
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


PRO InitLearn, MaxWin,_CON, _LS, _EXTRA=e
   
   Default, MODE , 1
   
   COMMON ATTENTION
   COMMON SH_LEARN, LEARNwins, LEARN_1, LEARN_2, LEARN_3, LEARN_4

   On_Error, 2

   IF ExtraSet(e, 'NEWWIN') THEN LEARNwins = 0

   IF (SIZE(LEARNwins))(1) EQ 0 THEN BEGIN

      ;LEARN_1 = LonArr(MaxWin)
      ;LEARN_1 = LEARN_1 - 1


      LEARN_2 = LonArr(MaxWin)
      LEARN_2 = LEARN_2 - 1
      
      LEARN_3 = LonArr(MaxWin)
      LEARN_3 = LEARN_3 - 1
      
      LEARN_4 = LonArr(MaxWin)
      LEARN_4 = LEARN_4 - 1
   END 
   
  
  FOR LLoop=0, MaxWin-1 DO BEGIN   ; Layer-Loop
  
     Handle_Value, _LS(LLoop), LS, /NO_COPY
     TestInfo,LS,'LEARN'
  
      
            
   curDW = Handle_Val(P.DWW(LS.DW))

   IF NOT ExtraSet(LS, 'RULE')  THEN console,P.CON, 'tag RULE undefined!',/fatal
   IF NOT ExtraSet(LS, 'DW')    THEN console,P.CON, 'tag DW undefined!',/fatal
   IF NOT ExtraSet(LS, 'INDEX') THEN console,P.CON, 'tag INDEX undefined!',/fatal
   ;Default, MaxWin, 1

  

   ;----->
   ;-----> ORGANIZE THE SHEETS
   ;----->
  
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      LEARN_1= DefineSheet(/NULL, MULTI=[MaxWin,MaxWin,1])
      IF (LS.SHOWW NE 0) THEN LEARN_2(LS.index) = DefineSheet(/NULL)
      LEARN_3(LS.index) = DefineSheet(/NULL)
      LEARN_4(LS.index) = DefineSheet(/NULL)
      
      LEARNwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      LEARN_1 = DefineSheet(/NULL)
      IF (LS.SHOWW NE 0) THEN LEARN_2(LS.index) = DefineSheet(/NULL)
      LEARN_3(LS.index) = DefineSheet(/NULL)
      LEARN_4(LS.index) = DefineSheet(/NULL)
      LEARNwins = 0
   END ELSE BEGIN
   

     IF (SIZE(LEARNwins))(1) EQ 0 THEN BEGIN

; initialize weight-watchers    
        IF LLoop EQ 0 THEN begin
           IF MaxWin GE 1 THEN LEARN_1 = DefineSheet(/WINDOW, XSIZE=400, YSIZE=200, MULTI=[MaxWin,MaxWin,1], TITLE='Weight Watchers')
        END 
; --------------------------

; initialize showweights-sheets
        IF (LS.SHOWW NE 0) THEN BEGIN
           width  = LS.ZOOM*LayerWidth(_CON(LS.DW), /TARGET)*(LayerWidth(_CON(LS.DW), /SOURCE)) + 50
           height = LS.ZOOM*LayerHeight(_CON(LS.DW), /TARGET)*(LayerHeight(_CON(LS.DW), /SOURCE)) + 50
           LEARN_2(LS.index) = DefineSheet(/Window, XDRAWSIZE=width, YDRAWSIZE=height, $
                                            XSIZE=MIN([width,height]), YSIZE=MIN([width,height]), $
                                            TITLE=curDW.NAME)

        END
; ------------------------------

        LEARN_3(LS.index) = DefineSheet(/Window, XSIZE=300, YSIZE=200, TITLE=curDW.NAME)
        LEARN_4(LS.index) = DefineSheet(/Window, XSIZE=300, YSIZE=200, TITLE='Loop Control'+curDW.NAME)
      END
   END




   learningRule = ['NONE', 'LHLP2', 'ABS', 'BIPOO','EXTERN']
;                     0       1       2       3 
   learningWindow = ['NONE', 'ALPHA', 'EXPO']
;                       0       1        2 
   controlType = ['NONE', 'MEANWEIGHTS']
;                   0           1

   IF NOT ExtraSet(LS, 'RULE')    THEN lRule = 0  ELSE lRule = (WHERE(STRUPCASE(LS.RULE) EQ learningRule  ,c))(0)
   IF NOT ExtraSet(LS, 'WIN')     THEN lWin = 0   ELSE lWin  = (WHERE(STRUPCASE(LS.WIN)  EQ learningWindow,c))(0)
   IF NOT ExtraSet(LS, 'CONTROL') THEN cType = 0  ELSE cType = (WHERE(STRUPCASE(LS.CONTROL) EQ controlType,c))(0)
   




   ;----->
   ;-----> INIT LEARNING STRUCTURES
   ;----->
   curSLayer = Handle_Val(P.LW(curDW.SOURCE))
   curTLayer = Handle_Val(P.LW(curDW.TARGET))
   console, P.CON, 'LEARNING: '+curSLayer.NAME+' -> '+curTLayer.NAME+' with '+ LS.RULE,/msg


   ;determine if correpsonding DW is delayed or not, cause this changes the call of initrecall
   IF INFO(_CON(0)) EQ 'SDW_WEIGHT' THEN delay = 0 ELSE delay = 1

;---------------------------------
   IF lRule EQ 4 THEN BEGIN 
      temp1 =  LS.INIT
      name = temp1.NAME
      params = temp1.PARAMS
      win = CALL_FUNCTION(name,LW=P.LW(curDW.SOURCE),_EXTRA=params)
      SetTag, LS, 'TYPE', lrule
      SetTag, LS, '_WIN', win
      END ELSE BEGIN 

;---------------------------------
  IF lRule EQ 0 THEN BEGIN
      IL = {TYPE : 0} ; do nothing at all
   END ELSE IF InSet(lRule, [1,2]) THEN BEGIN
      CASE lWin OF 
         1: BEGIN; ALPHA
            console, P.CON, 'LEARNWIN: ALPHA, '+ STR(LS.tau_inc)+ ' ms, '+ STR(LS.tau_dec)+' ms',/msg 
            IF delay THEN win = InitRecall(_CON(LS.DW), ALPHA=[1.0, LS.tau_inc, LS.tau_dec], SAMPLEPERIOD=P.SIMULATION.SAMPLE) $
             ELSE win = InitRecall(P.LW(curDW.SOURCE), ALPHA=[1.0, LS.tau_inc, LS.tau_dec], SAMPLEPERIOD=P.SIMULATION.SAMPLE)
         END
         2: BEGIN; EXPO
            console,P.CON, 'LEARNWIN: EXPO, '+ STR(LS.tau)+ ' ms',/msg
            win = InitRecall(_CON(LS.DW), EXPO =[1.0, LS.tau], SAMPLEPERIOD=P.SIMULATION.SAMPLE)
         END
         ELSE: console,P.CON, 'Learning Window for these learning rule expected!',/fatal
      END
      SetTag, LS, 'TYPE', lrule
      SetTag, LS, '_WIN', win
   END ELSE IF lRule EQ 3 THEN BEGIN
      IF NOT ExtraSet(LS, 'V_PRE') THEN BEGIN
         LW = InitLearnBiPoo(postv=LS.v_post, pretau=LS.tau_pre, posttau=LS.tau_post, SAMPLE=P.SIMULATION.SAMPLE, /PREBAL)
         console, P.CON, 'LEARN: BIPOO, delearn, tau='+ STR(LS.tau_pre)+ ' ms, learn, '+ STR(LS.v_post)+ '  '+ STR(LS.tau_post)+ ', balanced',/msg
      END ELSE IF NOT ExtraSet(LS, 'V_POST') THEN BEGIN
         LW = InitLearnBiPoo(prev=LS.v_pre, pretau=LS.tau_pre, posttau=LS.tau_post, SAMPLE=P.SIMULATION.SAMPLE, /POSTBAL)
         console, P.CON, 'LEARN: BIPOO, delearn, '+ STR(LS.v_pre)+ ',  tau='+ STR(LS.tau_pre)+ ' ms, learn, tau='+ STR(LS.tau_post)+ ', balanced',/msg
      END ELSE BEGIN
         LW = InitLearnBiPoo(postv=LS.v_post, prev=LS.v_pre, pretau=LS.tau_pre, posttau=LS.tau_post, SAMPLE=P.SIMULATION.SAMPLE)
         console, P.CON, 'LEARN: BIPOO, delearn, '+ STR(LS.v_pre)+'  '+STR(LS.tau_pre)+' ms, learn, '+ STR(LS.v_post)+ '  '+ STR(LS.tau_post),/msg
      END
      win = InitPrecall(_CON(LS.DW), LW)
      SetTag, LS, 'TYPE', lrule
      SetTag, LS, '_WIN', win
      SetTag, LS, '_WIN2', LW

      OpenSheet, LEARN_3(LS.index)
      xax=indgen(n_elements(lw)-2)-lw(0)-1
      plot, xax, lw(2:n_elements(lw)-2), XSTYLE=1, TITLE='Learning '+curDW.NAME+': BiPoo'
      CloseSheet, LEARN_3(LS.index)
   END ELSE Message, 'unknown Learning Rule'

ENDELSE  

   

   ;----->
   ;-----> CONTROL DEVELOPMENT OF WEIGHTS
   ;----->
   SetTag, LS, 'CTYPE', cType
   CASE cTYPE OF 
      1: BEGIN
         reg = InitRegler()
         SetTag, LS, '_CONTROLLER', reg
         SetTag, LS, '_CONT_MW', MeanWeight(_CON(LS.DW))
         OpenSheet, LEARN_4(LS.index)
         PCLC = InitPlotcilloscope(TIME=200, RAYS=2, OVERSAMPLING=1./(1000*P.SIMULATION.SAMPLE)/FLOAT(LS.RECCON), TITLE='Loop Control: '+curDW.NAME+'(Error/Corr)')
         CloseSheet, LEARN_4(LS.index)
         SetTag, LS, '_PCLC', PCLC
      END
      ELSE: dummy = 1 ;its only a dummy
   END
   
   
   ;----->
   ;-----> INIT PLOTTING
   ;----->
   OpenSheet, LEARN_1, LS.index
   PCW = InitPlotcilloscope(TIME=200, /NOSCALEYMIN, RAYS=2, OVERSAMPLING=1./(1000*P.SIMULATION.SAMPLE)/FLOAT(LS.RECCON), TITLE='Weight Watch '+curDW.NAME+' (Mean/Maximum)')
   CloseSheet, LEARN_1, LS.index
   SetTag, LS, '_PCW', PCW


   ;----->
   ;-----> INIT RECORDING OF WEIGHT CONVERGENCES
   ;----->
   ExampleFrame =  DblArr(3)
   vidDist = InitVideo( ExampleFrame, TITLE=P.File+'.'+curDW.FILE+'.dist', /SHUTUP, /ZIP )
   SetTag, LS, '_VIDDIST', vidDist
   distMat = Handle_Create(!MH, VALUE=Weights(_CON(LS.DW)))
   SetTag, LS, '_DISTMAT', distMat 


   Handle_Value, _LS(LLoop),LS,/NO_COPY,/SET
   ENDFOR ; LLoop

   LEARNwins = 1
  
END
