;+
; NAME: SetDOGWeight
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegf�hrenden
;          Verbindungen Mexica-Hat-f�rmig. (DOG="Difference of Gaussians")
;
; CATEGORY: SIMU/CONNECTIONS
;
; CALLING SEQUENCE: SetDOGWeight ( DWS
;                                   [,Maximum] [,On_Sigma | ,ON_HWB=Halbwertsbreite] [,Off_Sigma | ,OFF_HWB=Halbwertsbreite]
;                                   {  ,S_ROW=Source_Row, S_COL=Source_Col, T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                    | ,T_ROW=Source_Row, T_COL=Source_Col, S_HS_ROW=Target_HotSpot_Row, S_HS_COL=Target_HotSpot_Col}
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] 
;                                   [,TRANSPARENT] [,INITSDW])
;
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;
;         dann ENTWEDER     S_ROW:    Zeilennr des Sourceneurons im Sourcelayer
;        (Source->Target)   S_COL:    Spaltennr
;                           T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das die max. Verbindungsst�rke (Bergspitze) erh�lt
;                           T_HS_COL: Spaltennr
;           
;                  ODER     T_ROW:    Zeilennr des Targetneurons im Targetlayer
;        (Target->Source)   T_COL:    Spaltennr
;                           S_HS_ROW: Zeilennr des Sourceneurons im Sourcelayer, das die max. Verbindungsst�rke (Bergspitze) erh�lt
;                           S_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: St�rke der Verbindung im Zentrum (H�he der Bergspitze)
;                  On_Sigma/Off_Sigma  : Standardabweichung der Teil-G�usse in Gitterpunkten.
;                                        alternativ kann in ON_HWB/OFF_HWB die Halbwertsbreite angegeben werden.
;	
;                                        Merke: F�r On_Sigma < Off_Sigma erh�lt man ein ON-Center/OFF-Surround - Feld.
;                                               F�r On_Sigma > Off_SIgma erh�lt man ein OFF-Center/ON-Surround - Feld.
;
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRANSPARENT, INITSDW : s.a. <A HREF="#SETWEIGHT">SetWeight()</A>
;
; SIDE EFFECTS: Die Gewichte der Delay-Weight-Struktur werden entsprechend ge�ndert.
;
; PROCEDURE: Default, Setweight, Gauss_2D()
;
; EXAMPLE: SetDOGWeight (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 1, 2, 4)
;
;              Setzt sie Gewichte, die von Neuron (1,2) ausgehen so, da� sie DOG-f�rmig in den Targetlayer verlaufen,
;              und zwar mit Zentrum auf Neuron (23,17). Die DOG-Maske ist eine �berlagerung eines positiven Gau�bergs mit sigma=2
;              unf eines negativen Gau�bergs mit sigma=4.
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
;       $Log$
;       Revision 1.7  1998/02/10 14:26:46  kupper
;              Tippfehler korrigiert.
;
;       Revision 1.6  1998/02/05 13:16:06  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.5  1997/12/10 15:53:43  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;
;       Mon Sep 8 17:23:16 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		kann jetzt auch Verbindungen Target->Source setzen.
;
;       Wed Aug 6 14:25:42 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch �bernahme von SetGaussWeight.
;
;-

Pro SetDOGWeight, DWS, Amp, On_Sigma, Off_Sigma, ON_HWB=on_hwb, OFF_HWB=off_hwb, $
                  S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                  T_ROW=t_row, T_COL=t_col, S_HS_ROW=S_hs_row, S_HS_COL=S_hs_col, $
                  ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
                  TRANSPARENT=transparent, _EXTRA=extra


   tw = DWDim(DWS, /TW)
   th = DWDim(DWS, /TH)
   sw = DWDim(DWS, /SW)
   sh = DWDim(DWS, /SH)
   

   Default, Amp, 1


   If set(s_row) or set(s_col) or set(t_hs_row) or set(t_hs_col) then begin ;Wir definieren TOS:
      
      on = Gauss_2D(th, tw, On_Sigma, HWB=on_hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row)
      on = on/total(on)         ; auf Volumen 1 normieren!
      off = Gauss_2D(th, tw, Off_Sigma, HWB=off_hwb, Y0_ARR=t_hs_col, X0_ARR=t_hs_row)
      off = off/total(off)      ; auf Volumen 1 normieren!
      dog = on-off              ; => dog hat Gesamtvolumen 0.
      dog = dog/max([max(dog), -min(dog)])*Amp ; Zentrum auf Amp normieren!

      if not(set(s_row)) or not(set(s_col)) or not(set(t_hs_row)) or not(set(t_hs_col)) then $
       message, 'Zur Definition der Source->Target Verbindungen bitte alle vier Schl�sselworte S_ROW, S_COL, T_HS_ROW, T_HS_COL angeben!'

      SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
       dog, $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
       TRANSPARENT=transparent, _EXTRA=extra

   endif else begin             ; Wir definieren FROMS:

      on = Gauss_2D(sh, sw, On_Sigma, HWB=on_hwb, Y0_ARR=s_hs_col, X0_ARR=s_hs_row)
      on = on/total(on)         ; auf Volumen 1 normieren!
      off = Gauss_2D(sh, sw, Off_Sigma, HWB=off_hwb, Y0_ARR=s_hs_col, X0_ARR=s_hs_row)
      off = off/total(off)      ; auf Volumen 1 normieren!
      dog = on-off              ; => dog hat Gesamtvolumen 0.
      dog = dog/max([max(dog), -min(dog)])*Amp ; Zentrum auf Amp normieren!

      if not(set(t_row)) or not(set(t_col)) or not(set(s_hs_row)) or not(set(s_hs_col)) then $
       message, 'Zur Definition der Target->Source Verbindungen bitte alle vier Schl�sselworte T_ROW, T_COL, S_HS_ROW, S_HS_COL angeben!'
      
      SetWeight, DWS, T_ROW=t_row, T_COL=t_col, $
       dog, $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
       TRANSPARENT=transparent, _EXTRA=extra

   endelse

end












