;+
; NAME:               LoopName
;
; PURPOSE:            Generates an individual string for a given loop
;                     structure. This may serve as basis for a
;                     filename to save iteration specific data.
;                     The strings contains of the tag names and values
;                     of the variable loop parameters.
;                         
; CATEGORY:           CONTROL
;
; CALLING SEQUENCE:   s = LoopName(LS [,/NOLONG] [,/PRINT] [,SEP=sep])
;
; INPUTS:             LS: a loop structure, initialized with InitLoop
;
; OUTPUTS:            S : the generated string 
;                              
; KEYWORD PARAMETERS: NOLONG: omits tag names in the string (only the
;                             values will be used)
;                     PRINT:  if set, S returns a string suitable for
;                             printing to the sreen
;                     SEP:    the loop separator (Default: '_'), only
;                             functional, if you have more than one
;                             loop variable.
;
; EXAMPLE:
;                         myParameters={ a: 0.5, b:1.5432, $
;                                          c:[1,2], $
;                                          d:['A','C'] }
;                         LS = InitLoop(myParameters)
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
; SEE ALSO:          InitLoop, Looping, LoopValue
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.8  2000/06/19 13:06:12  saam
;           + translated doc header
;           + new keyword SEP for loop variable separators
;           + removed the undocumented stuff
;
;     Revision 1.7  2000/04/04 13:21:04  saam
;           corrected typo
;
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

FUNCTION LoopName, LS, NOLONG=nolong, PRINT=print, SEP=sep

   ON_ERROR, 2
   
   Default, sep, '_'
   IF Contains(LS.Info,'Loop') THEN BEGIN
      
      Name = ''

      tagNames = Tag_Names(LS.struct)
      countVal = CountValue(LS.counter)

      FOR tag = 0, LS.n-1 DO BEGIN 
          tagSize = SIZE(LS.struct.(tag))
          IF tagSize(N_Elements(tagSize)-1) GE 1 THEN BEGIN
              IF Keyword_Set(PRINT) THEN BEGIN
                  Name = Name + STR(tagNames(tag))  + ' : ' + STR(STRING((LS.struct.(tag))(countVal(tag)))) + '    '
              END ELSE BEGIN
                  IF NOT Keyword_Set(NOLONG) THEN Name = Name + STRCOMPRESS(STRING(tagNames(tag)))
                  Name = Name + '_' + STRCOMPRESS(STRING((LS.struct.(tag))(countVal(tag))),/REMOVE_ALL) + sep
              END
          END 
      END

      RETURN, Name

   END ELSE CONSOLE, 'no valid loop structure passed', /FATAL

END
