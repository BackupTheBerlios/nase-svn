;+
; NAME:
;  GetDelay()
;
; AIM: Read single delays from given DW structure.
;
; PURPOSE: Liest ein oder mehrere Delays aus einer
;          Delay_Weight-Struktur aus
;
;          Dies ist das Gegenstück zu SetDelay.
;
; CATEGORY: Simulation / Connections
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
; KEYWORD PARAMETERS: S_ROW, S_COL: Zeile und Spalte des SourceNourons. Alternativ kann der eindimensionale Index in S_INDEX angegeben werden.
;                     T_ROW, T_COL: Zeile und Spalte des SourceNourons. Alternativ kann der eindimensionale Index in T_INDEX angegeben werden.
;
; OUTPUTS: 1. Wenn SOURCE- UND TARGETneuron spezifiziert wurden, ist der Output das Delay dieser Verbindung.
;          2. Wenn NUR das SOURCEneuron spezifiziert wurde (weder T_ROW, T_COL noch T_INDEX angegeben),
;             so ist der Output das Array aller von diesem Neuron wegführenden Verbindungen.
;             Das Array ist ZWEIDIMENSIONAL und hat die Ausmaße des Target-Layers.
;          3. Wenn NUR das TARGETneuron spezifiziert wurde (weder S_ROW, S_COL noch S_INDEX angegeben),
;             so ist der Output das Array aller zu diesem Neuron hinführenden Verbindungen.
;             Das Array ist ZWEIDIMENSIONAL und hat die Ausmaße des Source-Layers.
;
; RESTRICTIONS: Geht natürlich nur, wenn die Struktur mit Delays
;               initialisiert wurde!
;
; PROCEDURE: Set(), LayerIndex()
;
;-  
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.7  2000/09/25 16:49:13  thiel
;           AIMS added.
;
;       Revision 1.6  1998/02/05 13:16:01  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.5  1997/12/10 15:53:38  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;
;       Wed Jul 30 18:53:56 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;		Urversion erstellt, im wesentlichen durch kopieren von
;		GetWeight().
;

Function GetDelay, DW, S_ROW=s_row, S_COL=s_col, S_INDEX=s_index,  $
                   T_ROW=t_row, T_COL=t_col, T_INDEX=t_index


   IStr = Info(DW) 
   IF (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'[S]DW_DELAY_WEIGHT structure expected, but got '+iStr+' !'

   tw = DWDim(DW, /TW)
   th = DWDim(DW, /TH)
   sw = DWDim(DW, /SW)
   sh = DWDim(DW, /SH)
   D  = Delays(DW)
  
    if not set(S_ROW) and not set(S_INDEX) then begin ; Array mit Verbindung NACH Target:

       if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=tw, HEIGHT=th)
       RETURN, REFORM( D(t_index, *), sh, sw )

    end

 
   if not set(T_ROW) and not set(T_INDEX) then begin ; Array mit Verbindungen VON Source:

       if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=sw, HEIGHT=sh)
       RETURN, REFORM( D(*, s_index),  th, tw )
   
 end

; Nur einzelne Verbindung zurückliefern:

 if not set(s_index) then s_index = LayerIndex(ROW=s_row, COL=s_col, WIDTH=sw, HEIGHT=sh)
 if not set(t_index) then t_index = LayerIndex(ROW=t_row, COL=t_col, WIDTH=tw, HEIGHT=th)

 RETURN, D(t_index, s_index)

END






