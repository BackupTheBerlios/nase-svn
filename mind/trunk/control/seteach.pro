;+
; NAME:
;   SetEach
;
; VERSION:
;  $Id$
;
; AIM:
;   selects a specific iteration to work on
;
; PURPOSE:
;   There are many MIND routines working on a specific
;   iteration. Especially when working interactively, you may want to
;   pick a certain combination of parameters. This may be done with
;   this routine.
;
; CATEGORY:
;  DataStructures
;  ExecutionControl
;  MIND
;
; CALLING SEQUENCE:
;* FakeEach, [__X...]+
;
; INPUT KEYWORDS:
;   __X :: Set loop variable <*>X</*> to a specific value. For
;          <*>X</*> you have to insert the name of a valid loop
;          variable.
;
; COMMON BLOCKS:
;   ATTENTION
;
; SIDE EFFECTS:
;   modifies AP and P in <*>ATTENTION</*>
;
; RESTRICTIONS:
;   loop names and values have to be valid
;
; EXAMPLE:
;* > SetEach, __STIMORIENT=0.0, __STIMPHASE=180.
;
; SEE ALSO:
;  <A>ForEach</A>, <A>FakeEach</A>
;
;-

;;; look in ../doc/header.pro for explanations and syntax,
;;; or view the NASE Standards Document
PRO _FAKE, _EXTRA=e
x=1
END

PRO SetEach, _EXTRA=e

iter=FOREACH('_FAKE', _EXTRA=e)

END
