;+
; NAME:                Input
;
; PURPOSE:             Generates various inputs for various Layers. This routine
;                      is called from SIM. It makes nearly no sense to call it directly.
;
; CATEGORY:            MIND SIM INTERNAL
;
; COMMON BLOCKS:       ATTENTION
;                      COMMON_RANDOM : nase COMMON block 
;                      PLOT_INPUT    : shares plotcilloscope with INPUT
;                      SH_INPUT      : shares sheets with INPUT
;                      INPUT         : shares serveral data structures with INPUT
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#INITINPUT>initinput</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/12/10 09:36:47  saam
;           * hope these are all routines needed
;           * no test, yet
;
;
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
FUNCTION Input, L, _IN

   COMMON ATTENTION

   COMMON PlotInput, PC_Input
   COMMON SH_INPUT, INPUTwins, INPUT_1
   COMMON COMMON_Random, seed
   COMMON INPUT, typelist


   Handle_Value, _IN, IN, /NO_COPY
   Handle_Value, P.INPUT(IN.INDEX), INP

   IF IN.TYPE LT 11 THEN BEGIN
      curLayer = Handle_Val(P.LW(INP.LAYER))
      w  = curLayer.w
      h  = curLayer.h
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
         R = PoissonInput(FUCKIDL)
         IN.DATA = FUCKIDL
         frame = Byte(SSpassBeiseite(R))
      END
      3: BEGIN
         FUCKIDL = IN.DATA
         T = PoissonInput(FUCKIDL, PULSE=pulse) ;correlated
         IN.DATA = FUCKIDL
         FUCKIDL = IN.DATA2
         U = PoissonInput(FUCKIDL)              ;uncorrelated
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
   ENDCASE

   
   IF IN.FADEYN THEN R = Spassmacher(R*IN.FADE(_TIME)); ELSE R = Spassmacher(R)


   IF ((_TIME GE OS*IN.REC(0)) AND (_TIME LT OS*IN.REC(1)) AND (IN.REC(0) NE -1)) THEN dummy = CamCord( IN.RECLUN, frame)

   
   Handle_Value, _IN, IN, /NO_COPY, /SET
   RETURN, R
END
