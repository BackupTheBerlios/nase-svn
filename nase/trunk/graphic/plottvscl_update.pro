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
;               ursprünglich übergeben wurden (NASE, NSCALE, SETCOL,
;               COLORMODE,...) werden, soweit sie sich auf die
;               Farbskalierung beziehen, unverändert übernommen.
;
;     RANGE_IN:: When passed, the two-element array is taken as the range to
;               scale to the plotting colors. (I.e. the first element is scaled to
;               color index 0, the scond is scaled to the highest available
;               index (or to PlotInfo.Top in the no-NASE, no-NEUTRAL, no-NOSCALE 
;               case)).
;               Note that when Info.NASE, Info.NSCALE or Info.NEUTRAL is specified, only the highest
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

;;;   On_Error, 2
   IF NOT Set(W) THEN Message, 'Argument undefined'
   IF !D.Name EQ 'NULL' THEN RETURN
   
   ;;These Keywords are needed in both cases, init and update:
   Default, ORDER, Info.order
   Default, NSCALE, Info.nscale
   Default, NORDER, Info.norder
   Default, POLYGON, Info.polygon
   Default, CUBIC, Info.cubic
   Default, INTERP, Info.interp
   Default, MINUS_ONE, Info.minus_one
   Default, NOSCALE, Info.noscale
   Default, COLORMODE, Info.colormode
   Default, SETCOL, Info.setcol
   Default, ALLOWCOLORS, Info.allowcolors

   ;; ---------- handling of incoming RANGE_IN keyword --------------
   ;; ------- outgoing value will be handled according to -----------
   ;; ------- different cases (see below) ---------------------------
   ;;If RANGE_IN was explicitely specified, it shall override the
   ;;value stored in the Info struct, but only for this call. We will
   ;;use that value for scaling, in both cases (INT and not).
   ;; a value of Info.RANGE_IN=[-1d,-1d] indicates uninitialized
   ;; color-scaling.
   Default, RANGE_IN, Info.Range_In

   If a_eq(RANGE_IN, [-1d, -1d]) then begin
      ;; colorscaling is uninitialized and unspecified, so we force INIT:
      INIT = 1
      ;; Showweights_Scale_Range_In is left undefined,
      ;; showweights_scale() will chose a value.
   endif else begin
      ;; colorscaling is explicitely specified, or already
      ;; established, so we want to tell Showweights_Scale what to do:
      Showweights_Scale_Range_In = max(abs(RANGE_IN))
      ;;Note that while info.Range_In and the value passed in the keyword
      ;;are arrays of two elements, the local variable
      ;;Showweights_Scale_Range_In is scalar.
   endelse

   If not Keyword_Set(INIT) then begin ;Just plot in new image
      SETCOL = 0  ; We never want to have the colortable set at an update.
   Endif
   ;; Note that the above does not cover the non-NSCALE, non-NEUTRAL,
   ;; non-NOSCALE case (As it relies on ShowWeights_Scale). 
   ;; The INIT/update of this case is therefore
   ;; handled in special in the Plotting part below.    

   ;; --------- end: handling of incoming RANGE_IN keyword ----------



   ;;-----Zeichnen der Graphik:
   If keyword_set(NOSCALE) then begin

      ;; case: NOSCALE
      ;;       utv-call
      UTV, NORDER=NORDER, W, Info.x00_norm, CUBIC=cubic, $
           INTERP=interp, MINUS_ONE=minus_one, $
           Info.y00_norm, ALLOWCOLORS=allowcolors, $
           X_SIZE=float(Info.x1)/!D.X_PX_CM, $
           Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
           ORDER=order, POLYGON=POLYGON
      If Keyword_Set(INIT) then Info.Range_In = [-1d, -1d]
      ;;(colorscaling uninitialized)

   Endif else begin   
      
      IF Keyword_Set(NSCALE) THEN BEGIN
         ;;case: NSCALE only
         ;;      utv-call mit showweights_scale()
         UTV, NORDER=NORDER, ALLOWCOLORS=allowcolors, $ $
              ShowWeights_Scale(W, SETCOL=setcol, COLORMODE=colormode, $
                                GET_COLORMODE=get_colormode, $
                                RANGE_IN=Showweights_Scale_Range_In, $
                                GET_RANGE_IN=get_range_in), $
              Info.x00_norm, CUBIC=cubic, INTERP=interp, $
              MINUS_ONE=minus_one, $
              Info.y00_norm, X_SIZE=float(Info.x1)/!D.X_PX_CM, $
              Y_SIZE=float(Info.y1)/!D.Y_PX_CM, ORDER=Order, POLYGON=POLYGON
         If Keyword_Set(INIT) then begin 
            Info.Range_In = get_range_in
            Info.colormode = get_colormode ;store for update
            if (a_eq(get_range_in, [0, 0])) then begin
               console, /Warning, "/INIT: Unable to establish " + $
                        "color scaling, because all entries " + $
                        "are 0 or !NONE."
               console, /Warning, "Postponed initialization to next call."
               ;; we want to indicate this by setting Info.Range_In to
               ;; "uninitialized":
               Info.Range_In = [-1d, -1d]
            endif
         EndIf
         
      ENDIF else begin
         
         
         ;;case: None of NSCALE, NOSCALE set:
         ;;      utvscl-call
         If Keyword_Set(INIT) then begin ;store array Range in info
            ;;               PRINT, "INIT"
            nonones = where(W ne !NONE, nononecount)
            if nononecount ne 0 then begin
               ;; there is at least one entry that is not !NONE
               min = min(W[nonones])
               max = max(W[nonones])
               Info.Range_In = [min, max]
               ;; if RANGE_IN was originally not passed and
               ;; colorscaling is uninitialized, we want to use
               ;; this scaling.
               if a_eq(RANGE_IN, [-1d, -1d]) then RANGE_IN = [min, max]
               if (min eq max) then begin
                  console, /Warning, "/INIT: Unable to establish " + $
                           "color scaling, because all entries " + $
                           "are equal (value: "+str(min)+")."
                  console, /Warning, "Postponed initialization to next call."
                  ;; we want to indicate this by setting Info.Range_In to
                  ;; "uninitialized":
                  Info.Range_In = [-1d, -1d]
               endif
            endif  else begin
               ;; all entries are !NONE
               Info.Range_In = [-1d, -1d]
               console, /Warning, "/INIT: Unable to establish " + $
                        "color scaling, because all entries are !NONE."
            endelse
         Endif               
         
         
         ;;scale as stored in info
         UTVScl, NORDER=NORDER, W, TOP=Info.Top, RANGE_IN=Range_In, $
                 ALLOWCOLORS=allowcolors, $
                 Info.x00_norm, CUBIC=cubic, INTERP=interp, $
                 MINUS_ONE=minus_one, $
                 Info.y00_norm, $
                 X_SIZE=float(Info.x1)/!D.X_PX_CM, $
                 Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
                 ORDER=Order, POLYGON=POLYGON
         
      ENDELSE
   endelse

;-----ENDE:
END
