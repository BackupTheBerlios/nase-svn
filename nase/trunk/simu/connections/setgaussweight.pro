;+
; NAME: SetGaussWeight
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Verbindungen gaussförmig.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetGaussWeight ( DWS
;                                   [,Maximum] [,Sigma | ,HWB=Halbwertsbreite]
;                                    ,S_ROW=Source_Row, S_COL=Source_Col
;                                    ,T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col )
;
;
; 
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;         S_ROW:    Zeilennr des Sourceneurons im Sourcelyer
;         S_COL:    Spaltennr
;         T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das die max. Verbindungsstärke (Bergspitze) erhält
;         T_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: Stärke der stärksten Verbindung (Höhe der Bergspitze)
;                  Sigma  : Standardabweichung in Gitterpunkten.
;                           alternativ kann in HWB die Halbwertsbreite angegeben werden.
;	
; KEYWORD PARAMETERS: s.o.
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Die Gewichte der Delay-Weight-Struktur werden entsprechend geändert.
;
; RESTRICTIONS: ---
;
; PROCEDURE: Default, Setweight
;
; EXAMPLE: SetGaussWeight (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17)
;
;              Setzt sie Gewichte, die von Neuron (1,2) ausgehen so, daß sie gaußförmig in den Targetlayer verlaufen,
;              und zwar am stärksten auf Neuron (23,17).
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetGaussWeight, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4
;
; MODIFICATION HISTORY:
;
;       Fri Aug 1 17:55:26 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion fertiggestellt.
;
;-

Pro SetGaussWeight, DWS, Amp, Sigma, HWB=hwb, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col

   Default, Amp, 1

   SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
              Amp * Gauss_2D(DWS.target_h, DWS.target_w, Sigma, HWB=hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row)

end
