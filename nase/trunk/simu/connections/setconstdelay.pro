;+
; NAME: SetConstDelay
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Delays konstant bis zu einer maximalen Reichweite.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetConstDelay ( DWS
;                                   [,Wert] [,Range=Reichweite]
;                                    ,S_ROW=Source_Row, S_COL=Source_Col
;                                    ,T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] )
;
;
; 
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;         S_ROW:    Zeilennr des Sourceneurons im Sourcelyer
;         S_COL:    Spaltennr
;         T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das das Zentrum des Kreises enthaelt
;         T_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Wert   : Verzoegerung der Verbindungen
;                  Range  : Reichweite in Gitterpunkten. (Reichweite (Radius) des Kreises) (Default ist 1/6 der Targetlayerhöhe)
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRUNCATE, TRUNC_VALUE : s. SetWeight!
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
; PROCEDURE: Default, Setweight
;
; EXAMPLE: SetConstDelay (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 10)
;
;              Setzt sie Gewichte, die von Neuron (1,2) ausgehen so, daß sie kegelförmig in den Targetlayer verlaufen,
;              und zwar am stärksten auf Neuron (23,17).
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetConstDelay, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4
;
; MODIFICATION HISTORY:
;
;       Thu Aug 14 11:52:03 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion erstellt, durch Modifikation von setconstweight.pro
;
;-

Pro SetConstDelay, DWS, Amp, Range, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

   Default, Range, DWS.target_h/6  
   Default, Amp, 1

   SetDelay, DWS, S_ROW=s_row, S_COL=s_col, $
              Amp*(Range GT Shift(Dist(DWS.target_h, DWS.target_w), t_hs_row, t_hs_col)), $
              ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

end
