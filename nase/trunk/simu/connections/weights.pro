;+
; NAME:                Weights
;
; PURPOSE:             Ermittelt die zu einer DelayWeigh-Struktur 
;                      gehoerende Gewichtmatrix 
;
; CATEGORY:            SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:    W = Weights(DW [,/DIMENSIONS])
;
; INPUTS:              DW: Eine mit InitDW initialisierte DelayWeigh-
;                          Struktur (SDW oder Oldstyle-DW)
;
; OUTPUTS:             W: die Gewichtsmatrix
;                         Dies ist eine zweidimensionales Array der Form
;                         W ( Target_Neuron, Source_Neuron ), wenn
;                         nicht das Schlüsselwort /DIMENSIONS
;                         angegeben wurde.
;
; KEYWORDS:            DIMENSIONS: Wird dieses Schlüsselwort
;                                  angegeben, so ist W eine
;                                  vierdimensionale Matrix (Matrix von 
;                                  Matrizen) der Form
;                                  W ( Target_Row,Target_Col, Source_Row,Source_Col )
;
; EXAMPLE:             DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                                  T_WIDTH=5, T_HEIGHT=5,
;                                  WEIGHT=4.0)
;                      W = Weights(DW)
;                      help, W
;
;                      Output:
;                               W               FLOAT     = Array(25, 100)  
;
;                      W = Weights(DW, /DIMENSIONS)
;                      help, W
;
;                      Output:
;                               W               FLOAT     = Array(5, 5, 10, 10)  
;
; SEE ALSO:            <A HREF="#INITDW">InitDW</A>
;                      <A HREF="#SETWEIGHTS"></A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.10  1998/03/25 17:03:39  kupper
;            OVERWRITE bei Reform eingefügt!
;
;     Revision 2.9  1998/03/24 12:55:41  kupper
;            Völlig überflüssige Schleife im SDW-Teil ruasgeworfen.
;             Sollte jetzt schneller sein.
;
;     Revision 2.8  1998/03/19 11:36:45  thiel
;            Letzte Aenderung aus Geschwindigkeitsgruenden
;            rueckgaengig gemacht.
;
;     Revision 2.6  1998/03/15 17:20:28  kupper
;            DIMENSIONS-Schlüsselwort implementiert.
;
;     Revision 2.5  1998/03/14 14:12:19  saam
;           handling of empty dw-structures now works
;
;     Revision 2.4  1998/02/05 14:15:47  saam
;           loop variable was only int
;
;     Revision 2.3  1998/02/05 13:16:10  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.2  1998/01/27 12:54:25  kupper
;            Nur einen Verweis auf SETWEIGHTS hinzugefügt.
;
;     Revision 2.1  1997/12/10 15:34:34  saam
;           Creation
;
;
;-
FUNCTION Weights, _DW, DIMENSIONS=dimensions
   
   IF (Info(_DW) EQ 'DW_WEIGHT') OR (Info(_DW) EQ 'DW_DELAY_WEIGHT') THEN BEGIN
      Handle_Value, _DW, DW, /NO_COPY
      W = DW.Weights
      Handle_Value, _DW, DW, /NO_COPY, /SET
      If Keyword_Set(DIMENSIONS) then W = Reform(/OVERWRITE, W, DWDim(_DW,/TH), DWDim(_DW,/TW), DWDim(_DW,/SH), DWDim(_DW,/SW))
      RETURN, W
   END

   IF (Info(_DW) NE 'SDW_WEIGHT') AND (Info(_DW) NE 'SDW_DELAY_WEIGHT') THEN Message, '[S]DW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_DW))+' !'
   
   sS = DWDim(_DW, /SW) * DWDim(_DW, /SH)
   tS = DWDim(_DW, /TW) * DWDim(_DW, /TH)

   W = Make_Array(tS, sS, /FLOAT, VALUE=!NONE)

   Handle_Value, _DW, DW, /NO_COPY
   IF NOT (N_Elements(DW.W) EQ 1 AND DW.W(0) EQ !NONE) THEN BEGIN
;      FOR wi=0l, N_Elements(DW.W)-1 DO W(DW.c2t(wi),DW.c2s(wi)) = DW.W(wi)
      W(DW.c2t,DW.c2s) = DW.W
   END
   Handle_Value, _DW, DW, /NO_COPY, /SET
   
   If Keyword_Set(DIMENSIONS) then W = Reform(/OVERWRITE, W, DWDim(_DW,/TH), DWDim(_DW,/TW), DWDim(_DW,/SH), DWDim(_DW,/SW))
   RETURN, W
END
