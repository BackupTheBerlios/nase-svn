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
;                                       [, GET_BASE=Widget_ID] [, GROUP=Leader_Widget_ID ] )
; 
; KEYWORD PARAMETERS: XPOS, YPOS, XSIZE, YSIZE: Parameter des Fensters, das tatsächlich auf
;                                               dem Bilschirm erscheint.
;                     XDRAWSIZE, YDRAWSIZE    : Größe des zur gesamten virtuellen Fensters
;                     GROUP                   : Eine Widget-ID des Widgets, das als Group-Leader dienen soll.
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
; Die einzigen Events, die ankommen, sind Size-Events

   Draw = WIDGET_INFO(Event.Top, /CHILD) ;das ist unser Draw-Widget!

   WIDGET_CONTROL, Draw, SCR_XSIZE=Event.X, SCR_YSIZE=Event.Y

End

Function ScrollIt, XPOS=xpos, YPOS=ypos, XSIZE=xsize, YSIZE=ysize, $
                   XDRAWSIZE=xdrawsize, YDRAWSIZE=ydrawsize, $
                   TITLE=title, $
                   GET_BASE=get_base, GROUP=group

   Default,  xsize, 300
   Default,  ysize, 300
   Default,  xpos,  200
   Default,  ypos,  200
   Default,  xdrawsize, 500
   Default,  ydrawsize, 500
   Default,  title, 'Scroll It!'
   Default,  group, 0
 
   Base = Widget_Base(GROUP_LEADER=group, TITLE=title, $
                     XOFFSET=xpos, YOFFSET=ypos, $
                     /TLB_SIZE_EVENTS)
   Draw = Widget_Draw(Base, $
                      XSIZE=xdrawsize, YSIZE=ydrawsize, $
                      X_SCROLL_SIZE=xsize, Y_SCROLL_SIZE=ysize)

   Widget_Control, /REALIZE, Base
   Widget_Control, GET_VALUE=Window_ID, Draw

;   Leider funktioniert das Resize erst so richtig ab IDL 4.0:
   If fix(!VERSION.Release) ge 4 then XMANAGER, 'ScrollIt', Base, /JUST_REG

   get_base = Base
   return, Window_ID
end

