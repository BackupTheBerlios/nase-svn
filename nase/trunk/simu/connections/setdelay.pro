;+
; NAME:
;  SetDelay
;
; AIM: Set delays of single connections contained in DW structure. 
;
; PURPOSE: Schreibt ein oder mehrere Delays in eine
;          Delay_Weight-Struktur.
;
;          Diese Prozedur ist das Gegenstück zu GetDelay().
;          Die Aufrufe sind kompatibel, bis auf den Unterschied, daß
;          SetDelay eine Prozedur ist, und hier als zweites Argument das (die) Delay(s)
;          angegeben wird.
;
; CATEGORY:
;  Simulation / Connections
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
; INPUTS: Delay: Delay(array), das gesetzt werden soll.
;         alles andere: siehe GetDelay()
;
; OPTIONAL INPUTS:siehe GetDelay()
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
; RESTRICTIONS: Die übergebenen Delays müssen je nach Kontext
;               entweder ein Skalar oder ein Array mit entsprechenden
;               imensionen (s. GetDelay() ) sein!
;
;               Das alles geht natürlich nur, wenn die Struktur mit
;               Delays initialisiert wurde!
;
; PROCEDURE:siehe GetDelay()
;
; EXAMPLE:siehe GetDelay()
;
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.13  2000/09/25 16:49:13  thiel
;           AIMS added.
;
;       Revision 1.12  1998/12/15 13:02:20  saam
;             multiple bugfixes
;
;       Revision 1.11  1998/11/08 17:47:02  saam
;             + problems with TARGET_TO_SOURCE and SOURCE_TO_TARGET corrected
;             + problem with NOCON corrected
;
;       Revision 1.10  1998/03/19 12:01:33  kupper
;              Bricht jetzt bei eindimensionalen Matrizen nicht mehr ab.
;
;       Revision 1.9  1998/02/05 13:16:05  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.8  1997/12/10 15:53:42  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 1.7  1997/10/30 12:57:52  kupper
;              Bug beim ALL-Schlüsselwort behoben (Integerdivision durch Fließkomma ersetzt.)
;
;
;       Sun Sep 7 23:36:35 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		TRANSPARENT zugefügt durch kopieren aus SetWeight.
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

PRO SetDelay, DW, Delay, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
              T_ROW=t_row, T_COL=t_col, T_INDEX=t_index, $
              ALL=all, LWX=lwx, LWY=lwy, TRUNCATE=truncate, TRUNC_VALUE=trunc_value, $
              TRANSPARENT=transparent

   
   IStr = Info(DW) 
   IF (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'[S]DW_DELAY_WEIGHT structure expected, but got '+iStr+' !'
   
   tw = DWDim(DW, /TW)
   th = DWDim(DW, /TH)
   sw = DWDim(DW, /SW)
   sh = DWDim(DW, /SH)
   D  = Delays(DW)

   if set(TRANSPARENT) then Default, trunc_value, transparent
   s = size(Delay)

    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if s(0) ne 2 then begin
          message, /INFORM, 'WARNUNG: 2D-Array erwartet!'
       endif else begin
          if (s(1) ne sh) or (s(2) ne sw) then message, 'Das übergebene Array muß die Ausmaße des Source-Layers haben!'
       EndElse

       count = -1
       if Set(TRANSPARENT) then begin
          boolmaske = Delay ne transparent;Dies ist noch ein 2-dim Array!
          maske =  Where(boolmaske, count); wo wird das Array neu gesetzt? (1-dim)
       endif
       if count eq -1 then begin
          maske = indgen(n_elements(Delay)) ; ganzes Array neu setzen!
          boolmask = Delay-Delay+(1 eq 0) ;lauter FALSEs
       endif

        if not set(t_index) then begin
          t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=tw, HEIGHT=th)
       endif else begin 
          t_row = LayerRow(INDEX=t_index, WIDTH=tw, HEIGHT=th)
          t_col = LayerCol(INDEX=t_index, WIDTH=tw, HEIGHT=th)
       end
       if keyword_set(ALL) then begin
          Default, LWX, sw/float(tw)
          Default, LWY, sh/float(th)

          for x=-t_col, tw-1-t_col do begin
             for y=-t_row, th-1-t_row do begin
                if keyword_set(TRUNCATE) then begin ;truncate
                   if count ne -1 then maske = where(NoRot_Shift(boolmaske, round(LWY*y), round(LWX*x), WEIGHT=(TRUNC_VALUE ne TRANSPARENT))) ;hat transparenten stellen 
                   IF (size(maske))(0) NE 0 THEN D(Layerindex(ROW=y+t_row, COL=x+t_col, WIDTH=tw, HEIGHT=th), maske)=(NoRot_Shift(Delay, round(LWY*y), round(LWX*x), WEIGHT=TRUNC_VALUE))(maske)
                endif else begin ;no truncate
                   if count ne -1 then maske = where(Shift(boolmaske, round(LWY*y), round(LWX*x) )) ;hat transparente stellen 
                   IF (size(maske))(0) NE 0 THEN D(Layerindex(ROW=y+t_row, COL=x+t_col, WIDTH=tw, HEIGHT=th), maske)=(Shift(Delay, round(LWY*y), round(LWX*x) ))(maske)
                endelse
             endfor
          endfor
       end else DW.Delays(t_index, maske) = Delay(maske) 

    end

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:
       if s(0) ne 2 then message, '2D-Array erwartet!'
       if (s(1) ne th) or (s(2) ne tw) then message, 'Das übergebene Array muß die Ausmaße des Target-Layers haben!'

       count = -1
       if Set(TRANSPARENT) then begin
          boolmaske = Delay ne transparent;Dies ist noch ein 2-dim Array!
          maske =  Where(boolmaske, count); wo wird das Array neu gesetzt? (1-dim)
       endif
       if count eq -1 then begin
          maske = indgen(n_elements(Delay)) ; ganzes Array neu setzen!
          boolmaske = Delay-Delay+(1 eq 0) ;lauter FALSEs
       endif

       if not set(s_index) then begin
          s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=sw, HEIGHT=sh)
       endif else begin
          s_row = LayerRow(INDEX=s_index, WIDTH=sw, HEIGHT=sh)
          s_col = LayerCol(INDEX=s_index, WIDTH=sw, HEIGHT=sh)
       end
       if keyword_set(ALL) then begin
          Default, LWX, tw/float(sw)
          Default, LWY, th/float(sh)

          for x=-s_col, sw-1-s_col do begin
             for y=-s_row, sh-1-s_row do begin
                if Keyword_set(TRUNCATE) then begin ;truncate
                   if count ne -1 then maske = where(NoRot_Shift(boolmaske, round(LWY*y), round(LWX*x), WEIGHT=(TRUNC_VALUE ne TRANSPARENT))) ;hat transparenten stellen 
                   IF (size(maske))(0) NE 0 THEN D(maske, Layerindex(ROW=y+s_row, COL=x+s_col, WIDTH=sw, HEIGHT=sh) )=(NoRot_Shift(Delay, round(LWY*y), round(LWX*x), WEIGHT=TRUNC_VALUE))(maske)
                endif else begin ;no Truncate
                   if count ne -1 then maske = where(Shift(boolmaske, round(LWY*y), round(LWX*x) )) ;hat transparente stellen 
                   IF (size(maske))(0) NE 0 THEN D(maske, Layerindex(ROW=y+s_row, COL=x+s_col, WIDTH=sw, HEIGHT=sh) )=(Shift(Delay, round(LWY*y), round(LWX*x) ))(maske)
                endelse
             endfor
          endfor
       end else D(maske, s_index) = Delay(maske)
    end


   if (set(S_ROW) or set(S_INDEX)) and (set(T_ROW) or set(T_INDEX)) then begin ; Nur einzelne Verbindung zurückliefern:

      if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=sw, HEIGHT=sh)
      if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=tw, HEIGHT=th)

      if s(0) gt 1 then message, 'Skalares Gewicht erwartet!'

      D(t_index, s_index) = Delay

   end

   SetDelays, DW, D
end   
