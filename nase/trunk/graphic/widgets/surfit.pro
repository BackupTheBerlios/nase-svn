;+
; NAME: SurfIt
;            
; AIM:
;  Interactively display a surface plot.
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
;          Ab Revision 1.9 auch als Kind-Widget in einer Widget-Applikation. 
;
; CATEGORY:
;  Animation
;  Array
;  Graphic
;  NASE
;  Widgets
;
; CALLING SEQUENCE: SurfIt, Data_Array [, Parent ]
;                                      [,XPOS=xpos] [,YPOS=ypos] [,XSIZE=xsize] [,YSIZE=ysize]
;                                      [,GROUP=group [,/MODAL]] [,/JUST_REG] [,NO_BLOCK=0]
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
; OPTIONAL INPUTS: Parent: Eine Widget-ID des Widgets, dessen Kind das 
;                          neue ScrollIt-Widget werden soll.
;
; KEYWORD PARAMETERS: XPOS, YPOS, XSIZE, YSIZE: Die Fenster-Koordinaten, wie üblich
;                     GROUP:    Die Widget-ID eines Widgets, das als "Group-Leader" dienen soll:
;                               Wird der Group-Leader gekillt, so stirbt auch unser Widget.
;                     MODAL:    Wenn angegeben, ist das Widget modal,
;                               d.h. alle anderen Widgets sind
;                               deaktiviert, solange dieses existiert.
;                               MODAL erfordert die Angabe eines
;                               Group-Leaders in GROUP.
;                     JUST_REG: Dieses Keyword wird an der XMANAGER weitergereicht.
;                               Wird es gesetzt, so wird das Surf-Widget nur angemeldet, aber noch nicht gemanaged.
;                               Das ermöglicht es, mehrere solche Widgets anzumelden und dann erst mit dem letzten
;                               auch den Manager zu starten, so daß alle gleichzeitig laufen. (Vgl. Beispiel unten.)
;                     NO_BLOCK: Wird ab IDL 5 an den XMANAGER
;                               weitergegeben. (Beschreibung
;                               s. IDL-Hilfe)
;                               Der Default ist 1, also kein
;                               Blocken. Wird Blocken gewünscht, so muß
;                               NO_BLOCK explizit auf 0 gesetzt werden.
;                     DELIVER_EVENTS: Hier kann ein Array
;                                     von Widget-Indizes übergeben werden, an die alle 
;                                     ankommenden Events
;                                     weitergereicht werden.
;                     TITLE:    Ein Titel für das Fenster. (Default:
;                               "Surf It!")
;                     PLOT_TITLE: Ein Titel für den Plot. (Default:
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

Pro SurfIt_Cleanup, ID
 WIDGET_CONTROL, ID, GET_UVALUE=info, /NO_COPY
 PTR_FREE, info.surface
 ; and leave uvale undefined.
End

Pro SurfIt_Paint, info
   ;;Paint surface to the currently active window (or pixmap)

   If (info.lun ne -1) and not(info.got_streamdata) then begin
      xyouts, /normal, 0.1, 0.5, "waiting for stream data..."
   endif else begin
      PrepareNasePlot, (size(*info.surface))(2), (size(*info.surface))(1), get_old=oldplot, CENTER=info.center, NONASE=1-info.nase
      
      If info.nase then call_Procedure, info.plotproc, *info.surface, title=info.plot_title, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0), MAX_VALUE=999998, _EXTRA=info._extra else $
       call_Procedure, info.plotproc, *info.surface, title=info.plot_title, ax=info.CurrentPos(1)+info.delta(1), az=info.CurrentPos(0)+info.delta(0), _EXTRA=info._extra
      xyouts, /device, 10, 10, "AX="+string(info.CurrentPos(1)+info.delta(1))+"      AZ="+string(info.CurrentPos(0)+info.delta(0))
      
      PrepareNasePlot, restore_old=oldplot

      If info.lun ne -1 then xyouts, /device, 20, 20, "frame #"+str(info.frame_no)
   endelse
End

Pro SurfIt_Draw_Notify_Realize, ID
   Draw       = ID              ;The Draw-Widget
   SurfWidget = Widget_Info(Draw, /PARENT) ; The Top Level Base

   ;;Die Widow_Nummer des Draw-Widgets kann erst nach einem Realize
   ;;ermittelt werden!
   WIDGET_CONTROL, SurfWidget, GET_UVALUE=info, /NO_COPY
   WIDGET_CONTROL, Draw, GET_VALUE=drawwin ;Die Fensternummer des Draw-Widgets
   info.drawwin = drawwin
   
   wset, drawwin
   SurfIt_Paint, info

   If info.lun ne -1 then begin      ;Stream-Update-Mode
      Widget_Control, SurfWidget, TIMER=0 ;Request Timer-Event
   endif

   WIDGET_CONTROL, SurfWidget, SET_UVALUE=info, /NO_COPY
End

Pro SurfIt_Event, Event
 
 WIDGET_CONTROL, Event.Handler, GET_UVALUE=info, /NO_COPY
; If Event.Top eq Event.Id then Ev = info else WIDGET_CONTROL, Event.Id, GET_UVALUE=Ev

    CASE TAG_NAMES(Event, /STRUCTURE_NAME) OF 
     "WIDGET_TIMER": Begin ;A timer-event for stream update
        if not(eof(info.lun)) then begin
;        If available(info.lun) then begin
           If info.got_streamdata then begin
                                ; Read next frame
              Readf, info.lun, *info.surface
              info.frame_no = info.frame_no+1
                                ;Paint Window
              wset, info.pixwin
              SurfIt_Paint, info
              wset, info.drawwin
              Device, copy=[0, 0, info.xsize-1, info.ysize-1, 0, 0, info.pixwin]
              
           endif else begin
                                ; Read stream specification (frame size)
              frame_rows = 0l
              frame_cols = 0l
              Readf, info.lun, frame_rows, frame_cols
              info.got_streamdata = 1
              ptr_free, info.surface
              info.surface = ptr_new(fltarr(frame_rows, frame_cols), /NO_COPY)
           endelse
;          end
         ;  If no data is available, do nothing!
           Widget_Control, Event.Handler, TIMER=0.1 ;Request new timer event
        endif; If eof(lun), request NO further timer events!
     End
     "WIDGET_BASE": Begin ;Unser Main-Widget wird resized
        Ev = info
        info.xsize = Event.X
        info.ysize = Event.Y
        WIDGET_CONTROL, WIDGET_INFO(Event.Top, /CHILD), $ ;Das ist unser Draw-Widget!
                        XSIZE=Event.X, $
                        YSIZE=Event.Y

        wdelete, info.pixwin
        window, /free, /pixmap, xsize=Event.X, ysize=Event.Y ;Da brauchen wir auch ein neues Pixmap-Window!
        info.pixwin = !D.Window

        wset, info.drawwin ; und dann machen wir doch noch ein Paint
        SurfIt_Paint, info
     End      
     "WIDGET_DRAW": Begin
        WIDGET_CONTROL, Event.Id, GET_UVALUE=Ev
        Case Event.Type of
           0: Begin ;Button Press
              If (Event.Clicks eq 2) then begin ;Double-Click! Raise copy of myself!
                 Surfit, *info.surface, $
                  $             ;XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize, $
                  GROUP=Event.ID, $
                  DELIVER_EVENTS=Event.ID, $
                  TITLE=info.title, PLOT_TITLE=info.plot_title, $
                  AX=info.CurrentPos(1), AZ=info.CurrentPos(0), $
                  NASE=info.nase, GRID=info.grid, _EXTRA=info._extra
              End
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
                 SurfIt_Paint, info
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

  WIDGET_CONTROL, Event.Handler, SET_UVALUE=info, /NO_COPY
End

PRO SurfIt, _data, Parent, $
            XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize, $
            GROUP=group, JUST_REG=Just_Reg, NO_BLOCK=no_block, MODAL=modal, $
            DELIVER_EVENTS=deliver_events, GET_BASE=get_base, $
            TITLE=title, PLOT_TITLE=plot_title, $
            NASE=nase, GRID=grid, SHADES=_shades, $
            AX=ax, AZ=az, $
            _EXTRA=_extra

   Default, ax, 30.0
   Default, az, 30.0
   Default, grid, 0
   Default, shades, _shades     ;Do not change Contents!
;   Default, xpos, 500
;   Default, ypos, 100
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
   If (size(_data))(0) eq 0 then begin
      ; Stream-Update mode!
      lun = _data
      data = -1
   endif else begin
      data = reform(_data)      ;Do not change Contents!
      lun = -1
   endelse
   got_streamdata = 0           ;For stream-update
   
   ;;------------------> NASE-Array:
   If Keyword_Set(NASE) then begin
      data = rotate(data, 3)
      nones = where(data eq !NONE, count)
      If count ne 0 then data(nones) = +999999 ;Weil ILD3.6 bei Plots nur MAX_Value kennt und kein MIN_Value
      If Keyword_Set(Shades) then shades = rotate(shades, 3)
   endif
   ;;--------------------------------

   If Keyword_Set(Shades) then _extra = Create_Struct(_extra, 'shades', shades)

   window, /free, /pixmap, colors=256, xsize=xsize, ysize=ysize

   IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

   If Set(Parent) then begin; Will be child
       SurfWidget = WIDGET_BASE(Parent, GROUP_LEADER=Group, $
                                UVALUE={Widget        : "Main", $
                                        surface       : ptr_new(data, /NO_COPY), $
                                        got_streamdata: got_streamdata, $
                                        lun           : lun, $
;                                        frame_rows    : 0l, $ ; # of rows in the frame for stream-update
;                                        frame_cols    : 0l, $ ; # of cols in the frame for stream-update
                                        frame_no      : 0, $
                                        Button_Pressed: (0 eq 1), $ ;FALSE
                                        Press_x       :0, $
                                        Press_y       :0, $
                                        CurrentPos    :[az, ax, 0.0], $
                                        delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
                                        pixwin        :!D.Window, $
                                        drawwin       :0, $ ;still unknown!
                                        xsize         :xsize, $
                                        ysize         :ysize, $
                                        deliver_events:deliver_events, $
                                        plot_title    :plot_title, $
                                        title         :title, $
                                        nase          :nase, $
                                        plotproc      :plotproc, $
                                        center        :center, $
                                        grid          :grid, $
                                        _extra        :_extra $
                                       }, $
                                /NO_COPY, $
                                XOFFSET=xpos, $
                                YOFFSET=ypos, $
                                /COLUMN, $
                                SPACE=10)
   endif else begin             ;Will be Top level Base
      If fix(!VERSION.Release) ge 5 then $ ;Ab IDL 5 ist MODAL ein BASE-Keyword
       SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $
                                MODAL=modal, $
                                TITLE=title, $
                                UVALUE={Widget        : "Main", $
                                        surface       : ptr_new(data, /NO_COPY), $
                                        lun           : lun, $
                                        got_streamdata: got_streamdata, $
;                                        frame_rows    : 0l, $ ; # of rows in the frame for stream-update
;                                        frame_cols    : 0l, $ ; # of cols in the frame for stream-update
                                        frame_no      : 0, $
                                        Button_Pressed: (0 eq 1), $ ;FALSE
                                        Press_x       :0, $
                                        Press_y       :0, $
                                        CurrentPos    :[az, ax, 0.0], $
                                        delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
                                        pixwin        :!D.Window, $
                                        drawwin       :0, $ ;still unknown!
                                        xsize         :xsize, $
                                        ysize         :ysize, $
                                        deliver_events:deliver_events, $
                                        title         :title, $
                                        plot_title    :plot_title, $
                                        nase          :nase, $
                                        plotproc      :plotproc, $
                                        center        :center, $
                                        grid          :grid, $
                                        _extra        :_extra $
                                       }, $
                                /NO_COPY, $
                                XOFFSET=xpos, $
                                YOFFSET=ypos, $
                                /COLUMN, $
                                SPACE=10, $
                                /TLB_SIZE_EVENTS) $
      else SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $ ; IDL 4 oder früher
                                    TITLE=title, $
                                    UVALUE={Widget        : "Main", $
                                            surface       : ptr_new(data, /NO_COPY), $
                                            lun           : lun, $
                                            got_streamdata: got_streamdata, $
;                                            frame_rows    : 0l, $ ; # of rows in the frame for stream-update
;                                            frame_cols    : 0l, $ ; # of cols in the frame for stream-update
                                            frame_no      : 0, $
                                            Button_Pressed: (0 eq 1), $ ;FALSE
                                            Press_x       :0, $
                                            Press_y       :0, $
                                            CurrentPos    :[az, ax, 0.0], $
                                            delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
                                            pixwin        :!D.Window, $
                                            drawwin       :0, $ ;still unknown!
                                            xsize         :xsize, $
                                            ysize         :ysize, $
                                            deliver_events:deliver_events, $
                                            title         :title, $
                                            plot_title    :plot_title, $
                                            nase          :nase, $
                                            plotproc      :plotproc, $
                                            center        :center, $
                                            grid          :grid, $
                                            _extra        :_extra $
                                           }, $
                                    /NO_COPY, $
                                    XOFFSET=xpos, $
                                    YOFFSET=ypos, $
                                    /COLUMN, $
                                    SPACE=10, $
                                    /TLB_SIZE_EVENTS)
   endelse ;; set(Parent)

   Draw =  WIDGET_DRAW(SurfWidget, $
                       COLORS=256, $
                       /MOTION_EVENTS, $
                       /BUTTON_EVENTS, $
;;                       RETAIN=1, $
                       UVALUE={Widget: "Draw"}, $
                       XSIZE=xsize, $
                       YSIZE=ysize, $
                      NOTIFY_REALIZE="SurfIt_Draw_Notify_Realize")


   get_base = SurfWidget

   If not Set(Parent) then begin; I am top level, so realize and register!
      WIDGET_CONTROL, SurfWidget, /REALIZE
      If fix(!VERSION.Release) ge 5 then XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, NO_BLOCK=no_block, CLEANUP='SurfIt_cleanup' $
      else XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, MODAL=modal, CLEANUP='SurfIt_cleanup'
   endif else begin; I am child, just establ. my private event-handler
      Widget_Control, SurfWidget, EVENT_PRO="SurfIt_Event"
   endelse
   
END


;========================== Function SurfIt ===================================

;Function SurfIt, _data, Parent, $
;                 XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize, $
;                 GROUP=group, JUST_REG=Just_Reg, NO_BLOCK=no_block, MODAL=modal, $
;                 DELIVER_EVENTS=deliver_events, GET_BASE=get_base, $
;                 TITLE=title, PLOT_TITLE=plot_title, $
;                 NASE=nase, GRID=grid, SHADES=_shades, $
;                 AX=ax, AZ=az, $
;$ ;Widget_Keywords:
;                 VALUE=value, $ ;This was "_data" before!
;                 _EXTRA=_extra

;   Default, ax, 30.0
;   Default, az, 30.0
;   Default, grid, 0
;   data = reform(_data)         ;Do not change Contents!
;   Default, shades, _shades     ;Do not change Contents!
;;   Default, xpos, 500
;;   Default, ypos, 100
;   Default, xsize, 500
;   Default, ysize, 500   
;   Default, deliver_events, [-1]
;   Default, title, "Surf It!"
;   Default, plot_title, Title
;   If plot_title eq "Surf It!" then plot_title = ""
;   Default, nase, 0
;   If not Keyword_Set(_extra) then _extra = {title: plot_title} else _extra = Create_Struct(_extra, 'title', plot_title)
;   center = 0
;   If extraset(_extra, "LEGO") then begin
;      grid = 1                  ;lego implies grid
;      center = 1
;   endif
;   If Keyword_Set(GRID) then plotproc = "SURFACE" else plotproc = "SHADE_SURF"
;   Default, no_block, 1
;   Default, modal, 0

;   ;;------------------> NASE-Array:
;   If Keyword_Set(NASE) then begin
;      data = rotate(data, 3)
;      nones = where(data eq !NONE, count)
;      If count ne 0 then data(nones) = +999999 ;Weil ILD3.6 bei Plots nur MAX_Value kennt und kein MIN_Value
;      If Keyword_Set(Shades) then shades = rotate(shades, 3)
;   endif
;   ;;--------------------------------

;   If Keyword_Set(Shades) then _extra = Create_Struct(_extra, 'shades', shades)

;   window, /free, /pixmap, colors=256, xsize=xsize, ysize=ysize

;   IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

;   If Set(Parent) then begin; Will be child
;       SurfWidget = WIDGET_BASE(Parent, GROUP_LEADER=Group, $
;                                UVALUE={Widget        : "Main", $
;                                        surface       : data, $
;                                        Button_Pressed: (0 eq 1), $ ;FALSE
;                                        Press_x       :0, $
;                                        Press_y       :0, $
;                                        CurrentPos    :[az, ax, 0.0], $
;                                        delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
;                                        pixwin        :!D.Window, $
;                                        drawwin       :0, $ ;still unknown!
;                                        xsize         :xsize, $
;                                        ysize         :ysize, $
;                                        deliver_events:deliver_events, $
;                                        plot_title    :plot_title, $
;                                        title         :title, $
;                                        nase          :nase, $
;                                        plotproc      :plotproc, $
;                                        center        :center, $
;                                        grid          :grid, $
;                                        _extra        :_extra $
;                                       }, $
;                                /NO_COPY, $
;                                XOFFSET=xpos, $
;                                YOFFSET=ypos, $
;                                /COLUMN, $
;                                SPACE=10)
;   endif else begin             ;Will be Top level Base
;      If fix(!VERSION.Release) ge 5 then $ ;Ab IDL 5 ist MODAL ein BASE-Keyword
;       SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $
;                                MODAL=modal, $
;                                TITLE=title, $
;                                UVALUE={Widget        : "Main", $
;                                        surface       : data, $
;                                        Button_Pressed: (0 eq 1), $ ;FALSE
;                                        Press_x       :0, $
;                                        Press_y       :0, $
;                                        CurrentPos    :[az, ax, 0.0], $
;                                        delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
;                                        pixwin        :!D.Window, $
;                                        drawwin       :0, $ ;still unknown!
;                                        xsize         :xsize, $
;                                        ysize         :ysize, $
;                                        deliver_events:deliver_events, $
;                                        title         :title, $
;                                        plot_title    :plot_title, $
;                                        nase          :nase, $
;                                        plotproc      :plotproc, $
;                                        center        :center, $
;                                        grid          :grid, $
;                                        _extra        :_extra $
;                                       }, $
;                                /NO_COPY, $
;                                XOFFSET=xpos, $
;                                YOFFSET=ypos, $
;                                /COLUMN, $
;                                SPACE=10, $
;                                /TLB_SIZE_EVENTS) $
;      else SurfWidget = WIDGET_BASE(GROUP_LEADER=Group, $ ; IDL 4 oder früher
;                                    TITLE=title, $
;                                    UVALUE={Widget        : "Main", $
;                                            surface       : data, $
;                                            Button_Pressed: (0 eq 1), $ ;FALSE
;                                            Press_x       :0, $
;                                            Press_y       :0, $
;                                            CurrentPos    :[az, ax, 0.0], $
;                                            delta         :[0.0, 0.0, 0.0], $ ; Diese Arrays haben nur der Bequemlichkeit halber drei Elemente...
;                                            pixwin        :!D.Window, $
;                                            drawwin       :0, $ ;still unknown!
;                                            xsize         :xsize, $
;                                            ysize         :ysize, $
;                                            deliver_events:deliver_events, $
;                                            title         :title, $
;                                            plot_title    :plot_title, $
;                                            nase          :nase, $
;                                            plotproc      :plotproc, $
;                                            center        :center, $
;                                            grid          :grid, $
;                                            _extra        :_extra $
;                                           }, $
;                                    /NO_COPY, $
;                                    XOFFSET=xpos, $
;                                    YOFFSET=ypos, $
;                                    /COLUMN, $
;                                    SPACE=10, $
;                                    /TLB_SIZE_EVENTS)
;   endelse ;; set(Parent)

;   Draw =  WIDGET_DRAW(SurfWidget, $
;                       COLORS=256, $
;                       /MOTION_EVENTS, $
;                       /BUTTON_EVENTS, $
;                       RETAIN=1, $
;                       UVALUE={Widget: "Draw"}, $
;                       XSIZE=xsize, $
;                       YSIZE=ysize, $
;                      NOTIFY_REALIZE="SurfIt_Draw_Notify_Realize")



;   get_base = SurfWidget

;   If not Set(Parent) then begin; I am top level, so realize and register!
;      WIDGET_CONTROL, SurfWidget, /REALIZE
;      If fix(!VERSION.Release) ge 5 then XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, NO_BLOCK=no_block $
;      else XMANAGER, 'SurfIt', SurfWidget, JUST_REG=Just_Reg, MODAL=modal
;   endif else begin; I am child, just establ. my private event-handler
;      Widget_Control, SurfWidget, EVENT_PRO="SurfIt_Event"
;   endelse
   
;END
