;+
; NAME: Gauss_2D()
;
;
;
; PURPOSE: Erzeugt ein Array mit einer zweidimensionalen Gau�verteilung mit Maximum 1.
;
;
;
; CATEGORY: Allgemein, Kohonen, X-Zellen, Basic
;
;
;
; CALLING SEQUENCE: Array = Gauss_2D ( x_Laenge, y_Laenge [,NORM] 
;                                      [[,sigma | ,HWB=hwb] | [ ,XHWB=xhwb ,YHWB=yhwb]] 
;                                      [,x0] [,y0] [,BLOW])
;
;
; 
; INPUTS: x_Lange, y_Laenge: Dimensionen des gew�nschten Arrays. F�r y_Laenge=1 wird ein eindimensionales Array erzeugt.
;
;
; OPTIONAL INPUTS: sigma           : Die Standardabweichung in Gitterpunkten. (Default = X_Laenge/6)
;                  Norm            : Volumen der Gaussmaske auf Eins normiert
;	  	   HWB		   : Die Halbwertsbreite in Gitterpunkten. Kann alternativ zu sigma angegeben werden.
;	  	   XHWB, YHWB	   : Die Halbwertsbreite in Gitterpunkten bzgl. x und y (alternativ zu sigma und HWB)
;	  	   x0, y0	   : Die Position der Bergspitze(reltiv zum Arraymittelpunkt). F�r x0=0, y0=0 (Default) liegt der Berg in der Mitte des
;			  	     Feldes. (Genauer: bei fix(Laenge/2)).
;                  x0_arr,y0_arr   : wie x0,y0, relativ zur linken oberen Arrayecke
;
;	
; KEYWORD PARAMETERS: HWB, x0_arr, y0_arr, s.o.
;
;
;
; OUTPUTS: Array: Ein ein- oder zweidimensionales Array vom Typ Double und der angegebenen Dimension mit Maximum 1.
;
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: ---
;
;
;
; SIDE EFFECTS: ---
;
;
;
; RESTRICTIONS: Man beachte, dass die Arraydimensionen ungerade sein m�ssen, wenn der Berg symmetrisch im Array liegen soll!
;
;
;
; PROCEDURE: Default
;
;
;
; EXAMPLE: Bspl 1:	Int_Surf, Gauss_2D (31,31)
;	   Bspl 2:	Int_Surf, Gauss_2D (31,21, HWB=2, 5, 5)
;
;
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.7  1999/04/13 14:39:19  thiel
;               'Set' bei der NORM-Abfrage durch 'Keyword_Set' ersetzt.
;
;        Revision 1.6  1997/11/25 18:07:14  gabriel
;              Blow geloescht, Halbwertsbreiten fuer x und y hinzugefuegt
;
;        Revision 1.5  1997/11/25 17:03:32  gabriel
;              Blow Keyword eingesetzt
;
;        Revision 1.4  1997/11/10 19:08:44  gabriel
;             Option: /NORM fuer Volumennormierte Gaussmaske
;
;
;        Urversion irgendwann 1995 (?), R�diger Kupper
;        Keyword HWB zugef�gt am 21.7.1997, R�diger Kupper
;        Standard-Arbeitsgruppen-Header angef�gt am 25.7.1997, R�diger Kupper
;        Keywords X0_ARR und Y0_ARR zugef�gt, 30.7.1997, R�diger Kupper
;-


Function Gauss_2D, xlen,ylen, $
                   sigma,NORM=norm,hwb=HWB,xhwb=XHWB,yhwb=YHWB, x0, y0,$ ;(optional)
                   X0_ARR=x0_arr, Y0_ARR=y0_arr ;(optional)

  ; Defaults:
    Default, x0, 0
    Default, y0, 0
    Default, x0_arr, x0+xlen/2d
    Default, y0_arr, y0+ylen/2d
    Default,sigma,xlen/6d
   
  If keyword_set(HWB) then sigma=hwb/sqrt(alog(4))
  
  IF (set(XHWB) AND NOT set(YHWB)) OR (set(YHWB) AND NOT set(XHWB)) THEN $
   message,'Both XHWB and YHWB must be set'

  IF set(XHWB) AND set(XHWB) THEN BEGIN
     
     sigmax=xhwb/sqrt(alog(4))
     sigmay=yhwb/sqrt(alog(4))
     xerg = exp(-shift(dist(xlen,1),x0_arr)^2d / 2d /sigmax^2d)
     yerg = exp(-shift(dist(1,ylen),x0_arr,y0_arr)^2d / 2d /sigmay^2d)
     xerg = REBIN(xerg,xlen,ylen,/SAMPLE)
     yerg = REBIN(yerg,xlen,ylen,/SAMPLE)
     ERG = xerg*yerg
     return, ERG(*,*)   

  ENDIF

  if ylen eq 1 then return, exp(-shift(dist(xlen,ylen),x0_arr)^2d / 2d /sigma^2d)           
 
  ERG =  exp(-shift(dist(xlen,ylen),x0_arr,y0_arr)^2d / 2d /sigma^2d) 
  

  If Keyword_Set(NORM) then ERG =  ERG /TOTAL(ABS(ERG))

  return, ERG(*,*)          
end
