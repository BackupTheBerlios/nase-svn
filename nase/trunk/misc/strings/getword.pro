;+
; NAME:
;  GetWord()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return the n'th word from a text string.
;
; PURPOSE:
;  Return the n'th word from a text string.
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;
;
; CATEGORY:
;  Strings
;
; CALLING SEQUENCE:
;*  word = GetWord(text, n [,m] [,DELIMITER=...] [,/LAST] [,/NOTRIM]
;*                  [,LOCATION=...] [,NWORDS=...])
;
; INPUTS:
;       text :: text string to extract from
;       n    :: word number to get (first:0, default)
;
; OPTIONAL INPUTS:
;       m    :: optional last word number to get
;
; INPUT KEYWORDS:
;  DELIMITER :: set word delimiter as string or array of strings (default: space & tab).
;  LAST      :: means n is offset from last word.  So n=0 gives
;               last word, n=-1 gives next to last, ...
;               If n=-2 and m=0 then last 3 words are returned.
;  NOTRIM    :: suppresses whitespace trimming on ends
;
; OUTPUTS:
;       word :: returned word or words
;
; OPTIONAL OUTPUTS:
;  LOCATION  :: return word n string location
;  NWORDS    :: returns number of words in string
;
; COMMON BLOCKS: 
;  GetWord_Com
;
; RESTRICTIONS:
;  If a NULL string is given (text="") then the last string
;  given is used.  This saves finding the words again.
;  If m > n, word will be a string of words from word n to
;  word m.  If no m is given, word will be a single word.
;  n<0 returns text starting at word abs(n) to string end
;  If n is out of range then a null string is returned.
;
; EXAMPLE:
;* print, getword("hello mr foo bar", 2)
;* > foo
;
;* print, getword("hello mr foo bar", 1, 3)
;* > mr foo bar
;
;-

	FUNCTION GETWORD, TXTSTR, NTH, MTH, location=ll,$
	   delimiter=delim, notrim=notrim, last=last, nwords=nwords
 
	common getword_com, txtstr0, nwds, loc, len
 
	if n_params(0) lt 2 then nth = 0		; Def is first word.
	IF N_PARAMS(0) LT 3 THEN MTH = NTH		; Def is one word.
 
	if strlen(txtstr) gt 0 then begin
	  ddel = ' '					; Def del is a space.
	  if n_elements(delim) ne 0 then ddel = delim	; Use given delimiter.
	  TST = (byte(ddel))(0)				; Del to byte value.
	  tb = byte(txtstr)				; String to bytes.
	  if ddel eq ' ' then begin		        ; Check for tabs?
	    w = where(tb eq 9B, cnt)			; Yes.
	    if cnt gt 0 then tb(w) = 32B		; Convert any to space.
	  endif
	  X = tb NE TST					; Non-delchar (=words).
	  X = [0,X,0]					; 0s at ends.
 
	  Y = (X-SHIFT(X,1)) EQ 1			; Diff=1: word start.
	  Z = WHERE(SHIFT(Y,-1) EQ 1)			; Word start locations.
	  Y2 = (X-SHIFT(X,-1)) EQ 1			; Diff=1: word end.
	  Z2 = WHERE(SHIFT(Y2,1) EQ 1)			; Word end locations.
 
	  txtstr0 = txtstr				; Move string to common.
	  NWDS = long(TOTAL(Y))				; Number of words.
	  LOC = Z					; Word start locations.
	  LEN = Z2 - Z - 1				; Word lengths.
	endif else begin
	  if n_elements(nwds) eq 0 then begin		; Check if first call.
	    print,' Error in getword: must give a '+$
	      'non-NULL string on the first call.'
	    return, -1					; -1 = error flag.
	  endif
	endelse
 
	nwords = nwds					; Set nwords
 
	if keyword_set(last) then begin			; Offset from last.
	  lst = nwds - 1
	  in = lst + nth				; Nth word.
	  im = lst + mth				; Mth word.
	  if (in lt 0) and (im lt 0) then return, ''	; Out of range.
	  in = in > 0					; Smaller of in and im
	  im = im > 0					;  to zero.
	  if (in gt lst) and (im gt lst) then return,'' ; Out of range.
	  in = in < lst					; Larger of in and im
	  im = im < lst					;  to be last.
	  ll = loc(in)					; Nth word start.
	  return, strtrim(strmid(txtstr0,ll,loc(im)-loc(in)+len(im)), 2) 
	endif
 
	N = ABS(NTH)					; Allow nth<0.
	IF N GT NWDS-1 THEN RETURN,''			; out of range, null.
	ll = loc(n)					; N'th word position.
	IF NTH LT 0 THEN GOTO, NEG			; Handle nth<0.
	IF MTH GT NWDS-1 THEN MTH = NWDS-1		; Words to end.
 
	if keyword_set(notrim) then begin
	  RETURN, STRMID(TXTSTR0,ll,LOC(MTH)-LOC(NTH)+LEN(MTH))
	endif else begin
	  RETURN, strtrim(STRMID(TXTSTR0,ll,LOC(MTH)-LOC(NTH)+LEN(MTH)), 2)
 	endelse
 
NEG:	if keyword_set(notrim) then begin
	  RETURN, STRMID(TXTSTR0,ll,9999)
	endif else begin
	  RETURN, strtrim(STRMID(TXTSTR0,ll,9999), 2)
	endelse
 
	END
