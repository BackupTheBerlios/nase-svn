;+
; NAME:
;  UWriteU()
;
; VERSION:
;  $Id$
;
; AIM:
;  saves a data structure in a file (unformatted/binary)
;
; PURPOSE:
;  IDL's <C>WRITEU</C> procedure writes unformatted binary data from an
;  expression into a file. This is done by directly transferring the
;  data with no processing of any kind being done to the data. This
;  causes several problems when saving strings or more complex data
;  like structures, arrays of structures or structures containing
;  other structures. <C>UWriteU<C> is a wrapper for <C>WriteU</C> that
;  cares for all these problems using a special format to save the
;  data. All data that is saved with this routine will have to be
;  restored using <A>UReadU</A>.<BR>
;  Remember that data is saved in an
;  architecture dependent format, unless you 
;  specified <*>/XDR</*> when opening the file. So be sure, that you
;  use compatible calls for read and write.<BR>
;  This routine completely replaces and enhances the functionality of
;  <A>Save2</A> and <A>SaveStruc</A>, but note that all data is saved
;  binary and save formats are incompatible.
;
; CATEGORY:
;  DataStorage
;  DataStructures
;  Files
;  IO
;  Structures
;
; CALLING SEQUENCE:
;*UWriteU, lun, x
;
; INPUTS:
;  lun :: a valid, writable <B>LUN</B> (see <A>UOpenW</A> how to
;         get one). Alternatively you may specify a <B>filename</B> and
;         <C>UReadU</C> will manage opening and closing automatically. In
;         this case, only one data structure can be saved.
;  x   :: the data structure to saved into <*>lun</*>
;
; SIDE EFFECTS:
;  modifies the file attached to <*>lun</*>
;
; EXAMPLE:
;*a={a:1,b:2.,c:'3',d:intarr(4),e:{e:dblarr(1,2,3,4)}}
;*uwriteu, 'test.sav', a
;*b=ureadu('test.sav')
;*help, b, /str
;*help, b.e, /str
;
; SEE ALSO:
;  <A>UReadU</A>, <A>UOpenW</A>, <A>UClose</A>,
;  <C>OpenW</C> and <*>XDR</*> description of the IDL help
;
;-




; variable save format:
;  length of size array may be x; long
;  size array; lonarr(x)
; 
; STRUCTURE: number of tags (long), i-th tagname as string, i-th elements
;            (for all tags)
; STRING   : length of i-th string element, i-th string  (for all string
;            elements) 
; OTHER    : rawdata
; 


PRO _Uwriteu, lun, x, _EXTRA=e

  ON_Error, 2

  _t=TypeOf(x, INDEX=type)
  IF SubSet(type,[0,10,11]) THEN Console, "can't write type UNDEFINED/POINTER/OBJECT", /FATAL
  sx = SIZE(x)


  IF ((type EQ 8) AND (sx(N_Elements(sx)-1) EQ 1)) THEN BEGIN
      ; it is a scalar structure
      
      sx = SIZE(x)
      IF N_Elements(x) NE 1 THEN Console, 'can only save scalar structures', /FATAL

     ; write the size of the size array and
     ; the size array itself (yes, this can only be a scalar at the moment)
      WriteU, lun, LONG(N_Elements(sx)), LONG(sx)

      nTags = N_Tags(X)
      tagName = Tag_Names(X)
      sName = Tag_Names(X, /STRUCTURE_NAME)

      WriteU, lun, LONG(nTags)
      _Uwriteu, lun, sName
      FOR tag=0, nTags-1 DO BEGIN
          _Uwriteu, lun, tagName(tag)
          _t = TypeOf(X.(tag), INDEX=type)
          IF SubSet(type, [0,10,11]) THEN Console, 'sorry, tags are not allowed to be UNDEFINED/POINTER/OBJECT', /FATAL
          _Uwriteu, lun, X.(tag)
      END

  END ELSE BEGIN
      ;; write the size of the size array and the size array itself
      WriteU, lun, LONG(N_Elements(sx)), LONG(sx)

      ;; write the data
      CASE TypeOf(x) OF
          'STRING': FOR i=0, N_Elements(x)-1 DO WriteU, lun, LONG(StrLen(x(i))), x(i)
          'STRUCT': FOR i=0, N_Elements(x)-1 DO _Uwriteu, lun, x(i)
          ELSE    : WriteU, lun, x
      END
  END

END



PRO UWriteU, _lun, x, _EXTRA=e
  ON_Error, 2

  IF N_Params() NE 2 THEN Console, 'two positional arguments expected', /FATAL
  IF TypeOf(_lun) EQ 'STRING' THEN lun=UOpenW(_lun,_EXTRA=e) ELSE lun=_lun

  ; write version and ID
  printf, lun, 'UWriteU/$Revision$'

  _UWriteU, lun, x, _EXTRA=e
  

  IF TypeOf(_lun) EQ 'STRING' THEN UClose, lun ELSE _lun=lun
END
