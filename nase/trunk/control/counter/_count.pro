;
; NAME:              _Count
;
; PURPOSE:           Wird von Count benutzt.
;
; CATEGORY:          INTERNAL
;
; CALLING SEQUENCE:  _Count(CS, index)
;
; INPUTS:            CS   : eine mit InitCounter initialisiertes Zaehlwerk
;                    index: der Zaehler index wird um eins hochgezaehlt 
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1997/12/01 11:44:19  saam
;           Modification History ergaenzt
;
;
FUNCTION _Count, CS, index
   
   IF index GE 0 THEN BEGIN
      CS.counter(index) = CS.counter(index)+1
      
      ; Ueberlauf ??
      IF CS.counter(index) GE CS.maxCount(index) THEN BEGIN
         CS.counter(index) = 0
         tmp = _Count(CS, index-1)
         Return, tmp
      END ELSE RETURN, 0
   END ELSE RETURN, 1

END
