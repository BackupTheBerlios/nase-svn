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
;                                         [ ,ALL [ ,LWX ,LWY] ]
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
; KEYWORD PARAMETERS: ALL: Wird dieses Keyword gesetzt, so werden
;                          nicht nur die Delays für das angegebene
;                          Neuron gesetzt, sondern auch die aller
;                          anderen. Dabei wird die übergebene
;                          Delaymatrix entsprechend verschoben. Die
;                          Verschiebung wird so berechnet, daß die
;                          resultierenden HotSpots gleichmäßig im
;                          Layer verteilt sind. Wird eine andere
;                          Verschiebung gewünscht, so kann die
;                          Laufweite in LWX und LWY übergeben werden.
;
;                     alles andere: siehe GetDelay()
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
;       Tue Aug 5 17:50:20 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TRUNCATE, TRUNC_VALUE zugefügt.
;
;       Mon Aug 4 01:01:40 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		ALL, LWX, LWY zugefügt.
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
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index, $
                                    ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value
    
   s = size(Delay)

    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.source_h) or (s(2) ne V_Matrix.source_w) then message, 'Das übergebene Array muß die Ausmaße des Source-Layers haben!'

       if not set(t_index) then begin
          t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       endif else begin 
          t_row = LayerRow(INDEX=t_index, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
          t_col = LayerCol(INDEX=t_index, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       end
       if keyword_set(ALL) then begin
          Default, LWX, V_Matrix.source_w/V_Matrix.target_w
          Default, LWY, V_Matrix.source_h/V_Matrix.target_h
;          Delay = Shift(Delay, -LWY*t_row, -LWX*t_col)
          for x=-t_col, V_Matrix.target_w-1-t_col do begin
             for y=-t_row, v_Matrix.target_h-1-t_row do begin
                if keyword_set(TRUNCATE) then V_Matrix.Delays(Layerindex(ROW=y+t_row, COL=x+t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h), *)=NoRot_Shift(Delay, LWY*y, LWX*x, WEIGHT=TRUNC_VALUE) $
                   else V_Matrix.Delays(Layerindex(ROW=y+t_row, COL=x+t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h), *)=Shift(Delay, LWY*y, LWX*x)
             endfor
          endfor
       end else V_Matrix.Delays(t_index, *) = Delay 

    end

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:
       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.target_h) or (s(2) ne V_Matrix.target_w) then message, 'Das übergebene Array muß die Ausmaße des Target-Layers haben!'

       if not set(s_index) then begin
          s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
       endif else begin
          s_row = LayerRow(INDEX=s_index, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
          s_col = LayerCol(INDEX=s_index, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
       end
       if keyword_set(ALL) then begin
          Default, LWX, V_Matrix.target_w/V_Matrix.source_w
          Default, LWY, V_Matrix.target_h/V_Matrix.source_h
;          Delay = Shift(Delay, -LWY*s_row, -LWX*s_col)
          for x=-s_col, V_Matrix.source_w-1-s_col do begin
             for y=-s_row, v_Matrix.source_h-1-s_row do begin
                if Keyword_set(TRUNCATE) then V_Matrix.Delays(*, Layerindex(ROW=y+s_row, COL=x+s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h) )=NoRot_Shift(Delay, LWY*y, LWX*x, WEIGHT=TRUNC_VALUE) $
                else V_Matrix.Delays(*, Layerindex(ROW=y+s_row, COL=x+s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h) )=Shift(Delay, LWY*y, LWX*x)
             endfor
          endfor
       end else V_Matrix.Delays(*, s_index) = Delay
    end


   if (set(S_ROW) or set(S_INDEX)) and (set(T_ROW) or set(T_INDEX)) then begin ; Nur einzelne Verbindung zurückliefern:

      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)

      if s(0) gt 1 then message, 'Skalares Gewicht erwartet!'

      V_Matrix.Delays(t_index, s_index) = Delay

   end

end   
