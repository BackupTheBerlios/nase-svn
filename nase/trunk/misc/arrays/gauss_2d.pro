;+
; NAME: Gauss_2D()
;
;
;
; PURPOSE: Erzeugt ein Array mit einer zweidimensionalen Gaußverteilung mit Maximum 1.
;
;
;
; CATEGORY: Allgemein, Kohonen, X-Zellen, Basic
;
;
;
; CALLING SEQUENCE: Array = Gauss_2D ( {
;                                        /AUTOSIZE, {(sigma|HWB=hwb) | XHWB=xhwb,YHWB=yhwb} 
;                                       |
;                                        x_Laenge, y_Laenge [(,sigma|,HWB=hwb)|,XHWB=xhwb,YHWB=yhwb] [,x0] [,y0] 
;                                      }
;                                      [,/NORM])
;
; OPTIONAL INPUTS: x_Lange, y_Laenge: Dimensionen des gewünschten Arrays.
;                                     Für y_Laenge=1 wird ein eindimensionales
;                                     Array erzeugt.
;                                     Diese Parameter entfallen bei Gebrauch des 
;                                     AUTOSIZE-Schluesselwortes (s.u.)
;
;                  sigma           : Die Standardabweichung in Gitterpunkten. (Default = X_Laenge/6)
;                  Norm            : Volumen der Gaussmaske auf Eins normiert
;	  	   HWB		   : Die Halbwertsbreite in Gitterpunkten. Kann alternativ zu sigma angegeben werden.
;	  	   XHWB, YHWB	   : Die Halbwertsbreite in Gitterpunkten bzgl. x und y (alternativ zu sigma und HWB)
;	  	   x0, y0	   : Die Position der Bergspitze(reltiv zum Arraymittelpunkt). Für x0=0, y0=0 (Default) liegt der Berg in der Mitte des
;			  	     Feldes. (Genauer: bei fix(Laenge/2)).
;                  x0_arr,y0_arr   : wie x0,y0, relativ zur linken oberen Arrayecke
;
;	
; KEYWORD PARAMETERS: HWB, x0_arr, y0_arr, s.o.
;
;                     AUTOSIZE: Wenn gesetzt werden die Ausmaße des
;                       zurueckgelieferten Arrays auf die sechsfache
;                       Standardabweichung eingestellt. (D.h. dreifache
;                       Standardabweichung in beide Richtungen.)
;                       Die Parameter x_Laenge und y_Laenge duerfen in diesem
;                       Fall nicht uebergeben werden.
;                        Es ist zu beachten, dass bei gesetztem AUTOSIZE maximal 
;                       ein Positionsparameter (sigma) uebergeben werden
;                       kann. In anderen Faellen ist das Verhalten der Routine undefiniert!
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
; RESTRICTIONS: Man beachte, dass die Arraydimensionen ungerade sein müssen,
;               wenn der Berg symmetrisch im Array liegen soll!
;
;               Für XHWB != YHWB liefert die Funktion das Produkt zweier
;               eindimensionaler Gaussfunktionen. Dies ist nicht wirklich
;               äquivalent zu einer elliptischen Gaussfunktion. (?)
;               Abhilfe: Eine noch zu implementierende elliptische
;                        DIST()-Funktion als Grundlage verwenden!
;
;               Es ist zu beachten, dass bei gesetztem AUTOSIZE maximal 
;               ein Positionsparameter (sigma) uebergeben werden
;               kann. In anderen Faellen ist das Verhalten der Routine undefiniert!
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
;        Revision 1.11  2000/02/29 17:29:33  kupper
;        Added AUTOSIZE Keyword.
;
;        Revision 1.10  2000/02/29 15:03:05  kupper
;        Added comment on case XHWB != YHWB.
;
;        Revision 1.9  2000/02/29 14:56:10  kupper
;        Added a "Temporary" here and there.
;
;        Revision 1.8  1999/04/13 17:10:30  thiel
;               Noch ein Bugfix bei XHWB/YHWB und NORM-Zusammenarbeit.
;
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
;        Urversion irgendwann 1995 (?), Rüdiger Kupper
;        Keyword HWB zugefügt am 21.7.1997, Rüdiger Kupper
;        Standard-Arbeitsgruppen-Header angefügt am 25.7.1997, Rüdiger Kupper
;        Keywords X0_ARR und Y0_ARR zugefügt, 30.7.1997, Rüdiger Kupper
;-


Function Gauss_2D, xlen,ylen, AUTOSIZE=autosize, $
                   sigma,NORM=norm,hwb=HWB,xhwb=XHWB,yhwb=YHWB, x0, y0,$ ;(optional)
                   X0_ARR=x0_arr, Y0_ARR=y0_arr ;(optional)

   ;; Defaults:
   Default, x0, 0
   Default, y0, 0
   
   IF (set(XHWB) AND NOT set(YHWB)) OR (set(YHWB) AND NOT set(XHWB)) THEN $
    message,'Both XHWB and YHWB must be set'
   
   If keyword_set(HWB) then sigma=hwb/sqrt(alog(4))
   If keyword_set(XHWB) then sigmax=xhwb/sqrt(alog(4))
   If keyword_set(YHWB) then sigmay=yhwb/sqrt(alog(4))
   
   If Keyword_Set(AUTOSIZE) then begin
      If Keyword_Set(XHWB) then begin
         xlen = 2*3*sigmax
         ylen = 2*3*sigmay
      Endif Else begin
         If not Keyword_Set(HWB) then sigma = xlen ;;the first parameter
         xlen = 2*3*sigma
         ylen = 2*3*sigma
      EndElse
   Endif
    
   Default, x0_arr, x0+xlen/2d
   Default, y0_arr, y0+ylen/2d
   Default, sigma,xlen/6d



  IF set(XHWB) THEN BEGIN
     
     xerg = exp(-shift(dist(xlen,1),x0_arr)^2d / 2d /sigmax^2d)
     yerg = exp(-shift(dist(1,ylen),x0_arr,y0_arr)^2d / 2d /sigmay^2d)
     xerg = REBIN(temporary(xerg),xlen,ylen,/SAMPLE)
     yerg = REBIN(temporary(yerg),xlen,ylen,/SAMPLE)
     ERG = temporary(xerg)*temporary(yerg)
     If Keyword_Set(NORM) then ERG =  ERG /TOTAL(ABS(temporary(ERG)))
    return, ERG(*,*)   

  ENDIF

  if ylen eq 1 then return, exp(-shift(dist(xlen,ylen),x0_arr)^2d / 2d /sigma^2d)           
 
  ERG =  exp(-shift(dist(xlen,ylen),x0_arr,y0_arr)^2d / 2d /sigma^2d) 
  

  If Keyword_Set(NORM) then ERG =  ERG /TOTAL(ABS(temporary(ERG)))

  return, ERG(*,*)          
end
