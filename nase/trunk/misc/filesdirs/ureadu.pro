;+
; NAME:
;  UReadU()
;
; VERSION:
;  $Id$
;
; AIM:
;  restores unformatted/binary data structures saved by <A>UWriteU</A>
;
; PURPOSE:
;  Restores data structures saved by <A>UWriteU</A>. Remember that
;  this data is saved in an architecture dependent format, unless you
;  specified <*>/XDR</*> when opening the file. So be sure, that you
;  use compatible calls for read and write.
;
; CATEGORY:
;  DataStorage
;  DataStructures
;  Files
;  IO
;  Structures
;
; CALLING SEQUENCE:
;*r = UReadU(lun [,ERROR=...])
;
; INPUTS:
;  lun :: a valid, readable <B>LUN</B> (see <A>UOpenR</A>,<A>UOpenW</A> how to
;         get one) to a file that contains data saved by
;         <A>UWriteU</A>. Alternatively you may specify a <B>filename</B> and
;         <C>UReadU</C> will manage opening and closing automatically. In
;         this case, only the first data structure in the file can be restored.
;
; INPUT KEYWORDS:
;  _EXTRA:: all keywords will be passed to <A>UOpenR</A>
;
; OUTPUTS:
;  r :: restored data structure
;
; OPTIONAL OUTPUTS:
;  error:: will be set true, if data can't be read. In this case, the
;          routine will of course not stop execution.
;
; SIDE EFFECTS:
;* modifies the position index of the <*>lun</*>
;
; EXAMPLE:
;*a={a:1,b:2.,c:"3",d:intarr(4),e:{e:dblarr(1,2,3,4)}}
;*uwriteu, 'test.sav', a
;*b=ureadu('test.sav')
;*help, b, /str
;*help, b.e, /str
;
; SEE ALSO:
;  <A>UWriteU</A>, <A>UOpenR</A>, <A>UOpenW</A>, <A>UClose</A>,
;  <C>OpenW</C> and <*>XDR</*> description of the IDL help
;
;-

FORWARD_FUNCTION _UReadU

FUNCTION _UReadU, lun, _EXTRA=e
  ON_Error, 2

  ; read the size structure of the data to be read
  nsx=0l
  ReadU, lun, nsx
  sx=LonArr(nsx)
  ReadU, lun, sx


  IF ((sx(N_Elements(sx)-2) EQ 8) AND (sx(N_Elements(sx)-1) EQ 1)) THEN BEGIN
      ; we have a scalar structure
      nTags = 0l
      ReadU, lun, nTags

      ; name of the structure, empty string if anonymous
      sName = _ureadu(lun)


      FOR tag=0, nTags-1 DO BEGIN
          tagName = _ureadu(lun)
          IF TypeOF(tagName) NE "STRING" THEN Console, 'error in file (no tag name string)'

          tagVal = _ureadu(lun)

          IF tag EQ 0 THEN BEGIN
              x = Create_Struct(tagName, tagVal)
          END ELSE BEGIN
              x = Create_Struct(x, tagName, tagVal)
          END
      END
      x = Create_Struct(NAME=sName, x) ;;; i have to do this here, because sName might exist and would produce a
                                       ;;; conflicting structure type error


  END ELSE BEGIN


      ;; create an appropriate data structure
      IF sx(N_Elements(sx)-2) NE 8 THEN BEGIN ; structures need different init
          IF N_Elements(sx) LT 4 THEN BEGIN
              ;; we have to restore a scalar
              x = Make_Array(SIZE=[1,1,sx(1), sx(2)])
              x = x(0)
          END ELSE BEGIN
              ;; it's an array
              x = Make_Array(SIZE=sx)
          END
      END

      ;; finally read the scalar or array
      CASE sx(N_Elements(sx)-2) OF
          7 : BEGIN             ; string
              FOR i=0,N_Elements(x)-1 DO BEGIN
                  ;; read the actual string length and create an appropriate string
                  sl = 0l
                  ReadU, lun, sl
                  tmp = StrRepeat(" ",sl)
                  ;; read string
                  ReadU, lun, tmp
                  x(i)=TEMPORARY(tmp)
              END
          END
          8 : BEGIN             ; struct
              x = _ureadu(lun)   ; read first struc

              x = Replicate(x, Product(sx(1:sx(0)))) ; fucking REPLICATE doesn't accept a vector of dimensions!
              x = REFORM(x, sx(1:sx(0)), /OVERWRITE)

              FOR i=1,N_Elements(x)-1 DO x(i)=_UReadU(lun)
          END
          ELSE: ReadU, lun, x
      END
  END
  RETURN, x
END



FUNCTION UReadU, _lun, ERROR=error, _EXTRA=e

  ON_ERROR, 2

  IF TypeOf(_lun) EQ 'STRING' THEN lun=UOpenR(_lun,_EXTRA=e) ELSE lun=_lun


  ; small lookahead
  Point_Lun, -lun, pos
  version = ''
  ReadF, lun, version

  ;print, "*"+version+"*"

  ;; if we have an old style, formatted version string
  ;; we can simply proceed
  IF (STRMID(version, 0, 8) EQ 'UWriteU/') THEN BEGIN
      ; we know it was written with uwriteu

      IF Float(StrMid(version, 19,3)) GT 1.3 THEN BEGIN
          ; its the new binary format

          ;; rewind and read again
          Point_Lun, lun, pos
          version = StrRepeat(" ",40)
          ReadU, lun, version

      END
  END ELSE BEGIN
      ;; we don't know this data
      ;; rewind data and exit
      Point_Lun, lun, pos
      IF Set(Error) THEN BEGIN
          Error = 1
          RETURN, !NONE
      END ELSE Console, "data not written using UWriteU, can't restore", /FATAL
  END

  x = _ureadu(lun)

  IF TypeOf(_lun) EQ 'STRING' THEN UClose, lun ELSE _lun=lun
  RETURN, x
END
