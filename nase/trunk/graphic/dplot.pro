;+
; NAME:               DPlot  
;
; AIM: Plot two graphs in same coordinate system, with different
;      y-axes on left and right.
;
; PURPOSE:            Ermoeglicht die Darstellung zwei Plots mit
;                     zwei unterschiedlichen Achsenbeschriftungen
;                     (links und rechts) in einem.
;
; CATEGORY:           NASE GRAPHIC
;
; CALLING SEQUENCE:   DPlot, x, y1, y2, _EXTRA=e
;
; INPUTS:             x : die gemeinsamen Abszissen-Werte
;                     y1: Ordinaten-Werte fuer die linke Achse
;                     y2: Ordinaten-Werte fuer die rechte Achse 
;
; KEYWORD PARAMETERS: + alle Plot-Keywords gelten fuer die linke Achse
;                     + alle Plot-Keywords mit der zusaetzlichen Endung
;                       '2' gelten fuer die rechte Achse
;
; EXAMPLE:            
;                     x=findgen(100)/10.
;                     y1=sin(x)
;                     y2=0.25*randomu(seed,100)
;                     dplot, x, y1, y2, ytitle='sinus', yrange2=[0,1], ytitle2='noise'
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 1.1  1999/12/22 18:45:14  saam
;           happy xmas
;
;
;-
PRO DPlot, x, y1, y2, _EXTRA=e

ON_ERROR, 2
   
;divide keywords for different axes
   IF SET(e) THEN BEGIN
      rax2 = ExtraDiff(e, '2', /SUBSTRING)

      IF TypeOf(rax2) EQ 'STRUCT' THEN BEGIN
         ; delete '2' from tagnames
         TN = Tag_Names(rax2)
         FOR i=0, N_ELEMENTS(TN)-1 DO BEGIN
            IF Set(rax) THEN SetTag, rax, STRMID(TN(i), 0, STRLEN(TN(i))-1), rax2.(i) $
                        ELSE rax = Create_Struct(STRMID(TN(i), 0, STRLEN(TN(i))-1), rax2.(i))
         END
      END
   END

mOld = !P.Multi

PLOT, x, y1, YSTYLE=8, XMARGIN=[10, 10], _EXTRA=e

mAct = !P.Multi
!P.Multi = mOld

IF !P.MULTI(0) EQ 0 THEN !P.MULTI(0) = !P.MULTI(1)+!P.MULTI(2)
PLOT, x, y2, XSTYLE=4, YSTYLE=4, XMARGIN=[10, 10], _EXTRA=rax
AXIS, YAXIS=1, YRANGE = !Y.CRANGE, _EXTRA=rax

!P.Multi = mAct

END
