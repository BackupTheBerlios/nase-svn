;+
; NAME:
;  FillBetween
;
; VERSION:
;  $Id$
;
; AIM:
;  Fills area between datapoints
;
; PURPOSE:
;  Fills area between datapoints
;  
;
; CATEGORY:
;  Graphic
;
;
; CALLING SEQUENCE:
;* fillbetween, XVALS, Y1VALS,Y2VALS [,COLOR=COLOR]
;*  [, other polyfill-parameters]
;
;
; INPUTS:
;  XVALS:: specifies the x-axis
;  Y1VALS:: specifies function 1
;  Y2VALS:: specifies function 2
;
; OPTIONAL INPUTS:
;  
;  COLOR: specifies fill-colour (Default: grey)
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;
; this procedure only rearranges the given datavalues to be
; suitable for polyfill. that's all.
;
; EXAMPLE:
;* plot,indgen(100),yrange=[0,5],/NODATA
;* line1=randomu(seed,80)+2.0
;* line2=randomu(seed,80)+1.0
;* axis=indgen(80)+10
;* fillbetween,axis,line1,line2,color=rgb("yellow")
;* oplot,axis,line1
;* oplot,axis,line2
;*>
;
; SEE ALSO:
; 
;-


pro fillbetween,xvals,y1vals,y2vals,color=color,_EXTRA=_extra

	default,color,rgb("grey")
	resx = xvals
        resy = y1vals
          for i=0,n_elements(xvals)-1 do begin
            resx = [resx,xvals(n_elements(xvals)-1-i)]
            resy = [resy,y2vals(n_elements(y2vals)-1-i)]
          endfor
        resx = [resx,resx(0)]
	resy = [resy,resy(0)]
	polyfill,resx,resy,color=color,_extra=_extra
    
end
