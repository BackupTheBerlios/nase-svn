;+
; NAME:                  Info
;
; PURPOSE:               Ermittelt, ob ob die uebergegebene Struktur eine
;                        gueltige NASE-Struktur ist und gibt den Info-Tag
;                        zurueck.
;                        Ist die Struktur nicht gueltig, wird die Bearbeitung
;                        mit einem Fehler abgebrochen.
;
; CATEGORY:              SIMULATION
;
; CALLING SEQUENCE:      infoTag = Info(S)
;
; INPUTS:                S: eine Nase-Struktur (z.B. DelayWeigh oder Layer..)
;
; OUTPUTS:               infoTag: der Wert des Info-Tags
;
; EXAMPLE:               print, Info(S)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/01/05 16:34:58  saam
;           aus der Not geboren
;
;
;-
FUNCTION Info, _NS

   On_Error, 2

   IF N_Params() NE 1 THEN Message, 'incorrect number of arguments'
   IF NOT Set(_NS) THEN Message, 'argument undefined'
      
   S = Size(_NS)
   ; is it a handle ??
   IF S(0) EQ 0 AND S(1) EQ 3 AND S(2) EQ 1 THEN BEGIN
       ; ...then try get its value
      IF NOT Handle_Info(_NS) THEN Message, 'invalid NASE-structure (invalid handle)'
      handling = 1
      Handle_Value, _NS, NS, /NO_COPY
   END ELSE BEGIN
      NS = _NS
      handling = 0
   END

  ; NS has to a structure
   S = Size(NS)
   IF NOT (S(0) EQ 1 AND S(1) EQ 1 AND S(2) EQ 8) THEN BEGIN
      print, size(ns)
      IF handling THEN Handle_Value, _NS, NS, /NO_COPY, /SET
      Message, 'invalid NASE-structure (no structure)'
   END
   
  ; NS has to have an INFO-tag
   numTags = N_Tags(NS)
   tagNames = Tag_Names(NS)
   FOR tag=0,numTags-1 DO IF StrUpCase(tagNames(tag)) EQ 'INFO' THEN tagFound = 1
   IF NOT Set(tagFound) THEN BEGIN
      IF handling THEN Handle_Value, _NS, NS, /NO_COPY, /SET
      Message, 'invalid NASE-structure (no info tag)'
   END
      
   infoValue = NS.info
   
   IF handling THEN Handle_Value, _NS, NS, /NO_COPY, /SET
   RETURN, infoValue
END
