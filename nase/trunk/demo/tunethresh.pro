;+
; NAME:
;  TuneThresh
;
; AIM: Measure behavior of neurons receiving syncronous increase of input.
;
; PURPOSE:            Simuliert wird das Verhalten eines Typ2-Neurons bei einem Potentialsprung
;                     (Gesamtsimulationszeit 300ms, Potentialsprung bei t=150ms)
;                     Die Prozedur liefert die charakteristischen Werte der Impulsdichte in der Naehe des
;                     Potentialsprungs (breite, hoehe, differenz der Impulsdichten) zurueck.
;              
; CATEGORY: DEMO
;
; CALLING SEQUENCE:   tunethresh [,taur=taur_wert] [,tauf=tauf_wert] [,taus=taus_wert] [,vs=vs_wert] [,vr=vr_wert]
;                                [,inp_left=left_lvl] [,inp_right=rght_lvl] [,th0=theta0] [,sigma=sigma_wert] [,plot=plot_flag]
;                                [,anzahl=neuronen] [,width=breite] [,height=hoehe] [,diff=differenz] [,ok=ok]
;
; KEYWORD PARAMETERS: taur   (Default 1.0)      analog Typ 2
;                     tauf      "     1.0
;                     taus      "     1.0
;                     vs        "     10.0
;                     vr        "     3.0 
;                     th0       "     0.8
;                     sigma     "     1.7
;                     inp_left  : Feedingpotential in der ersten Simulationshaelfte  (Default 0.2)
;                     inp_right :      "             "    zweiten    "               (Default 1)
;                     plot      : Graphikausgabe Impulsdichte(t) bei /plot
;                     anzahl    : Anzahl der verwendeten Neuronen                    (Default 1600) 
;        
; OPTIONAL OUTPUTS:   width         : Adaptions - Zeitkonstante
;                     height        : Hoehe des am Potentialsprung auftretenden Peaks  
;                     differenz     : Differenz der Impulsdichten vor/nach Feedingpotentialsprung
;                     ok            : ok=True --> gueltiges Ergebnis
;
; RESTRICTIONS:       nur sinvoll fuer inp_right > inp_left
;
; EXAMPLE:           tunethresh, /plot, width = w, ok = gueltig
;                    if gueltig then print,'Die Breite des Peaks (Abfall auf 1/e) ist', w  
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/09/25 13:48:26  thiel
;         Moved from nase/simu.
;
;     Revision 1.1  1999/04/01 10:11:16  neurotmp
;          blkaboa blka
;
;


PRO _funct, X, A, F, PDER
   F = A(0) * (EXP(-A(1) * X))
   IF N_PARAMS() GE 4 THEN BEGIN      ;If the function is called with four parameters, calculate the partial derivatives.
      pder = FLTARR(N_ELEMENTS(X), 2) ;PDER's column dimension is equal to the number 
                                      ;of elements in xi and its row dimension is equal to the number of parameters in the function F.
      pder(*, 0) = EXP(-A(1) * X)     ;Compute the partial derivatives with respect to a0 and place in the first row of PDER.
      pder(*, 1) = -A(0) * x * EXP(-A(1) * X) ;Compute the partial derivatives with respect to a1 and place in the second row of PDER.
   ENDIF
END

PRO tunethresh, taur=taur_wert, tauf=tauf_wert, taus=taus_wert, vs=vs_wert, vr=vr_wert, $
          inp_left=left_lvl, inp_right=rght_lvl, th0=theta0, sigma=sigma_wert, anzahl=neuronen, plot=plot_flag, $
          width=breite, height=hoehe, diff=differenz,ok=ok

   default, taur_wert, 1.0
   default, tauf_wert, 1.0
   default, vs_wert,   10.0
   default, vr_wert,   3.0
   default, taus_wert, 3.0
   default, theta0,    0.8
   default, sigma_wert,1.7
   default, left_lvl,  0.2
   default, rght_lvl,  1.0
   default, neuronen,  1600

   maxtime = 300                ;Anzahl der Zeitschritte
   mitte = maxtime/2            ;bei t=mitte Umschalten des Potentials
   max_tau = 1.0/mitte          ;Hilfsvariable
   anz_neuro =  neuronen/2      
   count = fltarr(maxtime+1)    ;psp
   maxtime_2 =  maxtime/2       ;Hilfsvariable
   ok = 1                       ;false:Funktion fehlerhaft

   I_l1_f1 = spassmacher(reform((fltarr(neuronen)+left_lvl),neuronen))
   I_l1_f2 = spassmacher(reform((fltarr(neuronen)+rght_lvl),neuronen))
 
   ;neuron 
   layer1 = InitPara_2(tauf=tauf_wert, taul=taul_wert, taui=taui_wert, vs=vs_wert, vr= vr_wert, $
                       taur= taur_wert, taus=taus_wert, th0=theta0, sigma=sigma_wert)

   l1 =  initlayer(width=2, height=anz_neuro, type=layer1)

   FOR time=0,maxtime DO BEGIN
   
      ;Zeitschritt
      IF time LT (maxtime_2) THEN inputlayer, l1, feeding=I_l1_f1 ELSE inputlayer, l1, feeding=I_l1_f2
      proceedlayer, l1
      layerdata, l1, output=out
      count(time) =  total(out)/neuronen
   ENDFOR                       ;time

   freelayer,l1
     
   avrg_right = total(count((0.75*maxtime):maxtime))/(0.25*maxtime)
   avrg_left = total(count((0.2*maxtime):(0.45*maxtime)))/(0.25*maxtime)
   differenz = avrg_right-avrg_left
         
   xindex =  where(count(mitte:maxtime) GT avrg_right,c)
   IF (c GT 0) THEN begin
      newcount =  fltarr(c)
      newcount =  count(mitte+xindex)
      
      W = newcount              ;Define a vector of weights. 
      A = [max(newcount),0.2]   ;Provide an initial guess of the function's parameters. 
      yfit = UCURVEFIT(indgen(c), newcount-avrg_right, W, A, SIGMA_A, FUNCTION_NAME = '_funct',$
                       converged=ok)+avrg_right
      
      IF a(1) GT max_tau THEN breite = 1/a(1) $
      ELSE ok = 0
      
   ENDIF ELSE  breite(taur_wert-start_taur,vr_wert-start_vr) = 0

   IF (keyword_set(plot_flag)) THEN plot,count,xtitle='Zeit in ms',ytitle='Membranpotential'
END
