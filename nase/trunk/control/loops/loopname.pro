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
; CALLING SEQUENCE:   Name = LoopName(LS [,/NOLONG])
;
; INPUTS:             LS: eine mit InitLoop initialisierte LoopStructure
;
; OUTPUTS:            Name: der String
;                              
; KEYWORD PARAMETERS: NOLONG: der Tag-Name wird nicht zur Generierung des
;                             Strings verwendet
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
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1997/11/26 09:21:38  saam
;           Update der Docu
;
;     Revision 1.1  1997/11/25 16:42:16  saam
;           vom Hundertsten ins Tausendste
;
;
;-
FUNCTION LoopName, LS, NOLONG=nolong

   IF Contains(LS.Info,'Loop') THEN BEGIN
      
      Name = ''
      
      tagNames = Tag_Names(LS.struct)
      countVal = CountValue(LS.counter)

      FOR tag = 0, LS.n-1 DO BEGIN 
         tagSize = SIZE(LS.struct.(tag))
         IF tagSize(N_Elements(tagSize)-1) GT 1 THEN BEGIN
            IF NOT Keyword_Set(NOLONG) THEN Name = Name + '_' + STRCOMPRESS(STRING(tagNames(tag)))
            Name = Name + '_' + STRCOMPRESS(STRING((LS.struct.(tag))(countVal(tag))),/REMOVE_ALL)
         END
      END

      RETURN, Name

   END ELSE Message, 'no valid loop structure passed'

END
