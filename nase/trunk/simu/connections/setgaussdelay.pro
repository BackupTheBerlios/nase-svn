;+
; NAME: SetGaussDelay
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Delays gaussförmig. (Eine umgedrehte Gaussglocke mit Minimum im Zentrum!)
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetGaussDelay ( DWS
;                                   [,MIN=Minimum] [,Maximum] [,Sigma | ,HWB=Halbwertsbreite]
;                                    ,S_ROW=Source_Row, S_COL=Source_Col
;                                    ,T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] )
;
;
; 
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;         S_ROW:    Zeilennr des Sourceneurons im Sourcelyer
;         S_COL:    Spaltennr
;         T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das das min. Delay (Talsohle) erhält
;         T_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: Größe der größten Delays (Höhe der "Ebene", in die das Gaußtal eingebettet wird.)
;                  Minimum: Größe des kleinsten Delays (Höhe der Talsohle)
;                  Sigma  : Standardabweichung in Gitterpunkten.
;                           alternativ kann in HWB die Halbwertsbreite angegeben werden.
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRUNCATE, TRUNC_VALUE : s. SetDelay!
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Die Delays der Delay-Weight-Struktur werden entsprechend geändert.
;
; RESTRICTIONS: ---
;
; PROCEDURE: Default, SetDelay, Gauss_2D()
;
; EXAMPLE: SetGaussDelay (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 10, Min=1)
;
;              Setzt die Delays, die von Neuron (1,2) ausgehen so, daß sie gaußförmig in den Targetlayer verlaufen,
;              und zwar mit Minimum auf Neuron (23,17). Das Delay eben dieses Minimums beträgt 1, das größte vorkommende Delay beträgt 10.
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetGaussDelay, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4, /DELAYS
;
; MODIFICATION HISTORY:
;
;       Wed Aug 6 14:45:19 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch Übernahme von SetGaussWeight.
;
;-

Pro SetGaussDelay, DWS, Amp, Sigma, HWB=hwb, MIN=min, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

   Default, Amp, 1
   Default, min, 0
   Default, trunc_value, Amp

   SetDelay, DWS, S_ROW=s_row, S_COL=s_col, $
              Amp - (Amp-min)*Gauss_2D(DWS.target_h, DWS.target_w, Sigma, HWB=hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row), $
              ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

end
