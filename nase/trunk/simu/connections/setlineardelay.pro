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
;                                   {  ,S_ROW=Source_Row, S_COL=Source_Col, T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                    | ,T_ROW=Source_Row, T_COL=Source_Col, S_HS_ROW=Target_HotSpot_Row, S_HS_COL=Target_HotSpot_Col}
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] )
;
;
; 
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;
;         dann ENTWEDER     S_ROW:    Zeilennr des Sourceneurons im Sourcelayer
;        (Source->Target)   S_COL:    Spaltennr
;                           T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das die min. Verbindungsstärke (Kegelspitze) erhält
;                           T_HS_COL: Spaltennr
;           
;                  ODER     T_ROW:    Zeilennr des Targetneurons im Targetlayer
;        (Target->Source)   T_COL:    Spaltennr
;                           S_HS_ROW: Zeilennr des Sourceneurons im Sourcelayer, das die min. Verbindungsstärke (Kegelspitze) erhält
;                           S_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: Größe der größten Delays (Höhe der "Ebene", in die der Kegel eingebettet wird.)
;                  Minimum: Größe des kleinsten Delays (absolute Höhe der Kegelspitze)
;                  Range  : Reichweite in Gitterpunkten. (Radius der Kegelgrundfläche) (Default ist 1/6 der Targetlayerhöhe)
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRUNCATE, TRUNC_VALUE : s. SetDelay!
;
; SIDE EFFECTS: Die Delays der Delay-Weight-Struktur werden entsprechend geändert.
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
;       $Log$
;       Revision 1.5  1998/02/05 13:16:08  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.4  1997/12/10 15:53:45  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;
;       Tue Sep 2 00:51:40 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		kann jetzt auch Verbindungen Target->Source setzen.
;
;       Wed Aug 6 16:39:16 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch Übernahme von SetGaussDelay.
;
;-

Pro SetLinearDelay, DWS, Amp, Range, MIN=min, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                       T_ROW=t_row, T_COL=t_col, S_HS_ROW=S_hs_row, S_HS_COL=S_hs_col, $
                       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

   tw = DWDim(DWS, /TW)
   th = DWDim(DWS, /TH)
   sw = DWDim(DWS, /SW)
   sh = DWDim(DWS, /SH)


   Default, Range, th/6
   Default, Amp, 1
   Default, min, 0
   Default, trunc_value, Amp

   If set(s_row) or set(s_col) or set(t_hs_row) or set(t_hs_col) then begin ;Wir definieren TOS:
   
      if not(set(s_row)) or not(set(s_col)) or not(set(t_hs_row)) or not(set(t_hs_col)) then $
       message, 'Zur Definition der Source->Target Verbindungen bitte alle vier Schlüsselworte S_ROW, S_COL, T_HS_ROW, T_HS_COL angeben!'

      SetDelay, DWS, S_ROW=s_row, S_COL=s_col, $
       min + (Amp-min)/double(Range)*(Range < Shift(Dist(th, tw), t_hs_row, t_hs_col)), $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value

   endif else begin             ; Wir definieren FROMS:
      
      if not(set(t_row)) or not(set(t_col)) or not(set(s_hs_row)) or not(set(s_hs_col)) then $
       message, 'Zur Definition der Target->Source Verbindungen bitte alle vier Schlüsselworte T_ROW, T_COL, S_HS_ROW, S_HS_COL angeben!'

      SetDelay, DWS, T_ROW=t_row, T_COL=t_col, $
       min + (Amp-min)/double(Range)*(Range < Shift(Dist(sh, sw), s_hs_row, s_hs_col)), $
       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value
      
   endelse

end
