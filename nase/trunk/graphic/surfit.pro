;+
; NAME: SurfIt
;            
; PURPOSE: Interaktiver Surface-Plot.
;          Diese Routine ersetzt das programmtechnisch simplere Int_Surf.
;          Der Unterschied ist, daß diese Routine hier eine kleine
;          Widget-Applikation ist, was es ermöglicht, mehrere
;          SurfIt-Fenster nebeneinander laufen zu lassen, in denen
;          dann unabhängig voneinander gesurft werden kann.
;          Man beachte, daß im Unterschied zu Int_Surf
;          der Knopf im Fenster gedrückt gehalten werden muß, wenn
;          man den Plot drehen will! (Sonst könnte man ja das
;          Fenster nicht verlassen, um sich woanders zu vergnügen,
;          ohne dabei den Plot total zu verdrehen!)
;          Das Fenster kann auch interaktiv vergrößert oder
;          verkleinert werden.  
;
;          Leider hat zumindest mein Fenster-Manager ein kleines
;          Farbproblem mit IDL_Widgets (ganz allgemein): Falls der
;          Plot nicht in der richtigen Farbe erscheint, hilft es,
;          zuerst in ein anderes Fenster und danach wieder in das
;          Surf-Fenster zu klicken.        
;
; CATEGORY: Darstellung, Miscellaneous
;
; CALLING SEQUENCE: SurfIt, Data_Array [,XPOS] [,YPOS] [,XSIZE] [,YSIZE] [,GROUP] [,JUST_REG]
; 
; INPUTS: Data_Array: Das zu plottende Array
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS: XPOS, YPOS, XSIZE, YSIZE: Die Fenster-Koordinaten, wie üblich
;                     GROUP:    Die Widget-ID eines Widgets, das als "Group-Leader" dienen soll:
;                               Wird der Group-Leader gekillt, so stirbt auch unser Widget.
;                     JUST_REG: Dieses Keyword wird an der XMANAGER weitergereicht.
;                               Wird es gesetzt, so wird das Surf-Widget nur angemeldet, aber noch nicht gemanaged.
;                               Das ermöglicht es, mehrere solche Widgets anzumelden und dann erst mit dem letzten
;                               auch den Manager zu starten, so daß alle gleichzeitig laufen. (Vgl. Beispiel unten.)
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: ---
;
; PROCEDURE: Benutzte Routinen: Default
;
;            Die Routine erzeugt ein Base-Widget mit einem Draw-Widget
;            drin. Über die Motion-Events wird der Cursor
;            abgefragt. Man beachte, daß im Unterschied zu Int_Surf
;            der Knopf im Fenster gedrückt gehalten werden muß, wenn
;            man den Plot drehen will! (Sonst könnte man ja das
;            Fenster nicht verlassen, um sich woanders zu vergnügen,
;            ohne dabei den Plot total zu verdrehen!) Die Koordinaten
;            werden in Winkel umgerechnet und über AX und AZ an
;            Shade_Surf übergeben.
;            Resize-Events werden abgefragt und umgesetzt.
;
; EXAMPLE: 1. SurfIt, Gauss_2D(30,30)
;
;          2. SurfIt, Gauss_2D(30,30), XPOS=100, /JUST_REG
;             SurfIt, Dist(30,30), XPOS=700, XSIZE=300, YSIZE=300
;
; MODIFICATION HISTORY:
;
;       Tue Aug 19 17:00:55 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Hier und da ein NO_COPY eingefügt. Geht jetzt
;		vielleicht schneller.
;
;       Mon Aug 18 04:46:24 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt. Sollte eigentlich funktionieren.
;
;-
Pro SurfIt_Event, Event
 
 WIDGET_CONTROL, Event.Top, GET_UVALUE=info, /NO_COPY
 If Event.Top eq Event.Id then Ev = info else WIDGET_CONTROL, Event.Id, GET_UVALUE=Ev
  CASE TAG_NAMES(Event, /STRUCTURE_NAME) OF 
     "WIDGET_BASE": Begin ;Unser Main-Widget wird resized
        info.xsize = Event.X
        info.ysize = Event.Y
        WIDGET_CONTROL, Event.Top, $ ;Das ist unser Main-Widget! Frag mich nicht, warum, aber auch das muss von Hand resized werden...
                        XSIZE=Event.X, $
                        YSIZE=Event.Y
        WIDGET_CONTROL, WIDGET_INFO(Event.Top, /CHILD), $ ;Das ist unser Draw-Widget!
                        XSIZE=Event.X, $
                        YSIZE=Event.Y

        wdelete, info.pixwin
        window, /free, /pixmap, xsize=Event.X, ysize=Event.Y ;Da brauchen wir auch ein neues Pixmap-Window!
        info.pixwin = !D.Window

        wset, info.drawwin ; und dann machen wir doch noch ein Paint
        shade_surf, info.surface, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0)
        xyouts, /device, 0, 0, "AX="+string(info.CurrentPos(1)+info.delta(1))+"      AZ="+string(info.CurrentPos(0)+info.delta(0))
     End      
     "WIDGET_DRAW": Begin
        Case Event.Type of
           0: Begin ;Button Press
              info.Button_Pressed = (1 eq 1) ;TRUE
              info.Press_x = Event.X
              info.Press_y = Event.Y
              End
           1: Begin ;Button Release
              info.Button_Pressed = (1 eq 0) ;FALSE
              info.CurrentPos = info.CurrentPos+info.delta
              info.delta = [0.0, 0.0, 0.0]
              End
           2: Begin ;Motion
              If info.Button_Pressed then begin
                 info.delta = Convert_Coord(Event.X-info.Press_x, Event.Y-info.Press_y, /DEVICE, /TO_NORMAL)
                 info.delta = info.delta*360
                 info.delta(1) = -info.delta(1)
                 wset, info.pixwin
                 shade_surf, info.surface, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0)
                 xyouts, /device, 0, 0, "AX="+string(info.CurrentPos(1)+info.delta(1))+"      AZ="+string(info.CurrentPos(0)+info.delta(0))
                 wset, info.drawwin
                 Device, copy=[0, 0, info.xsize-1, info.ysize-1, 0, 0, info.pixwin]
              endif
           end
           Endcase          
     End
  Endcase


   ;;-----------Deliver Events to other Widgets?-------------------------
   deliver_events = info.deliver_events
   if deliver_events(0) ne -1 then begin
      valid = WIDGET_INFO(deliver_events, /VALID_ID)
      For wid=1, n_elements(deliver_events) do $
       If valid(wid-1) then begin
         sendevent = Event
         sendevent.ID = deliver_events(wid-1)
         next = deliver_events(wid-1)
         repeat begin
            top = next
            next = WIDGET_INFO(top, /PARENT)
         endrep until next eq 0
         sendevent.TOP = top
         sendevent.HANDLER = 0
         WIDGET_CONTROL, deliver_events(wid-1), SEND_EVENT=sendevent, /NO_COPY
      EndIf
   endif
   ;;-----------End: Deliver Events to other Widgets?-------------------------

  WIDGET_CONTROL, Event.Top, SET_UVALUE=info, /NO_COPY
End

PRO SurfIt, data, XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize, GROUP=group, JUST_REG=Just_Reg, $
            DELIVER_EVENTS=deliver_events, GET_BASE=get_base, $
            TITLE=title

Default, xpos, 500
Default, ypos, 100
Default, xsize, 500
Default, ysize, 500   
Default, deliver_events, [-1]
Default, title, "Surf It!"

window, /free, /pixmap, colors=256, xsize=xsize, ysize=ysize

  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

  junk   = { CW_PDMENU_S, flags:0, name:'' }


  SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $
      MAP=1, $
      TITLE=title, $
      UVALUE={Widget        : "Main", $
              surface       : data, $
              Button_Pressed: (0 eq 1), $ ;FALSE
              Press_x       :0, $
              Press_y       :0, $
              CurrentPos    :[30.0, 30.0, 0.0], $
              delta         :[0.0, 0.0, 0.0], $; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
              pixwin        :!D.Window, $
              drawwin       :0, $ ;still unknown!
              xsize         :xsize, $
              ysize         :ysize, $
              deliver_events:deliver_events $
             }, $
      /NO_COPY, $
      XSIZE=xsize, $
      YSIZE=ysize, $
      XOFFSET=xpos, $
      YOFFSET=ypos, $
      /COLUMN, $
      SPACE=10, $
      /TLB_SIZE_EVENTS)

  Draw =  WIDGET_DRAW(SurfWidget, $
                      COLORS=256, $
                      /MOTION_EVENTS, $
                      /BUTTON_EVENTS, $
                      RETAIN=1, $
                      UVALUE={Widget: "Draw"}, $
                      XSIZE=xsize, $
                      YSIZE=ysize)


  WIDGET_CONTROL, SurfWidget, /REALIZE

  WIDGET_CONTROL, SurfWidget, GET_UVALUE=info, /NO_COPY
  WIDGET_CONTROL, Draw, GET_VALUE=drawwin        ;Die Fensternummer des Draw-Widgets
  info.drawwin = drawwin
  WIDGET_CONTROL, SurfWidget, SET_UVALUE=info, /NO_COPY
  
  wset, drawwin
  shade_surf, data
  xyouts, /device, 0, 0, "AX="+string(30.0)+"      AZ="+string(30.0)

  get_base = SurfWidget

  If fix(!VERSION.Release) ge 5 then XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, /NO_BLOCK $
  else XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg
 

END
