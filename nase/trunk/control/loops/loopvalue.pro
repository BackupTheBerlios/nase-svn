;+
; NAME:               LoopValue
;
; AIM: returns the actual loop-state of a structure initialized with <A>initloop</A>
;
; PURPOSE:            Diese Routine liefert die aktuelle Schleifenzustand einer
;                     mit InitLoop initialisierten LoopStructure zurueck.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   tmpStruc = LoopValue(LS [,iter])
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure
;
; OPTIONAL OUTPUTS:  iter: enthaelt nach dem Aufruf die Gesamtzahl
;                           bereits durchgefuehrter Schleifendurchlaeufe
;
; OUTPUTS:            tmpStruc: eine Struktur mit der Belegung des aktuellen
;                               Zaehlerzustandes
;
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         REPEAT BEGIN
;                           tmpStruc = LoopValue(LS)
;                           help, tmpStruc, /STRUCTURE
;                           dummy = Get_Kbrd(1)
;                           Looping, LS, dizzy   
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
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPNAME">LoopName</A>, <A HREF="#LOOPING">Looping</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2000/09/28 13:24:44  alshaikh
;           added AIM
;
;     Revision 1.3  1998/01/20 12:03:59  saam
;           Erweiterung um optionalen Ouput Iterationszahl
;
;     Revision 1.2  1997/12/02 10:12:57  saam
;           Inkompatiblitaet von IDL3.6 zu 4,5 bei Klammersetzungen
;           korrigiert.
;
;     Revision 1.1  1997/11/26 09:19:53  saam
;           EntStanden aus Aufteilung von Looping
;
;
;-
FUNCTION LoopValue, LS, iter

   IF Contains(LS.Info,'Loop', /IGNORECASE) THEN BEGIN

      ; names for new structure      
      TagNames   = Tag_Names(LS.struct)

      ; values for new structure
      latestLoop = CountValue(LS.counter)

      newStruct =  Create_Struct(TagNames(0), (LS.struct.(0))(latestLoop(0)))
      FOR tag = 1, LS.n-1 DO BEGIN 
        newStruct = Create_Struct(newStruct, TagNames(tag),(LS.struct.(tag))(latestLoop(tag)) )
      END

      dummy = CountValue(LS.counter, iter)

      IF LS.info EQ 'LoopStruc' THEN RETURN, newStruct ELSE RETURN, newStruct.huhu

   END ELSE Message, 'no valid loop structure passed'

END
