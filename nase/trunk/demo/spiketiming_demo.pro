;+
; NAME: SPIKETIMING_DEMO
;
; AIM: demo simulation that demonstrates the usage of <A>DoSpikeTiming</A> and its partners
;
; PURPOSE: DEMONSTRATIONSPROGRAMM fuer die routinen initspiketiming, dospiketiming,showspiketiming
;          und freespiketiming 
;          ein neuron (L1) bekommt input von 300 exzitatorischen (L0E,CON_EXC) 
;          und 150 inhibitorischen (L0I,CON_INH) eingaengen, so dass
;          das mittlere membranpotential etwas unter der ruheschwelle liegt.
;          ein AP wird nur dann ausgeloest, wenn vorher viele exzitatorische eingaenge aktiv waren,
;          d.h. die wahrscheinlichkeit dass ein presynaptischer spike einem postsynaptischen vorausging
;          ist etwas groesser als der umgekehrte fall... 
;          das sieht man im histogramm, welches von SHOWSPIKETIMING ausgegeben wird.
;          das genaue verhaeltnis der haeufigkeiten kann man sich mit dem KEYWORD
;          /RATIO=ratio zurueckgeben lassen.
;          
;
;
; CATEGORY: MISCELLANEOUS
;
;
; CALLING SEQUENCE: .run spiketiming_demo
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.3  2000/09/27 15:59:11  saam
;     service commit fixing several doc header violations
;
;     Revision 1.2  2000/09/25 09:10:32  saam
;     * appended AIM tag
;     * some routines got a documentation update
;     * fixed some hyperlinks
;
;     Revision 1.1  1999/11/10 15:06:27  alshaikh
;           initial version
;
;


; simulation parameters

total_timesteps = 5000  ; number of simulation timesteps
freq = 50               ; firing rate for (poisson) input
theta0 = 1.0            ; threshold

 
; Dimension of excitatory inputs
w_exc = 150
h_exc = 2

; Dimension of inhibitory inputs
w_inh = 75
h_inh = 2

neuro_in = w_exc*h_exc 

; sheets and more
sheet1 = definesheet(/window,/verbose,xsize=400,ysize=300,colors=256,xpos=450,ypos=10)
sheet2 = definesheet(/window,/verbose,xsize=400,ysize=300,colors=256,xpos=10,ypos=10)


opensheet,sheet1
p1 =  initplotcilloscope(rays=2, time=200)
closesheet,sheet1

; layer type
Layer = InitPara_1( TAUF=10.0, TAUL=5.0, TAUI=10.0, VS=5.0, TAUS=1.0, TH0=theta0, SIGMA=0.0)

; initialize neuron(s)   
; target layer : 
L1 = InitLayer(WIDTH=2, HEIGHT=2, TYPE=Layer)

; source layer :
L0E = InitLayer(width=w_exc,Height=h_exc, TYPE=Layer)
L0I = InitLayer(width=w_inh,Height=h_inh, TYPE=Layer)


; excitatory connections
CON_EXC = InitDW(S_WIDTH=w_exc, S_HEIGHT=h_exc, T_LAYER=L1, $
                      W_random=[0.03,0.07])

; inhibitory connections
CON_INH = InitDW(S_WIDTH=w_inh, S_HEIGHT=h_inh, T_LAYER=L1, $
                      W_random=[0.09,0.11])


; define learnWindow
LearnWindow =  InitLearnBiPoo(postv=0.001,posttau=10,prev=0.001,pretau=10)
zaehler =  initspiketiming(learnwindow)


LP_EXC = InitPrecall(CON_EXC,LearnWindow)




; main simulation loop
FOR act_time=0l,total_timesteps-1 DO begin
   

;generate random input of frequency 'freq' for excitatory inputs
   inparr =  fltarr(w_exc*h_exc)   
   r =  randomu(seed,w_exc*h_exc)
   index_1 =  where ( r LT (freq/1000.0) ,c1)
   IF c1 GT 0 THEN inparr(index_1) = 1
   feed_in = spassmacher(reform(inparr,w_exc,h_exc))

  
;generate random input of frequency 'freq' for inhibitory inputs
   inparr =  fltarr(w_inh*h_inh)   
   r =  randomu(seed,w_inh*h_inh)
   index_1 =  where ( r LT (freq/1000.0) ,c1)
   IF c1 GT 0 THEN inparr(index_1) = 1
   inhib_in = spassmacher(reform(inparr,w_inh,h_inh))
   
   
   I_L1_I = DelayWeigh(CON_INH,layerout(L0i))
   I_L1_F = DelayWeigh(CON_EXC, layerout(l0e))
   
   Totalprecall, LP_EXC,CON_EXC, L1
   dospiketiming, LP_EXC, zaehler
   
   inputlayer, L0e, feeding=feed_in
   inputlayer, l0i, feeding=inhib_in
   InputLayer, L1, FEEDING=I_L1_F, INHIBITION=I_L1_i
   
   proceedlayer,l0e
   proceedlayer,l0i  
   ProceedLayer,L1
 
   layerdata,l1,potential=pot,schwelle=theta
   
  
   
   opensheet,sheet1
   plotcilloscope, p1, [pot[1],theta[1]+theta0]
   closesheet,sheet1
   
   
ENDFOR   ; act_time


; show results ...
ratio = 0.0
opensheet, sheet2
showspiketiming, zaehler, RATIO=ratio
closesheet,sheet2

print,'ratio #(t_post-t_pre>0)/#(t_post-t_pre<0) :', ratio

taste = ''
read,taste


; ... and clean up
FreeDw, CON_EXC
FreeDw, CON_INH
freelayer,L1
freelayer,l0e
freelayer,l0i

DestroySheet,sheet1
DestroySheet,sheet2
END
