;+
; NAME:
;  SetConstDelay
;
; AIM: Set all connections from single neuron in source layer to fixed delay.
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegführenden
;          Delays konstant bis zu einer maximalen Reichweite.
;
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE: SetConstDelay ( DWS
;                                   [,Wert] [,Range=Reichweite]
;                                    ,S_ROW=Source_Row, S_COL=Source_Col
;                                    ,T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ], [,/INVERSE] )
;
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;         S_ROW:    Zeilennr des Sourceneurons im Sourcelyer
;         S_COL:    Spaltennr
;         T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das das Zentrum des Kreises enthaelt
;         T_HS_COL: Spaltennr
;         INVERSE : Setzt Verbindungen ab einer minimalen Reichweite
;
; OPTIONAL INPUTS: Wert   : Verzoegerung der Verbindungen
;                  Range  : Reichweite in Gitterpunkten. (Reichweite (Radius) des Kreises) (Default ist 1/6 der Targetlayerhöhe)
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRUNCATE, TRUNC_VALUE : s. SetWeight!
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
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.9  2000/09/25 16:49:13  thiel
;           AIMS added.
;
;       Revision 1.8  1998/11/09 10:40:43  saam
;             NOCON (Range) cut radius+1
;
;       Revision 1.7  1998/11/08 17:47:00  saam
;             + problems with TARGET_TO_SOURCE and SOURCE_TO_TARGET corrected
;             + problem with NOCON corrected
;
;       Revision 1.6  1998/02/05 13:16:04  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.5  1997/12/10 15:53:41  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 1.4  1997/09/17 10:25:55  saam
;       Listen&Listen in den Trunk gemerged
;
;
;       Sun Sep 7 23:31:36 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;               Keyword Transparent analog zu SetConstWeight.pro implementiert		
;
;       Sun Sep 7 16:36:30 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Keyword Inverse hinzugefuegt
;
;       Thu Aug 14 11:52:03 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion erstellt, durch Modifikation von setconstweight.pro
;

Pro SetConstDelay, DWS, Amp, Range, $
                   S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                   T_ROW=t_row, T_COL=t_col, S_HS_ROW=S_hs_row, S_HS_COL=S_hs_col, $
                   ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, INVERSE=inverse,$
                   TRANSPARENT=transparent

   tw = DWDim(DWS, /TW)
   th = DWDim(DWS, /TH)
   sw = DWDim(DWS, /SW)
   sh = DWDim(DWS, /SH)

   Default, Range, th/6  
   Default, Amp, 1

   IF set(s_row) OR set(s_col) OR set(t_hs_row) OR set(t_hs_col) THEN BEGIN ;Wir definieren TOS:
      
      if not(set(s_row)) or not(set(s_col)) or not(set(t_hs_row)) or not(set(t_hs_col)) then $
       message, 'Zur Definition der Source->Target Verbindungen bitte alle vier Schlüsselworte S_ROW, S_COL, T_HS_ROW, T_HS_COL angeben!'
      
      IF Keyword_Set(inverse) THEN BEGIN
         SetDelay, DWS, Amp*(Range LE ROUND(Shift(Dist(th, tw), t_hs_row, t_hs_col))),$
          S_ROW=s_row, S_COL=s_col, $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value,$
          TRANSPARENT=transparent
      END ELSE BEGIN
         SetDelay, DWS, Amp*(Range GT ROUND(Shift(Dist(th, tw), t_hs_row, t_hs_col))),$
          S_ROW=s_row, S_COL=s_col, $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value,$
          TRANSPARENT=transparent
      END

   ENDIF ELSE BEGIN             ; Wir definieren FROMS:
      
      if not(set(t_row)) or not(set(t_col)) or not(set(s_hs_row)) or not(set(s_hs_col)) then $
       message, 'Zur Definition der Target->Source Verbindungen bitte alle vier Schlüsselworte T_ROW, T_COL, S_HS_ROW, S_HS_COL angeben!'
      
      IF Keyword_Set(inverse) THEN BEGIN
         SetDelay, DWS, T_ROW=t_row, T_COL=t_col, $
          Amp*((Range LE ROUND(Shift(Dist(sh, sw), s_hs_row, s_hs_col)))), $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
          TRANSPARENT=transparent
      END ELSE BEGIN
         SetDelay, DWS, T_ROW=t_row, T_COL=t_col, $
          Amp*(Range GT ROUND(Shift(Dist(sh, sw), s_hs_row, s_hs_col))), $
          ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
          TRANSPARENT=transparent
      ENDELSE 
      
      
   ENDELSE 

END
