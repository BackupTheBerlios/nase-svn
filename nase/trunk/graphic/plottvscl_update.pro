;+
; NAME: PlotTVScl_update
;
; AIM:
;  Refresh a previous PlotTVScl plot using same color coding.
;
; PURPOSE: Refresh a plot previously created using <A>PlotTVScl</A>.
;          Starting from revision 2.8, this routine does not need to be called
;          directly. Instead, a <*>PlotInfo</*> structure can be passed through the
;          <*>UPDATE_INFO</*> keyword to <A>PlotTvScl</A>.
;          However, you may still call this routine directly.
;
; CATEGORY: Graphic
;
; CALLING SEQUENCE: PlotTvScl_update, Array, PlotInfo [,/INIT] [,RANGE_IN=[a,b]]
;
; INPUTS: Array   :: Der neue Inhalt der Graphik. Muß
;                   selbstverständlich die gleichen Ausmaße wie
;                   das ursprüngliche Array haben.
;                   (Die Ausmaße werden von der Routine NICHT getestet.)
;         PlotInfo:: Der von <A>PlotTVScl</A> beim
;                   ursprünglichen Aufruf in GET_INFO
;                   zurückgelieferte Struct.
;
; INPUT KEYWORDS: 
;
;         INIT:: Wenn gesetzt, wird eine neue Farbskalierung
;               durchgeführt, so, als ob <A>PlotTvScl</A> (ohne 
;               das Schlüsselwort UPDATE_INFO) aufgerufen
;               worden wäre. Alle Schlüsselworte, die <A>PlotTvScl</A>
;               ursprünglich übergeben wurden (NASE, SETCOL,
;               COLORMODE,...) werden, soweit sie sich auf die
;               Farbskalierung beziehen, unverändert übernommen.
;
;     RANGE_IN:: When passed, the two-element array is taken as the range to
;               scale to the plotting colors. (I.e. the first element is scaled to
;               color index 0, the scond is scaled to the highest available
;               index (or to PlotInfo.Top in the no-NASE, no-NEUTRAL, no-NOSCALE 
;               case)).
;               Note that when Info.NASE or Info.NEUTRAL is specified, only the highest
;               absolute value of the passed array is used, as according to NASE 
;               conventions, the value 0 is always mapped to color index 0 (black).
;
; PROCEDURE: Ausgelagert aus PlotTvScl. Es werden keine neuen
;            Positionsberechnungen durchgeführt. Alle nötigen
;            Positionsdaten werden dem PLOTTVSCL_INFO-Struct
;            entnommen.
;            Die Farben werden entsprechend der dort
;            gespeicherten Informationen skaliert.
;
; EXAMPLE: width = 25
;          height = 50
;          W = gauss_2d(width, height)+0.01*randomn(seed,width, height)
;          window, xsize=500, ysize=600
;          PlotTvScl, W, 0.0, 0.1, XTITLE='X-AXEN-Beschriftungstext', $
;                     /LEGEND, CHARSIZE=2.0, GET_INFO=i
;          
;          W = gauss_2d(width, height)+0.05*randomn(seed,width, height)
;          PlotTvScl_update, W, i
;
; SEE ALSO: <A>PlotTVScl</A>
;-

PRO PlotTvscl_update, W, Info, INIT=init, RANGE_IN=range_in

   On_Error, 2
   IF NOT Set(W) THEN Message, 'Argument undefined'
   IF !D.Name EQ 'NULL' THEN RETURN
   
   ;;These Keywords are needed in both cases, init and update:
   Default, ORDER, Info.order
   Default, NASE, Info.nase
   Default, POLYGON, Info.polygon
   Default, CUBIC, Info.cubic
   Default, INTERP, Info.interp
   Default, MINUS_ONE, Info.minus_one
   Default, NEUTRAL, Info.neutral
   Default, NOSCALE, Info.noscale
   Default, COLORMODE, Info.colormode
   Default, SETCOL, Info.setcol
   Default, ALLOWCOLORS, Info.allowcolors

   If Keyword_Set(RANGE_IN) then Showweights_Scale_Range_In = max(abs(RANGE_IN))
   ;;If RANGE_IN was specified, use that value for scaling, in both cases (INT
   ;;and not).

;Note that while info.Range_In and the value passed in the keyword are arrays of two
;elements, the local variable Showweights_Scale_Range_In is scalar.

   If not Keyword_Set(INIT) then begin ;Just plot in new image
      Default, Showweights_Scale_Range_In, max(abs(Info.Range_In))
                                ;use given scaling, let not
                                ;choose showweights_scale.
                                ;(If RANGE_IN was specified, use that value. If
                                ;not, use the value in Info.Range_In.)
      
      SETCOL    = 0             ;We never want to have the colortable set at an update.
   Endif
;Note that the above does not cover the non-NASE, non-NEUTRAL,
;non-NOSCALE case (As it relies on ShowWeights_Scale). 
;The INIT/update of this case is therefore
;handled in special in the Plotting part below.
  
   
;   ;-----Behandlung der NASE und ORDER-Keywords:
   IF keyword_set(ORDER) THEN BEGIN
      UpSideDown = 1
   ENDIF ELSE BEGIN
      UpSideDown = 0
   ENDELSE

   IF (Keyword_Set(NASE)) AND (Keyword_Set(ORDER)) THEN BEGIN
      UpsideDown = 0 
   ENDIF

   IF (Keyword_Set(NASE)) AND (NOT(Keyword_Set(ORDER)))THEN BEGIN
      UpSideDown = 1 
   ENDIF 
    


   ;-----Plotten der UTVScl-Graphik:
   IF Keyword_Set(NASE) THEN BEGIN

      If Keyword_Set(NOSCALE) then BEGIN ;CASE: NASE, but do not scale
;         print, "NASE, NOSCALE"
         ;; setting NASE in UTv does transpose array, nothing else. 
         UTV, /NASE, W, Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm, ALLOWCOLORS=allowcolors, $
          X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM,$
          ORDER=UpSideDown, POLYGON=POLYGON
         If Keyword_Set(INIT) then Info.Range_In = [-1.0, -1.0]

      END ELSE BEGIN            ;CASE: NASE
;         print, "NASE"
         ;; setting NASE in UTv does transpose array, nothing else. 
         ;; ALLOWCOLORS must be set to have the !NONE displayed
         ;; correctly, as ShowWeights_Scale replaces it by the color
         ;; index for the blue color.
         UTV, /NASE, /ALLOWCOLORS, $
          ShowWeights_Scale(W,SETCOL=setcol, COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                            RANGE_IN=Showweights_Scale_Range_In, GET_RANGE_IN=get_range_in), $
          Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm, X_SIZE=float(Info.x1)/!D.X_PX_CM,$
          Y_SIZE=float(Info.y1)/!D.Y_PX_CM, ORDER=UpSideDown , POLYGON=POLYGON
         If Keyword_Set(INIT) then begin 
            Info.Range_In = get_range_in(1) ;=MAXCOL, by the way...
            Info.colormode = get_colormode ;store for update
         EndIf

      ENDELSE

   END ELSE BEGIN               ;NASE not set

      IF Keyword_Set(NEUTRAL) THEN BEGIN ;CASE: NEUTRAL: just scale like NASE
;         print, "NEUTRAL"
         ;; ALLOWCOLORS must be set to have the !NONE displayed
         ;; correctly, as ShowWeights_Scale replaces it by the color
         ;; index for the blue color.
         UTV, /ALLOWCOLORS, $
          ShowWeights_Scale(W, SETCOL=setcol, COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                            RANGE_IN=Showweights_Scale_Range_In, GET_RANGE_IN=get_range_in), $
          Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm, X_SIZE=float(Info.x1)/!D.X_PX_CM, $
          Y_SIZE=float(Info.y1)/!D.Y_PX_CM, ORDER=UpSideDown , POLYGON=POLYGON
         If Keyword_Set(INIT) then begin 
            Info.Range_In = get_range_in(1) ;=MAXCOL, by the way...
            Info.colormode = get_colormode ;store for update
         EndIf

      END ELSE BEGIN
         
         If Keyword_Set(NOSCALE) then begin ;CASE: NoNase, Noscale
;            print, "simple NOSCALE"
            UTV, W, ALLOWCOLORS=allowcolors, $
             Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
             Info.y00_norm, $
             X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
             ORDER=UpSideDown, POLYGON=POLYGON
            If Keyword_Set(INIT) then Info.Range_In = [-1.0, -1.0]            
         endif else begin       ;CASE: None of NASE, NEUTRAL, NOSCALE set
;            print, "NONE"
            If Keyword_Set(INIT) then begin ;store array Range in info
;               PRINT, "INIT"
               If Keyword_Set(RANGE_IN) then Info.Range_In = RANGE_IN else $
                Info.Range_In = [min(W), max(W)]
            Endif               
            ;; If defined, RANGE_IN overrides the value stored in info:
            Default, Range_In, Info.Range_In
            ;;scale as stored in info 
               UTV, Scl(W, [0, Info.Top], Range_In), ALLOWCOLORS=allowcolors, $
                Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
                Info.y00_norm, $
                X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
                ORDER=UpSideDown, POLYGON=POLYGON
                           
         EndElse

     END
   END



;-----ENDE:
END
