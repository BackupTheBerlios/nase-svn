;+
; NAME: PlotTVScl_update
;
;
; PURPOSE: Auffrischung einer zuvor mittels <A HREF="#PLOTTVSCL">PlotTVScl</A> dargestellten
;          Graphik
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: PlotTvScl_update, Array, PlotInfo [,/INIT]
;
; INPUTS: Array   : Der neue Inhalt der Graphik. Muß
;                   selbstverständlich die gleichen Ausmaße wie
;                   das ursprüngliche Array haben.
;                   (Die Ausmaße werden von der Routine NICHT getestet.)
;         PlotInfo: Der von <A HREF="#PLOTTVSCL">PlotTVScl</A> beim
;                   ursprünglichen Aufruf in GET_INFO
;                   zurückgelieferte Struct.
;
; KEYWORD PARAMETERS: 
;
;         INIT: Wenn gesetzt, wird eine neue Farbskalierung
;               durchgeführt, so, als ob <A HREF="#PLOTTVSCL">PlotTvScl</A> aufgerufen
;               worden wäre. Alle Schlüsselworte, die <A HREF="#PLOTTVSCL">PlotTvScl</A>
;               ursprünglich übergeben wurden (NASE, SETCOL,
;               COLORMODE,...) werden, soweit sie sich auf die
;               Farbskalierung beziehen, unverändert übernommen.
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
; SEE ALSO: <A HREF="#PLOTTVSCL">PlotTVScl</A>
;      
; MODIFICATION HISTORY:
;     
;     $Log$
;     Revision 2.6  1999/09/23 17:52:44  kupper
;     Oops! Forgot to pass SETCOL-Keyword, sorry...
;
;     Revision 2.5  1999/09/23 14:12:39  kupper
;     Corrected Legend colorscaling (now uses TOP).
;     Updating should work now, behaviour of plottvscl should even be
;     faster.
;     Case /NOSCALE, NASE=0 was broken(!). Fixed.
;
;     Revision 2.4  1999/09/23 14:01:22  kupper
;     Huh, covered all cases now, hopefully...
;
;     Revision 2.3  1999/09/22 09:49:30  kupper
;     Added Documentation.
;
;     Revision 2.2  1999/09/22 09:08:31  kupper
;     Added NEUTRAL Keyword in PlotTvScl_update (forgotten).
;     Corrected minor bug in legend scaling.
;
;     Revision 2.1  1999/09/22 08:44:57  kupper
;     Ausgelagert aus PlotTvScl.
;     Kann nun zum updaten von PlotTvScl-Graphiken benutzt werden.
;
;-

PRO PlotTvscl_update, W, Info, INIT=init

;print, "PlotTvScl_update"
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

   Default, TOP, Info.top
   Default, TOP, !D.Table_Size-1

   If not Keyword_Set(INIT) then begin ;Just plot in new image with same scaling
      Range_In = Info.Range_In(1)  ;use given scaling, let not choose showweights_scale
      SETCOL    = 0             ;We never want to have the colortable set at an update.
   EndIf
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
         UTV, Transpose(W), Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm,$
          X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM,$
          ORDER=UpSideDown, POLYGON=POLYGON
         If Keyword_Set(INIT) then Info.Range_In = [-1.0, -1.0]

      END ELSE BEGIN            ;CASE: NASE
;         print, "NASE"
         UTV, $
          ShowWeights_Scale(Transpose(W),SETCOL=setcol, COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                            RANGE_IN=Range_In, GET_RANGE_IN=get_range_in), $
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
         UTV, $
          ShowWeights_Scale(W, SETCOL=setcol, COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                            RANGE_IN=Range_In, GET_RANGE_IN=get_range_in), $
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
            UTV, W, $
             Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
             Info.y00_norm, $
             X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
             ORDER=UpSideDown, POLYGON=POLYGON
            If Keyword_Set(INIT) then Info.Range_In = [-1.0, -1.0]            
         endif else begin       ;CASE: None of NASE, NEUTRAL, NOSCALE set
;            print, "NONE"
            If Keyword_Set(INIT) then begin ;Use normal UTvScl and store Range
;               PRINT, "INIT"
               Info.Range_In = [min(W), max(W)]
               UTVSCL, W, $
                Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
                Info.y00_norm, $
                X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
                ORDER=UpSideDown, POLYGON=POLYGON, TOP=top
            Endif Else begin    ;this is an update: Use UTV and scale as stored at last INIT 
;               PRINT, "UPDATE"
               UTV, Scl(W, [0, TOP], Info.Range_In), $
                Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
                Info.y00_norm, $
                X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
                ORDER=UpSideDown, POLYGON=POLYGON
            Endelse
         EndElse

     END
   END



;-----ENDE:
END
