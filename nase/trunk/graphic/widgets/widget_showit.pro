;+
; NAME: Widget_ShowIt
;
; AIM:
;  Create and initialize an extended draw widget, that stores
;  individual plot parameters and color tables. 
;
; PURPOSE: Diese Routine dient der Initialisierung eines Widgets, das ein 
;          einfaches IDL-Draw-Widget um die Fähigkeit der NASE-<A HREF="./SHEETS/#DEFINESHEET">Sheets</A>
;          erweitert, die Graphik-Systemvariablen und private Farbtabellen zu 
;          speichern.
;          Auf Pseudocolor-Displays erhält das ShowIt-Widget wie <A HREF="#SCROLLIT">ScrollIt()</A> eine eigene
;          Eventhandling-Funktion, die die private Farbtabelle setzt, falls
;          der Mauszeiger das jeweilige Fenster "betritt".
;          Außerdem übernimmt die zugehörige Routine
;          <A HREF="#SHOWIT_OPEN">ShowIt_Open</A> die Ermittlung der Window-ID und
;          bereitet das entsprechende Fenster für die Graphikausgabe vor. 
;
; CATEGORY: GRAPHIC /WIDGETS
;
; CALLING SEQUENCE: widgetid = Widget_ShowIt(Parent 
;                                            [, /PRIVATE_COLORS]
;                                            [any keywords])
;
; INPUTS: Parent: Das Eltern-Widget. (Wie Draw-Widgets auch können ShowIt-
;                  Widgets keine Top-Level-Widgets sein. Man muß also immer ein
;                  Eltern-Widget angeben.)
;
; KEYWORD PARAMETERS: /PRIVATE_COLORS: Ist dieses Schlüsselwort gesetzt, so
;                                      wird die private
;                                      Farbtabelle des Widgets 
;                                      immer dann gesetzt ,
;                                      wenn sich der Mauszeiger im 
;                                      Bereich des Widgets befindet. Zum
;                                      Speichern der gewünschten Farbtabelle
;                                      siehe <A HREF="#SHOWIT_CLOSE">ShowIt_Close</A>.
;
;                    Folgende weiteren Schlüsselworte werden mittels _EXTRA an die
;                    dafür zuständigen Widgets weitergereicht:
;
;                     ALIGN_BOTTOM
;                     ALIGN_CENTER 
;                     ALIGN_LEFT
;                     ALIGN_RIGHT
;                     ALIGN_TOP
;                     APP_SCROLL
;                     BUTTON_EVENTS
;                     EVENT_PRO
;                     EVENT_FUNC
;                     EXPOSE_EVENTS
;                     NOTIFY_REALIZE
;                     KILL_NOTIFY
;                     FRAME
;                     GROUP_LEADER
;                     MAP
;                     MOTION_EVENTS
;                     NO_COPY
;                     UNAME
;                     UNITS
;                     UVALUE
;                     XOFFSET
;                     YOFFSET                             
;                     COLOR_MODEL
;                     COLORS
;                     GRAPHICS_LEVEL
;                     RENDERER
;                     RESOURCE_NAME
;                     RETAIN
;                     SCR_XSIZE
;                     SCR_YSIZE
;                     SCROLL
;                     SENSITIVE
;                     TRACKING_EVENTS
;                     UNITS
;                     VIEWPORT_EVENTS
;                     XSIZE
;                     YSIZE
;                     X_SCROLL_SIZE
;                     Y_SCROLL_SIZE
;                    Vgl. IDL-Hilfe zu 'Widget_Draw' und 'Widget_Base'
;
; OUTPUTS: widgetid: Die Identifikationsnummer des generierten Widgets.
;
; PROCEDURE: Erzeugen eines Draw-Widgets, das in seinem UVALUE-Teil die
;            Graphik-Systemvariablen !P, !X, !Y und !Z und die eigene 
;            Farbtabelle ablegt.
;            Event-Handling, das Tracking-Events abfragt und bei Enter-
;            Events die eigene Farbpalette setzt.  
;
; EXAMPLE: p=Widget_Base()
;          s=Widget_ShowIt(p, /PRIVATE_COLORS, XSIZE=500, YSIZE=200)
;          ShowIt_Open, s
;          Plot, RandomN(seed,50)
;          Showit_Close, s   
;
; SEE ALSO: <A HREF="#SCROLLIT">ScrollIt</A>, <A HREF="./SHEETS/#DEFINESHEET">DefineSheet</A>, <A HREF="./SHEETS/#OPENSHEET">OpenSheet</A>, <A HREF="./SHEETS/#CLOSESHEET">CloseSheet</A>, 
;           IDL-Online-Hilfe zu 'Widget_Draw'
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.11  2000/10/01 14:51:59  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.10  2000/03/16 15:13:04  kupper
;        Added oldwin tag to xtra struct.
;
;        Revision 1.9  2000/03/10 20:38:52  kupper
;        some header formatting.
;
;        Revision 1.8  2000/03/10 20:36:10  kupper
;        Added missing keywords to _extra passing.
;
;        Revision 1.7  2000/03/10 20:08:21  kupper
;        Moved Event_Func to draw-widget in order to provide free Event_Func/Event_Pro
;        for the compound widget.
;        Event_Func/Event_Pro keywords are now passed correctly through _extra.
;        Corrected pass-through of event: event-handler must be 0 for a passed-through
;        event!
;
;        Revision 1.6  2000/02/22 16:28:32  kupper
;        Had to use ref_extra for selective keyword passing.
;
;        Revision 1.5  2000/02/22 16:21:12  kupper
;        So. Now all Keywords are passed to the proper widgets.
;
;        Revision 1.4  2000/02/22 15:52:07  kupper
;        Keyword NOTIFY_REALIZE is now passed correctly to the base-widget, not the draw
;        widget!
;
;        Revision 1.3  1999/11/16 17:05:13  kupper
;        Incorporated changes previously made to the sheet/scrollit routines:
;        Will not produce tracking events for TrueColor or DirectColor
;        visuals, but will set colortable upon opening in that case.
;
;        Revision 1.2  1999/09/06 14:04:56  thiel
;            Wrapped draw-widget inside base to provide free uservalue.
;
;        Revision 1.1  1999/09/01 16:43:53  thiel
;            Moved from other directory.
;
;        Revision 1.1  1999/08/30 09:20:34  thiel
;            DrawWidgets who rember their colortables. For use with FaceIt.
;
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

   If Not(PseudoColor_Visual()) then begin
	message, /INFO, 'This does not look like an 8-bit-display! - Will not produce tracking-events!'
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
                  YourPalette : {R: Red, G: Green, B: Blue}, $
                  oldwin : 0l $
                }

   ; create outer base to have free uservalue:
   b = Widget_Base(Parent, _EXTRA=["align_bottom", $
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
   
   ; put draw-widget inside base and store xtra-values in its UVALUE:
   d = Widget_Draw(b, $
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



 

