;+
; NAME:  UCONVERT_COORD
;
;
; PURPOSE:
;           The CONVERT_COORD function transforms one or more sets of coordinates to 
;           and from the coordinate systems supported by IDL. The result of the function
;           is a vector in the same dimensions containing the (x[, y][, z]) components of the n output coordinates.
;           The input coordinates X and, optionally, Y and/or Z can be given in data, device, 
;           or normalized form by using the DATA, DEVICE, or NORMAL keywords. The default input
;           coordinate system is DATA. The keywords TO_DATA, TO_DEVICE, and TO_NORMAL specify 
;           the output coordinate system.
;           Further it's possible to convert only selected coordinates with the Keywords OX, OY and OZ 
;           (default is to convert all coordinates) 
;           If the input points are in 3D data coordinates, be sure to set the T3D keyword.
;
;
; CATEGORY: 
;
;
; CALLING SEQUENCE: 
;                    UCONVERT_COORD, X [,Y][,Z][,DATA=DATA][,DEVICE=DEVICE][,NORMAL=NORMAL]
;                                   [,T3D=T3D][,TO_DATA=TO_DATA][,TO_DEVICE=TO_DEVICE][,TO_NORMAL=TO_NORMAL]
;                                   [,OX=OX][,OY=OY][,OZ=OZ]
;
; 
; INPUTS:
;
;              X        A vector or scalar argument providing the X components of the input coordinates. 
;                       If only one argument is specified, X must be an array of either two or three vectors 
;                       (i.e., (2,*) or (3,*)). In this special case, X[0,*] are taken as the X values, X[1,*] 
;                       are taken as the Y values, and, if present, X[2,*] are taken as the Z values.
;
;
; OPTIONAL INPUTS:
;
;              Y        An optional argument providing the Y input coordinate(s).
;              Z        An optional argument providing the Z input coordinate(s).
;	
; KEYWORD PARAMETERS:
;                     
;              DATA
;              Set this keyword if the input coordinates are in data space (the default).
;              DEVICE
;              Set this keyword if the input coordinates are in device space.
;              NORMAL
;              Set this keyword if the input coordinates are in normalized space.
;              T3D
;              Set this keyword if the 3D transformation !P.T is to be applied.
;              TO_DATA
;              Set this keyword if the output coordinates are to be in data space.
;              TO_DEVICE
;              Set this keyword if the output coordinates are to be in device space.
;              TO_NORMAL
;              Set this keyword if the output coordinates are to be in normalized space.
;              OX
;              Set this keyword if only the X-coordinate is to be converted
;              OY
;              Set this keyword if only the Y-coordinate is to be converted
;              OZ
;              Set this keyword if only the Z-coordinate is to be converted
;
;
; OUTPUTS:  Convertion of the input vector
;
;
; EXAMPLE:
;           Convert, using the currently established viewing transformation, 
;           11 points along the parametric line x = t, y = 2t, z = t^2, along the interval [0, 1] 
;           from data coordinates to device coordinates:
;           X = FINDGEN(11)/10.                   ;Make a vector of X values.
;           D = CONVERT_COORD(X, 2*X, X^2, /T3D, /TO_DEVICE)  ;Convert the coordinates. D will be an (3,11) element array.
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  1998/04/10 16:51:21  kupper
;            Es wurden nichtdefinierte Schlüsselworte übergeben.
;
;     Revision 2.1  1998/02/23 13:27:42  gabriel
;          jetzt kann man explizit coordinaten konvertieren
;
;
;-

FUNCTION UCONVERT_COORD,X, Y, Z, DATA=DATA, DEVICE=DEVICE, NORMAL=NORMAL,$
                 T3D=T3D, TO_DATA=TO_DATA, TO_DEVICE=TO_DEVICE, TO_NORMAL=TO_NORMAL,OX=OX,OY=OY,OZ=OZ

   Default, data, 0
   Default, device, 0
   Default, normal, 0
   Default, t3d, 0
   Default, to_data, 0
   Default, to_device, 0
   Default, to_normal, 0
   
   tmp = size(X)
   IF tmp(0) GT 0 THEN datadim = tmp(1)$
   ELSE datadim = tmp(0)
   
   CASE 1  OF
      set(X) AND set(y) AND set(z): BEGIN
         dim = 3
         erg = CONVERT_COORD(X, Y, Z, DATA=DATA, DEVICE=DEVICE, NORMAL=NORMAL,$
                             T3D=T3D, TO_DATA=TO_DATA, TO_DEVICE=TO_DEVICE, TO_NORMAL=TO_NORMAL)
         
      END  
      set(X) AND set(y): BEGIN
         dim = 2 
         erg = CONVERT_COORD(X, Y,  DATA=DATA, DEVICE=DEVICE, NORMAL=NORMAL,$
                             T3D=T3D, TO_DATA=TO_DATA, TO_DEVICE=TO_DEVICE, TO_NORMAL=TO_NORMAL)
         erg = erg(0:1)
      END
      set(X) OR (datadim GT 0): BEGIN 
         dim = datadim 
         erg = CONVERT_COORD(X,  DATA=DATA, DEVICE=DEVICE, NORMAL=NORMAL,$
                             T3D=T3D, TO_DATA=TO_DATA, TO_DEVICE=TO_DEVICE, TO_NORMAL=TO_NORMAL)
         
      END
      
      
   ENDCASE
      
   IF datadim EQ 0 THEN BEGIN
      IF  set(ox) THEN BEGIN
         IF DIM GE 2 THEN erg(1) = y
         IF DIM EQ 3 THEN erg(2) = z
      ENDIF
      IF set(oy) THEN  BEGIN
         IF DIM GE 2 THEN erg(0) = x
         IF DIM EQ 3 THEN erg(2) = z  
         
      ENDIF
      IF  set(oz) THEN  BEGIN
         IF DIM GE 2 THEN erg(0) = x
         IF DIM EQ 3 THEN erg(1) = y  
         
      END
   
    
   END ELSE BEGIN
      
      IF set(ox)THEN  BEGIN
         IF DIM GE 2 THEN erg(1,*) = x(1,*)
         IF DIM EQ 3 THEN erg(2,*) = x(2,*)  
      ENDIF
      IF set(oy) THEN  BEGIN
         IF DIM GE 2 THEN erg(0,*) = x(0,*)
         IF DIM EQ 3 THEN erg(2,*) = x(2,*)  
      ENDIF
      IF set(oz) THEN BEGIN
         IF DIM GE 2 THEN erg(0,*) = x(0,*)
         IF DIM EQ 3 THEN erg(1,*) = x(2,*)  
      ENDIF
        
   ENDELSE
   erg = erg(0:dim-1,*)
   RETURN,erg
END
