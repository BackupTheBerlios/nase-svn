;+
; NAME: SetGaussWeight
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur 
;                 - die von einem Neuron im Source-Layer wegführenden Verbindungen
;          oder   - die zu  einem Neuron im Target-Layer hinführenden Verbindungen 
;          gaussförmig.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetGaussWeight ( DWS
;                                   [,Maximum] [,Sigma | ,HWB=Halbwertsbreite]
;                                   {  ,S_ROW=Source_Row, S_COL=Source_Col, T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                    | ,T_ROW=Source_Row, T_COL=Source_Col, S_HS_ROW=Target_HotSpot_Row, S_HS_COL=Target_HotSpot_Col}
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] 
;                                   [,TRANSPARENT])
;
;
; 
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;
;         dann ENTWEDER     S_ROW:    Zeilennr des Sourceneurons im Sourcelayer
;        (Source->Target)   S_COL:    Spaltennr
;                           T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das die max. Verbindungsstärke (Bergspitze) erhält
;                           T_HS_COL: Spaltennr
;           
;                  ODER     T_ROW:    Zeilennr des Targetneurons im Targetlayer
;        (Target->Source)   T_COL:    Spaltennr
;                           S_HS_ROW: Zeilennr des Sourceneurons im Sourcelayer, das die max. Verbindungsstärke (Bergspitze) erhält
;                           S_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: Stärke der stärksten Verbindung (Höhe der Bergspitze)
;                  Sigma  : Standardabweichung in Gitterpunkten.
;                           alternativ kann in HWB die Halbwertsbreite angegeben werden.
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRANSPARENT : s. SetWeight!
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
;       Tue Sep 2 00:37:58 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		kann jetzt auch Verbindungen Target->Source setzen.
;
;       Tue Aug 5 17:56:10 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TRUNCATE, TRUNC_VALUE zugefügt.
;
;       Mon Aug 4 01:14:21 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		ALL, LWX, LWY zugefügt.
;
;       Fri Aug 1 17:55:26 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion fertiggestellt.
;
;-

Pro SetGaussWeight, DWS, Amp, Sigma, HWB=hwb, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                       T_ROW=t_row, T_COL=t_col, S_HS_ROW=S_hs_row, S_HS_COL=S_hs_col, $
                       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
                       TRANSPARENT=transparent

   Default, Amp, 1

   If set(s_row) or set(s_col) or set(t_hs_row) or set(t_hs_col) then begin ;Wir definieren TOS:
   
      if not(set(s_row)) or not(set(s_col)) or not(set(t_hs_row)) or not(set(t_hs_col)) then $
       message, 'Zur Definition der Source->Target Verbindungen bitte alle vier Schlüsselworte S_ROW, S_COL, T_HS_ROW, T_HS_COL angeben!'

      SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
       Amp * Gauss_2D(DWS.target_h, DWS.target_w, Sigma, HWB=hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row), $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
       TRANSPARENT=transparent

   endif else begin             ; Wir definieren FROMS:

      if not(set(t_row)) or not(set(t_col)) or not(set(s_hs_row)) or not(set(s_hs_col)) then $
       message, 'Zur Definition der Target->Source Verbindungen bitte alle vier Schlüsselworte T_ROW, T_COL, S_HS_ROW, S_HS_COL angeben!'
      
      SetWeight, DWS, T_ROW=t_row, T_COL=t_col, $
       Amp * Gauss_2D(DWS.source_h, DWS.source_w, Sigma, HWB=hwb, Y0_ARR=s_hs_col, X0_ARR=s_hs_row), $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
       TRANSPARENT=transparent

   endelse

end
