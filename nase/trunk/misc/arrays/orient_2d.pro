;+
; NAME: ORIENT_2D
;
;
;
; PURPOSE: The ORIENT_2D Function creates a filtermask  
;          for a orientation detection. The result is an 
;          array for further imageprocessing (like CONVOL) 
;    
;	
;	
; CATEGORY: Filter Mask/Processing
;
; 	
;
;
; CALLING SEQUENCE: 
;
;	  ARRAY = ORIENT_2D(MaskSize,[ DEGREE=degree ],[ STRETCH=stretch ],[ SHARP=sharp ]
;
; 
; INPUTS: 
;
;	  MaskSize
;        Dimension of filtermask	
;        
;
;	
; KEYWORD PARAMETERS: 
;	
;        DEGREE 
;        Angle of orientation in degrees clockwise (Default is zero)     
;   
;        STRETCH
;        Factor  (GE 1) to increase  the orientation mask for more sharpness in orientation (Default is 1.0).
;
;        SHARP
;        Factor to increase  the orientation mask for more sharpness in location 
;        (Default is 1.0, less than 1.0 means more sharpness)
;
; OUTPUTS: 
; 
;        Result is a filtermask (dimension: MaskSize*Stretch x MaskSize*Stretch)   
;
;                               negativ
;        Weights of the MASK    --------   (DEGREE=0)
;                               positive
;
;
; 
; EXAMPLE:
;    	
; 
;         MASK = ORIENT_2D(9,DEGREE=90)
; 
;	   TVSCL, REBIN(MASK,9*10,9*10,/SAMPLE)
;
;
; MODIFICATION HISTORY: ANDREAS GABRIEL 4. Nov 1997
;
;-

Function __Fermi, x,x0,sigma
  sgnx=2*(x GT 0)-1
  Return, 1/(1+ exp( (sgnx*x-x0)/sigma ))
End

Function __Gauss, x, sigma
  Return, exp(-x*x/2/sigma/sigma)
End

FUNCTION ORIENT_2D,MASKSIZE,DEGREE=DEGREE,STRETCH=STRETCH,SHARP=SHARP

DEFAULT,STRETCH,1.0
DEFAULT,DEGREE,0.0
DEFAULT,SHARP,1.0

YS = FIX(STRETCH*MASKSIZE)
XS = MASKSIZE
sigy = YS/4. ; empirisch bestimmt
sigx = XS/6.*SHARP ; empirisch bestimmt
;xn = DINDGEN(XS,YS) MOD XS
;yn = TRANSPOSE(XN)

;ERG_SIN = sin((XN + XS/2+1 ) *2*!Pi/XS)^2 * sin( YN *!Pi /YS) 
;ERG_SIN = transpose(ERG_SIN)
;help,erg_sin
Y = DINDGEN(YS)
X =  DINDGEN(XS)
ERG_Y = __Fermi(Y-YS/2,YS/4,sigy/10)
ERG_X = (X-XS/2)/sigx^2*__GAUSS(X-XS/2,sigx)

FERMI_MASK = REBIN(ERG_Y,YS,XS,/SAMPLE)
FERMI_MASK = TRANSPOSE(FERMI_MASK)
DGAUSS_MASK = REBIN(ERG_X,XS,YS,/SAMPLE)
ORIENT_MASK = DGAUSS_MASK*FERMI_MASK;*ERG_SIN

MASK = DBLARR(STRETCH*MASKSIZE,STRETCH*MASKSIZE)
A = YS - XS
MASK(A/2:YS-A/2-1,*) = ORIENT_MASK(*,*)
MASK = MASK/TOTAL(ABS(MASK))
MASK = ROT(MASK,DEGREE+90,1.0,YS/2,YS/2,/CUBIC,/PIVOT)


RETURN,MASK(*,*)

END
