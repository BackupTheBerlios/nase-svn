;+
; NAME:              FlatIndex
;
; AIM:               converts a multi dimensional array index into the corresponding one dimensional one
;
; PURPOSE:           Returns the corresponding onedimensional array index for a
;                    multidimensional array index. This is particular
;                    useful if you work on reformed arrays.
;
; CATEGORY:          MISC ARRAY INDICES NASE 
;
; CALLING SEQUENCE:  oidx = FlatIndex (s, midx)
;
; INPUTS:            s   : The size of the array, as returned by the
;                          idl SIZE command. Therefore you will always
;                          pass SIZE(array) as first argument. Advantage
;                          is, that this method saves memory consumption.
;                    midx: the multidimensional [sub-]index for then array
;
; OUTPUTS:           oidx: the onedimensional index
;
; EXAMPLE:           a = Indgen(2,3,4,5,6,7,8)
;                    b = REFORM(a, 2l*3*4*5*6*7*8)
;                    c = REFORM(a, 2l*3*4*5*6*7,8)
;                    print, a(0,0,0,4,1,2,3)
;                    print, b(flatindex(size(a),[0,0,0,4,1,2,3])) 
;                    print, c(flatindex(size(a),[0,0,0,4,1,2]),3)
;                    
; SEE ALSO:          <A HREF="#SUBSRIPT">Subscript</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/25 09:12:54  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  2000/04/07 13:52:17  saam
;              + can be very useful
;              + extensive error checking
;
;
;-

Function FlatIndex, s, idx

ON_ERROR, 2

IF NOT Set(s)   THEN Console, '1st argument undefined', /FATAL
IF NOT Set(idx) THEN Console, '2nd argument undefined', /FATAL

sidx = N_Elements(idx)

IF (s(0) EQ 0) AND (sidx EQ 1) AND (idx(0) EQ 0) THEN RETURN, 0
IF s(0) LT sidx(0) THEN Console, 'complete index has more dimensions than array', /FATAL

IF TOTAL(idx GE s(1:s(0))) THEN Console, 'at least one index is larger than the corresponding array dimension', /FATAL
fidx = LONG(idx(sidx-1))
FOR i=sidx-1,1,-1 DO BEGIN
    fidx=fidx*s(i)+idx(i-1)
END

return, fidx
End
