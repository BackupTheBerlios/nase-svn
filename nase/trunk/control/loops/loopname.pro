;+
; NAME:               LoopName
;
; PURPOSE:            Liefert zu einer LoopStructure einen geeigneten
;                     String, der als Basis fuer einen Filenamen dienen
;                     kann. Geeignet bedeutet, dass der aktuelle Schleifen-
;                     zustand eindeutig auf einen String abgebildet wird.
;                     Dieser String besteht aus dem Tag-Namen und -Wert
;                     von sich veraendernden Parametern.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   Name = LoopName(LS [,/NOLONG] [,/PRINT])
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure
;
; OUTPUTS:            Name: der String
;                              
; KEYWORD PARAMETERS: NOLONG: der Tag-Name wird nicht zur Generierung des
;                             Strings verwendet
;                     PRINT:  falls gesetzt liefert name einen String zurueck,
;                             der auf dem Screen ausgegeben werden kann:
;                                  'Parameter : Wert'
;
; EXAMPLE:
;                         MeineParameter={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(MeineParameter)
;                         REPEAT BEGIN
;                           print, LoopName(LS)
;                           print, LoopName(LS,/NOLONG)
;                           tmpStruc = LoopValue(LS)
;                           dummy = Get_Kbrd(1)
;                           Looping, LS, dizzy
;                         END UNTIL dizzy
;
;                    ScreenShot:
;                           _C_1_D_A
;                           _1_A
;                           _C_1_D_C
;                           _1_C
;                           _C_2_D_A
;                           _2_A
;                           _C_2_D_C
;                           _2_C                                   
;      
; SEE ALSO:          <A HREF="#INITLOOP">InitLoop</A>, <A HREF="#LOOPING">Looping</A>, <A HREF="#LOOPVALUE">LoopValue</A>
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  2000/04/04 13:02:34  saam
;           + added PNAME keyword to get the name for the next
;             higher loop order but deactivated it, because i'm
;             solving my problem by another method...its working
;             anyway
;           + added some spaces to print output
;           + uses console
;
;     Revision 1.5  1998/06/29 13:11:32  saam
;           \n removed in string result
;
;     Revision 1.4  1998/06/17 08:54:14  saam
;          new keyword PRINT
;
;     Revision 1.3  1998/01/21 21:39:47  saam
;           Wird ueberhaupt kein Parameter variiert
;           war der Name vorher leer, jetzt lautet
;           er '_'
;
;     Revision 1.2  1997/11/26 09:21:38  saam
;           Update der Docu
;
;     Revision 1.1  1997/11/25 16:42:16  saam
;           vom Hundertsten ins Tausendste
;
;

FUNCTION LoopName, LS, NOLONG=nolong, PRINT=print;, PNAME=pname

ON_ERROR, 2

   IF Contains(LS.Info,'Loop') THEN BEGIN
      
      Name = ''
;      PName = ''

      tagNames = Tag_Names(LS.struct)
      countVal = CountValue(LS.counter)

      FOR tag = 0, LS.n-1 DO BEGIN 
;          PName = Name
          tagSize = SIZE(LS.struct.(tag))
          IF tagSize(N_Elements(tagSize)-1) GE 1 THEN BEGIN
              IF Keyword_Set(PRINT) THEN BEGIN
                  Name = Name + STR(tagNames(tag))  + ' : ' + STR(STRING((LS.struct.(tag))(countVal(tag)))) + '    '
              END ELSE BEGIN
                  IF NOT Keyword_Set(NOLONG) THEN Name = Name + '_' + STRCOMPRESS(STRING(tagNames(tag)))
                  Name = Name + '_' + STRCOMPRESS(STRING((LS.struct.(tag))(countVal(tag))),/REMOVE_ALL)               
              END
          END 
      END
      IF (Name EQ '') AND NOT Keyword_Set(PRINT) THEN Name = '_'
;      IF (PName EQ '') AND NOT Keyword_Set(PRINT) THEN PName = '_'
      RETURN, Name

   END ELSE , CONSOLE, 'no valid loop structure passed', /FATAL

END
