;+
; NAME:              _Count
;
; AIM: is called by <A>count</A>.
;
; PURPOSE:           Wird von Count benutzt.
;
; CATEGORY:          INTERNAL
;
; CALLING SEQUENCE:  _Count(CS, index)
;
; INPUTS:            
;                    CS   : eine mit InitCounter initialisiertes Zaehlwerk
;                    index: der Zaehler index wird um eins hochgezaehlt 
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/09/28 13:24:19  alshaikh
;           added AIM
;
;     Revision 2.3  2000/09/27 15:59:08  saam
;     service commit fixing several doc header violations
;
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
