;+
; NAME:
;  TryReadF()
;
; VERSION:
;  $Id$
;
; AIM:
;  Make n non-blocking read-attempt on a file.
;
; PURPOSE:
;  By default, IDL always opens a file in blocking I/O mode. I.e., if
;  the user tries to read from the file, and no data is
;  available<SUP>*)</SUP>, IDL sleeps until data becomes
;  available. <C>TryReadF()</C> attempts to read from a file, but will
;  not block if no data is waiting to be read. Instead it returns
;  <C>TRUE</C>, if data was successfully read, and <C>FALSE</C>, if no
;  data is available at the moment.<BR>
;  <I>A similar functionality was provided by the <A>Available()</A>
;  function, which was currupted by a change in IDL's buffering
;  behaviour in version IDL 5.4. If <A>Available()</A> does not work
;  correctly on your system, use <C>TryReadF()</C> instead.</I><BR>
;  Note: since Rev. 1.4, <C>TryReadF()</C> calls <A>Available()</A>
;        with the keyword <C>/USE_SELECT</C> set. This should work
;        without a problem, as long as the file is line buffered.<BR>
;  <BR> 
;  <SUP>*)</SUP> This means, there is nothing to read, although the file is not
;  EOF, which is very often the case when reading from a UNIX pipe or
;  fifo, or from a file that is open for writing by another
;  process.)<BR>
;  <BR> 
;  <I>Note that a file needs to be opened with the <C>/STDIO</C> keyword to
;  <C>OPEN[RWU]</C> for this routine to work!</I>;  
;
; CATEGORY:
;  Files
;  IO
;  OS
;
; CALLING SEQUENCE:
;*result = TryReadF( lun, var1,...,varn [,/VERBOSE] [,KEYWORDS] )
;
; INPUTS:
;  lun, var1,...,varn:: These arguments are identical to those of
;                       IDL's <C>READF</C> command. Please see the IDL
;                       help for documentation.
;
; INPUT KEYWORDS:
;  VERBOSE :: If this keyword is set, <C>TryReadF</C> will issue debug
;             messages via <A>DMsg</A>, specifying the reason for a
;             failed read-attempt.
;  KEYWORDS:: Any other keywords given are passed by value to IDL's
;             <C>READF</C> command. Please see the IDL help for
;             documentation.
;
; OUTPUTS:
;  result:: <C>TRUE (1)</C>, if data was successfully read, <C>FALSE
;           (0)</C>, if no data was available. If no data was
;           available, the arguments passed to the function stay
;           unchanged.
;
; RESTRICTIONS:
;  A file needs to be opened with the <C>/STDIO</C> keyword to
;  <C>OPEN[RWU</C>] for this routine to work.
;
; PROCEDURE:
;  Call <A>Available</A>, if true, <C>READF</C>.
;
; EXAMPLE:
;*$mkfifo testfifo
;*openw,23,"testfifo"
;*openr,24,"testfifo",/Stdio
;*printf,23,"line1"
;*printf,23,"line2"
;*printf,23,"line3"
;*l=""
;*while TryReadF(24,l,/verbose) do print,l
;*>line1
;*>line2
;*>line3
;
; SEE ALSO:
;  <A>Available()</A>, <A>SetNonblocking</A>, <A>SetBlocking</A>
;  <C>ON_IOERROR</C>, <C>READF</C>.
;-

Function TryReadF, lun, var2, var3, var4, var5, var6, var7, var8, $
                   verbose=verbose, $
                   _extra=_extra


;;; --- old version: This breaks, if data chunk to be read is too ---------
;;;     big to fit into buffer, or if the whole chunk can not be
;;;     written as fast as IDL tries to read. In this case, EOF
;;;     appears somewhere durin the read!
;;;     I leave the old version commented out in case we need to get
;;;     back to something like this later...

;   On_ioerror, readerr

   
;   dummy = Call_External (!NASE_LIB, "set_nonblocking", lun)

;   case n_params() of
;      1: ReadF, lun, _extra=_extra 
;      2: ReadF, lun, var2, _extra=_extra
;      3: ReadF, lun, var2, var3, _extra=_extra
;      4: ReadF, lun, var2, var3, var4, _extra=_extra
;      5: ReadF, lun, var2, var3, var4, var5, _extra=_extra
;      6: ReadF, lun, var2, var3, var4, var5, var6, _extra=_extra
;      7: ReadF, lun, var2, var3, var4, var5, var6, var7, _extra=_extra
;      8: ReadF, lun, var2, var3, var4, var5, var6, var7, var8, _extra=_extra
;   endcase

;   dummy = Call_External (!NASE_LIB, "set_blocking", lun)

;   return, 1

   
;   readerr: ;; a read error occured
;   If Keyword_Set(verbose) then begin
;      Dmsg, "No data available. ("+!error_state.MSG+")"
;      If !error_state.SYS_MSG ne "" then Dmsg, "System error " + $
;        "'"+!error_state.SYS_MSG+"'."
;   Endif

;   dummy = Call_External (!NASE_LIB, "set_blocking", lun)

;   return, 0

;;; ---------- end of old version ----------------------------



   available = available(lun, /Use_Select)

   if available then begin
      case n_params() of
         1: ReadF, lun, _extra=_extra 
         2: ReadF, lun, var2, _extra=_extra
         3: ReadF, lun, var2, var3, _extra=_extra
         4: ReadF, lun, var2, var3, var4, _extra=_extra
         5: ReadF, lun, var2, var3, var4, var5, _extra=_extra
         6: ReadF, lun, var2, var3, var4, var5, var6, _extra=_extra
         7: ReadF, lun, var2, var3, var4, var5, var6, var7, _extra=_extra
         8: ReadF, lun, var2, var3, var4, var5, var6, var7, var8, _extra=_extra
      endcase
   endif

   return, available

End
