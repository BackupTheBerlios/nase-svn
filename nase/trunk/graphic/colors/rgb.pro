;+
; NAME: RGB()
;
; VERSION:
;  $Id$
;
; AIM:
;  Define color for plotting, works on truecolor and pseudocolor displays.
;
; PURPOSE:
;  Allocates one or multiple color cells for plotting on arbitrary displays.
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE: 
;*color = RGB( {red,green,blue | colorname} [,/NOALLOC] )
;                    
; INPUTS:
;  red,green,blue:: red, green and blue values of the color ranging
;                   from 0 to 255. May be scalars or arrays.
;  colorname:: valid color string or array of strings (see <A>Color</A>)
;
; INPUT KEYWORDS:
;  NOALLOC:: Instead of allocating a new color, a maximally similar,
;            already allocated color will be returned. This option is
;            intended to save color cells and is only functional only
;            for 8-bit displays. It will be ignored on all other displays.
;
;                 
; OUTPUTS: 
;  color:: color index or array of color indices (type LONG),
;           depending on the input arguments
;
; COMMON BLOCKS:
;  <*>COMMON_RGB</*> contains UCC that keeps track of the next free color index
;
; SIDE EFFECTS:
;  The color map may be modified.
;
; RESTRICTIONS:
;  IMPORTANT: To determine the type of display correctly, the color
;  information must be established in !D, i.e. the display has to be
;  opened at least once before using <*>RGB()</*>.<BR>  
;  The <*>TVLCT</*> command in <*>RGB()</*> cannot be used on the NULL
;  device. In this case, <*>RGB()</*> skips the colortable loading and
;  issues a debug message.
;
; EXAMPLE:
;*Plot, Indgen(10), COLOR=RGB(0,0,255) 
; results in a blue plot.
;*Plot, Indgen(10), COLOR=RGB('blue')
; is another alternative to get the same result.
; You may also specify multiple colors:
;*OPlotMaximumFirst, RandomU(seed,50,2), COLOR=RGB(["red","pale green"])
;
;-


   
FUNCTION _RGB, R,G,B, NOALLOC=noalloc
Common common_RGB, ucc

;;; ucc : user color counter; counter for the reserved color indices
;;;       protected from overwriting by Uloadct, indicated by !TOPCOLOR;
;;;       ucc = 0 points to !TOPCOLOR+1


   If (TypeOf(R) eq 'STRING') then Color, R, /EXIT, RED=R, GREEN=G, BLUE=B


   ;; order of following cases matters:


   ;; ---- NOALLOC --------------------------------------------------------------
   IF Keyword_Set(NOALLOC) THEN BEGIN 
       IF NOT Pseudocolor_Visual() THEN BEGIN
;;           Dmsg, "ignoring keyword NOALLOC in true color mode"
       END ELSE BEGIN
           ;; keine Farbe umdefinieren, sondern aehnlichste zurueckgeben
           myCM = bytarr(!D.Table_Size,3) 
           TvLCT, myCM, /GET
           New_Color_Convert, myCM(*,0), myCM(*,1), myCM(*,2), myY, myI, myC, /RGB_YIC
           New_Color_Convert, R, G, B, Y, I, C, /RGB_YIC
           differences = (myY - Y)^2 + (myI - I)^2 + (myC - C)^2
           lowestDiff = MIN(differences, bestMatch)
           RETURN, bestMatch
       END
   END
   ;; ---------------------------------------------------------------------------



   ;;; search if color is already in palette
   currentColorMap = bytarr(!D.Table_Size,3) 
   TvLCT, currentColorMap, /GET
   matchIdx = MAX(CutSet(CutSet(WHERE(currentColorMap(*,0) EQ R), WHERE(currentColorMap(*,1) EQ G)), WHERE(currentColorMap(*,2) EQ B)))
   IF (matchIdx GT !TOPCOLOR) THEN RETURN, MAX(matchIdx)


   ;;; ok, we have to set a new index
   Default, ucc, -1
   ucc = (ucc + 1) MOD (!D.TABLE_SIZE - !TOPCOLOR - 1 - 2) 
                                ; -2 protects black and white from
                                ; overwrite
   index_to_set = !TOPCOLOR + 1 + ucc



   ;; ---- Screen (X, MAC or WIN), and not pseudocolor: ---------------------------------------
   IF (!D.Name EQ ScreenDevice()) AND NOT Pseudocolor_Visual() THEN BEGIN
      SetColorIndex, index_to_set, R, G, B  
   ENDIF ELSE BEGIN
   ;; ---- all other devices: -------------------------------------------------   
       My_Color_Map = bytarr(!D.Table_Size,3) 
       TvLCT, My_Color_Map, /GET  
       My_Color_Map (index_to_set,*) = [R,G,B]  
       IF !D.NAME NE 'NULL' THEN TvLCT, Temporary(My_Color_Map) $
        ELSE DMsg, 'TVLCT can not be executed on NULL device.'
   END

   return, index_to_set
   ;; ---------------------------------------------------------------------------

END



FUNCTION RGB, R,G,B, _EXTRA=e
  COMMON common_RGB, ucc
  ON_Error, 2

  nr=n_elements(R)
  IF nr GT (!D.TABLE_SIZE - !TOPCOLOR - 1 - 2) THEN Console, "trying to allocate more colors than simutaneously available, consider decreasing !TOPCOLOR", /WARN
  ;; previous statement is not exactly true, since rgb only allocates
  ;; colors not defined before. If the user passes arrays containing
  ;; the same color multiple times, it will nevertheless work. However,
  ;; i'm too lazy to check this here. If you are disturbed by this
  ;; warning, change infolevel
  res=LonArr(nr)
  CASE N_Params() OF
      1: BEGIN
          IF TypeOf(R) NE 'STRING' THEN Console, 'string argument expected', /FATAL
          FOR i=0,nr-1 DO res(i)=_RGB(r(i), _EXTRA=e)
      END
      3: BEGIN
          ng=n_elements(G)
          nb=n_elements(B)
          
          IF (nr ne ng) OR (nr ne nb) or (ng ne nb) THEN CONSOLE, "red, green, blue arguments are of different count", /FATAL
          FOR i=0,nr-1 DO res(i)=_RGB(r(i), g(i), b(i), _EXTRA=e)
      END
      ELSE : Console, 'wrong argument count', /FATAL
  END
  IF nr EQ 1 THEN RETURN, res(0) $
             ELSE RETURN, res

END
