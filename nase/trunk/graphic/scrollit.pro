;+
; NAME: ScrollIt()
;
; PURPOSE: Darstellung großer Graphiken in kleinen Fenstern mit Scrollbalken
;
; CATEGORY: Darstellung, allgemein
;
; CALLING SEQUENCE: Win_Nr = ScrollIt ( [ TITLE=FensterTitel ]
;                                       [, XPOS=Fenster_X_Position] [, YPOS=Fenster_Y_Position ]
;                                       [, XSIZE=Fenster_X_Größe ]  [, YSIZE=Fenster_Y_Größe ]
;                                       [, XDRAWSIZE=Virtuelle_Fenster_X_Größe] [, YDRAWSIZE=Virtuelle_Fenster_Y_Größe]
;                                       [, /PIXMAP ]
;                                       [, GET_BASE=Widget_ID] [, GROUP=Leader_Widget_ID ]
;                                       [, KILL_NOTIFY=KillPro ] )
; 
; KEYWORD PARAMETERS: XPOS, YPOS, XSIZE, YSIZE: Parameter des Fensters, das tatsächlich auf
;                                               dem Bilschirm erscheint.
;                     XDRAWSIZE, YDRAWSIZE    : Größe des zur gesamten virtuellen Fensters
;                     PIXMAP                  : Wird PIXMAP gesetzt, so wird das Widget nicht geMAPped,
;                                               was bedeutet, daß es nicht auf dem Bildschirm erscheint.
;                                               Der Effekt ist also ähnlich der /PIXMAP-Option von Standard-IDL-Fenstern.
;                                               Man vergesse jedoch nicht, das Widget nach Gebrauch zu zuerstören! (S.u.)
;                                               Dazu muß die Base-ID mit GET_BASE angefordert werden.
;                                               Das Widget kann später beliebig mit WIDGET_CONTROL, Widget_ID, MAP={0|1}
;                                               ein- und ausgeblendet werden.
;                     GROUP                   : Eine Widget-ID des Widgets, das als Group-Leader dienen soll.
;                     KILL_NOTIFY             : wie für alle Widgets kann hier ein String mit dem Namen einer Prozedur
;                                               übergeben werden, die aufgerufen wird, wenn das Widget stirbt.
;                                               Dieser Prozedur wird als einziger Parameter die ID des Draw-Widgets übergeben,
;                                               Und up-to-date (IDL 5) ist das EINZIGE, was diese Prozedur damit anfangen kann,
;                                               mittels WIDGET_CONTROL den User-Value abzufragen.
;                                               Dienlicherweise wird dieser von ScrollIt() auf einen Struct der Form
;                                               {info      : 'DRAWWIDGET', $
;                                                Window_ID : Window_ID};
;                                               gesetzt, damit man auch erfährt, welches Fenster gestorben ist.
;
; OUTPUTS: Win_Nr: Ein  Window-Index für folgende Graphikbefehle.
;                  Das geöffnete Fenster wird aber auch zum aktuellen Fenster.
;
; OPTIONAL OUTPUTS: GET_BASE: ID des erstellten Base-Widgets.
;
; SIDE EFFECTS: Wenn IDL V4.0 oder höher verwendet wird, wird das Widget beim XMANAGER registriert.
;               Dann werden nach aufruf von XMANAGER auch Resize-Events richtig verarbeitet.
;
; RESTRICTIONS: Es bringt den XMANAGER durcheinander, wenn das Fenster mit
;               WDelete, Win_Nr gelöscht wird.
;               Lieber das Widget ordnungsgemäß mit dem Close-Knopf schließen
;               oder, wenn es programmgesteuert geschlossen werden
;               soll, das GET_BASE-Schlüsselwort benutzen und ein 
;                  WIDGET_CONTROL, Widget_ID, /DESTROY
;               machen.
;
; PROCEDURE: Einfaches Base- und Draw-Widget mit einfachem Resize-Event-Handler.
;
; EXAMPLE: My_Win = ScrollIt ()
;          Plot, indgen(100)
;          XManager
;
; SEE ALSO: Slide_Image  (Standard-IDL-Routine)
;
; MODIFICATION HISTORY:
;
;       Thu Sep 4 16:18:27 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro ScrollIt_Event, Event
; Die einzigen Events, die ankommen, sollten Size-Events sein!

   If TAG_NAMES(Event, /STRUCTURE_NAME) eq "WIDGET_BASE" then begin
      Draw = WIDGET_INFO(Event.Top, /CHILD) ;das ist unser Draw-Widget!
      
      WIDGET_CONTROL, Draw, SCR_XSIZE=Event.X, SCR_YSIZE=Event.Y
   EndIf
   
   ;;-----------Deliver Events to other Widgets?-------------------------
   WIDGET_CONTROL, Event.Top, GET_UVALUE=base_uval
   if base_uval.deliver_events(0) ne -1 then begin
      valid = WIDGET_INFO(base_uval.deliver_events, /VALID_ID)
      For wid=1, n_elements(base_uval.deliver_events) do $
       If valid(wid-1) then begin
         sendevent = Event
         sendevent.ID = base_uval.deliver_events(wid-1)
         next = base_uval.deliver_events(wid-1)
         repeat begin
            top = next
            next = WIDGET_INFO(top, /PARENT)
         endrep until next eq 0
         sendevent.TOP = top
         sendevent.HANDLER = 0
         WIDGET_CONTROL, base_uval.deliver_events(wid-1), SEND_EVENT=sendevent, /NO_COPY
      EndIf
   endif
   ;;-----------End: Deliver Events to other Widgets?-------------------------
  
End

Function ScrollIt, XPOS=xpos, YPOS=ypos, XSIZE=xsize, YSIZE=ysize, $
                   XDRAWSIZE=xdrawsize, YDRAWSIZE=ydrawsize, $
                   TITLE=title, $
                   PIXMAP=pixmap, $
                   RETAIN=retain, COLORS=colors, $
                   GET_BASE=get_base, GROUP=group, KILL_NOTIFY=kill_notify, $
                   DELIVER_EVENTS=deliver_events

   Default,  xsize, 300
   Default,  ysize, 300
   Default,  xpos,  200
   Default,  ypos,  200
   Default,  title, 'Scroll It!'
   Default,  group, 0
   Default,  pixmap, 0
   Default,  colors, 0
   Default,  retain, 1
   Default,  kill_notify, ''
   Default,  deliver_events, [-1]

   If not Keyword_Set(XDRAWSIZE) then begin
      XDRAWSIZE = XSIZE
      XSIZE = XSIZE-27
   EndIf
   If not Keyword_Set(YDRAWSIZE) then begin
      YDRAWSIZE = YSIZE
      YSIZE = YSIZE-27
   EndIf
 
   Base = Widget_Base(GROUP_LEADER=group, TITLE=title, $
                     XOFFSET=xpos, YOFFSET=ypos, $
                     /TLB_SIZE_EVENTS, MAP=1-PIXMAP, UVALUE={info          : 'ScrollIt_Base', $
                                                             deliver_events: [deliver_events]} )
   Draw = Widget_Draw(Base, $
                      XSIZE=xdrawsize, YSIZE=ydrawsize, $
                      X_SCROLL_SIZE=xsize, Y_SCROLL_SIZE=ysize, $
                      RETAIN=retain, COLORS=colors, KILL_NOTIFY=kill_notify)

   Widget_Control, /REALIZE, Base
   Widget_Control, GET_VALUE=Window_ID, Draw
   Widget_Control, Draw, SET_UVALUE={info      : 'DRAWWIDGET', $
                                     Window_ID : Window_ID}

;   Leider funktioniert das Resize erst so richtig ab IDL 4.0:
;   If fix(!VERSION.Release) eq 4 then XMANAGER, 'ScrollIt', Base, /JUST_REG
   If fix(!VERSION.Release) ge 5 then XMANAGER, 'ScrollIt', Base, /NO_BLOCK

   get_base = Base
   return, Window_ID
end

