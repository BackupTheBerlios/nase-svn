;+
; NAME: SetWeight
;
;
;
; PURPOSE: Schreibt ein oder mehrere Gewichte in eine
;          Delay_Weight-Struktur.
;
;          Diese Prozedur ist das Gegenstück zu GetWeight().
;          Die Aufrufe sind kompatibel, bis auf den Unterschied, daß
;          SetWeight eine Prozedur ist, und hier als zweites Argument das (die) Gewicht(e)
;          angegeben wird.
;
;
;
; CATEGORY: Simulation
;
;
;
; CALLING SEQUENCE: Gewicht = GetWeight ( D_W_Struktur, Gewicht,
;                                         {   ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index )
;                                           | ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                           | ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index ) ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                         }
;                                       )
;
;                            wizzig, nich? Wer's nicht kapiert: siehe GetWeight()!
;
;
; 
; INPUTS: Gewicht: Gewicht(sarray), das gesetzt werden soll.
;         alles andere: siehe GetWeight()
;
;
; OPTIONAL INPUTS:siehe GetWeight()
;
;
;	
; KEYWORD PARAMETERS:siehe GetWeight()
;
;
;
; OUTPUTS: ---
;
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
; RESTRICTIONS:siehe GetWeight()
;
;
;
; PROCEDURE:siehe GetWeight()
;
;
;
; EXAMPAMPLE:siehe GetWeight()
;
;
;
; MODIFICATION HISTORY:
;
;       Wed Jul 30 18:14:23 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion fertiggestellt.
;
;       Mon Jul 28 16:48:52 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt.
;-

Pro SetWeight, V_Matrix, Weight, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index
    
   s = size(Weight)

    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.source_h) or (s(2) ne V_Matrix.source_w) then message, 'Das übergebene Array muß die Ausmaße des Source-Layers haben!'

       if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       V_Matrix.Weights(t_index, *) = Weight 

    end

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:

       if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)

       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.target_h) or (s(2) ne V_Matrix.target_w) then message, 'Das übergebene Array muß die Ausmaße des Target-Layers haben!'

       V_Matrix.Weights(*, s_index) = Weight
   
   end


   if (set(S_ROW) or set(S_INDEX)) and (set(T_ROW) or set(T_INDEX)) then begin ; Nur einzelne Verbindung zurückliefern:

      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)

      if s(0) gt 1 then message, 'Skalares Gewicht erwartet!'

      V_Matrix.Weights(t_index, s_index) = Weight

   end

end   






