;+
; NAME:
;  Product()
;
; AIM:
;  Calculates the product over the elements of an array (index supported)
;
; PURPOSE:
;  To calculate the product over all elements of the passed array, thus corresponding to the IDL function <*>Total</*>.
;
; CATEGORY:
;  Algebra
;  Array
;  CombinationTheory
;  Math
;  NumberTheory
;  Statistics
;
; CALLING SEQUENCE:
;*    out = Product(a, [, dim] [, /DOUBLE])
;
; INPUTS:
;  a::   Array of any type except string or structure.
;  dim:: The dimension (subscript position) over which the product is meant to be calculated.
;
; INPUT KEYWORDS:
;  DOUBLE:: In case <*>A</*> is a float array, set this keyword to use double precision floating point values
;           in calculating the result.
;
; OUTPUTS:
;  out:: The resulting product has the same dimensional structure as <*>A</*>, but with the <*>dim</*>th dimension
;        missing. It is of long64 type if <*>A</*> is of any integer type; otherwise it is of the same type as <*>A</*>,
;        except the keyword <*>DOUBLE</*> is set.
;
; SIDE EFFECTS:
;  Be careful when passing an integer array; even the range of a long64 variable might not be sufficient to
;  represent the result appropriately!
;
; EXAMPLE:
;* A = [5,4,7]
;* print, Product(A)
;  IDL prints:
;* >140
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/11/28 13:22:18  bruns
;     * translated doc header
;     * fixed syntax violations in the doc header
;     * fixed wrong handling of the DOUBLE keyword for multi-dimensional arrays
;
;     Revision 2.3  2000/09/28 08:59:32  gabriel
;         AIM Tag added
;
;     Revision 2.2  1998/07/28 08:11:16  gabriel
;          across index now integrated
;
;     Revision 2.1  1998/06/23 11:34:13  saam
;           product across index missing
;
;
;-



FUNCTION Product, A, dim, DOUBLE=DOUBLE

   On_Error, 2

   S = Size(A)
   AType = S[S[0]+1]
   IF N_Params() EQ 1 THEN dim = 0
   IF N_Params() GT 2 THEN Console, '   Too many arguments.', /fatal
   IF dim GT S[0]     THEN Console, '   Dimension index too large for array.', /fatal

   CASE  AType  OF
     4   : IF  Keyword_Set(DOUBLE)  THEN  PType = 5  ELSE  PType = 4
     5   : PType = 5
     6   : IF  Keyword_Set(DOUBLE)  THEN  PType = 9  ELSE  PType = 6
     9   : PType = 9
     ELSE: IF  ((AType GE 1) AND (AType LE 3)) OR (AType GE 12)  THEN  PType = 14  $
                                                                 ELSE  Console, '   Cannot handle array type.', /fatal
   ENDCASE

   IF dim EQ 0 THEN BEGIN   ; no dimension given

      Prod = (Make_Array(dimension = [1], type = PType, value = 1))[0]   ; generate a scalar 1 of the desired type
      FOR i=0,S[S[0]+2]-1 DO Prod = Prod * A[i]   ; calculate the product over all elements

      Return, Prod

   END ELSE BEGIN

      ; generate an array of the desired dimensional structure and type
      Prod = Make_Array(dimension = S[ Where( (IndGen(S[0])+1) NE dim ) + 1 ], type = PType, value = 1)
      CASE  dim  OF   ; calculate the product over the specified dimension
        1: FOR  i=0,S(dim)-1  DO  Prod(*) = A(i,*,*,*,*,*,*) * Prod(*)
        2: FOR  i=0,S(dim)-1  DO  Prod(*) = A(*,i,*,*,*,*,*) * Prod(*)
        3: FOR  i=0,S(dim)-1  DO  Prod(*) = A(*,*,i,*,*,*,*) * Prod(*)
        4: FOR  i=0,S(dim)-1  DO  Prod(*) = A(*,*,*,i,*,*,*) * Prod(*)
        5: FOR  i=0,S(dim)-1  DO  Prod(*) = A(*,*,*,*,i,*,*) * Prod(*)
        6: FOR  i=0,S(dim)-1  DO  Prod(*) = A(*,*,*,*,*,i,*) * Prod(*)
        7: FOR  i=0,S(dim)-1  DO  Prod(*) = A(*,*,*,*,*,*,i) * Prod(*)
      ENDCASE

      Return, Prod

   END

END
