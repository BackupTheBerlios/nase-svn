;+
; NAME:
;  Input()
;
; VERSION:
;  $Id$
;
; AIM:
;  Provides all input to simulations (used by <A>Sim</A>).
;
; PURPOSE:
;  Generates various inputs for various Layers. This routine is called
;  from <A>Sim</A>. It makes nearly no sense to call it directly. See
;  comments in source for more details. 
;
; CATEGORY:
;  Input
;  Internal
;  MIND
;  Simulation  
;
; COMMON BLOCKS:
;  attention,
;  common_random (nase common block), 
;  plot_input (shares plotcilloscope with <A>Input</A>),
;  sh_input (shares sheets with <A>Input</A>),
;  input (shares serveral data structures with <A>Input</A>). 
;
; SEE ALSO:
;  <A>InitInput</A>, <A>FreeInput</A>, <A>Sim</A>.
;-

; COMMON TAGS:
; ------------   
;               INDEX   : a running index speciying the index i of INPUT parameters
;               LAYER   : the index of the layer where the input should go
;               SYNAPSE : the synapse-type where input should go (depending on neuron type)
;               TYPE    : input type specified below
;
; TYPE='GWN':
; -----------
;              off : amplitude of constant offset
;              sd  : standard deviation of cont. noise
;              cor : percentage of correlated gaussians
;   
; TYPE='POISSON':
; ---------------
;                  f   : RATE
;                  v   : VERSTARKUNG, da direkt in InputLayer
;                  cor : Bruchteil des correlierten Beitrags
;                  sig : Amplitude des gleichverteilten Jitters
;                  p   : Bruchteil der correlierten Inputs
;
; TYPE='SPIKES':
; --------------
;                 f    : pulse frequency 
;                 sd   : gaussian deviation of temporal jitter of individual spikes
;                 rand : ??
;                 v    : synaptic strength
;
; TYPE='BAR':
; -----------
;              TIME   : time of presentation
;              GAP    : distance between two bars
;              UNOISE : uniform noise on bar & surround
;              W      : bar width
;              H      : bar height
;              V      : amplitude of static signal
;
; TYPE='FADEBAR':
; ---------------
;                  FB_W : the maximal size of the bar
;                  FB_H : 
;                  GAP  : 
;                  V    : 
;
; TYPE='FADEIN':
; --------------
;                 V_IN : amplification of static input signals
;                 MAX  : 
;                 GAP  : distance between two bars
;                 W    : bar width
;                 H    : bar height
;
; TYPE='PCC':
; -----------
;              f     : mean firing rate for each channel
;              v     : weight, cause its going directly to InputLayer
;              sig   : amplitude of gaussian jitter
;              p     : fraction of neurons receiving the pulse (neurons were chosen randomly for each pulse)
;              r     : radius of neurons receiving input (centered in layers center)
;              xoff  /
;              yoff  : shift of the circle's center relative to layer's center (default: 0/0)
;              dyn   : dynamically move circle in the layer
;              decay : spatial-gaussian input correlations; at radius r the decayed to .1
; 
; TYPE='STATIC':
; --------------
;                 vals: FltArr(w,h) containing the values
;     
;
; TYPE='EXTERN':
; --------------
;             delta_t : refresh interval (delta_t=-1  => each SIM-step)
;             period  : periodicity (period=-1   =>infinite period)
;             filter  : array of filters
;             start   : time in ms when the input is activated (default: 0)
;             stop    :    "        "          stopped (default: simtime-1)
;             visible : yes(1), no(0)
;



FUNCTION Input, L, _IN

   COMMON ATTENTION

   COMMON PlotInput, PC_Input
   COMMON SH_INPUT, INPUTwins, INPUT_1
   COMMON COMMON_Random, seed
   COMMON INPUT, typelist


   Handle_Value, _IN, IN, /NO_COPY
   Handle_Value, P.INPUT(IN.INDEX), INP

   IF IN.TYPE LT 12 THEN BEGIN
      curLayer = Handle_Val(P.LW(INP.LAYER))
      w  = curLayer.w
      h  = curLayer.h
      IF ExtraSet(curLayer, 'WRAP') THEN wrap = curLayer.wrap ELSE wrap = 0 ; toroidal boundary conditions
      LayerData, L(INP.LAYER), PARA=LP
      OS = 1./(1000*P.SIMULATION.SAMPLE)
   END

   CASE IN.TYPE OF
      0: BEGIN
         FUCKIDL = IN.DATA
         R = NoisyRhythm(FUCKIDL, /DW)
         IN.DATA = FUCKIDL
      END
      1: BEGIN 
         T1 = REBIN(GwnOff(WIDTH=1, HEIGHT=1, OFFSET=INP.Off, DEVIATION=INP.cor, /NOSPASS), h*w) ; correlated noise without offset
         T2 = GwnOff(WIDTH=w, HEIGHT=h, OFFSET=0.0, DEVIATION=INP.sd, /NOSPASS) ; offset and uncorrelated GWN 
         R = SpassMacher(T1+T2)
         
;      OpenSheet, Input_1
;      IF In1_1(0) GT 0 THEN Plotcilloscope, PC_Input, [In1_1(3), In1_0(3)]
;      CloseSheet, Input_1
      END
      2: BEGIN
         FUCKIDL = IN.DATA
         ;R = PoissonInput(FUCKIDL)
         IN.DATA = FUCKIDL
         frame = Byte(SSpassBeiseite(R))
      END
      3: BEGIN
         FUCKIDL = IN.DATA
         ;T = PoissonInput(FUCKIDL, PULSE=pulse) ;correlated
         IN.DATA = FUCKIDL
         FUCKIDL = IN.DATA2
         ;U = PoissonInput(FUCKIDL)              ;uncorrelated
         IN.DATA2 = FUCKIDL
         IF IN.dyn AND PULSE THEN BEGIN
            IF ((IN.uniqueSet) AND (IN.uniqueIdx EQ -1)) THEN BEGIN ; get new blob distribution
               IN.unique = All_Random(w*h)
               IN.uniqueIdx = w*h-1
            END
            IF IN.uniqueSet THEN BEGIN
               shiftx = FIX(IN.dynx-(IN.unique(IN.uniqueIdx) MOD IN.uniqueMod))
               shifty = FIX(IN.dyny-(IN.unique(IN.uniqueIdx)  /  IN.uniqueMod))
               IN.uniqueIdx = IN.uniqueIdx-1
            END ELSE BEGIN
               shiftx = IN.dynx-FIX(IN.dynx*2.*(RandomU(seed, 1))(0))
               shifty = IN.dynx-FIX(IN.dyny*2.*(RandomU(seed, 1))(0))
            END
            IF IN.WRAP THEN IN.DMASK = SHIFT(IN.MASK, shiftx, shifty) $
             ELSE IN.DMASK = NOROT_SHIFT(IN.MASK, shiftx, shifty) 
            OpenSheet, INPUT_1
            PlotTvScl, IN.DMASK, /FULLSHEET
            CloseSheet, INPUT_1
            dummy = CamCord(IN.VID, [shiftx, shifty])
         END
         R = SpassMacher((T*IN.DMASK) + (U * (1-IN.DMASK)))
      END
      4: BEGIN
         R = GwnOff(WIDTH=w, HEIGHT=h, OFFSET=0.0, DEVIATION=INP.UNOISE, NORM=LP.th0, /NOSPASS) ; offset and uncorrelated GWN 
         IF IN.t GE INP.TIME THEN R = R + IN.IN
         R = Spassmacher(R)
         IN.t = IN.t + 1
      END
      5: BEGIN
         Rt = BAR(WIDTH=w, HEIGHT=h, GAP=INP.GAP, BARWIDTH=FIX(INP.w*(IN.t/FLOAT(P.SIMULATION.time*OS))), BARHEIGHT=INP.H, /NASE)
         R = Spassmacher((Rt/MAX(Rt)*INP.V)*(1.-LP.df))
         IN.T = IN.T + 1
      END 
      6: BEGIN
         R = Spassmacher(IN.IN*INP.MAX*IN.t/FLOAT(P.SIMULATION.time*OS)*(1.-LP.df))
         IN.t = IN.t + 1
      END 
      7: BEGIN
         R = IN.IN
      END
      8: BEGIN         
         R    = IN.IN
         IN.t = IN.t + 1
      END
      9: BEGIN
         ed = IN.ed
         hs = IN.hs
         IF EventDist(ed) THEN BEGIN
            IN.poi = HotSpot(hs)
            IN.curin = SHIFT(IN.input, IN.poi(0), IN.poi(1))
            OpenSheet, INPUT_1
            PlotTvScl, IN.Curin
            CloseSheet, INPUT_1
;            dummy = CamCord(IN.VID, IN.poi)
         END
         IN.ed = ed
         IN.hs = hs
         R = SpassMacher(IN.curin)
         IN.t = IN.t + 1
      END
      10: BEGIN; AF
         ed = IN.ed
         IF EventDist(ed) THEN BEGIN
            hs = IN.hs
            IN.hst = IN.t
            IN.poi = HotSpot(hs)
            IN.curp = SHIFT(IN.p, IN.poi(0), IN.poi(1))
            IN.curd = SHIFT(IN.d, IN.poi(0), IN.poi(1))
            OpenSheet, INPUT_1
            PlotTvScl, IN.curp
            CloseSheet, INPUT_1
            IN.hs = hs
         END
         IN.ed = ed
         dt = IN.t-IN.hst
         IF dt LE IN.maxd THEN R = SpassMacher((RandomU(seed,w,h) LT IN.curp) AND (dt EQ IN.curd)) ELSE R = [0,w*h]
         IN.t = IN.t + 1
      END

      
      11 : BEGIN                ; EXTERN
         
         act_time =  OS*IN.t    ; timesteps -> ms
         delta_t =   IN.delta_t ; resolution in ms
         
         pattern = FltArr(h,w)  ; initialize input-matrix
 
         IF ((act_time GE in.start) $
             AND (act_time LE in.stop)) THEN BEGIN; global start/stop

            number_filter =  IN.number_filter

            IF (IN.period NE -1) THEN act_time = act_time MOD IN.period

            IF ((delta_t EQ -1) OR (act_time MOD delta_t EQ 0)) THEN BEGIN
               FOR i=0, number_filter-1 DO BEGIN
               
                  IF N_Elements(IN.temps) EQ 1 THEN _t = IN.temps $
                  ELSE _t = IN.temps(i) ; fix IDL3.6 problems!
                  
                  IF N_Elements(IN.filters) EQ 1 $
                   THEN Handle_Value,IN.filters,act_filter $
                  ELSE Handle_Value,IN.filters(i),act_filter 
                   ;fix IDL3.6 problems!
                
                  IF ((act_time GE act_filter.start) $
                      AND (act_time LE act_filter.stop)) THEN BEGIN 
                      ; periodic start/stop
                     IF act_time EQ act_filter.start THEN BEGIN
                        ; initialize filter
                        console,P.CON, curLayer.NAME+ ', '+ IN.SYNAPSE,/msg
                        FILE = P.File+'.'+curLayer.FILE+'.if'+STR(i)
                        IF ExtraSet(act_filter, 'PARAMS') THEN BEGIN
                           temp = CALL_FUNCTION(act_filter.NAME $
                                                ,MODE=0,PATTERN=pattern $
                                                ,WIDTH=w,HEIGHT=h, WRAP=wrap $
                                                ,FILE=file $
                                                ,_EXTRA=act_filter.params $
                                                ,temp_vals=_t,DELTA_T=delta_t) 
                        ENDIF ELSE BEGIN
                           temp = CALL_FUNCTION(act_filter.NAME,MODE=0 $
                                                ,PATTERN=pattern,WIDTH=w $
                                                ,HEIGHT=h, WRAP=wrap $
                                                ,FILE=file $
                                                ,temp_vals=_t,DELTA_T=delta_t) 
                        ENDELSE ; params?
                     ENDIF      ; initialize filter                      

;obsolete?  IF ((delta_t EQ -1) OR ((act_time MOD (delta_t)) EQ 0)) THEN BEGIN
                  ; do filter step
                     pattern = CALL_FUNCTION(act_filter.NAME, MODE=1 $
                                             ,PATTERN=pattern, temp_vals=_t) 
;obsolete?  END
                  ENDIF ;; periodic start/stop?                  
               ENDFOR ;; i  
             
           ENDIF ;; ((delta_t EQ -1) OR (act_time MOD delta_t EQ 0))
         
        ENDIF ;; ((act_time GE in.start) AND (act_time LE in.stop))

        IN.pattern = pattern    ; store for future use
             
        IF IN.visible NE 0 THEN BEGIN ; show what you've done
           OpenSheet, INPUT_1
           PlotTvScl, IN.pattern
           CloseSheet, INPUT_1
        ENDIF ;; IN.visible NE 0
 
        R = Spassmacher(IN.pattern)
        IN.t = IN.t + 1

     END ;; external input
     

   ENDCASE

   
   IF IN.FADEYN THEN R = Spassmacher(R*IN.FADE(_TIME)) ; ELSE R = Spassmacher(R)


   IF ((_TIME GE OS*IN.REC(0)) AND (_TIME LT OS*IN.REC(1)) AND (IN.REC(0) NE -1)) THEN dummy = CamCord( IN.RECLUN, frame)
   
   
   Handle_Value, _IN, IN, /NO_COPY, /SET
   RETURN, R
END
