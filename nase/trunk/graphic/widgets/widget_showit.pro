;+
; NAME: Widget_ShowIt
;
; AIM:
;  Create and initialize an extended draw widget, that stores
;  individual plot parameters and color tables. 
;
; PURPOSE: Diese Routine dient der Initialisierung eines Widgets, das ein 
;          einfaches IDL-Draw-Widget um die Fähigkeit der NASE-Sheets
;          (siehe <A>DefineSheet()</A>)
;          erweitert, die Graphik-Systemvariablen und private Farbtabellen zu 
;          speichern.
;          Auf Pseudocolor-Displays erhält das ShowIt-Widget wie <A>ScrollIt()</A> eine eigene
;          Eventhandling-Funktion, die die private Farbtabelle setzt, falls
;          der Mauszeiger das jeweilige Fenster "betritt".
;          Außerdem übernimmt die zugehörige Routine
;          <A>ShowIt_Open</A> die Ermittlung der Window-ID und
;          bereitet das entsprechende Fenster für die Graphikausgabe vor. 
;
; CATEGORY: Graphic Widgets
;
; CALLING SEQUENCE:
;* widgetid = Widget_ShowIt([Parent] 
;*                          [, /PRIVATE_COLORS]
;*                          [any keywords])
;
; OPTIONAL INPUTS: Parent:: Das Eltern-Widget. If omitted, the widget will ba a
;                  top löevel widget.
;
; INPUT KEYWORDS: /PRIVATE_COLORS:: Ist dieses Schlüsselwort gesetzt, so
;                                   wird die private
;                                   Farbtabelle des Widgets 
;                                   immer dann gesetzt ,
;                                   wenn sich der Mauszeiger im 
;                                   Bereich des Widgets befindet. Zum
;                                   Speichern der gewünschten Farbtabelle
;                                   siehe <A>ShowIt_Close</A>.<BR>
;<BR>
;                    Folgende weiteren Schlüsselworte werden mittels _EXTRA an die
;                    dafür zuständigen Widgets weitergereicht:<BR>
;<BR>
;                     ALIGN_BOTTOM<BR>
;                     ALIGN_CENTER <BR>
;                     ALIGN_LEFT<BR>
;                     ALIGN_RIGHT<BR>
;                     ALIGN_TOP<BR>
;                     APP_SCROLL<BR>
;                     BUTTON_EVENTS<BR>
;                     EVENT_PRO<BR>
;                     EVENT_FUNC<BR>
;                     EXPOSE_EVENTS<BR>
;                     NOTIFY_REALIZE<BR>
;                     KILL_NOTIFY<BR>
;                     FRAME<BR>
;                     GROUP_LEADER<BR>
;                     MAP<BR>
;                     MOTION_EVENTS<BR>
;                     NO_COPY<BR>
;                     UNAME<BR>
;                     UNITS<BR>
;                     UVALUE<BR>
;                     XOFFSET<BR>
;                     YOFFSET    <BR>                         
;                     COLOR_MODEL<BR>
;                     COLORS<BR>
;                     GRAPHICS_LEVEL<BR>
;                     RENDERER<BR>
;                     RESOURCE_NAME<BR>
;                     RETAIN<BR>
;                     SCR_XSIZE<BR>
;                     SCR_YSIZE<BR>
;                     SCROLL<BR>
;                     SENSITIVE<BR>
;                     TRACKING_EVENTS<BR>
;                     UNITS<BR>
;                     VIEWPORT_EVENTS<BR>
;                     XSIZE<BR>
;                     YSIZE<BR>
;                     X_SCROLL_SIZE<BR>
;                     Y_SCROLL_SIZE<BR>
;<BR>
;                    Vgl. IDL-Hilfe zu 'Widget_Draw' und 'Widget_Base'
;
; OUTPUTS: widgetid:: Die Identifikationsnummer des generierten Widgets.
;
; PROCEDURE: Erzeugen eines Draw-Widgets, das in seinem UVALUE-Teil die
;            Graphik-Systemvariablen !P, !X, !Y und !Z und die eigene 
;            Farbtabelle ablegt.
;            Event-Handling, das Tracking-Events abfragt und bei Enter-
;            Events die eigene Farbpalette setzt.  
;
; EXAMPLE:
;*  p=Widget_Base()
;*  s=Widget_ShowIt(p, /PRIVATE_COLORS, XSIZE=500, YSIZE=200)
;*  ShowIt_Open, s
;*  Plot, RandomN(seed,50)
;*  Showit_Close, s   
;
; SEE ALSO: <A>ScrollIt</A>, <A>DefineSheet</A>, <A>OpenSheet</A>, <A>CloseSheet</A>, 
;           IDL-Online-Hilfe zu <C>Widget_Draw</C>
;-


FUNCTION Widget_ShowIt_Event, Event

   ;;event.HANDLER is the id of the draw widget
   ;;all information is stored in its UVALUE
   draw_widget = Event.handler
   outer_base = Widget_Info(draw_widget, /Parent)
   Widget_Control, draw_widget, GET_UVALUE=uv

   IF (TAG_NAMES(Event, /STRUCTURE_NAME) EQ  "WIDGET_TRACKING") $
    AND uv.private_colors THEN BEGIN ;possibly, the user requested tracking-events, but NOT private_colors!  

      ;Pointer entered or left the widget

      ;;-----------Check if pointer entered widget and set color table--------
      IF (Event.ENTER EQ 1) THEN BEGIN  ;It's an ENTRY-event!
                                ;save current palette:
         UTVLCT, /GET, Red, Green, Blue
         uv.YourPalette.R = Red
         uv.YourPalette.G = Green
         uv.YourPalette.B = Blue
         WIDGET_CONTROL, draw_widget, SET_UVALUE=uv
                                ;set private palette:
         UTVLCT, uv.MyPalette.R, uv.MyPalette.G, uv.MyPalette.B 
                                ;message, /INFO, "Setting private palette"
      ENDIF ELSE BEGIN          ;It's an LEAVE-event
                                ;reset old palette:
         UTVLCT, uv.YourPalette.R, uv.YourPalette.G, uv.YourPalette.B 
                                ;message, /INFO, "Resetting private palette"
      ENDELSE 
      ;;-----------End: Check if pointer entered widget and set color table---
     
      ; Swallow tracking events if user doesn't want them:
      IF NOT uv.tracking_events THEN Return, 0

   ENDIF

   ; make it look as if the outer base had created the event:
   event.id = outer_base
   event.handler = 0
   
   Return, event
  
END





FUNCTION Widget_ShowIt, Parent, $
                        PRIVATE_COLORS=private_colors, $
                        TRACKING_EVENTS=tracking_events, $
                        _REF_EXTRA=_extra

   Default, private_colors, 0
   Default, tracking_events, 0


   If Keyword_Set(PRIVATE_COLORS) and Not(PseudoColor_Visual()) then begin
	message, /INFO, 'Ignoring /PRIVATE_COLORS - this does not look like an 8-bit-display! '
	private_colors = 0
   end

  ;;obtain current color table:
   UTVLCT, /GET, Red, Green, Blue

   xtrastruct = { info  : 'widget_showit'   ,$
                  p     : !P    ,$
                  x     : !X    ,$
                  y     : !Y    ,$
                  z     : !Z    ,$
                  private_colors : private_colors, $
                  tracking_events : tracking_events, $
                  MyPalette   : {R: Red, G: Green, B: Blue}, $
                  YourPalette : {R: Red, G: Green, B: Blue}, $ ;; used in tracking events on pseudocolor
                  OldPalette  : {R: Red, G: Green, B: Blue}, $ ;; used in open/close
                  oldwin : 0l, $
                  opencount : 0 $
                }

   ; create outer base to have free uservalue:
   ;; we need to check for Parent set explicitely, cause widget_base
   ;; breaks on an unset argument:
   If Set(Parent) then begin
      b = Widget_Base(Parent, /Column, XPad=0, YPad=0, Space=0, _EXTRA=["align_bottom", $
                                      "align_left", $
                                      "align_right", $
                                      "align_top", $
                                      "event_func", $
                                      "event_pro", $
                                      "group_leader", $
                                      "notify_realize", $
                                      "kill_notify", $
                                      "frame", $
                                      "map", $
                                      "no_copy", $
                                      "uname", $
                                      "units", $
                                      "uvalue", $
                                      "xoffset", $
                                      "yoffset"])
   endif else begin
      b = Widget_Base(/Column, XPad=0, YPad=0, Space=0, _EXTRA=["align_bottom", $
                              "align_left", $
                              "align_right", $
                              "align_top", $
                              "event_func", $
                              "event_pro", $
                              "group_leader", $
                              "notify_realize", $
                              "kill_notify", $
                              "frame", $
                              "map", $
                              "no_copy", $
                              "uname", $
                              "units", $
                              "uvalue", $
                              "xoffset", $
                              "yoffset"])
   endelse

   ; put draw-widget inside base and store xtra-values in its UVALUE:
   d = Widget_Draw(b, $
                   FRAME=0, $
                   TRACKING_EVENTS=(private_colors OR tracking_events), $
                   UVALUE=xtrastruct, /NO_COPY, $
                   _EXTRA=["app_scroll", $
                           "button_events", $
                           "color_model", $
                           "colors", $
                           "expose_events", $
                           "graphics_level", $
                           "motion_events", $
                           "renderer", $
                           "resource_name", $
                           "retain", $
                           "scr_xsize", $
                           "scr_ysize", $
                           "scroll", $
                           "sensitive", $
                           "units", $
                           "viewport_events", $
                           "x_scroll_size", $
                           "xsize", $
                           "y_scroll_size", $
                           "ysize"])

   Widget_Control, d, EVENT_FUNC='Widget_ShowIt_Event'
      
   Return, b

END



 

