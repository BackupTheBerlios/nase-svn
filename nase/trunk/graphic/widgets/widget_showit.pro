;+
; NAME: Widget_ShowIt
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
;                                            [, _EXTRA=_extra])
;
; INPUTS: Parent: Das Eltern-Widget. (Wie Draw-Widgets auch können ShowIt-
;                  Widgets keine Top-Level-Widgets sein. Man muß also immer ein
;                  Eltern-Widget angeben.)
;
; OPTIONAL INPUTS: _extra: Alle Inputs und Schlüsselworte werden an das
;                           Draw-Widget weitergereicht. Siehe IDL-Online-
;                           Hilfe über 'Widget_Draw'
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

   ;;event.HANDLER is the id of the outer Base.
   ;;all information is stored in the UVALUE of its first child
   FirstChild = Widget_Info(event.HANDLER, /CHILD)
   Widget_Control, FirstChild, GET_UVALUE=uv
;   WIDGET_CONTROL, Event.Handler, GET_UVALUE=uv

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
         WIDGET_CONTROL, firstchild, SET_UVALUE=uv
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
   event.id = event.handler 
   
   Return, event
  
END





FUNCTION Widget_ShowIt, Parent, $
               PRIVATE_COLORS=private_colors, $
               TRACKING_EVENTS=tracking_events, $
               _EXTRA=_extra

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
                  YourPalette : {R: Red, G: Green, B: Blue} $
                }

   ; create outer base to have free uservalue:
   b = Widget_Base(Parent)

   
   ; put draw-widget inside base and store xtra-values in its UVALUE:
   d = Widget_Draw(b, $
                   TRACKING_EVENTS=(private_colors OR tracking_events), $
                   UVALUE=xtrastruct, /NO_COPY, $
                   _EXTRA=_extra)

   Widget_Control, b, EVENT_FUNC='Widget_ShowIt_Event'
      
   Return, b

END



 

