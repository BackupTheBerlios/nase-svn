;+
; NAME: SetDOGWeight
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Verbindungen Mexica-Hat-förmig. (DOG="Difference of Gaussians")
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetDOGWeight ( DWS
;                                   [,Maximum] [,On_Sigma | ,ON_HWB=Halbwertsbreite] [,Off_Sigma | ,OFF_HWB=Halbwertsbreite]
;                                   {  ,S_ROW=Source_Row, S_COL=Source_Col, T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                    | ,T_ROW=Source_Row, T_COL=Source_Col, S_HS_ROW=Target_HotSpot_Row, S_HS_COL=Target_HotSpot_Col}
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] 
;                                   [,TRANSPARENT] )
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
; OPTIONAL INPUTS: Maximum: Stärke der Verbindung im Zentrum (Höhe der Bergspitze)
;                  On_Sigma/Off_Sigma  : Standardabweichung der Teil-Gäusse in Gitterpunkten.
;                                        alternativ kann in ON_HWB/OFF_HWB die Halbwertsbreite angegeben werden.
;	
;                                        Merke: Für On_Sigma < Off_Sigma erhält man ein ON-Center/OFF-Surround - Feld.
;                                               Für On_Sigma > Off_SIgma erhält man ein OFF-Center/ON-Surround - Feld.
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
; PROCEDURE: Default, Setweight, Gauss_2D()
;
; EXAMPLE: SetDOGWeight (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 1, 2, 4)
;
;              Setzt sie Gewichte, die von Neuron (1,2) ausgehen so, daß sie DOG-förmig in den Targetlayer verlaufen,
;              und zwar mit Zentrum auf Neuron (23,17). Die DOG-Maske ist eine Überlagerung eines positiven Gaußbergs mit sigma=2
;              unf eines negativen Gaußbergs mit sigma=4.
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetDOGWeight, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20, 1, ON_HWB=3, OFF_HWB=7
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4
;
; MODIFICATION HISTORY:
;
;       Mon Sep 8 17:23:16 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		kann jetzt auch Verbindungen Target->Source setzen.
;
;       Wed Aug 6 14:25:42 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch Übernahme von SetGaussWeight.
;
;-

Pro SetDOGWeight, DWS, Amp, On_Sigma, Off_Sigma, ON_HWB=on_hwb, OFF_HWB=off_hwb, $
                  S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                  T_ROW=t_row, T_COL=t_col, S_HS_ROW=S_hs_row, S_HS_COL=S_hs_col, $
                  ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
                  TRANSPARENT=transparent

   Default, Amp, 1


   If set(s_row) or set(s_col) or set(t_hs_row) or set(t_hs_col) then begin ;Wir definieren TOS:
      
      on = Gauss_2D(DWS.target_h, DWS.target_w, On_Sigma, HWB=on_hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row)
      on = on/total(on)         ; auf Volumen 1 normieren!
      off = Gauss_2D(DWS.target_h, DWS.target_w, Off_Sigma, HWB=off_hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row)
      off = off/total(off)      ; auf Volumen 1 normieren!
      dog = on-off              ; => dog hat Gesamtvolumen 0.
      dog = dog/max([max(dog), -min(dog)])*Amp ; Zentrum auf Amp normieren!

      if not(set(s_row)) or not(set(s_col)) or not(set(t_hs_row)) or not(set(t_hs_col)) then $
       message, 'Zur Definition der Source->Target Verbindungen bitte alle vier Schlüsselworte S_ROW, S_COL, T_HS_ROW, T_HS_COL angeben!'

      SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
       dog, $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
       TRANSPARENT=transparent

   endif else begin             ; Wir definieren FROMS:

      on = Gauss_2D(DWS.source_h, DWS.source_w, On_Sigma, HWB=on_hwb, Y0_ARR=s_hs_col, X0_ARR=s_hs_row)
      on = on/total(on)         ; auf Volumen 1 normieren!
      off = Gauss_2D(DWS.source_h, DWS.source_w, Off_Sigma, HWB=off_hwb, Y0_ARR=s_hs_col, X0_ARR=s_hs_row)
      off = off/total(off)      ; auf Volumen 1 normieren!
      dog = on-off              ; => dog hat Gesamtvolumen 0.
      dog = dog/max([max(dog), -min(dog)])*Amp ; Zentrum auf Amp normieren!

      if not(set(t_row)) or not(set(t_col)) or not(set(s_hs_row)) or not(set(s_hs_col)) then $
       message, 'Zur Definition der Target->Source Verbindungen bitte alle vier Schlüsselworte T_ROW, T_COL, S_HS_ROW, S_HS_COL angeben!'
      
      SetWeight, DWS, T_ROW=t_row, T_COL=t_col, $
       dog, $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
       TRANSPARENT=transparent

   endelse

end












