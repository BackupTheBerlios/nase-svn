;+
; NAME: SetWeights
;
; PURPOSE: Setzt die Gewichtsmatrix einer DelayWeigh-Struktur. 
;
; CATEGORY: SIMULATION / CONNECTIONS
;
; CALLING SEQUENCE: SetWeights, DW, W [,/NO_INIT] [,/DIMENSIONS]
;
; INPUTS: DW: Eine mit <A HREF="#INITDW">InitDW</A> initialisierte DelayWeigh-Struktur.
;         W : die zu setzende Gewichtsmatrix.
;
; KEYWORD PARAMETERS: NO_INIT: Führt die neue Version dieser Routine aus.
;                              Diese löscht NICHT wie bisher die übergebene
;                              DW-Struktur und erzeugt sie neu, sondern setzt
;                              nur die Gewichte um. Default: NO_INIT=1.
;                     DIMENSIONS: Erlaubt die vierdimensionale Angabe der 
;                                 Gewichtsmatrix, so wie sie von <A HREF="#WEIGHTS">Weights</A> bei
;                                 gesetztem /DIMENSIONS-Keyword geliefert 
;                                 wird. Default: DIMENSIONS=0.
;
; RESTRICTIONS: DIMENSIONS=1 funktioniert nur für die neue Version, also bei
;               gesetztem NO_INIT-Schlüsselwort.
;
; PROCEDURE: Einfach die Umkehrung der Weights-Routine.
;
; EXAMPLE: DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                      T_WIDTH=5, T_HEIGHT=5,
;                      WEIGHT=4.0)
;          W = FltArr(5*5, 10*10)
;          SetWeights, DW, W, /NO_INIT
;
; SEE ALSO: <A HREF="#INITDW">InitDW</A>, <A HREF="#WEIGHTS">Weights</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.6  1999/08/31 13:02:20  thiel
;         Messages disabled.
;
;     Revision 2.5  1999/08/17 14:15:07  thiel
;         Bugfix in Old_DW_Part of SetWeights.
;         Setweight now uses new version of SetWeights.
;
;     Revision 2.4  1999/08/16 17:06:59  thiel
;         Now executes new version by default.
;
;     Revision 2.3  1999/08/11 14:21:06  thiel
;         Completely new: Does no longer use DW2SDW if /NO_INIT is set.
;
;     Revision 2.2  1998/02/05 13:16:09  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.1  1998/01/05 17:20:23  saam
;           Jo, hmm, viel Spass...
;
;
;-
PRO SetWeights, _DW, W, NO_INIT=no_init, DIMENSIONS=dimensions

   Default, no_init, 1
   Default, dimensions, 0

   IF Keyword_Set(NO_INIT) THEN BEGIN ; execute new version
;      Message, /INFO, 'NEW version of SetWeights executed.'


      CASE 1 OF 
                                ; oldstyle DW-structure:
      (Info(_DW) EQ 'DW_WEIGHT') OR (Info(_DW) EQ 'DW_DELAY_WEIGHT') : BEGIN
         IF Keyword_Set(DIMENSIONS) THEN $
          w = Reform(/OVERWRITE, w, DWDim(_DW,/TH)*DWDim(_DW,/TW), $
                     DWDim(_DW,/SH)*DWDim(_DW,/SW))
         Handle_Value, _DW, DW, /NO_COPY
         help, dw, /struct
         
         DW.Weights = W
         Handle_Value, _DW, DW, /NO_COPY, /SET

         END

                                ; sparse DW-structure:
      (Info(_DW) EQ 'SDW_WEIGHT') OR (Info(_DW) EQ 'SDW_DELAY_WEIGHT') : BEGIN

         IF Keyword_Set(DIMENSIONS) THEN $
          w = Reform(/OVERWRITE, w, DWDim(_DW,/TH)*DWDim(_DW,/TW), $
                     DWDim(_DW,/SH)*DWDim(_DW,/SW))
         Handle_Value, _DW, DW, /NO_COPY
         IF NOT (N_Elements(DW.W) EQ 1 AND DW.W(0) EQ !NONE) THEN $
          DW.W = W(DW.c2t,DW.c2s)
         Handle_Value, _DW, DW, /NO_COPY, /SET

         END

         ELSE : Message, $
          '[S]DW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_DW))+' !'
      
      ENDCASE



   ENDIF ELSE BEGIN             ; execute old version:
;      Message, /INFO, 'Old version of SetWeights executed.'
      IStr = Info(_DW) 
      IF (IStr EQ 'SDW_WEIGHT') OR (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
      IF NOT sdw AND (IStr NE 'DW_WEIGHT') AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'DW structure expected, but got '+iStr+' !'
   
      tS = DWDim(_DW, /TW)*DWDim(_DW, /TH)
      sS = DWDim(_DW, /SW)*DWDim(_DW, /SH)

      IF sdw THEN _DW = SDW2DW(_DW)
      
      Handle_Value, _DW, DW, /NO_COPY 
      S = Size(W)
      IF S(0) NE 2  THEN Message, 'Weight-Matrix has to be two-dimensional'
      IF S(1) NE tS THEN Message, 'wrong target dimensions'
      IF S(2) NE sS THEN Message, 'wrong source dimensions'
      DW.Weights = W
      Handle_Value, _DW, DW, /NO_COPY, /SET

      IF sdw THEN DW2SDW, _DW
   ENDELSE

END

