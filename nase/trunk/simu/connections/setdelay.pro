;+
; NAME: SetDelay
;
;
;
; PURPOSE: Schreibt ein oder mehrere Delays in eine
;          Delay_Weight-Struktur.
;
;          Diese Prozedur ist das Gegenstück zu GetDelay().
;          Die Aufrufe sind kompatibel, bis auf den Unterschied, daß
;          SetDelay eine Prozedur ist, und hier als zweites Argument das (die) Delay(s)
;          angegeben wird.
;
;
;
; CATEGORY: Simulation
;
;
;
; CALLING SEQUENCE:           SetDelay ( D_W_Struktur, Delay,
;                                         {   ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index )
;                                           | ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                           | ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index ) ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                         }
;                                       )
;
;                            wizzig, nich? Wer's nicht kapiert: siehe GetDelay()!
;
;
; 
; INPUTS: Delay: Delay(array), das gesetzt werden soll.
;         alles andere: siehe GetDelay()
;
;
; OPTIONAL INPUTS:siehe GetDelay()
;
;
;	
; KEYWORD PARAMETERS:siehe GetDelay()
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
; RESTRICTIONS: Die übergebenen Delays müssen je nach Kontext
;               entweder ein Skalar oder ein Array mit entsprechenden
;               imensionen (s. GetDelay() ) sein!
;
;               Das alles geht natürlich nur, wenn die Struktur mit
;               Delays initialisiert wurde!
;
;
;
; PROCEDURE:siehe GetDelay()
;
;
;
; EXAMPAMPLE:siehe GetDelay()
;
;
;
; MODIFICATION HISTORY:
;
;       Wed Jul 30 19:01:23 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt, im wesentlichen durch Kopieren von
;		SetWeight.
;
;
;-

Pro SetDelay, V_Matrix, Delay, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index
    
   if V_Matrix.Delays(0) eq -1 then message, 'Die übergebene Delay-Weight-Struktur enthält gar keine Delays!'

    s = size(Delay)

    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.source_h) or (s(2) ne V_Matrix.source_w) then message, 'Das übergebene Array muß die Ausmaße des Source-Layers haben!'

       if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       V_Matrix.Delays(t_index, *) = Delay 

    end

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:

       if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)

       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.target_h) or (s(2) ne V_Matrix.target_w) then message, 'Das übergebene Array muß die Ausmaße des Target-Layers haben!'

       V_Matrix.Delays(*, s_index) = Delay
   
   end


   if (set(S_ROW) or set(S_INDEX)) and (set(T_ROW) or set(T_INDEX)) then begin ; Nur einzelne Verbindung zurückliefern:

      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)

      if s(0) gt 1 then message, 'Skalares Delay erwartet!'

      V_Matrix.Delays(t_index, s_index) = Delay

   end

end   






