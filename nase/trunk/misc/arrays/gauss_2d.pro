;+
; NAME: Gauss_2D()
;
; PURPOSE: Erzeugt ein Array mit einer zweidimensionalen Gaußverteilung mit Maximum 1.
;
; CATEGORY: Allgemein, Kohonen, X-Zellen, Basic
;
; CALLING SEQUENCE: Array = Gauss_2D ( {
;                                        /AUTOSIZE, {{(sigma|HWB=hwb)}
;                                        | {XHWB=xhwb,YHWB=yhwb [,phi=phi]}} 
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
;                  PHI             : an assymetric distribution can be
;                                    rotated by an angle of PHI in
;                                    degree (clockwise). Center of
;                                    rotation is the array center,
;                                    shifting (x0,y0 NE 0) is done
;                                    prior to rotation.
;	  	   x0, y0	   : Die Position der Bergspitze(reltiv zum Arraymittelpunkt). Für x0=0, y0=0 (Default) liegt der Berg in der Mitte des
;			  	     Feldes. (Genauer: bei Laenge/2.0).
;                  x0_arr,y0_arr   : wie x0,y0, relativ zur linken oberen Arrayecke
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
; OUTPUTS: Array: Ein ein- oder zweidimensionales Array vom Typ Double und der angegebenen Dimension mit Maximum 1.
;
; RESTRICTIONS: Man beachte, dass die Arraydimensionen ungerade sein müssen,
;               wenn der Berg symmetrisch im Array liegen soll!
;
;               Für XHWB != YHWB liefert die Funktion das Produkt zweier
;               eindimensionaler Gaussfunktionen. (Dies ist 
;               äquivalent zu einer elliptischen Gaussfunktion.)
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
;        Revision 1.17  2000/07/19 13:54:44  kupper
;        Added comment on order of shifting/roztation.
;
;        Revision 1.16  2000/07/19 13:36:47  kupper
;        Now using non-cyclic Distance() instead of dist().
;        Hence, for non-centered tip-locations, mask is not cyclic shifted but
;        properly computed. Tip locations my now be outside the array, too.
;
;        Revision 1.15  2000/07/18 13:32:02  kupper
;        Changed /CUBIC to CUBIC=-0.5 in ROT() call.
;
;        Revision 1.14  2000/06/19 13:25:15  saam
;              + new keyword PHI to rotate assymmetric distributions
;
;        Revision 1.13  2000/02/29 18:53:10  kupper
;        Removed stupid ABS in normalization (gaussians are always positive!)
;        Corrected use of Temporary() in normalization.
;
;        Revision 1.12  2000/02/29 17:44:01  kupper
;        Added 1 to the sizes computed by AUTOSIZE. Thus, the array has odd size again.
;
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

Function Gauss_function, x, sigma
   return, exp( -0.5 * (x/float(sigma))^2 )
End

Function Gauss_2D, xlen,ylen, AUTOSIZE=autosize, $
                   sigma,NORM=norm,hwb=HWB,xhwb=XHWB,yhwb=YHWB, x0, y0,$ ;(optional)
                   X0_ARR=x0_arr, Y0_ARR=y0_arr, PHI=phi ;(optional)

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
         xlen = 2*3*sigmax+1
         ylen = 2*3*sigmay+1
      Endif Else begin
         If not Keyword_Set(HWB) then sigma = xlen ;;the first parameter
         xlen = 2*3*sigma+1
         ylen = 2*3*sigma+1
      EndElse
   Endif
    
   Default, x0_arr, x0+xlen/2d
   Default, y0_arr, y0+ylen/2d
   Default, sigma,xlen/6d



   IF set(XHWB) THEN BEGIN
       Default, phi, 0d

       xn = REBIN(Distance(xlen,1, x0_arr, 0.5  ), xlen, ylen, /SAMPLE)
       yn = REBIN(Distance(1,ylen, 0.5   ,y0_arr), xlen, ylen, /SAMPLE)
       IF PHI NE 0d THEN BEGIN
           xn = ROT(xn,phi,1,xlen/2,ylen/2,CUBIC=-0.5,/PIVOT)
           yn = ROT(yn,phi,1,xlen/2,ylen/2,CUBIC=-0.5,/PIVOT)
       END
       xerg = Gauss_function(xn, sigmax)
       yerg = Gauss_function(yn, sigmay)

       ERG = temporary(xerg)*temporary(yerg)
       If Keyword_Set(NORM) then begin
           i = TOTAL(ERG)
           ERG = temporary(ERG) / i
       Endif
       return, ERG

  ENDIF

  if ylen eq 1 then return, $
   Gauss_function(Distance(xlen,1,x0_arr,0.5), sigma)           
 
  ERG = Gauss_function(Distance(xlen,ylen,x0_arr,y0_arr), sigma) 
  

  If Keyword_Set(NORM) then begin
     i = TOTAL(ERG)
     ERG = temporary(ERG) / i
  Endif

  return, ERG          
end
