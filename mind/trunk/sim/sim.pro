;+
; NAME: 
;  Sim
;
; VERSION:
;  $Id$
;
; AIM:
;  Simulate network topology, display variables and record results. 
;
; PURPOSE: 
;  Simulates a defined network topology with variable input,
;  connectionism, learning. Displays relevant simulation variables and
;  records the results.
;
; CATEGORY:
;  Graphic
;  MIND
;  Simulation
;
; CALLING SEQUENCE: 
;*  Sim [,/WSTOP][,/NOGRAPHIC]
;
; INPUT KEYWORDS: 
;  WSTOP:: Stop after weight initialization; DWs are in CON(i), i=0..n-1
;  NOGRAPHIC:: Dont show any graphics. (Is considerably faster!)
;
; COMMON BLOCKS:
;  ATTENTION
;  SH_SIM
;  COMMON_Random
;
; EXAMPLE:
;* DSim & Sim
;
; SEE ALSO: 
;  <A>InitInput</A>, <A>Input</A>, <A>InitWeights</A>, <A>ForEach</A>  
;-



PRO _SIM, WSTOP=WSTOP, _EXTRA=e

   COMMON SH_SIM, SIMwins, CSIM_1, CSIM_2, CSIM_3, CSIM_4, CSIM_5, CSIM_6, CSIM_7, CSIM_8
   COMMON COMMON_Random, seed
   COMMON ATTENTION



   ;----->
   ;-----> GLOBAL DEFINES
   ;----->
   uclose, /all

   ;; The SIMWins flag is indicating that new definition of window
   ;; sheets is desired. this is the case at the first call of SIM,
   ;; and also after using /NOGRAPHIC to get back the sheets.
   Default, SIMWins, 0 
   
 
   ;; ATTENTION: spohisticated keyword handling! 
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN 
      ;; if NOGRAPHIC is present in EXTRA, theres two possibilities:
      IF e.nographic THEN BEGIN
         ;; NOGRAPHIC eq TRUE => user wants no graphic 
         graphic = 0
      ENDIF ELSE BEGIN
         ;; NOGRAPHIC eq FALSE => user wants graphic
         ;; as other routines only check for presence of "NOGRAPHIC"
         ;; in EXTRA, the tag has to be deleted to ensure that those
         ;; routines produce graphics.
         graphic = 1
         Deltag, e, 'NOGRAPHIC'
      ENDELSE
   ENDIF ELSE BEGIN
      ;; if NOGRAPHIC is not present in EXTRA, the user wants graphic
      graphic = 1
   ENDELSE
 
   

   Lmax  = N_Elements(P.LW)-1
   IF ExtraSet(P, "DWW")    THEN DWmax = N_Elements(P.DWW)-1    ELSE DWmax=-1
   IF ExtraSet(P, "NWATCH") THEN NWmax = N_Elements(P.NWATCH)-1 ELSE NWmax=-1


   ;----->
   ;-----> COMPLETE COMMAND SYNTAX
   ;----->
   OS = 1./(1000*P.SIMULATION.SAMPLE)


   ;-----> DETERMINE LEARNING STATUS
   IF ExtraSet(P, 'LEARNW') THEN LDWmax = N_Elements(P.LearnW)-1 ELSE LDWmax = -1
   IF LDWmax EQ -1 THEN LEARN = 0 ELSE LEARN = 1  ;;; boolearn showing if there is anything to be learned
  
   IF LEARN THEN BEGIN
      ZOOM = LonArr(LDWmax+1)
      FOR i=0,LDWmax DO BEGIN
         tmp = Handle_Val(P.LearnW(i))
;         TERM(i) = tmp.term
         ZOOM(i) = tmp.zoom
      END
   END



   ;-------------> DETERMINE SPIKERASTER STATUS
   TSSCloutMax = -1
   FOR i=0, Lmax DO BEGIN
      curLayer = Handle_Val(P.LW(i))
      IF curLayer.LEX.SPIKERASTER THEN BEGIN
         IF SET(TSSCl) THEN BEGIN 
            TSSCl = [TSSCl, i]
         END ELSE BEGIN
            TSSCl = i
         END
         TSSCloutMax = TSSCloutMax+1
      END
   END


   ;-------------> INIT LAYERS
   L = LonArr(Lmax+1)
   FOR i=0, Lmax DO BEGIN
      curLayer = Handle_Val(P.LW(i))
      tmp = curLayer.NPW

      NAME = tmp.INFO         ; name of init-routine
      deltag, tmp, 'INFO'     ; remove this name from structure
      tmp2 =  CALL_FUNCTION(NAME,_EXTRA=tmp)

      L(i) = InitLayer(WIDTH=curLayer.w, HEIGHT=curLayer.h, TYPE = tmp2)
      console, P.CON, 'LAYER: '+curLayer.NAME+ ', '+STR(curLayer.w)+'x'+ STR(curLayer.h)+', TYPE :'+NAME
   END

   ;-------------> INIT WEIGHTS
   IF DWmax GE 0 THEN CON = LonArr(DWmax+1)
   FOR i=0, DWmax DO BEGIN
       curDW = Handle_Val((P.DWW)(i))
       CON(i) = InitWeights(curDW)
   END
   IF Keyword_Set(WSTOP) THEN stop

   console,P.CON,'Initializing simulation...'


   IF NOT graphic THEN BEGIN
      IF TSSCloutmax GE 0 THEN $
       CSIM_1  = DefineSheet(/NULL, MULTI=[TSSCloutmax+1,1,TSSCloutmax])
      IF Lmax GE 0 THEN $
       CSIM_4 = DefineSheet(/NULL, MULTI=[Lmax+1,Lmax+1,1])
      IF LDWmax GE 0 THEN $
       CSIM_5 = DefineSheet(/NULL, MULTI=[LDWmax+1,LDWmax+1,1])
      IF NWmax GE 0 THEN $
       CSIM_6 = DefineSheet(/NULL, MULTI=[NWmax+1,NWmax+1,1])
      SIMwins = 0
   ENDIF ELSE IF ExtraSet(e, 'PS') THEN BEGIN 
      CSIM_1 = DefineSheet(/NULL)
      CSIM_4  = DefineSheet(/NULL)
      CSIM_5  = DefineSheet(/NULL)
      CSIM_6  = DefineSheet(/NULL)
      SIMwins = 0
   ENDIF ELSE BEGIN
      IF SIMwins EQ 0 THEN BEGIN
         IF TSSCloutmax GE 0 THEN $
          CSIM_1 = DefineSheet(/Window, XSIZE=600, YSIZE=200 $
                               , MULTI=[TSSCloutmax+1,1,TSSCloutmax+1] $
                               , TITLE='Spikeraster')
         IF Lmax GE 0 THEN $
          CSIM_4 = DefineSheet(/Window, XSIZE=400, YSIZE=200 $
                               , MULTI=[Lmax+1,Lmax+1,1], TITLE='MUAs')
         IF NWmax GE 0 THEN $
          CSIM_6 = DefineSheet(/WINDOW, XSIZE=400, YSIZE=200 $
                               , MULTI=[NWmax+1,NWmax+1,1] $
                               , TITLE='Neuron Watchers')
         SIMwins = 1
      ENDIF 
   ENDELSE
   


   IF graphic THEN BEGIN
       ;---------------> INIT WATCHING OF NEURONS
       IF NWmax GE 0 THEN PCWN = LonArr(NWmax+1)
       FOR i=0, NWmax DO BEGIN
           OpenSheet, CSIM_6, i
           !P.Multi = [0,0,1,0,0]
           WN = Handle_Val(P.NWATCH(i))
           curLayer = Handle_Val(P.LW(WN.L))
           PCWN(i) = InitPlotcilloscope(TIME=200, /NOSCALEYMIN, RAYS=3, OVERSAMPLING=os, TITLE='Watch '+curLayer.NAME+' ('+Str(WN.w)+','+Str(WN.h)+')')
           CloseSheet, CSIM_6, i
       END

      ;-------------> INIT WATCHING OF LAYERS
      FOR i=0, TSSCloutMax DO BEGIN
         curLayer = Handle_Val(P.LW(i))
         tLayer = Handle_Val(P.LW(TSSCL(i)))
         OpenSheet, CSIM_1, i
         tmp = InitTrainspottingscope(OVERSAMPLING=os, NEURONS=tLayer.w*tLayer.h, TITLE = tLayer.NAME)
         IF SET(TSSClout) THEN TSSClout = [TSSClout, tmp] ELSE TSSClout = tmp
         CloseSheet, CSIM_1, i
      END


      ;-------------> INIT ANALAYERS
      ANALmax = -1
      FOR i=0,Lmax DO BEGIN
         curLayer = Handle_Val(P.LW(i))
         IF curLayer.LEX.ANALYZE THEN BEGIN
            IF Set(ANAL) THEN ANAL = [ANAL, i] ELSE ANAL = i
            ANALmax = ANALmax+1
         END
      END
      IF ANALMax GE 0 THEN ANACL = LonArr(ANALmax+1)
      FOR i=0, ANALmax DO BEGIN
         curLayer = Handle_Val(P.LW(ANAL(i)))
         AnaCL(i) = InitAnalayer(curLayer.w, curLayer.h, TITLE=curLayer.NAME, STRETCH=10, OVERSAMPLING=os, _EXTRA=e)
      END

   
      ;--------------> INIT WATCH MUA
      PCMUA = LonArr(Lmax+1)
      FOR i=0,Lmax DO BEGIN
         curLayer = Handle_Val(P.LW(i))
         OpenSheet, CSIM_4, i
         PCMUA(i) = InitPlotcilloscope(TIME=500e, /NOSCALEYMIN, YMIN=0, YMAX=1, OVERSAMPLING=os, TITLE='MUA: '+curLayer.NAME)
         CloseSheet, CSIM_4, i
      END
   END ;graphic

   ;-------------> INIT RECORDING OF SPIKES & MEMBRANE POTENTIALS
   Vid_O   = LonArr(Lmax+1)
   Vid_M   = LonArr(Lmax+1)
   Vid_MUA = LonArr(Lmax+1)
   Vid_LFP = LonArr(Lmax+1)

   SelVidO = BytArr(Lmax+1)
   SelVidM = BytArr(Lmax+1)
   FOR i=0,Lmax DO BEGIN
      Handle_Value, P.LW(i), curLayer, /NO_COPY
      REC = curLayer.LEX

      ; ensure REC_LFP is defined
      IF NOT ExtraSet(REC, "REC_LFP") THEN BEGIN
          SetTag, REC, "REC_LFP", 0
          curLayer.LEX = REC
      END

      IF ((REC.REC_O(1) GT REC.REC_O(0)) AND (REC.REC_O(0) LT P.SIMULATION.TIME)) THEN BEGIN
         IF N_Elements(REC.REC_O) GT 2 THEN BEGIN
            Vid_O(i) = InitVideo( BytArr(N_Elements(REC.REC_O)-2), TITLE=P.File+'.'+curLayer.FILE+'.o.sim', /SHUTUP, /ZIPPED )
            console, P.CON, 'RECORDING: '+curLayer.NAME+' Output from '+STR(REC.REC_O(0))+' to '+STR(REC.REC_O(1))+' ms for '+STR(N_Elements(REC.REC_O)-2)+' neurons'
            SelVidO(i) = N_Elements(REC.REC_O)-2
         END ELSE BEGIN
            Vid_O(i) = InitVideo( BytArr(curLayer.w *curLayer.h), TITLE=P.File+'.'+curLayer.FILE+'.o.sim', /SHUTUP, /ZIPPED )
            console, P.CON,'RECORDING: '+curLayer.NAME+' Output from '+STR(REC.REC_O(0))+' to '+STR(REC.REC_O(1))+' ms'  
         END
      END
      IF ((REC.REC_M(1) GT REC.REC_M(0)) AND (REC.REC_M(0) LT P.SIMULATION.TIME)) THEN BEGIN
          IF N_Elements(REC.REC_M) GT 2 THEN BEGIN
              Vid_M(i) = InitVideo( DblArr(N_Elements(REC.REC_M)-2), TITLE=P.File+'.'+curLayer.FILE+'.o.sim', /SHUTUP, /ZIPPED )
              console,P.CON, 'RECORDING: '+curLayer.NAME+' Membrane from '+STR(REC.REC_M(0))+' to '+STR(REC.REC_M(1))+' ms for '+STR(N_Elements(REC.REC_M)-2)+' neurons'
              SelVidM(i) = N_Elements(REC.REC_M)-2
          END ELSE BEGIN
              Vid_M(i) = InitVideo( DblArr(curLayer.w *curLayer.h), TITLE=P.File+'.'+curLayer.FILE+'.m.sim', /SHUTUP)
              console, P.CON, 'RECORDING: '+curLayer.NAME+' Membrane from '+STR(REC.REC_M(0))+' to '+STR(REC.REC_M(1))+' ms'  
          END
      END
      IF REC.REC_MUA THEN BEGIN
         Vid_MUA(i) = InitVideo( 0l, TITLE=P.File+'.'+curLayer.FILE+'.mua.sim', /SHUTUP)
         console, P.CON, 'RECORDING: '+curLayer.NAME+' MUA'
      END
      IF REC.REC_LFP THEN BEGIN
         Vid_LFP(i) = InitVideo( 0., TITLE=P.File+'.'+curLayer.FILE+'.lfp.sim', /SHUTUP)
         console, P.CON, 'RECORDING: '+curLayer.NAME+' LFP'
      END
      Handle_Value, P.LW(i), curLayer, /NO_COPY, /SET
   END





   ;--------------> INIT INPUT
   INmax = N_Elements(P.INPUT)-1
   IN = LonArr(INmax+1)
   AIN  = StrArr(INmax+1) ; automatic INput
   AIN2 = LonArr(INmax+1) 
   FOR i=0,INmax DO BEGIN
      callstring = ''
      IN(i) = InitInput(L, P.INPUT(i), calls, calll,_EXTRA=e)
      AIN(i) = calls
      AIN2(i) = calll
   END


   ;--------------> INIT LEARNING
   IF Learn THEN InitLearn, LDWmax+1, CON, P.LearnW, _EXTRA=e
   IF Learn THEN InitNormalize, LDWmax+1, CON, P.LearnW, _EXTRA=e

 
   ;--------------> INIT CONNECTION STRUCTURE 
   IF DWmax GE 0 THEN ADW = StrArr(DWmax+1)    ; automatic DW
   FOR i=0, DWmax DO BEGIN
       curDW = Handle_Val((P.DWW)(i))
       ADW(i) = 'InputLayer, '+STR(L(curDW.TARGET))+', '+STR(curDW.SYNAPSE)+'=DelayWeigh(CON('+STR(i)+'), LayerOut(L('+STR(curDW.SOURCE)+')))'
       
       curSLayer = Handle_Val(P.LW(curDW.SOURCE))
       curTLayer = Handle_Val(P.LW(curDW.TARGET))
       console,P.CON,  'CONNECTIONS:  '+ curSLayer.NAME+ ' -> '+ curTLayer.NAME+' via '+ curDW.SYNAPSE+', '+curDW.NAME
   END

   ;--------------> SAVE WEIGHTS BEFORE SIMULATION/LEARNING
   IF Learn THEN BEGIN
       FOR i=0, DWmax DO BEGIN
          curDW = Handle_Val((P.DWW)(i)) 
          UWriteU, P.file+'.'+curDW.FILE+'.ini.dw', SaveDW(CON(i)), /COMPRESS
       END
   END


;------------->
;-------------> MAIN SIMULATION ROUTINE
;------------->
   console,P.CON, 'Starting main simulation loop...'
   console,P.CON, '  '

   FOR _TIME=0l,P.SIMULATION.TIME*os-1 DO BEGIN

      ;-------------> NEW INPUT & PROCEED CONNECTIONS
      FOR i=0, INmax DO BEGIN
         tmp = Create_Struct(AIN(i), Input(L, IN(i)))
         InputLayer, L(AIN2(i)), _EXTRA=tmp
      END
      FOR i=0, DWmax DO BEGIN
         Handle_Value, (P.DWW)(i), curDW, /NO_COPY
         tmp = Create_Struct(curDW.SYNAPSE, DelayWeigh(CON(i), LayerOut(L(curDW.SOURCE))))
         InputLayer, L(curDW.TARGET), _EXTRA=tmp
         Handle_Value, (P.DWW)(i), curDW, /NO_COPY, /SET
      END
      
      ;-------------> LEARN SOMETHING
      FOR i=0, LDWmax DO Learn, L, CON, P.LEARNW(i), _TIME

      ;-------------> Normalize Weights
      FOR i=0, LDWmax DO Normalize, L, CON, P.LEARNW(i), _TIME

      ;;----- Proceed layers
      FOR i=0,Lmax DO ProceedLayer, L(i)


      IF graphic THEN BEGIN
         FOR i=0,TSSCloutmax DO BEGIN
            OpenSheet, CSIM_1, i
            TrainspottingScope, TSSClout(i), LayerOut(L(TSSCl(i)))
            CloseSheet, CSIM_1, i
         ENDFOR
;      END ; graphic



      ;----
      ;----> MAKE A BIG SHOW
      ;----
;      IF graphic THEN BEGIN
         FOR i=0, ANALmax DO AnaLayer, AnaCL(ANAL(i)), L(ANAL(I))
         FOR i=0,Lmax DO BEGIN
            OpenSheet, CSIM_4, i
            Plotcilloscope, PCMUA(i), LayerMUA(L(i))
            CloseSheet, CSIM_4, i
         END


         ;----->  OPERATIONS DONE ANYTIME
         FOR i=0,NWmax DO BEGIN
            OpenSheet, CSIM_6, i
            NW = Handle_Val(P.NWATCH(i))
            LayerData, L(NW.L), FEEDING=f, POTENTIAL=m, THRESHOLD=s
            Plotcilloscope, PCWN(i), [F(NW.h,NW.w), M(NW.h, NW.w) $
                                      , S(NW.h, NW.w)]
            CloseSheet, CSIM_6, i
         END
         
      END ;graphic

      FOR i=0, Lmax DO BEGIN
         curLayer = Handle_Val(P.LW(i))
         REC = curLayer.LEX
         IF ((_TIME GE OS*REC.REC_O(0)) AND (_TIME LT OS*curLayer.LEX.REC_O(1))) THEN BEGIN
            IF SelVidO(i) NE 0 THEN dummy = CamCord( Vid_O(i), (BYTE(LayerSpikes(L(i))))(2:SelVidO(i)+1)) ELSE dummy = CamCord( Vid_O(i), BYTE(LayerSpikes(L(i))))
         END
         IF ((_TIME GE OS*REC.REC_M(0)) AND (_TIME LT OS*curLayer.LEX.REC_M(1)) AND ((_TIME MOD OS) EQ 0)) THEN BEGIN
            LayerData, L(i), POTENTIAL=M
            IF SelVidM(i) NE 0 THEN M = M(2:SelVidM(i)+1)
            dummy = CamCord( Vid_M(i), REFORM(DOUBLE(M), N_Elements(M), /OVERWRITE))
         END
         IF REC.REC_MUA THEN dummy = CamCord( VID_MUA(i), LONG(LayerMUA(L(i))))
         IF REC.REC_LFP THEN BEGIN
             LayerData, L(i), POTENTIAL=m
             dummy = CamCord( VID_LFP(i), FLOAT(TOTAL(m)))             
         END
      END

      ;-----> OPERATIONS DONE IN LEARNING MODE
;      FOR i=0, LDWmax DO BEGIN
;         IF ((t MOD RECCON(i)) EQ 0) THEN BEGIN
;            ;-------------> TERMINATE SIMULATION IF WEIGHTS EXPLODE
;            IF MaxW GT TERM(i) THEN BEGIN
;               t = P.SIMULATION.TIME*OS+1
;               Print,'SIM: weights exploding, terminating simulation'
;            END
;         END
;      END
;     
      IF (_TIME MOD 50 EQ 0 ) THEN consoletime,P.CON, bin=_time, ms= _TIME/os
   END
   console,P.CON, 'Main Simulation Loop done'


   ;-------------> CLOSE VIDEOS
   FOR i=0,Lmax DO BEGIN
      curLayer = Handle_Val(P.LW(i))
      REC = curLayer.LEX
      IF ((REC.REC_O(1) GT REC.REC_O(0)) AND (REC.REC_O(0) LT P.SIMULATION.TIME)) THEN Eject, Vid_O(i), /NOLABEL, /SHUTUP
      IF ((REC.REC_M(1) GT REC.REC_M(0)) AND (REC.REC_M(0) LT P.SIMULATION.TIME)) THEN Eject, Vid_M(i), /NOLABEL, /SHUTUP
      IF REC.REC_MUA THEN Eject, VID_MUA(i), /NOLABEL, /SHUTUP
      IF REC.REC_LFP THEN Eject, VID_LFP(i), /NOLABEL, /SHUTUP
   END
   FOR i=0, DWmax DO BEGIN
      curDW = Handle_Val((P.DWW)(i)) 
      IF ExtraSet(curDW, "FILE") THEN BEGIN
          IF (curDW.FILE NE 'NULL') THEN BEGIN
              UWriteU, P.file+'.'+curDW.FILE+'.dw', SaveDW(CON(i)), /COMPRESS
          ENDIF
      ENDIF
   END
   

   IF ExtraSet(e,'WAIT') THEN BEGIN
      print, "--> I'm waiting for you <--"
      dummy =  get_kbrd(1)
   END

   ;-------------> FREE MEMORY
   FOR i=0, INmax DO FreeInput, IN(i)
   IF graphic THEN BEGIN
      FOR i=0, NWmax DO FreePlotcilloscope, PCWN(i)
      FOR i=0, ANALmax DO FreeAnaLayer, AnaCL(ANAL(i))
      FOR i=0, Lmax DO FreePlotcilloscope, PCMUA(i)
      FOR i=0, TSSCloutmax DO FreeTrainspottingScope, TSSClout(i)
   END

   ;--------------> FREE LEARN
   FOR i=0, LDWmax DO FreeLearn, P.LearnW(i)


   ;--------------> FREE WEIGHTS AND LAYERS
   FOR i=0, DWmax DO FreeDW, CON(i) 
   FOR i=0, Lmax DO FreeLayer, L(i)
   
END




PRO SIM, _EXTRA=e
  iter=foreach('_SIM', _EXTRA=e)
END
