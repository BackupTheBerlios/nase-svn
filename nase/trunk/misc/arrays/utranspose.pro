;+
; NAME: UTRANSPOSE
;
; AIM: IDLs modern transpose function for IDL 3.6
;
; PURPOSE: The UTRANSPOSE function returns the transpose of Array. 
;          If an optional permutation vector is provided, the dimensions of Array are rearranged as well.
;
;
; CATEGORY: ARRAYS
;
;
; CALLING SEQUENCE: Result = UTRANSPOSE(Array [, P])
;
; 
; INPUTS:          Array: The array to be transposed. 
;      
;
;
; OPTIONAL INPUTS:  
;                  P: A vector specifying how the dimensions of Array will be permuted. 
;                     The elements of P correspond to the dimensions of Array; 
;                     the ith dimension of the output array is dimension P[i] of the input array.
;                     Each element of the vector P must be unique. 
;                     Dimensions start at zero and can not be repeated.
;                     If P is not present, the order of the indices of Array is reversed.
;                  
;	
;
; OUTPUTS:        RESULT: The transposed Array
;
;
; EXAMPLE:        Print a simple array and its transpose by entering:
;
;                 PRINT, INDGEN(3,3)
;                 PRINT, UTRANSPOSE(INDGEN(3,3))
;                 IDL prints the original array:
;
;                 0  1  2
;
;                 3  4  5
;
;                 6  7  8
;
;                 and its transpose:
;
;                 0  3  6
;
;                 1  4  7
;
;                 2  5  8
;
;To see how a multi-dimensional transposition works, first create a three-dimensional array A:
;
;                 A = INDGEN(2, 3, 4)
;
;                 Take the transpose, reversing the order of the indices:
;    
;                 B = UTRANSPOSE(A)
;
;                 Now re-order the dimensions of A, so that the second dimension becomes the first, 
;                 the third becomes the second, and the first becomes the third:
;
;                 C = UTRANSPOSE(A, [1, 2, 0])
;
;                 Now view the sizes of the three arrays:
;
;                 HELP, A, B, C
;
;                 IDL prints:
;
;                 A   INT  = Array[2, 3, 4]          ;The original array.
;
;                 B   INT  = Array[4, 3, 2]          ;Original array with indices reversed.
;
;                 C   INT  = Array[3, 4, 2]          ;Original array with indices re-ordered.
;
;
;     MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.4  2000/09/25 09:12:56  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.3  1999/04/28 15:11:53  gabriel
;          Hat bei 2-dim Arrays immer transponiert egal ob p=[0,1] oder p=[1,0]
;
;     Revision 1.2  1999/02/19 14:24:54  gabriel
;          Handle_Free vergessen
;
;     Revision 1.1  1999/02/19 14:01:48  gabriel
;          Damit IDL 3.x Benutzter auch toll transponieren koennen
;
;
;-

FUNCTION UTRANSPOSE,ARRAY,P

   On_Error, 2
   sa = size(array)
   
   IF sa(0) LT 2 THEN message,'Array dimensions must be greater than 1'
   IF sa(0) EQ 2 AND set(P) EQ 0 THEN return, transpose(ARRAY)
   default,P,REVERSE(indgen(sa(0)))

   IF N_ELEMENTS(P) NE sa(0) THEN message,'The elements of P should correspond to the dimensions of Array'
   IF idlversion() GE 4 THEN return, transpose(ARRAY,P)
   size = [sa(0),sa((P+1)),sa(sa(0)+1),sa(sa(0)+2)]
   ;stop
   TMPARRAY = MAKE_ARRAY(SIZE=SIZE)
   dimensions = sa(1:sa(0))
   maxdim1 = max(dimensions,maxind1)
   indexer = lindgen(maxdim1)
   i_handle1 = lonarr(sa(0))
   i_handle2 = lonarr(sa(0))
   MH = handle_create()
   FOR I=0L , sa(0)-1 DO BEGIN
      i_handle1(i) = handle_create(MH)
   ENDFOR
   i_handle2 = i_handle1(P) 
   Handle_Value,i_handle1(maxind1),indexer,/no_copy,/SET 
   dimensions(maxind1) = 1
   CASE 1 EQ 1 OF
      SA(0) EQ 3 :BEGIN
         
         FOR i=0L,dimensions(0)-1 DO BEGIN
            FOR j=0L,dimensions(1)-1 DO BEGIN   
               FOR k=0L,dimensions(2)-1 DO BEGIN     
                  counter = [i,j,k]
                  FOR _I=0L , sa(0)-1 DO $
                   IF _I NE maxind1 THEN Handle_Value,i_handle1(_i),counter(_i),/no_copy,/SET
                  TMPARRAY(Handle_Val(i_handle2(0)),Handle_Val(i_handle2(1)),Handle_Val(i_handle2(2))) = $
                   ARRAY(Handle_Val(i_handle1(0)),Handle_Val(i_handle1(1)),Handle_Val(i_handle1(2)))                  
               ENDFOR
            ENDFOR
         ENDFOR
      END
      SA(0) EQ 4 :BEGIN
        
         FOR I=0L,dimensions(0)-1 DO BEGIN
            FOR J=0L,dimensions(1)-1 DO BEGIN   
               FOR K=0L,dimensions(2)-1 DO BEGIN   
                  FOR L=0L,dimensions(3)-1 DO BEGIN   
                     counter = [i,j,k,l]
                     FOR _I=0L , sa(0)-1 DO $
                      IF _I NE maxind1 THEN Handle_Value,i_handle1(_i),counter(_i),/no_copy,/SET
                     TMPARRAY(Handle_Val(i_handle2(0)),Handle_Val(i_handle2(1)),$
                              Handle_Val(i_handle2(2)),Handle_Val(i_handle2(3))) = $
                      ARRAY(Handle_Val(i_handle1(0)),Handle_Val(i_handle1(1)),$
                            Handle_Val(i_handle1(2)),Handle_Val(i_handle1(3)))              
                  ENDFOR
               ENDFOR
            ENDFOR
         ENDFOR 
      END
      SA(0) EQ  5 :BEGIN
         FOR I=0L,dimensions(0)-1 DO BEGIN
            FOR J=0L,dimensions(1)-1 DO BEGIN   
               FOR K=0L,dimensions(2)-1 DO BEGIN   
                  FOR L=0L,dimensions(3)-1 DO BEGIN   
                     FOR M=0L,dimensions(4)-1 DO BEGIN 
                        counter = [i,j,k,l,m]
                        FOR _I=0L , sa(0)-1 DO $
                         IF _I NE maxind1 THEN Handle_Value,i_handle1(_i),counter(_i),/no_copy,/SET
                        TMPARRAY(Handle_Val(i_handle2(0)),Handle_Val(i_handle2(1)),$
                                 Handle_Val(i_handle2(2)),Handle_Val(i_handle2(3)),$
                                 Handle_Val(i_handle2(4))) = $
                         ARRAY(Handle_Val(i_handle1(0)),Handle_Val(i_handle1(1)),$
                               Handle_Val(i_handle1(2)),Handle_Val(i_handle1(3)),$
                               Handle_Val(i_handle1(4))) 
                        
                     ENDFOR
                  ENDFOR
               ENDFOR
            ENDFOR
         ENDFOR
      END
      SA(0) EQ  6 :BEGIN
         FOR I=0L,dimensions(0)-1 DO BEGIN
            FOR J=0L,dimensions(1)-1 dO BEGIN   
               FOR K=0L,dimensions(2)-1 DO BEGIN   
                  FOR L=0L,dimensions(3)-1 DO BEGIN   
                     FOR M=0L,dimensions(4)-1 DO BEGIN 
                        FOR N=0L,dimensions(5)-1 DO BEGIN 
                           counter = [i,j,k,l,m,n]
                           FOR _I=0L , sa(0)-1 DO $
                            IF _I NE maxind1 THEN Handle_Value,i_handle1(_i),counter(_i),/no_copy,/SET
                           TMPARRAY(Handle_Val(i_handle2(0)),Handle_Val(i_handle2(1)),$
                                    Handle_Val(i_handle2(2)),Handle_Val(i_handle2(3)),$
                                    Handle_Val(i_handle2(4)),Handle_Val(i_handle2(5))) = $
                            ARRAY(Handle_Val(i_handle1(0)),Handle_Val(i_handle1(1)),$
                                  Handle_Val(i_handle1(2)),Handle_Val(i_handle1(3)),$
                                  Handle_Val(i_handle1(4)), Handle_Val(i_handle1(5))) 
                
                        ENDFOR
                     ENDFOR
                  ENDFOR
               ENDFOR
            ENDFOR
         ENDFOR
      END
      SA(0) EQ  7 :BEGIN
         message,'7 Dimensions not supported yet'
      END   
      SA(0) EQ   8 :BEGIN
         message,'8 Dimensions not supported yet'
      END
   ENDCASE
   HANDLE_FREE,MH
   return,TMPARRAY
END





