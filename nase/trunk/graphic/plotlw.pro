;+
; NAME:
;  plotLW
;
; VERSION:
;  $Id$
;
; AIM:
;  produces a fancy plot of a given learnwindow
;
; PURPOSE:
;  produces a fancy plot of a given learnwindow (for instance, one
;  produced with <A>InitLearnBiPoo</A>
;
; CATEGORY:
;  Graphic
;  NASE
;
; CALLING SEQUENCE:
;*plotLW,lwin [,TITLE=title] [,FILENAME=filename]
;
; INPUTS:
;  lwin: a learn window in the format [prelength,postlength,predata,postdata]  
;
; OPTIONAL INPUTS:
;  none
;
; INPUT KEYWORDS:
;  TITLE: a title for the plot.
;  FILENAME: if FILENAME is specified the plot goes to an EPS,
;            otherwise the current window is used.
;  
;
; OUTPUTS:
;  none
;
; OPTIONAL OUTPUTS:
;  none
;
; COMMON BLOCKS:
;  none
;
; SIDE EFFECTS:
;  a plot is generated
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*> plotLW, InitLearnBiPoo(POSTV=0.002, PREV=0.004, $
;*          PRETAU=25.0, POSTTAU=20.0),title="BiPooWindow",filename="dummy"
;
; SEE ALSO:
;  <A>InitLearBiPoo</A>
;-

pro plotLW,lwin,title=title,filename=filename
;lwin = InitLearnBiPoo(POSTV=0.002, PREV=0.004, PRETAU=25.0, POSTTAU=20.0)
default,title,"STDP window"
default,filename,""

prelength = lwin[0]
postlength = lwin[1]
predata=lwin[2:prelength+1]
postdata=lwin[prelength+2:prelength+2+postlength-1]
totaldata = [predata,postdata]
totallength = n_elements(totaldata)
absmax = max(abs(totaldata))
totaldata=totaldata/absmax
absmax=1.0
absxmax=max(abs([prelength+1,postlength+1]))

if filename ne "" then begin
    sheet1 = definesheet(/ps,/verbose,/COLOR, /encapsulated,xsize=14,ysize=10,FILENAME=filename)
    opensheet,sheet1
endif

if filename ne "" then stdcolor = rgb("black") else stdcolor = rgb("white")
plot,indgen(totallength)-prelength, indgen(totallength)*0,/NODATA,xrange=[-absxmax,absxmax],YRANGE=[-absmax,absmax],/YSTYLE,/XSTYLE,color=stdcolor,ytitle="weightchange / a.u.",xtitle="delay / ms",title=title
    
for i=0,totallength-1 do begin
    x = i - prelength
    y = totaldata(i)
    if y lt 0 then begin
        polyfill,[x-.5,x-.5,x+.5,x+.5,x-.5],[0,y,y,0,0],color=rgb("red")
    end else begin        
        polyfill,[x-.5,x-.5,x+.5,x+.5,x-.5],[0,y,y,0,0],color=rgb("green")
    endelse        
end
oplot,[-absxmax,absxmax],[0,0],linestyle=0,color=stdcolor
oplot,[0,0],[-absmax,absmax],linestyle=0,color=stdcolor

if filename ne "" then begin
    closesheet,sheet1
endif
end
