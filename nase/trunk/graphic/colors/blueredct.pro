;+
; NAME: BLUEREDCT
;
; VERSION: $Id$
;
; AIM: Set the colortable running from red to blue,
;      special options for PS.
;
; PURPOSE:  Sets a BLUE-BLACK-RED colortable and changes the plot options device dependent
;
;
; CATEGORY:  
;
;    Colors
;
;
; CALLING SEQUENCE: 
;*                     BLUEREDCT [,/REV]
;
; KEYWORD PARAMETERS:
;                     REV::   Sets a BLUE-WHITE-RED colortable
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.3  2000/10/31 12:41:49  gabriel
;          Readjust to the nase color restrictions
;
;     Revision 2.2  2000/10/01 14:50:57  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.1  1999/03/19 12:31:49  gabriel
;          BLUE BLACK RED or BLUE WHITE RED Colortable
;
;
;-

PRO __setplotformat

!X.THICK = 1.0
!Y.THICK = 1.0
!P.CHARTHICK = 1.5
!P.THICK = 1.0
!P.CHARSIZE = 1.2

IF !D.NAME EQ "PS" THEN BEGIN
   !X.THICK = 5.0
   !Y.THICK = 5.0
   !P.CHARTHICK = 5.0
   !P.THICK = 5.0
END

END


PRO BLUEREDCT,R,G,B,REV=REV
   default,REV,0

   dim = !D.TABLE_SIZE
   R = indgen(dim)*255/dim
   
   R(0:dim/2-1) = indgen(dim/2)*2
   R(dim/2:*) = 255
   B = reverse(R)
   G = BYTSCL(R+B)
   
  
 
   IF REV EQ 1 THEN BEGIN
      R = BYTSCL(((FLOAT(R))^2)) 
      B = BYTSCL((((B))))
      G(0:dim/2) = BYTSCL(FLOAT(G(0:DIM/2))^2)
  
      
   END ELSE BEGIN
      R = reverse(dim-1-R) 
      B = reverse(dim-1-B) 
      G(*) = 0


   ENDELSE


   utvlct,R,G,B, /sclct

  
   __setplotformat  
END
