;+
; NAME:
;  Read_PPM2
;
; VERSION:
;  $Id$
;
; AIM:
;  Read a PGM (gray scale) or PPM (portable pixmap for color) image file.
;
; PURPOSE:
;  Read the contents of a PGM (gray scale) or PPM (portable pixmap
;  for color) format image file and return the image in the form
;  of an IDL variable.<BR>
;  PPM/PGM format is supported by the PMBPLUS and Netpbm packages.
;  PBMPLUS is a toolkit for converting various image formats to and from
;  portable formats, and therefore to and from each other.<BR><BR>
; 
;  This is an extended version of the original <C>READ_PPM</C> routine
;  distributed with IDL (Copyright (c) 1994-2000. Research Systems,
;  Inc.). Although the author of the original routine expresses his
;  hopes, that his code "should adhere to the PGM/PPM 'standard'", it
;  obviously <B>does not</B>.
;  (See <I>http://www.w3.org/Graphics/PNG/</I> for details.) 
;  Implementing the P5 and P6 binary subformats, it does not support
;  their 16bit versions. This <C>Read_PPM2</C> routine was created by
;  extending the original code where necessary, to implement the P5/P6
;  16bit versions.<BR>
;  To the user, there is not difference in using <C>Read_PPM2</C>
;  compared to <C>Read_PPM</C>.<BR>
;  Most of the text following is taken from the original documentation
;  of <C>Read_PPM</C>.
;
; CATEGORY:
;  Image
;  IO
;
; CALLING SEQUENCE:
;*READ_PPM, File, Image, [MAXVAL=...]
;
; INPUTS:
;  File:: Scalar string giving the name of the PGM or PPM file.
;
; OUTPUTS:
;  Image:: The 2D byte array to contain the image.  In the case
;          of a PPM file, a [3, n, m] array is returned.
;
; OPTIONAL OUTPUTS:
;  MAXVAL:: returned maximum pixel value.
;  
; RESTRICTIONS:
;  Accepts: P2 = graymap ASCII, P5 graymap RAWBITS, P3 true-color
;  ASCII pixmaps, and P6 true-color RAWBITS pixmaps.
;  Maximum pixel values are not limited.
;  Images are always stored with the top row first. (ORDER=1)
;  
; EXAMPLE:
;  To open and read the PGM image file named "foo.pgm" in the current
;  directory, store the image in the variable IMAGE1 enter:
;*READ_PPM, "foo.pgm", IMAGE1
;
; SEE ALSO:
;  IDL's <C>Read_PPM</C>
;-

Function READ_PPM2_NEXT_LINE, unit

COMPILE_OPT hidden

cr = string(13b)
repeat begin
    a = ''
    readf, unit, a
    l = strpos(a, '#')   ;Strip comments
    if l ge 0 then a = strmid(a,0,l)
    if strmid(a,0,1) eq cr then a = strmid(a,1,1000)  ;Leading <CR>
    if strmid(a,strlen(a)-1,1) eq cr then a = strmid(a,0,strlen(a)-1)
    a = strtrim(a,2)		;Remove leading & trailing blanks.
    a = strcompress(a)		;Compress white space.
endrep until strlen(a) gt 0
return, a
end

Function READ_PPM2_NEXT_TOKEN, unit, buffer

COMPILE_OPT hidden

if strlen(buffer) le 0 then buffer = READ_PPM2_NEXT_LINE(unit)
white = strpos(buffer, ' ')
if white eq -1 then begin	;No blanks?
    result = buffer
    buffer = ''
endif else begin		;Strip leading token.
    result = strmid(buffer, 0, white)
    buffer = strmid(buffer, white+1, 1000)
endelse
return, result
end



PRO READ_PPM2, FILE, IMAGE, MAXVAL = maxval

ON_IOERROR, bad_io
ON_ERROR, 2  ;; Changed from 1 to 2 - matches other read routines - SJL

OPENR, unit, file, /GET_LUN, /STREAM, /SWAP_IF_BIG_ENDIAN
;; PNG/PPM uses little endian byte order
image = 0
buffer = ''		;Read using strings
magic = READ_PPM2_NEXT_TOKEN(unit, buffer)
if strmid(magic,0,1) ne 'P' then begin
Not_pgm: MESSAGE, 'File "'+file+'" is not a PGM/PPM file.'
    return
    endif

type = strmid(magic,1,1)

width = long(READ_PPM2_NEXT_TOKEN(unit, buffer))
height = long(READ_PPM2_NEXT_TOKEN(unit, buffer))
maxval = ulong64(READ_PPM2_NEXT_TOKEN(unit, buffer))

returntype = MinimalIntType(maxval)

case type of
'2' : BEGIN
	image = make_array(width, height, /nozero, type=returntype)
	readf, unit, image
      ENDCASE
'3' : BEGIN
	image = make_array(3, width, height, /nozero, type=returntype)
	readf, unit, image
      ENDCASE
'5' : BEGIN
	image = make_array(width, height, /nozero, type=returntype)
	readu, unit, image
      ENDCASE
'6' : BEGIN
	image = make_array(3, width, height, /nozero, type=returntype)
	readu, unit, image
      ENDCASE
else :	goto, Not_pgm
ENDCASE

free_lun, unit
return
BAD_IO: Message, 'Error occured accessing PGM/PPM file:' + file
end

