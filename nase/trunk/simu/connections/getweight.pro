;+
; NAME: GetWeight()
;
;
;
; PURPOSE: Liest ein oder mehrere Gewichte aus einer
;          Delay_Weight-Struktur aus
;
;          Dies ist das Gegenstück zu SetWeight.
;
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Gewicht = GetWeight ( D_W_Struktur
;                                         {   ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index )
;                                           | ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                           | ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index ) ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                         }
;                                       [, NONE=value])
;
;                            wizzig, nich? Wer's nicht kapiert: s.u.
;
; INPUTS: D_W_Struktur: Eine (initialisierte) Delay_Weight_Struktur, aus der Gewichte gelesen werden sollen. 
;
; KEYWORD PARAMETERS: S_ROW, S_COL: Zeile und Spalte des SourceNourons. Alternativ kann der eindimensionale Index in S_INDEX angegeben werden.
;                     T_ROW, T_COL: Zeile und Spalte des SourceNourons. Alternativ kann der eindimensionale Index in T_INDEX angegeben werden.
;                     NONE        : Nichtexistierende Verbindungen werden auf den Wert value gesetzt
;
; OUTPUTS: 1. Wenn SOURCE- UND TARGETneuron spezifiziert wurden, ist der Output das Gewicht dieser Verbindung.
;          2. Wenn NUR das SOURCEneuron spezifiziert wurde (weder T_ROW, T_COL noch T_INDEX angegeben),
;             so ist der Output das Array aller von diesem Neuron wegführenden Verbindungen.
;             Das Array ist ZWEIDIMENSIONAL und hat die Ausmaße des Target-Layers.
;          3. Wenn NUR das TARGETneuron spezifiziert wurde (weder S_ROW, S_COL noch S_INDEX angegeben),
;             so ist der Output das Array aller zu diesem Neuron hinführenden Verbindungen.
;             Das Array ist ZWEIDIMENSIONAL und hat die Ausmaße des Source-Layers.
;
; PROCEDURE: Set(), LayerIndex()
;
; MODIFICATION HISTORY:
;
;
;       $Log$
;       Revision 1.6  1998/05/16 16:02:20  kupper
;              Verarbeitet jetzt auch Arrays von Indizes...
;
;       Revision 1.5  1998/02/05 13:16:02  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.4  1997/12/10 15:53:39  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 1.3  1997/11/11 10:24:06  gabriel
;             Keyword NONE hinzugefuegt. Dient zum Ersetzen der "Nicht-Verbindungen"
;             mit einem anderen Wert als !NONE
; 
;
;       Tue Jul 29 18:22:18 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion fertiggestellt.
;
;       Mon Jul 28 16:48:52 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt.
;-

Function GetWeight, DW, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index, NONE=none


   IStr = Info(DW) 
   IF (IStr EQ 'SDW_WEIGHT') OR (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_WEIGHT') AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'DW structure expected, but got '+iStr+' !'

   tw = DWDim(DW, /TW)
   th = DWDim(DW, /TH)
   sw = DWDim(DW, /SW)
   sh = DWDim(DW, /SH)
   W  = Weights(DW)


   if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:
      
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=tw, HEIGHT=th)
      ERG = W(t_index, *)
      ERG = reform(/OVERWRITE, ERG, n_elements(t_index), sh, sw)
      ERG = reform(/OVERWRITE, ERG) ;kill leading/trailing 1s

      If set(NONE) THEN BEGIN
         n_index = where(ERG EQ !NONE,n_count)
         IF n_count GT 0 THEN ERG(n_index) = none
      ENDIF
      return, ERG      
   end
   
   
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:
      
      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=sw, HEIGHT=sh)
      ERG = W(*, s_index)
      ERG = reform( /OVERWRITE, ERG, n_elements(s_index), th, tw)
      ERG = reform(/OVERWRITE, ERG) ;kill leading/trailing 1s
     
      If set(NONE) THEN BEGIN
         n_index = where(ERG EQ !NONE,n_count)
         IF n_count GT 0 THEN ERG(n_index) = none
      ENDIF
      return, ERG  
      
   end
   
; Nur einzelne Verbindung zurückliefern:
   
   if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=sw, HEIGHT=sh)
   if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=tw, HEIGHT=th)
   ERG =  W(t_index, s_index)
   If set(NONE) THEN BEGIN
      IF ERG EQ !NONE THEN ERG = none
   ENDIF
   return, ERG
   
   
end   






