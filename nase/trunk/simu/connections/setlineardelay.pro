;+
; NAME: SetLinearDelay
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Delays kegelförmig. (Ein umgedrehter Kegel mit Minimum im Zentrum!)
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetLinearDelay ( DWS
;                                   [,MIN=Minimum] [,Maximum] [,Range=Reichweite]
;                                    ,S_ROW=Source_Row, S_COL=Source_Col
;                                    ,T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] )
;
;
; 
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;         S_ROW:    Zeilennr des Sourceneurons im Sourcelyer
;         S_COL:    Spaltennr
;         T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das das min. Delay (Kegelspitze) erhält
;         T_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: Größe der größten Delays (Höhe der "Ebene", in die der Kegel eingebettet wird.)
;                  Minimum: Größe des kleinsten Delays (absolute Höhe der Kegelspitze)
;                  Range  : Reichweite in Gitterpunkten. (Radius der Kegelgrundfläche) (Default ist 1/6 der Targetlayerhöhe)
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
; EXAMPLE: SetLinearDelay (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 10, Min=1)
;
;              Setzt die Delays, die von Neuron (1,2) ausgehen so, daß sie kegelförmig in den Targetlayer verlaufen,
;              und zwar mit Minimum auf Neuron (23,17). Das Delay eben dieses Minimums beträgt 1, das größte vorkommende Delay beträgt 10.
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetLinearDelay, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4, /DELAYS
;
; MODIFICATION HISTORY:
;
;       Wed Aug 6 16:39:16 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch Übernahme von SetGaussDelay.
;
;-

Pro SetLinearDelay, DWS, Amp, Range, MIN=min, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

   Default, Range, DWS.target_h/6
   Default, Amp, 1
   Default, min, 0
   Default, trunc_value, Amp

   SetDelay, DWS, S_ROW=s_row, S_COL=s_col, $
              min + (Amp-min)/double(Range)*(Range < Shift(Dist(DWS.target_h, DWS.target_w), t_hs_row, t_hs_col)), $
              ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=Amp

end
