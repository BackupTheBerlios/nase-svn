;+
; NAME: BLUEREDCT
;
; AIM: (-outdated-) Set the colortable running from red to blue,
;      special options for PS.
;
; PURPOSE:  Sets a BLUE-BLACK-RED colortable and changes the plot options device dependent
;
;
; CATEGORY:COLORS
;
;
;
; CALLING SEQUENCE: BLUEREDCT,[REV]
;
; KEYWORD PARAMETERS:
;                     REV:   Sets a BLUE-WHITE-RED colortable
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/10/01 14:50:57  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.1  1999/03/19 12:31:49  gabriel
;          BLUE BLACK RED or BLUE WHITE RED Colortable
;
;
;-

PRO setplotformat
!X.THICK = 1.0
!Y.THICK = 1.0
!P.CHARTHICK = 1.5
!P.THICK = 1.0
!P.CHARSIZE = 1.2
;!P.COLOR = RGB(255,255,255,/NOALLOC) 
;!P.BACKGROUND = RGB(0,0,0,/NOALLOC) 
IF !D.NAME EQ "PS" THEN BEGIN
   !X.THICK = 5.0
   !Y.THICK = 5.0
   !P.CHARTHICK = 5.0
   !P.THICK = 5.0
   ;!P.BACKGROUND=RGB(255,255,255,/NOALLOC)     
END
END


PRO BLUREDCT,R,G,B,BW=BW,REV=REV
   default,REV,0
   default,BW,0
   dim = !D.TABLE_SIZE
   R = indgen(dim)*255/dim
   
   R(0:dim/2-1) = indgen(dim/2)*2
   R(dim/2:*) = 255
   B = reverse(R)
   G = BYTSCL(R+B)
   
   ;IF !D.NAME EQ "PS" THEN BEGIN
   ;   print,"Device ist PS"
 
   IF REV EQ 1 THEN BEGIN
      R = BYTSCL(((FLOAT(R))^2)) 
      B = BYTSCL((((B))))
      G(0:dim/2) = BYTSCL(FLOAT(G(0:DIM/2))^2)
       ;G(dim/2:dim-1) = BYTSCL(FLOAT(G(DIM/2:DIM-1)))
      
   END ELSE BEGIN
      R = reverse(dim-1-R) 
      B = reverse(dim-1-B) 
      G(*) = 0


   ENDELSE

   
   ;END ELSE print,"Device ist PS"
   !X.THICK = 1.0
   !Y.THICK = 1.0
   !P.CHARTHICK = 1.0
   IF !D.NAME EQ "PS" THEN BEGIN
      !X.THICK = 3.0
      !Y.THICK = 3.0
      !P.CHARTHICK = 3.0
      ;tc = reverse(r)
      ;R = BYTSCL(sqrt((reverse(R)))) 
      ;B = BYTSCL(sqrt((reverse(B))))
      ;G = BYTSCL(SQRT(G))
  
      ;stop
      ;G(*) = 0
      ;R = 255-R
      ;B = 255-B
      ;G(*) = 255
   ENDIF
  
   ;uloadct,5
   ;utvlct,R,G,B ,/GET
   !REVERTPSCOLORS = 1
   IF BW EQ 1 THEN BEGIN
   ;;;;;;;;
      R = FIX((255-abs(findgen(dim)-dim/2))*2*255/dim)
      G = R
      B = R
   ;;;;;; 
   ENDIF

   R(254) = (0)
   G(254) = (0)
   B(254) = (0)
   R(255) = (255)
   G(255) = (255)
   B(255) = (255)
   utvlct,R,G,B

   ;!P.COLOR = RGB(255,255,255,/NOALLOC)
   ;!P.BACKGROUND = RGB(0,0,0,/NOALLOC)
   setplotformat  
END
