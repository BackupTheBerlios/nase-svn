;+
; NAME:
;  LoopName()
;
; VERSION:
;  $Id$
;
; AIM:
;  Generates an individual string for a given loop structure.
;
; PURPOSE:
;  Generates an individual string for a given loop structure. This may
;  serve as basis for a filename to save iteration specific data. The
;  string contains the tag names and values of the variable loop parameters.
;
; CATEGORY:
;  DataStructures
;  ExecutionControl
;
; CALLING SEQUENCE:
;* s = LoopName(ls [,/NOLONG] [,/PRINT] [,SEP=...])
;
; INPUTS:
;  ls:: A loop structure, initialized with <A>InitLoop()</A>.
;
; INPUT KEYWORDS:
;  NOLONG:: Omits tag names in the string (only the values will be used).
;  PRINT::  If set, <*>s</*> returns a string suitable for printing to
;          the screen. 
;  SEP:: The loop separator (Default: '_'), only functional if you
;        have more than one loop variable.
;
; OUTPUTS:
;  s:: The generated string. 
;
; PROCEDURE:
;  String juggling.
;
; EXAMPLE:
;* myParameters={ a: 0.5, b:1.5432, $
;*                c:[1,2], $
;*                d:['A','C'] }
;* LS = InitLoop(myParameters)
;* REPEAT BEGIN
;*    print, LoopName(LS)
;*    print, LoopName(LS,/NOLONG)
;*    print, LoopName(LS,/PRINT)
;*    tmpStruc = LoopValue(LS)
;*    Looping, LS, dizzy
;* END UNTIL dizzy
;*
;*> A_0.500000_B_1.54320_C_1_D_A_
;*> _0.500000__1.54320__1__A_
;*> A : 0.500000    B : 1.54320    C : 1    D : A
;*> A_0.500000_B_1.54320_C_1_D_C_
;*> _0.500000__1.54320__1__C_
;*> A : 0.500000    B : 1.54320    C : 1    D : C
;*> A_0.500000_B_1.54320_C_2_D_A_
;*> _0.500000__1.54320__2__A_
;*> A : 0.500000    B : 1.54320    C : 2    D : A
;*> A_0.500000_B_1.54320_C_2_D_C_
;*> _0.500000__1.54320__2__C_
;*> A : 0.500000    B : 1.54320    C : 2    D : C
;
; SEE ALSO:
;  <A>InitLoop</A>, <A>Looping</A>, <A>LoopValue</A>.
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.11  2001/09/03 14:08:20  thiel
;        I was bored so I updated the header.
;
;     Revision 1.10  2000/10/03 13:29:18  saam
;     + extended to process several values simultaneously
;     + new syntax still undocumented
;     + just a test version
;
;     Revision 1.9  2000/09/28 13:24:44  alshaikh
;           added AIM
;
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
                  Name = Name + STR(tagNames(tag))  + ' : ' + StrJoin(Str(REFORM((LS.struct.(tag))(countVal(tag),*))), ' ') + '    '
              END ELSE BEGIN
                  IF NOT Keyword_Set(NOLONG) THEN Name = Name + STR(tagNames(tag))
                  
                  IF (Size((LS.struct.(tag))))(0) GT 1 THEN appendStr = Str(countVal(tag)) $
                                                       ELSE appendStr = Str((LS.struct.(tag))(countVal(tag)))
                  Name = Name + '_' + appendStr + sep
              END
          END 
      END

      RETURN, Name

   END ELSE CONSOLE, 'no valid loop structure passed', /FATAL

END





























