;+
; NAME:                InitInput
;
; PURPOSE:             Prepares data structures serving as input for sim. This routine
;                      is called from SIM. It makes nearly no sense to call it directly.
;
; CATEGORY:            MIND SIM INTERNAL
;
; COMMON BLOCKS:       ATTENTION
;                      PLOT_INPUT : shares plotcilloscope with INPUT
;                      SH_INPUT   : shares sheets with INPUT
;                      INPUT      : shares serveral data structures with INPUT
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#INPUT>input</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#FREEINPUT>freeinput</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  2000/01/19 17:20:21  saam
;          removed all poissoninput calls (!!!!!!!!!)
;
;     Revision 1.5  2000/01/19 09:08:55  saam
;           + wrong handling of delta_t fixed
;
;     Revision 1.4  2000/01/14 10:34:40  saam
;           bug in print corrected
;
;     Revision 1.3  2000/01/14 10:26:57  alshaikh
;           NEW: 'EXTERN' input
;
;     Revision 1.2  1999/12/10 10:05:15  saam
;           * hyperlinks for freeinput added
;
;     Revision 1.1  1999/12/10 09:36:46  saam
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
;               REC     :
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
;              f     : mean firing rate for each channel (may a be two-elements-array: f_uncorr, f_corr)
;              v     : weight, cause its going directly to InputLayer
;              sig   : amplitude of gaussian jitter
;              p     : fraction of neurons receiving the pulse (neurons were chosen randomly for each pulse)
;              r     : radius of neurons receiving input (centered in layers center)
;              xoff  /
;              yoff  : shift of the circle's center relative to layer's center (default: 0/0)
;              dyn   : dynamically move circle in the layer
;              decay : spatial-gaussian input correlations; at radius r the decayed to .1
;              wrap  : input has toroidal boundary conditions 
;              unique: displays blobs at each position once before repeating
;
; TYPE='BURST':
; ------------
;              f     : frequency of blobs
;              input : array containing static input for that layer
;
; TYPE='AF':
; ------------
;              f   : frequency of correlation blobs
;              sig : decay of gaussian probability to evoke spikes in spatial neighbourhood
;              p0  : (NOTE the norm keyword!) probability factor (amplitude of gaussian, hot spot will always be 1)
;              del : the next neighbour will be excited afer d BIN
;              norm: if defined, the area under the gaussian will always be p0
;               
; 
; TYPE='STATIC':
; --------------
;                 vals: FltArr(w,h) containing the values
;     
; TYPE='EXTERN':
; --------------
;             delta_t : refresh interval (delta_t=-1  => each SIM-step)
;             period  : periodicity (period=-1   =>infinite period)
;             filter  : array of filters
;             start   : time within a period when filter is activated
;             stop    :    "                "               stopped
;             visible : 0|1 ... what do you think?
;


FUNCTION InitInput, L, _IN, CallString, CallLong, _EXTRA=e;, EXTERN=_ext

   COMMON ATTENTION
   COMMON PlotInput, PC_Input
   COMMON SH_INPUT, INPUTwins, INPUT_1
   COMMON NINPUT, typelist

;   On_Error, 2

   IF NOT Handle_Info(_IN) THEN Message, 'invalid input handle'
   Handle_Value, _IN, IN


   IF NOT ExtraSet(IN, 'INDEX')   THEN Message, 'tag INDEX undefined!'
   IF NOT ExtraSet(IN, 'LAYER')   THEN Message, 'tag LAYER undefined!'
   IF NOT ExtraSet(IN, 'SYNAPSE') THEN Message, 'tag SYNAPSE undefined!'
   IF NOT ExtraSet(IN, 'TYPE')    THEN Message, 'tag TYPE undefined!'


   typelist = ['SPIKES', 'GWN', 'POISSON', 'PCC', 'BAR', 'FADEBAR', 'FADEIN', 'NONE', 'STATIC', 'BURST', 'AF','EXTERN']
;                 0        1        2        3      4        5          6        7        8        9      10    11

   ;----->
   ;-----> GLOBAL DEFINES
   ;----->
   curLayer = Handle_Val(P.LW(IN.LAYER))
   w = curLayer.w
   h = curLayer.h
   LayerData, L(IN.LAYER), PARA=LP


   ;----->
   ;-----> ORGANIZE THE SHEETS
   ;----->
   IF ExtraSet(e, 'NEWWIN') THEN InputWins = 0
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      INPUT_1 = DefineSheet(/NULL)
      INPUTwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      INPUT_1 = DefineSheet(/NULL)
      INPUTwins = 0
   END ELSE BEGIN
      IF (SIZE(INPUTwins))(1) EQ 0 THEN BEGIN
         w2h = w/h
         IF w2h GT 1 THEN BEGIN
            xs = 300+100
            ys = 300/w2h+100
         END ELSE BEGIN
            xs = 300*w2h+100
            ys = 300+100
         END
         INPUT_1 = DefineSheet(/Window, XSIZE=xs, YSIZE=ys, TITLE='NInput')
         INPUTwins = 1
      END
   END



   mytype = WHERE(STRUPCASE(IN.TYPE) EQ typelist,c)
   CASE mytype(0) OF
      0: R = { type:0, data : NoisyRhythm( RATE=IN.f, GAUSS=IN.sd, LAYER=L(0), RANDOM=IN.rand, V=IN.V) , index: IN.index }
      1: BEGIN
         OpenSheet, INPUT_1
         PC_Input = InitPlotcilloscope(TIME=200, /NOSCALEYMIN, YMAX=0.01, RAYS=2)
         CloseSheet, INPUT_1
         R = { type:1, index: IN.index }
      END
;      2: BEGIN
;         R = {  type  : 2,$
;                data  : PoissonInput(WIDTH=w, HEIGHT=h, RATE=IN.f, V=IN.v, CORR=IN.cor, GAUSSIAN_JITTER=IN.sig, FRAC=IN.p,$
;                                     SAMPLEPERIOD=P.SIMULATION.SAMPLE) ,$
;                index : IN.index }
;         sampleframe = BytArr(w*h)
;      END
      3: BEGIN; PCC
         IF IN.decay THEN BEGIN
            IF h NE w THEN Message, 'INTINPUT: PCC with DECAY and non-quadratic layers is not defined...'
            sigma = sqrt(-IN.r^2/2./alog(0.1)) ; okay, amplitude is at 0.1 at the circle border
            mask = Gauss_2D(h,w,sigma)
            Print, 'INPUT: PCC, R='+Str(IN.r)+' => sigma='+Str(sigma)
         END ELSE BEGIN
            mask = CutTorus(Make_Array(h,w,/BYTE, VALUE=1),IN.r,-1)
         END
         mask =  NOROT_SHIFT(mask,IN.xoff, IN.yoff)

         IF N_Elements(IN.F) EQ 2 THEN BEGIN
            f_corr = (IN.F)(1)
            f_uncorr = (IN.F)(0)
         END ELSE IF N_Elements(IN.F) EQ 1 THEN BEGIN
            f_corr = (IN.F)(0)
            f_uncorr = (IN.F)(0)
         END ELSE Message, 'Wrong Declaration of INPUT.v'
            
         IF ExtraSet(IN, 'WRAP') THEN WRAP = 1 ELSE WRAP = 0

         uniqueSet = 0
         unique    = All_Random(w*h) ;immediately overwritten in NInput
         uniqueIdx = -1
         IF ExtraSet(IN, 'UNIQUE') THEN uniqueSet = 1

         ; without decay: mask is just ANDed with the poissoninput
         ; with decay: mask is the probability that the spike is actually emitted 
         R = {  type  : 3,$
;                data  : PoissonInput(WIDTH=w, HEIGHT=h, RATE=f_corr, V=IN.V, CORR=1.0, GAUSSIAN_JITTER=IN.sig, FRAC=IN.p, SAMPLEPERIOD=P.SIMULATION.SAMPLE, /NOSPASS) ,$
;                data2 : PoissonInput(WIDTH=w, HEIGHT=h, RATE=f_uncorr, V=IN.V, CORR=0.0, SAMPLEPERIOD=P.SIMULATION.SAMPLE, /NOSPASS) ,$
                mask  : mask ,$
                dmask : mask ,$
                dyn   : IN.dyn,$
                decay : IN.decay,$
;                dynx  : MAX([0,w/2+IN.R]),$ this is buggy
;                dyny  : MAX([0,h/2+IN.R]),$
                dynx  : w/2,$
                dyny  : h/2,$
                index : IN.index         ,$
                wrap  : WRAP             ,$
                 uniqueSet : uniqueSet   ,$
                 unique    : unique      ,$
                 uniqueIdx : uniqueIdx   ,$
                 uniqueMod : w           ,$
                vid   : InitVideo([0,0], TITLE=P.File+'.'+STR(curLayer.FILE)+'.'+STR(IN.INDEX)+'.pcc.in.sim', /SHUTUP, /ZIPPED )$
             }
         OpenSheet, INPUT_1
         PlotTvScl, R.mask, /FULLSHEET
         CloseSheet, INPUT_1
      END
      4: BEGIN ; BAR
         Rt = BAR(WIDTH=w, HEIGHT=h, GAP=IN.GAP, BARWIDTH=IN.W, BARHEIGHT=IN.H, /NASE)
         OpenSheet, INPUT_1
         PlotTvScl, TRANSPOSE((Rt*IN.V)*(1.-LP.df(0))*(1.-LP.df(1))/(LP.df(1)-LP.df(0))), /LEGEND, TITLE='BAR'
         CloseSheet, INPUT_1
         R = { type  : 4                                                        ,$
               t     : 0l                                                       ,$
               In    : (Rt*IN.V)*(1.-LP.df(0))*(1.-LP.df(1))/(LP.df(1)-LP.df(0)),$
               index : IN.INDEX}
         Print, 'INPUT: BAR, ',STR(w),'x',STR(h),', GAP=',STR(IN.gap), ' -> ',curLayer.NAME, ', ', IN.SYNAPSE
      END
      5: R = { type : 5        ,$
               t    : 0l       ,$
               index: IN.index }
      6: BEGIN
         Rt = BAR(WIDTH=w, HEIGHT=h, GAP=IN.GAP, BARWIDTH=IN.W, BARHEIGHT=IN.H, /NASE)
         R = { type : 6      ,$
               t : 0l        ,$
               In: Rt/MAX(Rt),$
               index:IN.index }
      END 
      7: R = { type : 7    ,$ ;NONE
               t : 0l      ,$
               In: [0,w*h] ,$
               index: IN.index}
      8: BEGIN; STATIC
         IF NOT ExtraSet(IN, 'VALS') THEN Message, 'tag VALS undefined!'
         IF NOT ExtraSet(IN, 'CORR') THEN Message, 'tag CORR undefined!'
         
         s = SIZE(IN.vals)
         tmp = IN.vals
         IF IN.corr THEN tmp = tmp*(1.-LP.df(0))*(1.-LP.df(1))/(LP.df(1)-LP.df(0))
         IF (s(1) NE w) OR (s(2) NE h) THEN Message, "input and layer dimensions differ"
         R = { type : 8                           ,$
               index: IN.index                    ,$
               t    : 0l                          ,$
               IN   : TRANSPOSE(tmp)              }
         OpenSheet, INPUT_1
         PlotTvScl, IN.vals, /LEGEND, /FULLSHEET, TITLE='STATIC'
         CloseSheet, INPUT_1
         Print, 'INPUT: STATIC -> ',curLayer.NAME, ', ', IN.SYNAPSE
      END
      9: BEGIN; BURST
         ; without decay: mask is just ANDed with the poissoninput
         ; with decay: mask is the probability that the spike is actually emitted 
         R = {  type  : 9                ,$
                index : IN.index         ,$
                t     : 0l               ,$
;                hs    : InitHotSpot(WIDTH=w, HEIGHT=h, /UNIQUE),$
;                ed    : InitEventDist(POISSON=IN.f),$
                poi   : [0l,0l]          ,$ ;current hotspot
                input : IN.input         ,$
                curin : IN.input         ,$
                vid   : InitVideo([0l], TITLE=P.File+'.'+STR(curLayer.FILE)+'.'+STR(IN.INDEX)+'.burst.in.sim', /SHUTUP, /ZIPPED )$
             }
      END
      10: BEGIN; AF
         pr = Gauss_2d(w,h, IN.sig)
         IF ExtraSet(IN, 'NORM') THEN BEGIN
            pr = IN.p0 * pr / TOTAL(pr) 
            Print, 'INPUT: AF (NORM), sigma='+STR(IN.sig)+', d='+STR(IN.del)+', f='+STR(in.f)+' Hz, p0='+STR(IN.p0)
         END ELSE BEGIN
            pr = IN.p0*pr
            Print, 'INPUT: AF, sigma='+STR(IN.sig)+', d='+STR(IN.del)+', f='+STR(in.f)+' Hz, p0='+STR(IN.p0)
         END
         pr(w/2,h/2) = 1.0
	 d = FIX(IN.del*Shift(Dist(w,h),w/2,h/2))
         R = {  type  : 10               ,$
                index : IN.index         ,$
                t     : 0l               ,$
;                hs    : InitHotSpot(WIDTH=w, HEIGHT=h, /UNIQUE),$
 ;               ed    : InitEventDist(EQUAL=IN.f),$
                poi   : [0l,0l]          ,$ ;current hotspot
		hst   : 0l               ,$ ;time of last hot spot
                p     : pr               ,$
                curp  : pr               ,$
		d     : d                ,$
		curd  : d                ,$
                maxd  : max(d)           }
      END



      11: BEGIN; EXTERN
       
         number_filter = N_elements(IN.filters)
         pattern =  fltarr(h,w)
         tempo = lonarr(number_filter)
         FOR i=0,number_filter-1 DO BEGIN
            tempo(i) = Handle_Create(!MH, VALUE=0);, /NO_COPY)
         ENDFOR

         IF (IN.time_step EQ -1) THEN dt = P.SIMULATION.SAMPLE*1000. ELSE dt =  IN.time_step
         
         R =  { type            : 11                     ,$ ; input type (11=extern) 
                index           : IN.index               ,$ 
                period          : IN.period              ,$ ; period time
                number_filter   : N_elements(IN.filters) ,$ ; how many filters are used?
                delta_t         : dt                     ,$ ; time resolution
                t               : 0l                     ,$ ; internal sim-time
                filters         : IN.filters             ,$ ; filters
                temps           : tempo                  ,$ ; for storing internal filter-data
                visible         : IN.visible             ,$ ; visible (plottvscl)? yes(1) no(1)
                pattern         : pattern }                 ; generated input-pattern
      END 

      ELSE: Message, 'dont know that kind of input: '+STRING(IN.TYPE)
   ENDCASE

   ;----->
   ;-----> FADING SCHEME
   ;----->

   IF MYTYPE(0) EQ 8 THEN BEGIN
       IF ExtraSet(IN, 'FADE') THEN BEGIN
         tFade = REFORM(IN.FADE(0,*)/(1000*P.SIMULATION.SAMPLE)) ; time of fade-points in BIN 
         
         FADE = DblArr(P.SIMULATION.TIME/(1000*P.SIMULATION.SAMPLE))
         FOR i=0, N_Elements(IN.FADE)/2-2 DO BEGIN
            FADE(tFade(i)) = IN.FADE(1,i)
            FADE(tFade(i)+1:tFade(i+1)) = (DIndGen(tFade(i+1)-tFade(i))+1)/FLOAT(tFade(i+1)-tFade(i))*(IN.Fade(1,i+1)-IN.Fade(1,i))
         END
         FADE(tFade(i)+1:N_Elements(Fade)-1) = FADE(tFade(i))

         SetTag, R, 'FADE', FADE
         SetTag, R, 'FADEYN', 1
      END ELSE SetTag, R, 'FADEYN', 0
   END ELSE SetTag, R, 'FADEYN', 0

   ; recording
   IF ExtraSet(IN, 'REC') THEN BEGIN
      SetTag, R, 'REC', IN.REC
      IF R.REC(1) EQ -1 THEN R.REC(1) = P.SIMULATION.TIME+1
      IF ((R.REC(1) GT R.REC(0)) AND (R.REC(0) LT P.SIMULATION.TIME)) THEN BEGIN
         SetTag, R, 'RECLUN', InitVideo(sampleframe, TITLE=P.File+'.'+STR(curLayer.FILE)+'.'+STR(IN.INDEX)+'.in.sim', /SHUTUP, /ZIPPED )
         print, 'RECORDING: '+curLayer.NAME+' Input ('+STR(IN.INDEX)+') from '+STR(R.REC(0))+' to '+STR(R.REC(1))+' ms'  
      END
   END ELSE SetTag, R, 'REC', [-1,-1]

   
   InHandle =  Handle_Create(!MH, VALUE=R, /NO_COPY)

   CallString = IN.Synapse
   CallLong = IN.Layer

   RETURN, InHandle
END
