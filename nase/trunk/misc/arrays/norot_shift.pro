;+
; NAME: NOROT_SHIFT
;
;
;
; PURPOSE: 
;
;    The SHIFT function shifts elements of vectors or arrays
;    along any dimension by any number of elements. 
;	The result is a vector or array of the same structure and                   
;	Type as Array. Positive shifts are to the right while left
;	shifts are expressed as a negative number. 
;	All shifts are not circular (the circular shifted regions are
;	setted to zero).   
;
;
; CATEGORY: 
;
; 	Array and Image Processing Routines 
;
;
; CALLING SEQUENCE: 
;
;	result = NOROT_SHIFT(Array,S0,..,S6)
;
; 
; INPUTS: 

;	Array
;	The array to be shifted.
;
;	Si
;	The shift parameters. For arrays of more than one dimension,
;	the parameter Sn specifies the shift applied to the nth dimension. 
;	S1 specifies the shift along the first dimension and so on. 
;	If only one shift parameter is present and the parameter is an array, 
;	he array is treated as a vector (i.e., the array is treated as
; 	having one-dimensional subscripts).
;	A shift specification of 0 means that no shift is to be
;    performed along that dimension.
;
; OPTIONAL INPUTS: -
;
;
;	
; KEYWORD PARAMETERS: 
;	WEIGHT
;    Value to set the circular shifted regions (default is zero).
;	    
;
; OUTPUTS: 
;
;     Result is the shifted Array
;
;
; OPTIONAL OUTPUTS: -
;
;
;
; COMMON BLOCKS: -
;
;
;
; SIDE EFFECTS: -
;
;    If one shiftparameter Sn exceeds the size of nth dimension of the
;    Array, Sn is setted to the maximal size of nth dimension.
;  
;
; RESTRICTIONS:
;
; 	Highest allowed dimension of the array is six.
;
;
; PROCEDURE: -
;
;
;
; EXAMPLE:
;    	
;    A = shift(DIST(50,50,25,25))  ; two dimensional indexed array  	
;    B = exp(-A^2/75)              ; gaussean derviation
;    result = norot_shift(A,20,20)
;	tvscl,result
;
;
; MODIFICATION HISTORY: ANDREAS GABRIEL 4. August 1997
;
;-

function create_index , S ,DIM
         if S GT (DIM ) then begin
             S = (DIM)
             print,"Warning: Shiftsize greater than dimension of array"
         endif
         FROM =  ( ( DIM -1 + S + 1  ) MOD ( DIM  ) ) * ( S LT 0 ) 
         TO   = ( S LT 0 ) * (DIM-1) + ( (S - 1 ) MOD ( DIM  ) ) * ( S GT 0 ) 
;         print, 'from' , from, 'TO', TO
         
         index= LINDGEN (TO-FROM+1)
         index= index + from
;         print,index
         RETURN,index
END



function norot_shift,A,S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,WEIGHT = w
 IF NOT KEYWORD_SET(W) THEN W = 0

 DIMARR = SIZE(A)     
 DIM = SIZE(DIMARR)

 CASE N_PARAMS() OF 

     2    : BEGIN
         TMPARR = SHIFT( A , S0 )
         if S0 then  TMPARR(create_index(S0,DIMARR(1)))  = W

     END
     3    : BEGIN
         TMPARR = SHIFT(A,S0,S1)
         if S0 NE 0 then TMPARR(create_index(S0,DIMARR(1)),*) = W
         if S1 NE 0 then TMPARR(*,create_index(S1,DIMARR(2))) = W
     END
     4    : BEGIN
         TMPARR = SHIFT(A,S0,S1,S2)
         if S0  NE 0 then TMPARR(create_index(S0,DIMARR(1)),*,*) = W
         if S1  NE 0 then TMPARR(*,create_index(S1,DIMARR(2)),*) = W
         if S2  NE 0 then TMPARR(*,*,create_index(S2,DIMARR(3))) = W


     END
     5    : BEGIN 
         TMPARR = SHIFT(A,S0,S1,S2,S3)
         if S0  NE 0 then TMPARR(create_index(S0,DIMARR(1)),*,*,*) = W
         if S1  NE 0 then TMPARR(*,create_index(S1,DIMARR(2)),*,*) = W
         if S2  NE 0 then TMPARR(*,*,create_index(S2,DIMARR(3)),*) = W
         if S3  NE 0 then TMPARR(*,*,*,create_index(S3,DIMARR(4))) = W


     END
     6    : BEGIN
         TMPARR = SHIFT(A,S0,S1,S2,S3,S4)
         if S0  NE 0 then TMPARR(create_index(S0,DIMARR(1)),*,*,*,*) = W
         if S1  NE 0 then TMPARR(*,create_index(S1,DIMARR(2)),*,*,*) = W
         if S2  NE 0 then TMPARR(*,*,create_index(S2,DIMARR(3)),*,*) = W
         if S3  NE 0 then TMPARR(*,*,*,create_index(S3,DIMARR(4)),*) = W
         if S4  NE 0 then TMPARR(*,*,*,*,create_index(S4,DIMARR(5))) = W
     END
     ELSE : BEGIN
         print,"something is wrong: to much arguments > 7 "
     END
 ENDCASE
 RETURN,TMPARR
END
