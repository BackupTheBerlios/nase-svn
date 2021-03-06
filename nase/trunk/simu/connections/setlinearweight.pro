;+
; NAME:
;  SetLinearWeight
;
; AIM: Set connection strengths decreasing linearly with distance.
;
; PURPOSE: Besetzt in einer gegebenen Delay-Weight-Struktur die von einem Neuron im Source-Layer wegf�hrenden
;          Verbindungen kegelf�rmig.
;
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE: SetLinearWeight ( DWS
;                                   [,Maximum] [,Range=Reichweite]
;                                    ,S_ROW=Source_Row, S_COL=Source_Col
;                                    ,T_HS_ROW=Target_HotSpot_Row, T_HS_COL=Target_HotSpot_Col
;                                   [,ALL [,LWX ,LWY] [TRUNCATE, [,TRUNC_VALUE]] ] 
;                                   [,TRANSPARENT])
;
; INPUTS: DWS  :    Eine (initialisierte!) Delay-Weight-Struktur
;         S_ROW:    Zeilennr des Sourceneurons im Sourcelyer
;         S_COL:    Spaltennr
;         T_HS_ROW: Zeilennr des Targetneurons im Targetlayer, das die max. Verbindungsst�rke (Kegelspitze) erh�lt
;         T_HS_COL: Spaltennr
;
; OPTIONAL INPUTS: Maximum: St�rke der st�rksten Verbindung (H�he der Kegelspitze)
;                  Range  : Reichweite in Gitterpunkten. (Radius der Kegelgrundfl�che) (Default ist 1/6 der Targetlayerh�he)
;	
; KEYWORD PARAMETERS: s.o. -  ALL, LWX, LWY, TRUNCATE, TRUNC_VALUE, TRANSPARENT : s. SetWeight!
;
; SIDE EFFECTS: Die Delays der Delay-Weight-Struktur werden entsprechend ge�ndert.
;
; PROCEDURE: Default, Setweight
;
; EXAMPLE: SetLinearWeight (My_DWS, S_ROW=1, S_COL=2, T_HS_ROW=23, T_HS_COL=17, 10)
;
;              Setzt sie Gewichte, die von Neuron (1,2) ausgehen so, da� sie kegelf�rmig in den Targetlayer verlaufen,
;              und zwar am st�rksten auf Neuron (23,17).
;
;          Volles Beispiel:
;                           p = initpara_1()
;                           l1 = initlayer_1(width=2,  height=3,  type=p)
;                           l2 = initlayer_1(width=40, height=50, type=p)
;                           My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                           SetLinearWeight, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                           ShowWeights, My_DWS, /FROMS,  Groesse=4
;
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.5  2000/09/25 16:49:14  thiel
;           AIMS added.
;
;       Revision 1.4  1998/02/05 13:16:08  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.3  1997/12/10 15:53:45  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;
;       Wed Aug 6 16:51:48 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen Durch �bernahme von SetGaussWeight und SetLinearDelay
;

PRO SetLinearWeight, DWS, Amp, Range, $
                       S_ROW=s_row, S_COL=s_col, T_HS_ROW=t_hs_row, T_HS_COL=t_hs_col, $
                       ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
                       TRANSPARENT=transparent


   tw = DWDim(DWS, /TW)
   th = DWDim(DWS, /TH)

   Default, Range, th/6  
   Default, Amp, 1

   SetWeight, DWS, S_ROW=s_row, S_COL=s_col, $
              Amp - Amp/double(Range)*(Range < Shift(Dist(th, tw), t_hs_row, t_hs_col)), $
              ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
              TRANSPARENT=transparent

END
