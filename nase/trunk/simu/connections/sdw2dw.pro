;+
; NAME:               SDW2DW
;
; PURPOSE:            Wandelt ein SDW[_DELAY]_WEIGHT-Struktur in eine
;                     DW[_DELAY]_WEIGHT-Struktur um. 
;                     Diese Routine dient der INTERNEN Organisation
;                     der DW-Strukturen und sollte nur benutzt werden,
;                     WENN MAN WIRKLICH WEISS, WAS MAN TUT!!
;
; CATEGORY:           INTERNAL SIMU CONNECTIONS
;
; CALLING SEQUENCE:   DW = SDW2DW(SDW [,/KEEP_ARGUMENT])
;
; INPUTS:             SDW: eine SDW[_DELAY]_WEIGHT-Struktur
;
; KEYWORD PARAMETERS: KEEP_ARGUMENT: falls nicht gesetzt, ist SDW nach dem
;                                    Aufruf undefiniert; ist es gesetzt bleibt
;                                    SDW erhalten
;
; OUTPUTS:            DW: ein korrespondoerende DW[_DELAY]_WEIGHT-Struktur
;
; SIDE EFFECTS:       SDW wird veraendert, Lernpotentiale und Aktionspotentiale
;                     in verzoegerten Verbindungen sind in DW nicht enthalten
;
; SEE ALSO:           <A HREF='#DW2SDW>DW2SDW</A>, <A HREF='#INITDW>InitDW</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.7  1999/11/05 13:09:57  alshaikh
;           1)jede synapse hat jetzt ihr eigenes U_se
;           2)keyword REALSCALE
;
;     Revision 2.6  1999/10/25 08:14:18  alshaikh
;           Fehler korrigiert
;
;     Revision 2.5  1999/10/12 14:36:50  alshaikh
;           neues keyword '/depress'... synapsen mit kurzzeitdepression
;
;     Revision 2.4  1998/04/06 15:40:53  thiel
;            Kontroll-Ausgabe wieder entfernt.
;
;     Revision 2.3  1998/04/06 15:35:54  thiel
;            Tippfehler korrigiert.
;
;     Revision 2.2  1998/04/05 13:51:53  saam
;           now conversion is less memory intensive
;
;     Revision 2.1  1998/02/05 11:36:18  saam
;           Cool
;
;
;-

FUNCTION SDW2DW, _SDW, KEEP_ARGUMENT=keep_argument


   IF (Info(_SDW) NE 'SDW_DELAY_WEIGHT') AND (Info(_SDW) NE 'SDW_WEIGHT') THEN Message, 'SDW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_SDW))+' !'

   dims = DWDim(_SDW, /ALL)

   IF Info(_SDW) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN            
      DW = {  info    : 'DW_DELAY_WEIGHT',$
              source_w: dims(0) ,$
              source_h: dims(1) ,$
              target_w: dims(2) ,$
              target_h: dims(3) ,$
              Weights : Weights(_SDW),$
              Delays  : Delays(_SDW)  }
   END ELSE IF Info(_SDW) EQ 'SDW_WEIGHT' THEN BEGIN
      DW = {  info    : 'DW_WEIGHT'  ,$
              source_w: dims(0) ,$
              source_h: dims(1) ,$
              target_w: dims(2) ,$
              target_h: dims(3) ,$
              Weights : Weights(_SDW) }
      
   END ELSE Message, 'this must not happen!!'

; kompatibilitaetsabfrage zu alten sdw-strukturen
   IF NOT keyword_set(depress) THEN depress = 0
      
; depressions-parameter  
   IF depress EQ 1 THEN begin  
      settag,dw, 'U_se_const',U_se_const
      settag,dw, 'tau_rec', tau_rec
      settag,dw, 'realscale', realscale
   END 
   settag,dw, 'depress', depress
   
   
   IF NOT Keyword_Set(KEEP_ARGUMENT) THEN FreeDW, _SDW
   
   RETURN, Handle_Create(!MH, VALUE=DW, /NO_COPY)
END
