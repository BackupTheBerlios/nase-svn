;+
; NAME: GetDelay()
;
;
;
; PURPOSE: Liest ein oder mehrere Delays aus einer
;          Delay_Weight-Struktur aus
;
;          Dies ist das Gegenstück zu SetDelay.
;
;
; CATEGORY: Simulation
;
;
;
; CALLING SEQUENCE: Delay = GetDelay ( D_W_Struktur
;                                         {   ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index )
;                                           | ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                           | ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index ) ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                         }
;                                       )
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
;
;                     
;
;
; OUTPUTS: 1. Wenn SOURCE- UND TARGETneuron spezifiziert wurden, ist der Output das Delay dieser Verbindung.
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
; RESTRICTIONS: Geht natürlich nur, wenn die Struktur mit Delays
;               initialisiert wurde!
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
;       Wed Jul 30 18:53:56 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch kopieren von
;		GetWeight().
;
;-  

Function GetDelay, V_Matrix, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index

   if V_Matrix.Delays eq [-1] then message, 'Die übergebene Delay-Weight-Struktur enthält gar keine Delays!'
  
    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       return, reform( V_Matrix.Delays(t_index, *), V_Matrix.source_h, V_Matrix.source_w )

    end

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:

       if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
       return, reform( V_Matrix.Delays(*, s_index),  V_Matrix.target_h, V_Matrix.target_w )
   
 end

; Nur einzelne Verbindung zurückliefern:

 if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
 if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)

 return, V_Matrix.Delays(t_index, s_index)


end   






