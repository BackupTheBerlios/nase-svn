;+
; NAME: SurfIt
;            
; PURPOSE: Interaktiver Surface-Plot.
;          Diese Routine ersetzt das programmtechnisch simplere Int_Surf.
;          Der Unterschied ist, da� diese Routine hier eine kleine
;          Widget-Applikation ist, was es erm�glicht, mehrere
;          SurfIt-Fenster nebeneinander laufen zu lassen, in denen
;          dann unabh�ngig voneinander gesurft werden kann.
;          Man beachte, da� im Unterschied zu Int_Surf
;          der Knopf im Fenster gedr�ckt gehalten werden mu�, wenn
;          man den Plot drehen will! (Sonst k�nnte man ja das
;          Fenster nicht verlassen, um sich woanders zu vergn�gen,
;          ohne dabei den Plot total zu verdrehen!)
;          Das Fenster kann auch interaktiv vergr��ert oder
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
; CALLING SEQUENCE: SurfIt, Data_Array [,XPOS] [,YPOS] [,XSIZE] [,YSIZE]
;                                      [,GROUP [,/MODAL]] [,JUST_REG] [,NO_BLOCK=0]
;                                      [,TITLE=Fenstertitel]
;                                      [,DELIVER_EVENTS=Array_of_Widget_IDs]
;                                      [,GET_BASE=Base_ID]
;                                      [,PLOT_TITLE=Plottitel]
;                                      [,/NASE] [,/GRID]
;                                      [weitere Shade_Surf- bzw. Surface-Parameter, insbesondere SHADES, LEGO...]
;
; 
; INPUTS: Data_Array: Das zu plottende Array
;
; KEYWORD PARAMETERS: XPOS, YPOS, XSIZE, YSIZE: Die Fenster-Koordinaten, wie �blich
;                     GROUP:    Die Widget-ID eines Widgets, das als "Group-Leader" dienen soll:
;                               Wird der Group-Leader gekillt, so stirbt auch unser Widget.
;                     MODAL:    Wenn angegeben, ist das Widget modal,
;                               d.h. alle anderen Widgets sind
;                               deaktiviert, solange dieses existiert.
;                               MODAL erfordert die Angabe eines
;                               Group-Leaders in GROUP.
;                     JUST_REG: Dieses Keyword wird an der XMANAGER weitergereicht.
;                               Wird es gesetzt, so wird das Surf-Widget nur angemeldet, aber noch nicht gemanaged.
;                               Das erm�glicht es, mehrere solche Widgets anzumelden und dann erst mit dem letzten
;                               auch den Manager zu starten, so da� alle gleichzeitig laufen. (Vgl. Beispiel unten.)
;                     NO_BLOCK: Wird ab IDL 5 an den XMANAGER
;                               weitergegeben. (Beschreibung
;                               s. IDL-Hilfe)
;                               Der Default ist 1, also kein
;                               Blocken. Wird Blocken gew�nscht, so mu�
;                               NO_BLOCK explizit auf 0 gesetzt werden.
;                     DELIVER_EVENTS: Hier kann ein Array
;                                     von Widget-Indizes �bergeben werden, an die alle 
;                                     ankommenden Events
;                                     weitergereicht werden.
;                     TITLE:    Ein Titel f�r das Fenster. (Default:
;                               "Surf It!")
;                     PLOT_TITLE: Ein Titel f�r den Plot. (Default:
;                                 Fenstertitel, falls angegeben)
;                     NASE:     Das Array wird als NASE-Array
;                               behandelt (z.B. keine NONES plotten...)
;                     GRID:     Als Plot-Prozedur wird "Surface"
;                               verwendet, sonst "Shade_Surf"
;
;                     Alle weiteren Parameter werden geeignet an
;                     Shade_Surf bzw. Surface weitergegeben.
;
; OPTIONAL OUTPUTS: GET_BASE: Die ID des erstellten Base-Widgets
;
; PROCEDURE: Benutzte Routinen: Default
;
;            Die Routine erzeugt ein Base-Widget mit einem Draw-Widget
;            drin. �ber die Motion-Events wird der Cursor
;            abgefragt. Man beachte, da� im Unterschied zu Int_Surf
;            der Knopf im Fenster gedr�ckt gehalten werden mu�, wenn
;            man den Plot drehen will! (Sonst k�nnte man ja das
;            Fenster nicht verlassen, um sich woanders zu vergn�gen,
;            ohne dabei den Plot total zu verdrehen!) Die Koordinaten
;            werden in Winkel umgerechnet und �ber AX und AZ an
;            Shade_Surf �bergeben.
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
;		Hier und da ein NO_COPY eingef�gt. Geht jetzt
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

    PrepareNasePlot, (size(info.surface))(2), (size(info.surface))(1), get_old=oldplot, NONASE=1-info.nase, CENTER=info.center

    CASE TAG_NAMES(Event, /STRUCTURE_NAME) OF 
     "WIDGET_BASE": Begin ;Unser Main-Widget wird resized
        info.xsize = Event.X
        info.ysize = Event.Y
        WIDGET_CONTROL, WIDGET_INFO(Event.Top, /CHILD), $ ;Das ist unser Draw-Widget!
                        XSIZE=Event.X, $
                        YSIZE=Event.Y

        wdelete, info.pixwin
        window, /free, /pixmap, xsize=Event.X, ysize=Event.Y ;Da brauchen wir auch ein neues Pixmap-Window!
        info.pixwin = !D.Window

        wset, info.drawwin ; und dann machen wir doch noch ein Paint
        If info.nase then call_Procedure, info.plotproc, info.surface, title=info.plot_title, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0), MAX_VALUE=999998, _EXTRA=info._extra else $
         call_Procedure, info.plotproc, info.surface, title=info.plot_title, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0), _EXTRA=info._extra
        xyouts, /device, 10, 10, "AX="+string(info.CurrentPos(1)+info.delta(1))+"      AZ="+string(info.CurrentPos(0)+info.delta(0))
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
                 If info.nase then call_Procedure, info.plotproc, info.surface, title=info.plot_title, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0), MAX_VALUE=999998, _EXTRA=info._extra else $
                  call_Procedure, info.plotproc, info.surface, title=info.plot_title, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0), _EXTRA=info._extra
                 xyouts, /device, 10, 10, "AX="+string(info.CurrentPos(1)+info.delta(1))+"      AZ="+string(info.CurrentPos(0)+info.delta(0))
                 wset, info.drawwin
                 Device, copy=[0, 0, info.xsize-1, info.ysize-1, 0, 0, info.pixwin]
              endif
           end
           Endcase          
     End
  Endcase

  PrepareNasePlot, restore_old=oldplot

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

PRO SurfIt, _data, XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize, $
            GROUP=group, JUST_REG=Just_Reg, NO_BLOCK=no_block, MODAL=modal, $
            DELIVER_EVENTS=deliver_events, GET_BASE=get_base, $
            TITLE=title, PLOT_TITLE=plot_title, $
            NASE=nase, GRID=grid, SHADES=_shades, _EXTRA=_extra

   data = reform(_data)         ;Do not change Contents!
   Default, shades, _shades     ;Do not change Contents!
   Default, xpos, 500
   Default, ypos, 100
   Default, xsize, 500
   Default, ysize, 500   
   Default, deliver_events, [-1]
   Default, title, "Surf It!"
   Default, plot_title, Title
   If plot_title eq "Surf It!" then plot_title = ""
   Default, nase, 0
   If not Keyword_Set(_extra) then _extra = {title: plot_title} else _extra = Create_Struct(_extra, 'title', plot_title)
   center = 0
   If extraset(_extra, "LEGO") then begin
      grid = 1                  ;lego implies grid
      center = 1
   endif
   If Keyword_Set(GRID) then plotproc = "SURFACE" else plotproc = "SHADE_SURF"
   Default, no_block, 1
   Default, modal, 0

   ;;------------------> NASE-Array:
   If Keyword_Set(NASE) then begin
      data = rotate(data, 3)
      nones = where(data eq !NONE, count)
      If count ne 0 then data(nones) = +999999 ;Weil ILD3.6 bei Plots nur MAX_Value kennt und kein MIN_Value
      If Keyword_Set(Shades) then shades = rotate(shades, 3)
   endif
   ;;--------------------------------
   PrepareNasePlot, (size(data))(2), (size(data))(1), get_old=oldplot, CENTER=center, NONASE=1-NASE

   If Keyword_Set(Shades) then _extra = Create_Struct(_extra, 'shades', shades)

   window, /free, /pixmap, colors=256, xsize=xsize, ysize=ysize

   IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

   If fix(!VERSION.Release) ge 5 then $ ;Ab IDL 5 ist MODAL ein BASE-Keyword
    SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $
                             MODAL=modal, $
                             TITLE=title, $
                             UVALUE={Widget        : "Main", $
                                     surface       : data, $
                                     Button_Pressed: (0 eq 1), $ ;FALSE
                                     Press_x       :0, $
                                     Press_y       :0, $
                                     CurrentPos    :[30.0, 30.0, 0.0], $
                                     delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
                                     pixwin        :!D.Window, $
                                     drawwin       :0, $ ;still unknown!
                                     xsize         :xsize, $
                                     ysize         :ysize, $
                                     deliver_events:deliver_events, $
                                     plot_title    :plot_title, $
                                     nase          :nase, $
                                     plotproc      :plotproc, $
                                     center        :center, $
                                     _extra        :_extra $
                                    }, $
                             /NO_COPY, $
                             XOFFSET=xpos, $
                             YOFFSET=ypos, $
                             /COLUMN, $
                             SPACE=10, $
                             /TLB_SIZE_EVENTS) $
   else SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $ ; IDL 4 oder fr�her
                                 TITLE=title, $
                                 UVALUE={Widget        : "Main", $
                                         surface       : data, $
                                         Button_Pressed: (0 eq 1), $ ;FALSE
                                         Press_x       :0, $
                                         Press_y       :0, $
                                         CurrentPos    :[30.0, 30.0, 0.0], $
                                         delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
                                         pixwin        :!D.Window, $
                                         drawwin       :0, $ ;still unknown!
                                         xsize         :xsize, $
                                         ysize         :ysize, $
                                         deliver_events:deliver_events, $
                                         plot_title    :plot_title, $
                                         nase          :nase, $
                                         plotproc      :plotproc, $
                                         center        :center, $
                                         _extra        :_extra $
                                        }, $
                                 /NO_COPY, $
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
   WIDGET_CONTROL, Draw, GET_VALUE=drawwin ;Die Fensternummer des Draw-Widgets
   info.drawwin = drawwin
   WIDGET_CONTROL, SurfWidget, SET_UVALUE=info, /NO_COPY
   
   wset, drawwin
   If Keyword_Set(NASE) then call_Procedure, plotproc, data, Title=plot_title, MAX_VALUE=999998, _EXTRA=_extra else $
    call_Procedure, plotproc, data, Title=plot_title, _EXTRA=_extra
   xyouts, /device, 10, 10, "AX="+string(30.0)+"      AZ="+string(30.0)

   get_base = SurfWidget

   If fix(!VERSION.Release) ge 5 then XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, NO_BLOCK=no_block $
   else XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, MODAL=modal
   
   PrepareNasePlot, restore_old=oldplot
   
END
