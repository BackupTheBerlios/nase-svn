;+
; NAME: PlotTVScl_update
;
;
; PURPOSE: Auffrischung einer zuvor mittels <A HREF="#PLOTTVSCL">PlotTVScl</A> dargestellten
;          Graphik
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: PlotTvScl_update, Array, PlotInfo,
;                             [, /NOSCALE]
;                             [, /ORDER]
;                             [, /NASE]
;                             [, /NEUTRAL]
;                             [, /POLYGON]
;                             [, TOP=Farbindex]
;                             [, CUBIC=cubic] [, /INTERP] [, /MINUS_ONE]
;                             [, COLORMODE=+/-1] [, SETCOL=0] [, PLOTCOL=PlotColor]
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
;                     NOSCALE:   Schaltet die Intensitaetsskalierung ab.
;                                Siehe dazu auch den Unterschied zwischen den Original-IDL-Routinen 
;                                TVSCL und TV.
;                     ORDER:     der gleiche Effekt wie bei Original-TVScl
;                     NASE:      Bewirkt die richtig gedrehte Darstellung von Layerdaten 
;                                (Inputs, Outputs, Potentiale, Gewichte...).
;                                D.h. z.B. werden Gewichtsmatrizen in der gleichen
;                                Orientierung dargestellt, wie auch ShowWeights sie ausgibt.
;                     NEUTRAL:   bewirkt die Darstellung mit NASE-Farbtabellen inclusive Extrabehandlung von
;                                !NONE, ohne den ganzen anderen NASE-Schnickschnack
;                     POLYGON   : Statt Pixel werden Polygone
;                                 gezeichnet (gut fuer Postscript)
;                                 /POLYGON setzt /CUBIC, /INTERP
;                                 und /MINUS_ONE außer Kraft.
;                     TOP       : Benutzt nur die Farbeintraege von 0..TOP-1 (siehe IDL5-Hilfe von TvSCL)
;                     CUBIC,
;                     INTERP,
;                     MINUS_ONE : werden an ConGrid weitergereicht (s. IDL-Hilfe)
;                     COLORMODE : Wird an Showweights_scale
;                                 weitergereicht. Mit diesem Schlüsselwort kann unabhängig 
;                                 von den Werten im Array die
;                                 schwarz/weiss-Darstellung (COLORMODE=+1) 
;                                 oder die rot/grün-Darstellung
;                                 (COLORMODE=-1) erzwungen werden.
;                     SETCOL    : Wird an ShowWeights_Scale weitergereicht, beeinflusst also, ob
;                                 die Farbtabelle passend fuer den ArrayInhalt gesetzt wird, oder nicht.
;
;
; PROCEDURE: Ausgelagert aus PlotTvScl. Es werden keine neuen
;            Positionsberechnungen durchgeführt. Alle nötigen
;            Positionsdaten werden dem PLOTTVSCL_INFO-Struct entnommen.
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

PRO PlotTvscl_update, W, Info, $
             ORDER=Order, NASE=Nase, NEUTRAL=neutral, NOSCALE=NoScale, $
             POLYGON=POLYGON,$
             TOP=top,$
             CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
             COLORMODE=colormode, SETCOL=setcol, $
             INIT=init
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
