;+
; NAME: SetConstWeight
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Verbindungen konstant bis zu einer maximalen Reichweite.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: SetConstWeight ( DWS
;                                   [,Wert] [,Range=Reichweite]
;                                   {  ,S_ROW=Source_Row, S_COL=Source_Col, T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                    | ,T_ROW=Source_Row, T_COL=Source_Col, S_HS_ROW=Target_HotSpot_Row, S_HS_COL=Target_HotSpot_Col}
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ]
;                                   [,TRANSPARENT] [,INVERSE][,INITSDW] )
;
; INPUTS: DWS     : Eine (initialisierte!) Delay-Weight-Struktur
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
; OPTIONAL INPUTS: Wert   : Stärke der Verbindungen
;                  Range  : Reichweite in Gitterpunkten. (Reichweite (Radius) des Kreises) (Default ist 1/6 der Targetlayerhöhe)
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRUNCATE, TRUNC_VALUE, TRANSPARENT, INITSDW : s.a. <A HREF="#SETWEIGHT">SetWeight()</A>
;                     INVERSE : Setzt Verbindungen ab einer minimalen Reichweite
;
; SIDE EFFECTS: Die Delays der Delay-Weight-Struktur werden entsprechend geändert.
;
; PROCEDURE: Default, Setweight
;
; EXAMPLE: SetConstWeight (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 10)
;
;              Setzt sie Gewichte, die von Neuron (1,2) ausgehen so, daß sie kegelförmig in den Targetlayer verlaufen,
;              und zwar am stärksten auf Neuron (23,17).
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetConstWeight, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.6  1997/11/17 17:44:38  gabriel
;             INITSDW Keyword eingesetzt
;
;       Revision 1.5  1997/10/20 14:14:09  kupper
;       Kann jetzt auch Target->Source-Verbindungen.
;
;
;       Mon Aug 18 13:10:06 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Keyword Inverse hinzugef"ugt
;
;       Thu Aug 14 11:52:03 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion erstellt, durch Modifikation von setlinearweight.pro von Ruediger
;
;-

Pro SetConstWeight, DWS, Amp, Range, $
                    S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                    T_ROW=t_row, T_COL=t_col, S_HS_ROW=S_hs_row, S_HS_COL=S_hs_col, $
                    ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
                    INVERSE=inverse, TRANSPARENT=transparent, _EXTRA=extra

   Default, Range, DWS.target_h/6  
   Default, Amp, 1

   If set(s_row) or set(s_col) or set(t_hs_row) or set(t_hs_col) then begin ;Wir definieren TOS:
      
      if not(set(s_row)) or not(set(s_col)) or not(set(t_hs_row)) or not(set(t_hs_col)) then $
       message, 'Zur Definition der Source->Target Verbindungen bitte alle vier Schlüsselworte S_ROW, S_COL, T_HS_ROW, T_HS_COL angeben!'

      IF Keyword_Set(inverse) THEN BEGIN
         SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
          Amp*((Range LE Shift(Dist(DWS.target_h, DWS.target_w), t_hs_row, t_hs_col))), $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, TRANSPARENT=transparent, _EXTRA=extra
      END ELSE BEGIN
         SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
          Amp*(Range GT Shift(Dist(DWS.target_h, DWS.target_w), t_hs_row, t_hs_col)), $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, TRANSPARENT=transparent, _EXTRA=extra
      END

   endif else begin             ; Wir definieren FROMS:

      if not(set(t_row)) or not(set(t_col)) or not(set(s_hs_row)) or not(set(s_hs_col)) then $
       message, 'Zur Definition der Target->Source Verbindungen bitte alle vier Schlüsselworte T_ROW, T_COL, S_HS_ROW, S_HS_COL angeben!'
      
      IF Keyword_Set(inverse) THEN BEGIN
         SetWeight, DWS, T_ROW=t_row, T_COL=t_col, $
          Amp*((Range LE Shift(Dist(DWS.source_h, DWS.source_w), s_hs_row, s_hs_col))), $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, TRANSPARENT=transparent, _EXTRA=extra
      END ELSE BEGIN
         SetWeight, DWS, T_ROW=t_row, T_COL=t_col, $
          Amp*(Range GT Shift(Dist(DWS.source_h, DWS.source_w), s_hs_row, s_hs_col)), $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, TRANSPARENT=transparent, _EXTRA=extra
      END
      
   endelse

END
