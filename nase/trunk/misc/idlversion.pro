;+
; NAME:
;  IDLVersion()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return the version of the IDL that is running.
;
; PURPOSE:
;  If <C>IDLversion</C> is called without arguments, the main version
;  number (i.e. the number left to the first dot in <*>!VERSION.RELEASE</*>)
;  is returned as a long value.
;  If either the <*>/FLOAT</*> or the <*>/FULL</*> keyword is set, the
;  version and subversion are returned as a floating number or an array
;  of long values, respectively.
;
; CATEGORY:
;  ExecutionControl
;  Help
;
; CALLING SEQUENCE:
;*result = IDLVersion, [,/FLOAT] [,/FULL]
;
; INPUT KEYWORDS:
;  FLOAT:: Return the floating number that represents the main and the
;          minor version of IDL.<BR>
;          E.g. for version "5.4" the returned value is <*>5.4000</*>, for
;          version "3.6.1a" the returned value is <*>3.6000</*>.
;  FULL::  Return an array of LONG, containing the long
;          representations of the main and all minor versions of IDL.<BR>
;          E.g. for version "5.4" the returned value is <*>[5,4]</*>, for
;          version "3.6.1a" the returned value is <*>[3,6,1]</*>.
; 
; OUTPUTS:
;  A long value, a floating value or an array of long values, depending
;  on the keywords set. <I>(See section INPUT KEYWORDS.)</I>
;
; PROCEDURE:
;  Re-interpret the contents of the <*>!VERSION.RELEASE</*> system variable.
;
; EXAMPLE:
;*print, IDLVersion()
;*> 5      ; hey, i'm running idl 5 :)
;*
;*print, IDLVersion(/FLOAT)
;*> 5.0000 ; more precisely, it is IDL5, minor version 0
;*
;*print, IDLVersion(/FULL)
;*> 5 0 2  ; to be exact, I'm running IDL 5.0.2
;
; SEE ALSO:
;  The <*>!VERSION</*> system variable.
;-


FUNCTION IDLVERSION, FULL=full, FLOAT=FLOAT
   if Keyword_set(FLOAT) then return, float(!version.release)

   if Keyword_set(FULL) then begin
      ;; we have a bootstrapping problem here:
      ;; Versions up to IDL5.2 use STR_SEP for separating strings,
      ;; later versions use STRSPLIT!
      if IdlVersion(/Float) ge 5.3 then $
        return, long(split(!version.release, ".")) $
      else $
        return, long(str_sep(!version.release, "."))
   end
   
   RETURN, long(!version.release)
END
