;+
; NAME: SetWeight
;
; PURPOSE: Schreibt ein oder mehrere Gewichte in eine
;          Delay_Weight-Struktur.
;
;          Diese Prozedur ist das Gegenstück zu GetWeight().
;          Die Aufrufe sind kompatibel, bis auf den Unterschied, daß
;          SetWeight eine Prozedur ist, und hier als zweites Argument das (die) Gewicht(e) 
;          angegeben wird.
;
; CATEGORY: SIMULATION, CONNECTIONS 
;
; CALLING SEQUENCE:          SetWeight ( D_W_Struktur, Gewicht,
;                                         {   ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index )
;                                           | ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                           | ( ,S_ROW=s_row, S_COL=s_col | ,S_INDEX=s_index ) 
;                                             ( ,T_ROW=t_row, T_COL=t_col | ,T_INDEX=t_index )
;                                         }
;                                         [ ,ALL [,LWX ,LWY] [,TRUNCATE [,TRUNC_VALUE]] ]
;                                         [ ,TRANSPARENT][,INITSDW]
;                                       )
;
;                            wizzig, nich? Wer's nicht kapiert: siehe GetWeight()!
;
; INPUTS: Gewicht: Gewicht(sarray), das gesetzt werden soll.
;         alles andere: siehe GetWeight()
;
; OPTIONAL INPUTS:siehe GetWeight()
;
; KEYWORD PARAMETERS: ALL: Wird dieses Keyword gesetzt, so werden
;                          nicht nur die Gewichte für das angegebene
;                          Neuron gesetzt, sondern auch die aller
;                          anderen. Dabei wird die übergebene
;                          Gewichtsmatrix entsprechend verschoben. Die
;                          Verschiebung wird so berechnet, daß die
;                          resultierenden HotSpots gleichmäßig im
;                          Layer verteilt sind. Wird eine andere
;                          Verschiebung gewünscht, so kann die
;                          Laufweite in LWX und LWY übergeben werden.
;
;                     TRUNCATE: Wird dieses Schluesselwort zusätzlich zu ALL gesetzt, 
;                               so wirden beim Verschieben die Teile,
;                               die über den Rand geschoben werden,
;                               NICHT auf der anderen Seite
;                               hereingerollt. (S. NoRot_Shift() )
;                               Optional kann ein Wert in TRUNC_VALUE
;                               angegeben werden, mit dem die
;                               freiwerdenden Teile des Arrays
;                               aufgefüllt werden. (Vgl. Schlüsselwort
;                               WEIGHT in NoRot_Shift() )
;
;                     TRANSPARENT: Hier kann ein Wert angegeben werden
;                                  (meist wohl 0), der transparent
;                                  erscheint. D.h. an diesen Stellen
;                                  werden die Gewichte in der Matrix
;                                  NICHT ÜBERSCHRIEBEN, sondern
;                                  bleiben unverändert.
;                                  Wird dieses Keyword zusammen mit
;                                  TRUNCATE verwendet, so wird als
;                                  Default die transparente Farbe
;                                  nachgeschoben. (Kann jedoch in
;                                  TRUNC_VALUE explizit angegeben werden.)
;
;                     INITSDW: Initialisiert die dyn. Listen der D_W_Struktur neu (Default: keine Initialisierung)
;                               
;
;                     alles andere: <A HREF="#GETWEIGHT">siehe GetWeight()</A>
;
; RESTRICTIONS: Die übergebenen Gewichte müssen je nach Kontext
;               entweder ein Skalar oder ein Array mit entsprechenden
;               Dimensionen (s. GetWeight() ) sein!
;
; PROCEDURE:siehe GetWeight()
;
; SEE ALSO: <A HREF="#GETWEIGHT">GETWEIGHT</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.13  1997/12/10 15:53:46  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 1.12  1997/12/08 17:31:03  gabriel
;             noch ein paar fehler in der docu
;
;       Revision 1.11  1997/12/08 13:48:14  thiel
;              Druckfehler in der Doku berichtigt.
;
;       Revision 1.10  1997/11/17 17:46:24  gabriel
;             INITSDW Keyword eingefuegt
;
;       Revision 1.9  1997/10/30 12:57:54  kupper
;              Bug beim ALL-Schlüsselwort behoben (Integerdivision durch Fließkomma ersetzt.)
;
;
;       Mon Aug 18 19:35:46 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Schlüsselwort TRANSPARENT zugefügt. Scheiss
;		Arbeit. Sollte aber jetzt funktionieren.
;
;       Tue Aug 5 17:15:27 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TRUNCATE, TRUNC_VALUE zugefügt.
;
;       Mon Aug 4 00:43:52 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		ALL, LWX, LWY zugefügt.
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

Pro SetWeight, _V_Matrix, Weight, All=all, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                                    T_ROW=t_row, T_COL=t_col, T_INDEX=t_index, $
                                    LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
                                    TRANSPARENT=transparent,INITSDW=initsdw

   Handle_Value, _V_Matrix, V_Matrix, /NO_COPY
   
   if set(TRANSPARENT) then Default, trunc_value, transparent
   s = size(Weight)

    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.source_h) or (s(2) ne V_Matrix.source_w) then message, 'Das übergebene Array muß die Ausmaße des Source-Layers haben!'

       count = -1
       if Set(TRANSPARENT) then begin
          boolmaske = Weight ne transparent;Dies ist noch ein 2-dim Array!
          maske =  Where(boolmaske, count); wo wird das Array neu gesetzt? (1-dim)
       endif
       if count eq -1 then begin
          maske = indgen(n_elements(Weight)) ; ganzes Array neu setzen!
          boolmask = Weight-Weight+(1 eq 0) ;lauter FALSEs
       endif

       if not set(t_index) then begin
          t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       endif else begin 
          t_row = LayerRow(INDEX=t_index, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
          t_col = LayerCol(INDEX=t_index, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)
       end
       if keyword_set(ALL) then begin
          Default, LWX, V_Matrix.source_w/float(V_Matrix.target_w)
          Default, LWY, V_Matrix.source_h/float(V_Matrix.target_h)

          for x=-t_col, V_Matrix.target_w-1-t_col do begin
             for y=-t_row, v_Matrix.target_h-1-t_row do begin
                if keyword_set(TRUNCATE) then begin ;truncate
                   if count ne -1 then maske = where(NoRot_Shift(boolmaske, round(LWY*y), round(LWX*x), WEIGHT=(TRUNC_VALUE ne TRANSPARENT))) ;hat transparenten stellen 
                   V_Matrix.Weights(Layerindex(ROW=y+t_row, COL=x+t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h), maske)=(NoRot_Shift(Weight, round(LWY*y), round(LWX*x), WEIGHT=TRUNC_VALUE))(maske)
                endif else begin ;no truncate
                   if count ne -1 then maske = where(Shift(boolmaske, round(LWY*y), round(LWX*x) )) ;hat transparente stellen 
                   V_Matrix.Weights(Layerindex(ROW=y+t_row, COL=x+t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h), maske)=(Shift(Weight, round(LWY*y), round(LWX*x) ))(maske)
                endelse
             endfor
          endfor
       end else V_Matrix.Weights(t_index, maske) = Weight(maske) 

    end

                                ;Nur ein Hinweis: Die Implementierung
                                ;des ALL-Schlüsselwortes hätte man
                                ;rekursiv wesentlich eleganter machen
                                ;können! (Einfach SetWeight wiederholt
                                ;mit Shift(Weight) aufrufen.) Das hätte
                                ;mir auch nicht so viel Kopfzerbrechen
                                ;bereitet, wie das shiften dieser
                                ;ominösen boolmaske. Naja, was solls?
                                ;Rüdiger.

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:
       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne V_Matrix.target_h) or (s(2) ne V_Matrix.target_w) then message, 'Das übergebene Array muß die Ausmaße des Target-Layers haben!'

       count = -1
       if Set(TRANSPARENT) then begin
          boolmaske = Weight ne transparent;Dies ist noch ein 2-dim Array!
          maske =  Where(boolmaske, count); wo wird das Array neu gesetzt? (1-dim)
       endif
       if count eq -1 then begin
          maske = indgen(n_elements(Weight)) ; ganzes Array neu setzen!
          boolmaske = Weight-Weight+(1 eq 0) ;lauter FALSEs
       endif

       if not set(s_index) then begin
          s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
       endif else begin
          s_row = LayerRow(INDEX=s_index, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
          s_col = LayerCol(INDEX=s_index, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
       end
       if keyword_set(ALL) then begin
          Default, LWX, V_Matrix.target_w/float(V_Matrix.source_w)
          Default, LWY, V_Matrix.target_h/float(V_Matrix.source_h)

          for x=-s_col, V_Matrix.source_w-1-s_col do begin
             for y=-s_row, v_Matrix.source_h-1-s_row do begin
                if Keyword_set(TRUNCATE) then begin ;truncate
                   if count ne -1 then maske = where(NoRot_Shift(boolmaske, round(LWY*y), round(LWX*x), WEIGHT=(TRUNC_VALUE ne TRANSPARENT))) ;hat transparenten stellen 
                   V_Matrix.Weights(maske, Layerindex(ROW=y+s_row, COL=x+s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h) )=(NoRot_Shift(Weight, round(LWY*y), round(LWX*x), WEIGHT=TRUNC_VALUE))(maske)
                endif else begin ;no Truncate
                   if count ne -1 then maske = where(Shift(boolmaske, round(LWY*y), round(LWX*x) )) ;hat transparente stellen 
                   V_Matrix.Weights(maske, Layerindex(ROW=y+s_row, COL=x+s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h) )=(Shift(Weight, round(LWY*y), round(LWX*x) ))(maske)
                endelse
             endfor
          endfor
       end else V_Matrix.Weights(maske, s_index) = Weight(maske)
    end


   if (set(S_ROW) or set(S_INDEX)) and (set(T_ROW) or set(T_INDEX)) then begin ; Nur einzelne Verbindung zurückliefern:

      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=V_Matrix.source_w, HEIGHT=V_Matrix.source_h)
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=V_Matrix.target_w, HEIGHT=V_Matrix.target_h)

      if s(0) gt 1 then message, 'Skalares Gewicht erwartet!'

      V_Matrix.Weights(t_index, s_index) = Weight

   end
   IF set(INITSDW) THEN INIT_SDW,V_Matrix

   Handle_Value, _V_Matrix, V_Matrix, /NO_COPY, /SET

end   






