;+
; NAME:               Extra2Structure
;
; AIM:                replaces tags in a structure by equally named tags of another structure
;
; PURPOSE:            Ersetzt spez. Tag-Werte einer Structure S mit den Werten 
;                     gleichennamiger Tags einer anderen Structure E.
; 
;                     Die Idee, die dieser Routine zugrunde liegt ist die folgende.
;                     Angenommen man hat seine Simualtionsparameter in einer zentralen
;                     Struktur gespeichert, moechte aber die Flexibilitaet haben, die
;                     Parameter trotzdem durch Keywords zn veraedern. Dann braeuchte
;                     man fuer jeden Tag der Structure ein Keyword im PRO/FUNCTION-Kopf
;                     und braeuchte des weiteren eine Abfrage, ob dieses Keyword angegeben
;                     wurde und muss ggf. eine Zuweisung durchfuehren. Mit der vorliegenden
;                     kann man das Problem folgendermassen angehen:
;                     * alle Keywords werden in _EXTRA aufgefangen
;                     * Extra2Structure ersetzt alle Tags der Structure, die mit uebergebenen
;                       Keywords uebereinstimmen
;                     * passende Tags werden aus der E Structure entfernt.
;                                                                              
; CATEGORY:           MISC EXTRA TAGS STRUCTURE REPLACE
;
; CALLING SEQUENCE:   Extra2Structure, E, S [,/WARN] [,/LEAVE] [,/CREATE] [,/VERBOSE]
;
; INPUTS:             E: Struktur mit den Ersatz-Werten
;                     S: Struktur mit den zu ersetzenden Werten
;
; KEYWORD PARAMETERS: 
;                     LEAVE  :: passende Tags werden nicht aus E
;                               gestrichen
;                     CREATE :: nicht passende Tags werden in S
;                               zusätzlich erzeugt
;                     VERBOSE:: Tratsch...
;                     WARN   :: gibt eine Warnung aus, falls E nach der Ersetzung noch Tags enthaelt (und
;                               Keyword LEAVE nicht gesetzt wurde)
;                     
; RESTRICTIONS:       Der Typ des entsprechende Tags darf sich nicht veraendern.
;
; EXAMPLE:
;                     IDL> s = {a:1,c:2, e:3, d:4}
;                     IDL> e = {a:10,c:20,e:40,f:0,hallo:'shit'}
;                     IDL> Extra2Structure, e, s, /VERBOSE, /WARN
;                      EXTRA2STRUCTURE: Setting A from        1 to       10
;                      EXTRA2STRUCTURE: Setting C from        2 to       20
;                      EXTRA2STRUCTURE: Setting E from        3 to       40
;                      WARNING!! unprocessed keyword(s):  F HALLO
;                     IDL> help, e, /STR
;                      ** Structure <40080508>, 2 tags, length=24, refs=1:
;                      F               INT              0
;                      HALLO           STRING    'shit'
;
; SEE ALSO:            <A>ExtraDiff</A>
;
;-

PRO Extra2Structure, e, s, WARN=warn, LEAVE=leave, CREATE=create, VERBOSE=verbose

   On_Error, 2

   IF N_Params() NE 2 THEN Message, 'two arguments expected'
   IF NOT Set(e) THEN RETURN

   eTN = TAG_NAMES(e)
   sTN = TAG_NAMES(s)
   
   eC = N_TAGS(e)
   sC = N_Tags(s)

   ; find matching tag names and replace values for s by e
   FOR et=0,eC-1 DO BEGIN
      matched = 0
      FOR st=0,sC-1 DO BEGIN
         IF StrUpCase(eTN(et)) EQ  StrUpCase(sTN(st)) THEN BEGIN
            IF Set(matchTN) THEN matchTN = [matchTN, eTN(et)] ELSE matchTN = eTN(et)
            IF Keyword_Set(VERBOSE) THEN print, 'EXTRA2STRUCTURE: Setting ',eTN(et),' from ',s.(st),' to ', e.(et)
            s.(st) = e.(et)
            matched = 1
         END
      END
      ;; add left-over tagnames to s:
      If Keyword_Set(CREATE) and not matched then begin
         s = create_struct(temporary(s), eTN(et), e.(et))
         IF Keyword_Set(VERBOSE) THEN print, 'EXTRA2STRUCTURE: ' + $
           'Creating additional Tag ',eTN(et),'=', e.(et)
      endif
   END
   
   ; remove matching tagnames from e
   IF NOT Keyword_Set(LEAVE) THEN BEGIN
      dummy = ExtraDiff(e, matchTN)
      IF Keyword_Set(WARN) AND Set(e) THEN Print, 'WARNING!! unprocessed keyword(s): ', Tag_Names(e)
   ENDIF


END
