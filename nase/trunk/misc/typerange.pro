;+
; NAME:
;  TypeRange()
;
; VERSION:
;  $Id$
;
; AIM:
;  Returns the maximum and minimum values for IDL's integer datatypes.
;
; PURPOSE:
;  Returns the maximum and minimum values for IDL's integer datatypes.
;
; CATEGORY:
;  DataStructures
;  Help
;
; CALLING SEQUENCE:
;*result = TypeRange( typecode |
;*                    {/BYTE | /INT | /LONG | /L64 | /UINT | /ULONG | /UL64} )
;
; INPUTS:
;  typecode:: IDL's typecode, cf. IDL's <C>SIZE()</C>. Only scalar
;             integer datatypes are supported.
;
; INPUT KEYWORDS:
;  BYTE, INT, LONG, L64, UINT, ULONG, UL64:: you can specify these
;                                            keywords instead of the
;                                            typecode.
;
; OUTPUTS:
;  result:: Array <*>[min, max]</*> of the minimal and maximal value
;           that can be represented by the selected datatype. The
;           array returned is of the respective datatype.
;
; RESTRICTIONS:
;  Only scalar integer datatypes supported.
;
; PROCEDURE:
;  Straightforward case statement.
;
; EXAMPLE:
;*a= typerange(/L64) & help,a & print, a
;*>A               LONG64    = Array[2]
;*>  -9223372036854775808   9223372036854775807
;
; SEE ALSO:
;  <A>MinimalIntType</A>, IDL's <C>SIZE()</C>.
;-

Function TypeRange, typecode, $
                    BYTE = byte, $
                    INT = int, $
                    LONG = long, $
                    L64 = l64, $
                    UINT = uint, $
                    ULONG = ulong, $
                    UL64 = ul64
   case 1 of
      Keyword_Set(BYTE) : typecode =  1
      Keyword_Set(INT)  : typecode =  2
      Keyword_Set(LONG) : typecode =  3
      Keyword_Set(UINT) : typecode = 12
      Keyword_Set(ULONG): typecode = 13
      Keyword_Set(L64)  : typecode = 14
      Keyword_Set(UL64) : typecode = 15
      else: assert, set(typecode), "Must specify a typecode or keyword."
   endcase

   case typecode of
      1:   return, byte([0, 255])            ; byte
      2:   return, fix([-32768, 32767])        ; int
      3:   return, long([-2147483648, 2147483647]) ;longint
      12:  return, uint([0, 65535])     ;uint
      13:  return, ulong([0, 4294967295])     ;ulong
      14:  return, long64([-9223372036854775808, 9223372036854775807]) ;int64
      15:  return, ulong64([0, 18446744073709551615]) ;uint64
      else: console, /Fatal, "Only scalar integer datatypes are supported."
   endcase

end
