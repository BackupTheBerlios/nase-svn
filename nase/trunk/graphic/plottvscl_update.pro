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
;         PlotInfo: Der von <A HREF="#PLOTTVSCL">PlotTVScl</A> beim
;                   ursprünglichen Aufruf in GET_INFO
;                   zurückgelieferte Struct.
;
; KEYWORD PARAMETERS: 
;                     NOSCALE:   Schaltet die Intensitaetsskalierung ab. Der Effekt ist identisch
;                                mit dem Aufruf von <A HREF="#PLOTTV">PlotTV</A>
;                                Siehe dazu auch den Unterschied zwischen den Original-IDL-Routinen 
;                                TVSCL und TV.
;                     ORDER:     der gleiche Effekt wie bei Original-TVScl
;                     NASE:      Bewirkt die richtig gedrehte Darstellung von Layerdaten 
;                                (Inputs, Outputs, Potentiale, Gewichte...).
;                                D.h. z.B. werden Gewichtsmatrizen in der gleichen
;                                Orientierung dargestellt, wie auch ShowWeights sie ausgibt.
;                     NEUTRAL:   bewirkt die Darstellung mit NASE-Farbtabellen inclusive Extrabehandlung von
;                                !NONE, ohne den ganzen anderen NASE-Schnickschnack
;                     POLYGON   : Statt Pixel werden Polygone gezeichnet (gut fuer Postscript)
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
;                     SETCOL    : Default:1 Wird an ShowWeights_Scale weitergereicht, beeinflusst also, ob
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

PRO PlotTvscl_update, _W, Info, $
             ORDER=Order, NASE=Nase, NEUTRAL=neutral, NOSCALE=NoScale, $
             POLYGON=POLYGON,$
             TOP=top,$
             CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
             COLORMODE=colormode, SETCOL=setcol

   On_Error, 2
   IF NOT Set(_W) THEN Message, 'Argument undefined'
   IF !D.Name EQ 'NULL' THEN RETURN

   Default, ORDER, Info.order
   Default, NASE, Info.nase
   Default, NOSCALE, Info.noscale
   Default, POLYGON, Info.polygon
   Default, TOP, Info.top
   Default, CUBIC, Info.cubic
   Default, INTERP, Info.interp
   Default, MINUS_ONE, Info.minus_one
   Default, COLORMODE, Info.colormode
   Default, SETCOL, Info.setcol
   Default, NEUTRAL, Info.neutral



   W = _W
   IF (Keyword_Set(NASE) OR Keyword_Set(NEUTRAL)) THEN BEGIN
      maxW = Max(W)
      minW = Min(NoNone_Func(W))
   END

   IF Keyword_Set(NASE) THEN BEGIN
      ArrayHeight = (size(w))(1)
      ArrayWidth  = (size(w))(2)
   END ELSE BEGIN
      ArrayHeight = (size(w))(2)
      ArrayWidth  = (size(w))(1)
   END
   
   
   
;   ;-----Behandlung der NASE und ORDER-Keywords:
;   XBeschriftung = XRANGE
   IF keyword_set(ORDER) THEN BEGIN
      UpSideDown = 1
;      YBeschriftung = REVERSE(YRANGE)
   ENDIF ELSE BEGIN
      UpSideDown = 0
;      YBeschriftung = YRANGE
   ENDELSE
   IF (Keyword_Set(NASE)) AND (Keyword_Set(ORDER)) THEN BEGIN
      UpsideDown = 0 
;      YBeschriftung = YRANGE
   ENDIF
   IF (Keyword_Set(NASE)) AND (NOT(Keyword_Set(ORDER)))THEN BEGIN
;      YBeschriftung = REVERSE(YRANGE)
      UpSideDown = 1 
   ENDIF 
    


   ;-----Plotten der UTVScl-Graphik:
   IF Keyword_Set(NASE) THEN BEGIN
      If Keyword_Set(NOSCALE) then BEGIN 
         UTV, Transpose(W), Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm,$
          X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM,$
          ORDER=UpSideDown, POLYGON=POLYGON
      END ELSE BEGIN
         UTV, ShowWeights_Scale(Transpose(W),SETCOL=setcol, COLORMODE=colormode), Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm, X_SIZE=float(Info.x1)/!D.X_PX_CM,$
          Y_SIZE=float(Info.y1)/!D.Y_PX_CM, ORDER=UpSideDown , POLYGON=POLYGON
      ENDELSE
   END ELSE BEGIN
      IF Keyword_Set(NEUTRAL) THEN BEGIN
         UTV, ShowWeights_Scale(W, SETCOL=setcol, COLORMODE=colormode), Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm, X_SIZE=float(Info.x1)/!D.X_PX_CM, $
          Y_SIZE=float(Info.y1)/!D.Y_PX_CM, ORDER=UpSideDown , POLYGON=POLYGON
      END ELSE BEGIN
         UTVScl, W, Info.x00_norm, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          Info.y00_norm, $
          X_SIZE=float(Info.x1)/!D.X_PX_CM, Y_SIZE=float(Info.y1)/!D.Y_PX_CM, $
          ORDER=UpSideDown, NOSCALE=NoScale, POLYGON=POLYGON, TOP=top
      END
   END


;-----ENDE:
END
