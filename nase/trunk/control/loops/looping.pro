;+
; NAME:               Looping
;
; PURPOSE:            Diese Routine dient zur Behandlung von allgemeinen
;                     Schleifen. Das Prinzip ist folgendes: Alle Parameter
;                     werden in einer beliebigen Struktur (oder Array) gespeichert.
;                     Besteht ein Tag aus einer Liste von mehreren Ein-
;                     traegen, so werden diese der Reihe nach abgearbeitet.
;                     Jeder Aufruf von Looping liefert eine temporaere
;                     Struktur zurueck, die jeweils eine Parameterkombination 
;                     enthaelt.....argh!!!.....bssss!!!....zischh!!!!!
;                     Schaut lieber das Beispiel an. 
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   tmpStruc = Looping(LS [,dizzy])
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure
;
; OUTPUTS:            tmpStruc: eine Struktur mit der Belegung des aktuellen
;                               Zaehlerzustandes
; OPTIONAL OUTPUTS:   dizzy: wurden alle Permutatuionen durchgenudelt, ist 
;                            diese Variable TRUE
;
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         REPEAT BEGIN
;                           tmpStruc = Looping(LS, dizzy)
;                           help, tmpStruc, /STRUCTURE
;                           dummy = Get_Kbrd(1)
;                         END UNTIL dizzy
;
;                    ScreenShot:
;                        ** Structure <40004208>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              1
;                           D               STRING    'A'
;                        ** Structure <40004388>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              1
;                           D               STRING    'C'
;                        ** Structure <40004208>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              2
;                           D               STRING    'A'
;                        ** Structure <40004388>, 4 tags, length=32, refs=1:
;                           A               FLOAT          0.500000
;                           B               FLOAT           1.54320
;                           C               INT              2
;                           D               STRING    'C'
;      
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPNAME">LoopName</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  1997/11/25 16:43:52  saam
;           Hyperlink-Update
;
;     Revision 1.3  1997/11/25 10:43:56  saam
;           a HTML-Bug
;
;     Revision 1.1  1997/11/25 10:11:51  saam
;           IDL ist supertoll ;-)
;
;
;-
FUNCTION Looping, LS, dizzy

   IF Contains(LS.Info,'Loop') THEN BEGIN

      ; names for new structure      
      TagNames   = Tag_Names(LS.struct)


      ; values for new structure
      latestLoop = CountValue(LS.counter)

      newStruct =  Create_Struct(TagNames(0), LS.struct.(0)(latestLoop(0)))
      FOR tag = 1, LS.n-1 DO BEGIN 
        newStruct = Create_Struct(newStruct, TagNames(tag),(LS.struct.(tag))(latestLoop(tag)) )
      END

      ; update counters
      tmpCounter = LS.counter
      Count, tmpCounter, dizzy
      LS.counter = tmpCounter

      IF LS.info EQ 'LoopStruc' THEN RETURN, newStruct ELSE RETURN, newStruct.huhu

   END ELSE Message, 'no valid loop structure passed'

END
