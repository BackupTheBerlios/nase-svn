;+
; NAME: ScrollIt()
;
; PURPOSE: Darstellung großer Graphiken in kleinen Fenstern mit Scrollbalken
;
; CATEGORY: Darstellung, allgemein
;
; CALLING SEQUENCE: Win_Nr = ScrollIt ( [ TITLE=FensterTitel ]
;                                       [, XPOS=Hauptfenster_X_Position] [, YPOS=Hauptfenster_Y_Position ]
;                                       [, BASE_XSIZE=Hauptfenster_X_Größe] [, BASE_YSIZE=Hauptfenster_Y_Größe]
;                                       [, XSIZE=Fensterchen_X_Größe ]  [, YSIZE=Fensterchen_Y_Größe ]
;                                       [, XDRAWSIZE=Virtuelle_Fensterchen_X_Größe] [, YDRAWSIZE=Virtuelle_Fensterchen_Y_Größe]
;                                       [, /PIXMAP ]
;                                       [, GET_BASE=Widget_ID] [, GROUP=Leader_Widget_ID ]
;                                       [, KILL_NOTIFY=KillPro ]
;                                       [, DELIVER_EVENTS=Array_of_Widget_IDs ]
;                                       [, MULTI=Multi-Array ] )
; 
; KEYWORD PARAMETERS: XPOS, YPOS              : Position des Fensters, das tatsächlich auf
;                                               dem Bilschirm erscheint.
;                     XSIZE, YSIZE            : Größe des Fensters, das tatsächlich auf
;                                               dem Bilschirm erscheint.
;                                               Bei Verwendung von MULTI (s.u.) die tatsächlich sichtbare Größe
;                                               eines "Fensterchens".
;                     XDRAWSIZE, YDRAWSIZE    : Größe des gesamten virtuellen Fensters bzw. bei MULTI eines virtuellen "Fensterchens".
;                     BASE_[XY]SIZE           : Bei Verwendung von MULTI die absolute Größe des Haptfensters. Passen nicht alle "Fensterchen"
;                                               in dieses Fenster, so bekommt es (das Haptfenster) Scrollbalken.
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
;                     DELIVER_EVENTS          : Hier kann ein Array
;                                               von Widget-Indizes übergeben werden, an die alle 
;                                               ankommenden Events weitergereicht werden.
;                     MULTI                   : Implementiert eine Funktionalität ähnlich der
;                                               IDL-!P.Multi-Variable (mehrere "Fensterchen" in einem Fenster).
;                                               In MULTI kann ein maximal fünfelementiges Array angegeben werden, das
;                                               das gleiche Format wie !P.Multi hat:
;
;                                               [Anzahl_ges,Anzahl_x,Anzahl_y,Anzahl_z,Order].
;                                               Ausgelassene Argumente werden als 0 interpretiert. 
;                                               Anzahl_ges: Gesamtzahl der Fenster. (weicht leicht von der !P.Multi-Konvention ab.)
;                                               Anzahl_x/y/z: Anzahl in x/y/z-Richtung (Layout)
;                                                             Die z-Zahl wird augenblicklich ignoriert.
;                                               Order: Reihenfolge, in der Fenster generiert werden:
;                                                      0: erst Zeilen, dann Spalten
;                                                      1: erst Spalten, dann Zeilen.
;                                               Wird MULTI gesetzt, so ist das Ergebnis von ScrollIt()
;                                               ein ARRAY VON FENSTERNUMMERN.
;                                               Nach dem Aufruf aktiv ist das linke obere Fenster.
;
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
; EXAMPLE: 1. My_Win = ScrollIt ()
;             Plot, indgen(100)
;             XManager
;
;          2. My_MultiWin = ScrollIt (MULTI=[4,2,2], XSIZE=200, YSIZE=200, XDRAWSIZE=300, YDRAWSIZE=300)
;             Plot, indgen(10)
;             WSet, My_MultiWin(3)
;             Plot, 10-indgen(10)
;
; SEE ALSO: Slide_Image  (Standard-IDL-Routine)
;           <A HREF="#DEFINESHEET">DefineSheet()</A>.
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.16  1998/05/20 14:17:39  kupper
;              SPACE=0 hinzugefügt.
;
;       Revision 2.15  1998/05/19 14:19:59  kupper
;              BASE_[XY]SIZE hinzugefügt.
;
;       Revision 2.14  1998/05/18 17:42:56  kupper
;              Beispiel für MULTI, UPDATE-Kontrolle im Event-Handler.
;
;
;       Thu Sep 4 16:18:27 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro ScrollIt_Event, Event
; Die einzigen Events, die ankommen, sollten Size-Events sein!

   WIDGET_CONTROL, Event.Top, GET_UVALUE=base_uval

   If TAG_NAMES(Event, /STRUCTURE_NAME) eq "WIDGET_BASE" then begin ;Resize-Event
      If base_uval.fullscroll then begin ;Resize TLB
         WIDGET_CONTROL, Event.Top, SCR_XSIZE=Event.X, SCR_YSIZE=Event.Y
      endif else begin          ;Resize all draw-widgets
         WIDGET_CONTROL, Event.Top, UPDATE=0 ;Prevent Screen-Update
         
         New_XSize = (Event.X-base_uval.wincols*2*2)/base_uval.wincols ;Framedicke=2!
         New_YSize = (Event.Y-base_uval.winrows*2*2)/base_uval.winrows ;Framedicke=2!
         
         SubBase = WIDGET_INFO(Event.Top, /CHILD) ;das ist unsere erste SubBase
         while SubBase ne 0 do begin
            Draw = WIDGET_INFO(SubBase, /CHILD) ;das ist unser erstes Draw-Widget in der SubBase!
            while Draw ne 0 do begin
               WIDGET_CONTROL, Draw, SCR_XSIZE=New_XSize, SCR_YSIZE=New_YSize
               Draw = WIDGET_INFO(Draw, /SIBLING) ;das ist unser nächstes Draw-Widget!         
            endwhile
            SubBase = WIDGET_INFO(SubBase, /SIBLING) ;das ist unsere nächste SubBase!
         EndWhile
         WIDGET_CONTROL, Event.Top, UPDATE=1 ;Allow Screen-Update
      Endelse                     ;resize all draw-widgets
   EndIf
   
   ;;-----------Deliver Events to other Widgets?-------------------------
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
                   BASE_XSIZE=base_xsize, BASE_YSIZE=base_ysize, $
                   TITLE=title, $
                   PIXMAP=pixmap, $
                   RETAIN=retain, COLORS=colors, $
                   GET_BASE=get_base, GROUP=group, KILL_NOTIFY=kill_notify, $
                   DELIVER_EVENTS=deliver_events, MULTI=multi

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
   Default,  multi, [1, 1, 1, 1, 0]
   If n_elements(multi) lt 5 then multi = [fix(multi), intarr(5-n_elements(multi))]

   If Keyword_Set(base_xsize) or Keyword_Set(base_ysize) then fullscroll = 1 else fullscroll = 0 ;Type of Resize
   Default,  base_xsize, 0
   Default,  base_ysize, 0

   winrows = multi(2) > 1
   wincols = multi(1) > 1

   If Keyword_Set(XDRAWSIZE) and not Keyword_Set(YDRAWSIZE) then YDRAWSIZE = YSIZE
   If Keyword_Set(YDRAWSIZE) and not Keyword_Set(XDRAWSIZE) then XDRAWSIZE = XSIZE

   If not Keyword_Set(XDRAWSIZE) then begin
      XDRAWSIZE = XSIZE
      XSIZE = XSIZE-27
   EndIf
   If not Keyword_Set(YDRAWSIZE) then begin
      YDRAWSIZE = YSIZE
      YSIZE = YSIZE-27
   EndIf
 
   

   If keyword_set(multi(4)) then begin
      basecolumn = wincols
      baserow    = 0
      subcolumn  = 0
      subrow     = winrows
      countmajor = wincols
      countminor = winrows
   endif else begin
      basecolumn = 0
      baserow    = winrows
      subcolumn  = wincols
      subrow     = 0
      countmajor = winrows
      countminor = wincols
   EndElse

   Base = Widget_Base(GROUP_LEADER=group, TITLE=title, $
                      XOFFSET=xpos, YOFFSET=ypos, $
                      X_SCROLL_SIZE=BASE_XSIZE, Y_SCROLL_SIZE=BASE_YSIZE, $
                      COLUMN=basecolumn, ROW=baserow, $
                      XPAD=0, YPAD=0, SPACE=0, $
                      /TLB_SIZE_EVENTS, MAP=1-PIXMAP, UVALUE={info          : 'ScrollIt_Base', $
                                                              deliver_events: [deliver_events], $
                                                              winrows       : winrows, $
                                                              wincols       : wincols, $
                                                              fullscroll    : fullscroll})
   Draws  = lonarr(winrows*wincols)
   WinIDs = lonarr(winrows*wincols)
   count = 0

   For i=1, countmajor do begin
      SubBase = Widget_Base(Base, COLUMN=subcolumn, ROW=subrow, XPAD=0, YPAD=0, SPACE=0, FRAME=0)
      For j=1, countminor do begin
         If count lt multi(0) then begin
            Draws(count) = Widget_Draw(SubBase, $
                                       XSIZE=xdrawsize, YSIZE=ydrawsize, $
                                       X_SCROLL_SIZE=xsize, Y_SCROLL_SIZE=ysize, $
                                       FRAME=2, $
                                       RETAIN=retain, COLORS=colors, KILL_NOTIFY=kill_notify)
            count = count+1
         EndIf
      Endfor
   EndFor

   Widget_Control, /REALIZE, Base
   For i=1, multi(0) do begin
      Widget_Control, GET_VALUE=WinID, Draws(i-1)
      Widget_Control, Draws(i-1), SET_UVALUE={info      : 'DRAWWIDGET', $
                                              Window_ID : WinID}
      WinIDs(i-1) = WinID
   EndFor
   
      

;   Leider funktioniert das Resize erst so richtig ab IDL 4.0:
;   If fix(!VERSION.Release) eq 4 then XMANAGER, 'ScrollIt', Base, /JUST_REG
   If fix(!VERSION.Release) ge 5 then XMANAGER, 'ScrollIt', Base, /NO_BLOCK

   get_base = Base

   WSet, WinIDs(0)
   If n_elements(WinIDs) eq 1 then Window_ID = WinIDs(0) else Window_ID = WinIDs ;Do not return an array of one!
   return, Window_ID
end

