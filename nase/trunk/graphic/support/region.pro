;+
; NAME:
;  Region()
;
; VERSION:
;  $Id$
;
; AIM:
;  returns the region the next plot will occupy
;
; PURPOSE:
;  Computes the region of the next plot in normal or device
;  coordinates. Conforming to IDLs definition, the region specifies
;  a rectangle enclosing the plot area, which includes the plot data
;  window and its surrounding annotation area.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*r = Region([/NORMAL | /DEVICE])
;
; INPUT KEYWORDS:
;  NORMAL:: region will be returned in normal coordinates. This is
;           the default.
;  DEVICE:: region will be returned in device coordinates.
;  
;
; OUTPUTS:
;  r:: a four-element array containing the lower left and upper right
;      corner (x0,y0,x1,y1) of the next plot region in normal or
;      device coordinates.
;
; PROCEDURE:
;*+ get region size<BR>
;*+ determine position of next plot using <*>!P.MULTI(0)</*>
;*+ optionally convert to device coordinates
;  
; EXAMPLE:
;  Imagine you want the next plot to use only 50% of the horizontal
;  space available. This can quite easily be accomplished by reducing
;  the plot region:
;*  !P.REGION = Region()-[0,0,(RegionSize())(0)*.5,0]
;  Doing the plot just like normal:
;*  plot, indgen(10), TITLE='i only use 50% of the horizontal space'
;  Restoring the default arragement settings:
;*  !P.REGION = [0,0,0,0] 
;
; SEE ALSO:
;  <A>RegionSize</A>
;
;-
FUNCTION Region, NORMAL=normal, DEVICE=device

   mm = !P.MULTI
                                ; fix IDL nonsense
   mm(1) = MAX([1,mm(1)])
   mm(2) = MAX([1,mm(2)])


   ps = RegionSize(/DEVICE)     ; ps (x,y) is the size of the plot area in device coordinates


                                ; now we need the relative 
                                ; position rpp where the next plot will
                                ; go: [0,0] lower left corner, counted in number of plots

   pidx = (mm(0)+mm(1)*mm(2)-1) MOD (mm(1)*mm(2)) ; the future value of !P.MULTI(0)
   rpp = [mm(1)-1 - (pidx MOD mm(1)) ,$
                   (pidx  /  mm(1))  ]

   pr = [[rpp(0)*ps(0)        ,rpp(1)*ps(1)        ] ,$
         [rpp(0)*ps(0)+ps(0)-1,rpp(1)*ps(1)+ps(1)-1] ]

   IF NOT KEYWORD_SET(DEVICE) THEN BEGIN
       v= UConvert_Coord([0,pr(0)], [0,pr(1)], /DEVICE, /TO_NORMAL)
       pr(0:1) = (v(*,1)-v(*,0))
       v= UConvert_Coord([0,pr(2)], [0,pr(3)], /DEVICE, /TO_NORMAL)
       pr(2:3) = (v(*,1)-v(*,0))
   END
   RETURN, pr
   
END
