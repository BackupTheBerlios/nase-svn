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
;
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
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS: S_ROW, S_COL: Zeile und Spalte des SourceNourons. Alternativ kann der eindimensionale Index in S_INDEX angegeben werden.
;                     T_ROW, T_COL: Zeile und Spalte des SourceNourons. Alternativ kann der eindimensionale Index in T_INDEX angegeben werden.
;                     NONE        : Nichtexistierende Verbindungen werden auf den Wert value gesetzt
;                     
;
;
; OUTPUTS: 1. Wenn SOURCE- UND TARGETneuron spezifiziert wurden, ist der Output das Gewicht dieser Verbindung.
;          2. Wenn NUR das SOURCEneuron spezifiziert wurde (weder T_ROW, T_COL noch T_INDEX angegeben),
;             so ist der Output das Array aller von diesem Neuron wegführenden Verbindungen.
;             Das Array ist ZWEIDIMENSIONAL und hat die Ausmaße des Target-Layers.
;          3. Wenn NUR das TARGETneuron spezifiziert wurde (weder S_ROW, S_COL noch S_INDEX angegeben),
;             so ist der Output das Array aller zu diesem Neuron hinführenden Verbindungen.
;             Das Array ist ZWEIDIMENSIONAL und hat die Ausmaße des Source-Layers.
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: ---
;
;
;
; SIDE EFFECTS: ---
;
;
;
; RESTRICTIONS: ---
;
;
;
; PROCEDURE: Set(), LayerIndex()
;
;
;
; EXAMPAMPLE:
;
;
;
; MODIFICATION HISTORY:
;
;
;       $Log$
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

Function GetWeight, V_Matrix, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index, NONE=none
    
   if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:
      
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
      ERG = reform( V_Matrix.Weights(t_index, *), V_Matrix.source_h, V_Matrix.source_w )
  
      If set(NONE) THEN BEGIN
       
          n_index = where(ERG EQ !NONE,n_count)
          IF n_count GT 0 THEN ERG(n_index) = none
       ENDIF
      return, ERG      
   end
   
   
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:
      
      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
      ERG = reform( V_Matrix.Weights(*, s_index),  V_Matrix.target_h, V_Matrix.target_w )
     
      If set(NONE) THEN BEGIN
         n_index = where(ERG EQ !NONE,n_count)
         IF n_count GT 0 THEN ERG(n_index) = none
      ENDIF
      return, ERG  
      
   end
   
; Nur einzelne Verbindung zurückliefern:
   
   if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
   if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
   ERG =  V_Matrix.Weights(t_index, s_index)
   If set(NONE) THEN BEGIN
      IF ERG EQ !NONE THEN ERG = none
   ENDIF
   return, ERG
   
   
end   






