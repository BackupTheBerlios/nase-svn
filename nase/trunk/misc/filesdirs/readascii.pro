;+
; NAME:
;  ReadASCII()
;
; VERSION:
;  $Id$
;
; AIM:
;  Reads the lines from an ASCII file into a string array.
;
; PURPOSE:
;  This function reads the lines of an ASCII file one after the other and puts them into a string array. Certainly IDL
;  does already provide the function <*>Read_ASCII</*>, but handling of the corresponding structures is quite ponderous,
;  and if you just want to read the lines of an ASCII file into a string array, <*>Read_ASCII</*> is like taking a
;  sledgehammer to crack a nut.
;
; CATEGORY:
;  Files
;  IO
;  Strings
;
; CALLING SEQUENCE:
;* Lines = ReadASCII(FName)
;
; INPUTS:
;  FName::  A string scalar giving the name of the ASCII file. It is used as the argument for the OpenR procedure.
;
; OUTPUTS:
;  Lines::  A one-dimensional string array with as many elements as there are lines in the specified file.
;           If the file is of zero-size, a scalar empty string ('') is returned.
;
; RESTRICTIONS:
;  The specified file of course must exist. If it does not, the routine gives a fatal console message.
;
; PROCEDURE:
;  IDL's ReadF procedure is used both for determining how many lines the specified file contains and for reading the
;  lines into the <*>Lines</*> array.
;
; EXAMPLE:
;* Lines = ReadASCII('d:/temp/xxx.txt')   ; (please insert existing filename)
;* Help, Lines
;* For l = 0, N_Elements(Lines)-1  DO  Print, Lines[l]
;
;-



FUNCTION  ReadASCII, FName


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   TypeFName = Size(FName, /type)
   IF  TypeFName EQ 0            THEN  Console, '  No file name specified.', /fatal
   IF  TypeFName NE 7            THEN  Console, '  File name must be of string type.', /fatal
   IF  NOT FileExists(FName[0])  THEN  Console, '  Specified file does not exist.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Reading the lines from the ASCII file into a string array:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The specified file is opened for reading, and the file size is determined:
   OpenR, File, FName[0], /get_lun
   FSize = (FStat(File)).Size

   ; If the file size is zero, '' is returned as the result:
   IF  FSize EQ 0  THEN  BEGIN
     Free_LUN, File
     Return, ''
   ENDIF

   ; The number of lines contained in the file is determined; afterwards, the pointer is re-set to the beginning:
   Line   = ''
   NLines = 0l
   WHILE  NOT EOF(File)  DO  BEGIN
     ReadF, File, Line
     NLines = NLines + 1
   ENDWHILE
   Point_LUN, File, 0


   ; Each line of the file is read into the Lines array:
   Lines = StrArr(NLines)
   FOR  l = 0L, NLines-1  DO  BEGIN
     ReadF, File, Line
     Lines[l] = Line
   ENDFOR

   Free_LUN, File

   Return, Lines


END
