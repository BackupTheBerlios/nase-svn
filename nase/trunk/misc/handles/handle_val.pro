;+
; NAME:              Handle_Val
;
; PURPOSE:           Gibt den Wert eines Handles als Funktionsergebnis zurueck.
;                    Die IDL-Prozedur Handle_Value kann nur eine Variable mit 
;                    dem Ergebnis belegen.
;
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  value = Handle_Val(handle)
;
; INPUTS:            handle : ein IDL-Handle
;
; OUTPUTS:           value : der zugehoerige Inhalt des Handles
;
; EXAMPLE:
;                    handle = Handle_Create('Ich bin ein Beispiel')
;           alt:     Handle_Value, handle, result
;                    print, result
;           jetzt:   print, Handle_Val(handle)  
;                   
; MODIFICATION HISTORY:
;
;       Fri Sep 12 11:36:26 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       $Revision$
;		
;             Schoepfung 
;
;-
FUNCTION Handle_Val, handle

   On_Error, 2

   Handle_Value, handle, result
   RETURN, result

END
