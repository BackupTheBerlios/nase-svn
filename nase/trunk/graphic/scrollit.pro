;+
; NAME: ScrollIt()
;
; PURPOSE: Darstellung großer Graphiken in kleinen Fenstern mit
;          Scrollbalken.
;          Ab Revision 2.21 auch als Kind-Widgets in einer Widget-Applikation. 
;
; CATEGORY: Darstellung, Widgets, allgemein
;
; CALLING SEQUENCE: Win_Nr = ScrollIt ( [ Parent ]
;                                       [, TITLE=FensterTitel ]
;                                       [, XPOS=Hauptfenster_X_Position] [, YPOS=Hauptfenster_Y_Position ]
;                                       [, BASE_XSIZE=Hauptfenster_X_Größe] [, BASE_YSIZE=Hauptfenster_Y_Größe]
;                                       [, XSIZE=Fensterchen_X_Größe ]  [, YSIZE=Fensterchen_Y_Größe ]
;                                       [, XDRAWSIZE=Virtuelle_Fensterchen_X_Größe] [, YDRAWSIZE=Virtuelle_Fensterchen_Y_Größe]
;                                       [, /PIXMAP ]
;                                       [, GET_BASE=Widget_ID] [, GROUP=Leader_Widget_ID ]
;                                       [, KILL_NOTIFY=KillPro ]
;                                       [, DELIVER_EVENTS=Array_of_Widget_IDs ]
;                                       [, /BUTTON_EVENTS]
;                                       [, MULTI=Multi-Array ]
;                                       [, GET_DRAWID=Array_of_Draw-Widget-IDs]
;                                       [, /PRIVATE_COLORS] [, NO_BLOCK=0])
;
; OPTIONAL INPUTS: Parent: Eine Widget-ID des Widgets, dessen Kind das 
;                          neue ScrollIt-Widget werden soll.
;                          Man beachte, dass in diesem Fall der
;                          Rueckgabewert Win_Nr=-1 ist, da die
;                          Fensternummer eines Draw-Widgets erst nach
;                          dessen Realisierung ermittelt werden kann.
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
;                     BUTTON_EVENTS           : Wird dieses Schlüsselwort gesetzt, so generiert das im ScrollIt enthaltene
;                                               DrawWidget bei Mausklicks in seinem Bereich entsprechende Events, die
;                                               dann an die in DELIVER_EVENTS aufgeführten Widgets weitergegeben werden.
;                                               Default: 0.
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
;                     PRIVATE_COLORS          : Diese Option ist für den Gebrauch durch die Sheet-Routinen gedacht.
;                                               Sie ist sinnvoll bei 8-bit-Displays.
;                                               Wenn gesetzt, verarbeiten die Draw-Widgets Tracking-events, und setzen jedesmal,
;                                               wenn der Cursor in das Widget kommt, die Farbtabelle auf einen Wert, der im User-
;                                               value des Draw-Widgets gespeichert ist. Wenn der Cursor das Widget wieder verläßt,
;                                               wird der vorherige Wert restauriert.
;                                               Wird diese Option benutzt, sollte man sich mit GET_DRAWID die IDs der Widgets liefern
;                                               lassen, um Zugriff auf die User-Values der DrawWidgets zu haben. Die Werte der
;                                               privaten Colormap finden sich in uvalue.MyPalette.[R|G|B]
;                                     NO_BLOCK: Wird ab IDL 5 an den XMANAGER
;                                               weitergegeben. (Beschreibung
;                                               s. IDL-Hilfe)
;                                               Der Default ist 1, also kein
;                                               Blocken. Wird Blocken gewünscht, so muß
;                                               NO_BLOCK explizit auf 0 gesetzt werden.
;
;
; OUTPUTS: Win_Nr: Ein  Window-Index für folgende Graphikbefehle,
;                   bzw. ein Array von Indizes im Fall von MULIT.
;                  Das geöffnete Fenster wird aber auch zum aktuellen Fenster.
;
;                  Man beachte, dass wenn ein Parent-Widget angegeben wurde, der
;                   Rueckgabewert Win_Nr=-1 ist, da die
;                   Fensternummer eines Draw-Widgets erst nach
;                   dessen Realisierung ermittelt werden kann.
;                   (S. dazu Abschnitt RESTRICTIONS.)
;
; OPTIONAL OUTPUTS: GET_BASE: ID des erstellten Base-Widgets.
;                   GET_DRAWID: ID des Draw-Widgets, bzw. ein Array
;                    von IDs im Fall von MULTI.
;                    Dieses Schlüsselwort ist für den Gebrauch mit den 
;                    Sheets gedacht, die eine private Colormap in
;                    jedem Widget speichern, sofern die
;                    /PRIVATE_COLORS-Option gesetzt ist.
;
; SIDE EFFECTS: Wenn IDL V4.0 oder höher verwendet wird, wird das Widget beim XMANAGER registriert.
;               Dann werden nach aufruf von XMANAGER auch Resize-Events richtig verarbeitet.
;
; RESTRICTIONS: 1) Es bringt den XMANAGER durcheinander, wenn das Fenster mit
;                  WDelete, Win_Nr gelöscht wird.
;                  Lieber das Widget ordnungsgemäß mit dem Close-Knopf schließen
;                  oder, wenn es programmgesteuert geschlossen werden
;                  soll, das GET_BASE-Schlüsselwort benutzen und ein 
;                     WIDGET_CONTROL, Widget_ID, /DESTROY
;                  machen.
;
;               2) Wird ein Parent-Widget angegeben, so kann die
;                  Fensternummer des ScrollIt-Widgets erst nach dessen
;                  Realisierung ermittelt werden. Zu diesem Zweck lasse
;                  man sich die Widget-ID mittels GET_DRAWID=DrawId
;                  zurueckliefern und bestimme dann die Fensternummer
;                  mittels
;                     WIDGET_CONTROL, DrawId, GET_VALUE=Fensternummer
;                  Das ganze wird dem Benutzer abgenommen, wenn er <A HREF="sheets">Sheets</A>
;                  benutzt, was wir ihm empfehlen moechten.
;
;               3) Man beachte, dass das
;                  Hinzufuegen eines Sheets/ScrollIts zu einer
;                  bereits realisierten Widget-Hierarchie in der
;                  aktuellen IDL-Version (5.0.2) unter KDE zu einem
;                  astreinen IDL-Absturz fuehrt!
;
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
;       Revision 2.23  1999/08/16 16:37:56  thiel
;           Now delivers button-presses if wanted.
;
;       Revision 2.22  1999/06/15 17:36:38  kupper
;       Umfangreiche Aenderungen an ScrollIt und den Sheets. Ziel: ScrollIts
;       und Sheets koennen nun als Kind-Widgets in beliebige Widget-Applikationen
;       eingebaut werden. Die Modifikationen machten es notwendig, den
;       WinID-Eintrag aus der Sheetstruktur zu streichen, da diese erst nach der
;       Realisierung der Widget-Hierarchie bestimmt werden kann.
;       Die GetWinId-Funktion fragt nun die Fensternummer direkt ueber
;       WIDGET_CONTROL ab.
;       Ebenso wurde die __sheetkilled-Prozedur aus OpenSheet entfernt, da
;       ueber einen WIDGET_INFO-Aufruf einfacher abgefragt werden kann, ob ein
;       Widget noch valide ist. Der Code von OpenSheet und DefineSheet wurde
;       entsprechend angepasst.
;       Dennoch sind eventuelle Unstimmigkeiten mit dem frueheren Verhalten
;       nicht voellig auszuschliessen.
;
;       Revision 2.21  1999/06/10 16:50:02  kupper
;       Bugfix: VARIABLE used with GETDTAWID-Keyword needs to be defines
;       before call with IDL 3.6
;
;       Revision 2.20  1999/06/01 13:45:27  kupper
;       (Kontroll-Messages auskommentiert)
;
;       Revision 2.19  1999/06/01 13:41:28  kupper
;       Scrollit wurde um die GET_DRAWID und PRIVATE_COLORS-Option erweitert.
;       Definesheet, opensheet und closesheet unterstützen nun das abspeichern
;       privater Colormaps.
;
;       Revision 2.18  1999/06/01 13:20:15  kupper
;       *** empty log message ***
;
;       Revision 2.17  1999/03/08 10:38:40  thiel
;              Größe des Plotbereichs ein klein wenig verändert,
;              um unnötige Scrollbars zu vermeiden.
;
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

;Pro Scrollit_Draw_Notify_Realize, DrawID
;   ;Store my WinID in my User-Value (needed by _sheetkilled)
;   Widget_Control, DrawID, GET_UVALUE=uval, /NO_COPY
;   Widget_Control, DrawID, GET_VALUE=winid
;   uval.Window_ID = winid
;   Widget_Control, DrawID, SET_UVALUE=uval, /NO_COPY
;End


Pro ScrollIt_Event, Event

   WIDGET_CONTROL, Event.Handler, GET_UVALUE=base_uval

   CASE TAG_NAMES(Event, /STRUCTURE_NAME) OF 
      "WIDGET_BASE" : begin  ;Resize-Event
         If base_uval.fullscroll then begin ;Resize TLB
            WIDGET_CONTROL, Event.Top, SCR_XSIZE=Event.X, SCR_YSIZE=Event.Y
         endif else begin       ;Resize all draw-widgets
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
         Endelse                ;resize all draw-widgets
      End

      "WIDGET_TRACKING" : begin ;Pointer entered or left a (sub)-widget
         ;;-----------Check if pointer entered widget and set color table----------
         WIDGET_CONTROL, Event.ID, GET_UVALUE=draw_uval
         If (Event.ENTER eq 1) then begin ;It's an ENTRY-event!
                                ;save current palette:
            UTVLCT, /GET, Red, Green, Blue
            draw_uval.YourPalette.R = Red
            draw_uval.YourPalette.G = Green
            draw_uval.YourPalette.B = Blue
            WIDGET_CONTROL, Event.ID, SET_UVALUE=draw_uval
                                ;set private palette:
            UTVLCT, draw_uval.MyPalette.R, draw_uval.MyPalette.G, draw_uval.MyPalette.B 
                                ;message, /INFO, "Setting private palette"
         Endif else begin       ;It's an LEAVE-event
                                ;reset old palette:
            UTVLCT, draw_uval.YourPalette.R, draw_uval.YourPalette.G, draw_uval.YourPalette.B 
                                ;message, /INFO, "Resetting private palette"
         EndElse
         ;;-----------End: Check if pointer entered widget and set color table-----
      END

      ELSE : begin                ; Tracking events shall not be delivered!
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
      ENDELSE

   ENDCASE
  
END


Function ScrollIt, Parent, $
                   XPOS=xpos, YPOS=ypos, XSIZE=xsize, YSIZE=ysize, $
                   XDRAWSIZE=xdrawsize, YDRAWSIZE=ydrawsize, $
                   BASE_XSIZE=base_xsize, BASE_YSIZE=base_ysize, $
                   TITLE=title, $
                   PIXMAP=pixmap, $
                   RETAIN=retain, COLORS=colors, $
                   GET_BASE=get_base, GROUP=group, KILL_NOTIFY=kill_notify, $
                   DELIVER_EVENTS=deliver_events, $
                   BUTTON_EVENTS=button_events, $
                   MULTI=multi, GET_DRAWID=get_drawid, $
                   PRIVATE_COLORS=private_colors, NO_BLOCK=no_block

   Default,  no_block, 1
   Default,  private_colors, 0
   Default,  xsize, 300
   Default,  ysize, 300
;   Default,  xpos,  200
;   Default,  ypos,  200
   Default,  title, 'Scroll It!'
   Default,  group, 0
   Default,  pixmap, 0
   Default,  colors, 0
   Default,  retain, 1
   Default,  kill_notify, ''
   Default,  deliver_events, [-1]
   Default, button_events, 0

   button_events = button_events * Set(deliver_events) 
   ; Tell DrawWidget to generate BUTTON_EVENTS which can then be 
   ; delivered to other widgets, but if deliverevents is not set
   ; creating events is useless

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
      XSIZE = XSIZE-25
   EndIf
   If not Keyword_Set(YDRAWSIZE) then begin
      YDRAWSIZE = YSIZE
      YSIZE = YSIZE-25
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

   If Set(Parent) then begin    ;Will be child
      Base = Widget_Base(Parent, $
                         GROUP_LEADER=group, TITLE=title, $
                         XOFFSET=xpos, YOFFSET=ypos, $
                         X_SCROLL_SIZE=BASE_XSIZE, Y_SCROLL_SIZE=BASE_YSIZE, $
                         COLUMN=basecolumn, ROW=baserow, $
                         XPAD=0, YPAD=0, SPACE=0, $
                         MAP=1-PIXMAP, UVALUE={info          : 'ScrollIt_Base', $
                                               deliver_events: [deliver_events], $
                                               winrows       : winrows, $
                                               wincols       : wincols, $
                                               fullscroll    : fullscroll})
   endif else begin             ;Will be top-level-base
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
   endelse

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
                                       RETAIN=retain, COLORS=colors, KILL_NOTIFY=kill_notify, $
                                       TRACKING_EVENTS=private_colors, $
                                       BUTTON_EVENTS=button_events)
            count = count+1
         EndIf
      Endfor
   EndFor

   
   ;;obtain current color table:
   UTVLCT, /GET, Red, Green, Blue

   For i=1, multi(0) do begin
      Widget_Control, Draws(i-1), SET_UVALUE={info      : 'DRAWWIDGET', $
                                              Window_ID : -2, $
                                              MyPalette   : {R: Red, G: Green, B: Blue}, $
                                              YourPalette : {R: Red, G: Green, B: Blue} $
                                             };, NOTIFY_REALIZE="Scrollit_Draw_Notify_Realize"
   EndFor
   
      

   If not Set(Parent) then begin ; I am top level, so register!

      Widget_Control, /REALIZE, Base
;   Leider funktioniert das Resize erst so richtig ab IDL 4.0:
;   If fix(!VERSION.Release) eq 4 then XMANAGER, 'ScrollIt', Base, /JUST_REG
      If fix(!VERSION.Release) ge 5 then XMANAGER, 'ScrollIt', Base, NO_BLOCK=no_block

      For i=1, multi(0) do begin
         Widget_Control, GET_VALUE=WinID, Draws(i-1)
         WinIDs(i-1) = WinID
      Endfor
      WSet, WinIDs(0)
      If n_elements(WinIDs) eq 1 then begin
         Window_ID = WinIDs(0)  ;Do not return an array of one!
      endif else begin
         Window_ID = WinIDs
      endelse             

   Endif else begin ;; I am child of Parent, so just est. event handler (for tracking events)

      Widget_Control, Base, EVENT_PRO="ScrollIt_Event"
      Window_ID = -1

   EndElse
      
   If n_elements(Draws) eq 1 then begin
      Draw_ID   = Draws(0)      ;Do not return an array of one!
   endif else begin
      Draw_ID   = Draws
   endelse             

      
   get_base = Base


   ;return values:
   GET_DRAWID = Draw_ID
   return, Window_ID
end

