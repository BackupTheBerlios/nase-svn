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
;     Revision 2.1  1998/02/05 11:36:18  saam
;           Cool
;
;
;-

FUNCTION SDW2DW, _SDW, KEEP_ARGUMENT=keep_argument

   IF (Info(_SDW) NE 'SDW_DELAY_WEIGHT') AND (Info(_SDW) NE 'SDW_WEIGHT') THEN Message, 'SDW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_SDW))+' !'

   W = Weights(_SDW)
   IF (Info(_SDW) EQ 'SDW_DELAY_WEIGHT') THEN D = Delays(_SDW)

   Handle_Value, _SDW, SDW, /NO_COPY
   IF Info(SDW) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN            
      DW = {  info    : 'DW_DELAY_WEIGHT',$
              source_w: SDW.source_w ,$
              source_h: SDW.source_h ,$
              target_w: SDW.target_w ,$
              target_h: SDW.target_h ,$
              Weights : W            ,$
              Delays  : D             }
   END ELSE IF Info(SDW) EQ 'SDW_WEIGHT' THEN BEGIN
      DW = {  info    : 'DW_WEIGHT'  ,$
              source_w: SDW.source_w ,$
              source_h: SDW.source_h ,$
              target_w: SDW.target_w ,$
              target_h: SDW.target_h ,$
              Weights : W             }
      
   END ELSE Message, 'this mustnot happen!!'
   Handle_Value, _SDW, SDW, /NO_COPY, /SET
   IF NOT Keyword_Set(KEEP_ARGUMENT) THEN FreeDW, _SDW
   
   RETURN, Handle_Create(!MH, VALUE=DW)
END
