;+
; NAME:
;  Restore2
;
; VERSION:
;  $Id$
;
; AIM:
;  retrieves from a file IDL variables saved by <A>Save2</A>
;
; PURPOSE:
;  Retrieves from a file IDL variables saved by <A>Save2</A>.
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;   
; CATEGORY:
;  DataStorage
;
; CALLING SEQUENCE:
;*  restore2, filename, v1 [,v2 [,v3 [ ... [,v9]]] [,/XDR] [,/MORE] [,ERROR=...]
;
; INPUTS:
;  filename :: name of file to save variable in
;
; INPUT KEYWORDS:
;  ERROR :: error flag (0:ok, 1:could not open file, 2:restore incomplete,  3:not a save2 file)
;  XDR   :: save using XDR format
;  MORE  :: will keep the file open so more variables may be restored.
;           <C>Restore2</C> may be called repeatedly if <*>/MORE</*> is used each time.
;           A call to save2 without <*>/MORE</*> closes the file.
;
; OUTPUTS:
;  vi       :: variables to save (up to 9)
;
; COMMON BLOCKS:
;  RESTORE2_COM
;
; EXAMPLE:
;* save2, 'test.tmp', a, b, c, /more
;* save2, 'test.tmp', d, e, f
;
; SEE ALSO:
;  <A>Restore2</A>
;
;-
 
	PRO RESTORE2, FILE, T1, T2, T3, T4, T5, T6, T7, T8, T9,$
	   more=mre, error=err, xdr=xdr
 
	common restore2_com, openflag, lun
 
	NP = N_PARAMS(0)
 
	if n_elements(openflag) eq 0 then openflag = 0
	if openflag eq 0 then begin	; If file not open.
	  GET_LUN, LUN			; Get lun.
	  ON_IOERROR, FNF		; Set io error label.
	  if keyword_set(xdr) then begin
	    OPENR, LUN, FILE, /XDR, /stream	; Open file (XDR).
	  endif else begin
	    OPENR, LUN, FILE		; Open file.
	  endelse
	  openflag = 1			; Mark file as open.
	endif
	ON_IOERROR, ERR			; Catch EOF.
 
	FOR IV = 1, NP-1 DO BEGIN
	  L = 0L		; Length of TXT is a long int.
	  READU, LUN, L		; Read length.
	  if abs(l) gt 200 then begin
	    print," Error in restore2.  "+file+$
	      " doesn't look like a save2 file."
	    print,' Aborting.'
	    err = 3
	    goto, done2
	  endif
 
	  CASE 1 OF 
  L LT 0:   BEGIN		; Scalar string.
	      TXT = STRREPEAT(" ", -L)	;   Set up TXT for input string.
	      READU, LUN, TXT	;   Read string, TXT.
	      I = EXECUTE(TXT)	;   Execute it to get T.
	    END
  L EQ 0:   BEGIN		; String array.
	      READU, LUN, L	;   Read length of setup string.
	      if abs(l) gt 200 then begin
	        print," Error in restore2.  "+file+$
	          " doesn't look like a save2 file."
	        print,' Aborting.'
	        err = 3
	        goto, done2
	      endif
	      TXT = STRREPEAT(" ",L)	;   Set up TXT for input string.
	      READU, LUN, TXT	;   TXT contains code to set aside space.
	      I = EXECUTE(TXT)	;   Executing TXT makes T be a string array.
	      N = N_ELEMENTS(T)	;   Size of string array.
	      FOR I = 0, N-1 DO BEGIN	; Read each string.
		READU, LUN, L	;     String length.
	        if abs(l) gt 200 then begin
	          print," Error in restore2.  "+file+$
	            " doesn't look like a save2 file."
	          print,' Aborting.'
	          err = 3
	          goto, done2
	        endif
		TXT = STRREPEAT(" ", L)	;     Set up string of correct length.
		READU, LUN, TXT	;     Read string.
		T(I) = TXT	;     Store it.
	      ENDFOR
	    END
  L GT 0:   BEGIN		; Other data types.
	      TXT = STRREPEAT(" ", L)	;   Set up TXT for input string.
	      READU, LUN, TXT	;   TXT contains code to set aside space.
	      I = EXECUTE(TXT)	;   Execute TXT to set up space for T. 
	      READU, LUN, T	;   Now read contents of T.
	    END
	  ENDCASE
 
	  I = EXECUTE('T'+STRTRIM(IV,2)+' = T')	; Move data from T to Ti.
 
	ENDFOR  ; IV.
 
	err = 0
 
DONE:	if not keyword_set(mre) then begin	; If /MORE not given
done2:	  CLOSE, LUN				; Close file.
	  FREE_LUN, LUN				; Free lun.
	  ON_IOERROR, NULL			; Turn off io error label.
	  openflag = 0				; Mark file as closed.
	  RETURN
	endif
	return
 
ERR:	PRINT,'Error in RESTORE2, operation incomplete.'
	err = 2
	GOTO, DONE2
 
FNF:	PRINT,'File not found: '+FILE
	err = 1
	GOTO, DONE2
 
	END
