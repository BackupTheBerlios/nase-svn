;+
; NAME:
;   StrJoin()
;
; VERSION:
;   $Id$
;
; AIM:
;   concatenates string array to a single string
;   (obsolete for IDL 5.3 and larger)
;
; PURPOSE:
;   Concatentes an array of strings to single
;   string and inserts arbitrary separators between
;   them. Default separator is the empty string.
;   This routine is obsolete for IDL versions 5.3
;   and above, but implements the same syntax and
;   behaviour and therefore it isn't removed for
;   compatibility reasons.
;
; CATEGORY:
;   Strings
;
; CALLING SEQUENCE:
;   res = StrJoin(strs [, sep])
;
; INPUTS:
;   strs :: an array of strings
;
; OPTIONAL INPUTS:
;   sep :: a separator string inserted between element of strs (default: '')
;
; OUTPUTS:
;   res: the concatenated string
;
; EXAMPLE:
;*  print, StrJoin(['/usr/bin','/bin','/vol/bin'], ':')
;*  >'/usr/bin:/bin:/vol/bin'
;
;*  print, StrJoin(['/usr/bin'], ':')
;*  >'/usr/bin'
;
;-

FUNCTION StrJoin, strs, sep

   Default, sep, ''
   
   IF TypeOf(strs) NE 'STRING' THEN Message, 'only works for strings in 1st arg'
   IF TypeOf(sep)  NE 'STRING' THEN Message, 'only works for strings in 2nd arg'

   rstr = strs(0)
   nstrs = N_Elements(strs)
   FOR i=1,nstrs-1 DO rstr = rstr + sep + strs(i)

   RETURN, rstr
END
