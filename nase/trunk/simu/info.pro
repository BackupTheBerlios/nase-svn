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
;     Revision 1.3  1998/02/27 18:26:10  kupper
;            Jetzt wird nur noch mit NO_COPY dereferenziert.
;     	Das ist dann tatsächlich viel schneller, da DW-Strukturen ja manchmal
;             ganz schön groß sind...
;
;     Revision 1.2  1998/02/26 17:21:22  kupper
;            Jetzt schneller mit Trial-and-Error-Strategie!
;
;     Revision 1.1  1998/01/05 16:34:58  saam
;           aus der Not geboren
;
;
;-
FUNCTION Info, _NS

;Wir stellen uns hganz dumm und probieren erstmal:
Try = 0
Catch, My_Error                 ;hier hinter landen wir, wenn was nicht klappt

Try = Try+1                     ;nächster Versuch
;print, Try, '. Versuch!'
case Try of
   1: Return, _NS.info          ;1. Versuch: Eine Struktur mit info-Tag
   2: Begin                     ;2. Versuch: Ein Handle auf eine solche
      Handle_Value, _NS, NS, /NO_COPY
      handling = 1              ;Damit man auf jeden Fall weiss, daß der Handle schon dereferenziert wurde!
      info = NS.info            ;Das ist jetzt zwar ziemlich Spaghetticode-mäßig programmiert, aber dafür schnell...
      Handle_Value, _NS, NS, /NO_COPY, /SET
      Return, info
   End
   else: Catch, /CANCEL ;Dann machen wir halt eine konventionelle Untersuchung!
endcase



;; Hier folgt der Fehlerbehandlungsteil:

   On_Error, 2

   IF N_Params() NE 1 THEN Message, 'incorrect number of arguments'
   IF NOT Set(_NS) THEN Message, 'argument undefined'
      
   S = Size(_NS)
   ; is it a handle ??
   IF S(0) EQ 0 AND S(1) EQ 3 AND S(2) EQ 1 THEN BEGIN
       ; ...then try get its value
      IF NOT Handle_Info(_NS) THEN Message, 'invalid NASE-structure (invalid handle)'
;         handling = 1
;         Handle_Value, _NS, NS, /NO_COPY
   END ELSE BEGIN
      NS = _NS
      handling = 0
   END

  ; NS has to be a structure
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
