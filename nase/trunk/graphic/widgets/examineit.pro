;+
; NAME: ExamineIt
;
; PURPOSE: Darstellung und interaktive Abfrage eines zweidimensionalen
;          Arrays. (S. auch PROCEDURE-Abschnitt)
;
; CATEGORY: Visualisierung, Auswertung
;
; CALLING SEQUENCE: ExamineIt, Array [,TV_Array] [,ZOOM=Faktor] [,TITLE=Fenstertitel]
;                                        [,COLOR=PlotColor]
;                                        [,XPOS=xoffset] [,YPOS=yoffset]
;                                        [,/BOUND] [,/NASE]
;                                        [,GROUP=Widget_Leader [,/MODAL]] [,/JUST_REG], [,NO_BLOCK=0]
;                                        [,GET_BASE=BaseID]
;                                        [,DELIVER_EVENTS=Array_of_Widget_IDs]
;  
; INPUTS: Array: Das zu untersuchende Array (ein numerischer Typ!)
;
; OPTIONAL INPUTS: TV_Array: Die Version des Arrays, die tatsächlich
;                            mit TV auf den Bildschirm gebracht
;                            wird. Die kann sich ja eventuell vom
;                            Original unterscheiden, wenn
;                            beispielsweise bestimmten Arraywerten
;                            besondere Farbindizes zugeordnet werden
;                            sollen (man denke z.B. an
;                            N.A.S.E.-!NONE-Verbindungen).
;	
; OPTIONAL OUTPUTS: GET_BASE: Hier kann die ID des produzierten Widgets erfahren werden.
;
; KEYWORD PARAMETERS: ZOOM:   Vergrößerungsfaktor (Ein Arraypixel im
;                             TV-Feld wird als Quadrat der Größe ZOOM
;                             Bildschirmpixel dargestellt).
;                             Bei Nichtangabe wird ein mehr oder weniger
;                             guter Default gewählt.
;                     TITLE:  Der Fenstertitel. Default: "Examine It!"
;                     COLOR:  PlotFarbe für die Koordinatensysteme (Default: !P.Color)
;                 XPOS,YPOS:  Position von der linken oberen Bildschirmecke (Default: 100,100)
;                     BOUND:  Bei Angabe dieses Schlüsselwortes sind
;                             die Grenzen der Plotbereiche fest auf
;                             das Minimum/Maximum des Arrays
;                             eingestellt.
;                             Ansonsten sind die Grenzen das
;                             Minimum/Maximum der gerade untersuchten
;                             Reihe/Spalte, was den zur Verfügung
;                             stehenden Platz besser ausnutzt, aber
;                             beim "Durchfahren" des Arrays etwas
;                             irritierend wirken kann.
;                             The BOUND mode can also be toggled
;                             "online" via a widget menu entry.
;                      NASE:  Wenn gesetzt, wird das Array als NASE-Array in richtiger Orientierung und
;                             mit richtigen Farben dargestellt (Es braucht kein TV-Array angegeben zu werden.)
;                     GROUP:  Eine Widget-ID des Widgets, das als
;                             Übervater dienen soll.
;                     MODAL:  Wenn angegeben, ist das Widget modal,
;                             d.h. alle anderen Widgets sind
;                             deaktiviert, solange dieses existiert.
;                             MODAL erfordert die Angabe eines
;                             Group-Leaders in GROUP.
;                  JUST_REG:  Wird direkt an den XMANAGER
;                             weitergereicht und dient dazu, mehrere
;                             Instanzen von ExamineIt gleichzeitig zu
;                             benutzen. (Vgl. <A HREF="#SURFIT">SurfIt</A> oder 
;                             Beispiel.)
;                  NO_BLOCK:  Wird ab IDL 5 an den XMANAGER
;                             weitergegeben. (Beschreibung
;                             s. IDL-Hilfe)
;                             Der Default ist 1, also kein
;                             Blocken. Wird Blocken gewünscht, so muß
;                             NO_BLOCK explizit auf 0 gesetzt werden.
;             DELIVER_EVENTS: Hier kann ein Array
;                             von Widget-Indizes übergeben werden, an die alle 
;                             ankommenden Events
;                             weitergereicht werden. (VORSICHT, BUGGY!
;                             (s.u.))
;
; RESTRICTIONS: Kann bisher noch keine NASE-Typ-Arrays.
;
; PROCEDURE: Nach dem Aufruf kann mit der Maus in der TV-Darstellung
;            herumgeklickt oder gefahren werden, wobei der aktuelle
;            Arraywert ausgegeben, die jeweils
;            aktuelle Zeile/Spalte geplottet und deren jeweiliges Minimum
;            und Maximum sowie das Minimum/Maximum des gesamten Arrays
;            ausgegeben werden.
;
; EXAMPLE: ExamineIt, Gauss_2D(20,30), ZOOM=10, /JUST_REG
;          ExamineIt, DOG(40,30,5,10), /BOUND
;
; SEE ALSO: <A HREF="#SURFIT">SurfIt</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.6  2000/09/05 16:44:49  kupper
;       min/max output is now also read if BOUND is set.
;
;       Revision 1.5  2000/09/05 16:40:00  kupper
;       Changed BOUND indicators to orange color.
;
;       Revision 1.4  2000/09/04 19:17:37  kupper
;       Typo
;
;       Revision 1.3  2000/09/04 17:55:12  kupper
;       Added red BOUND indicators.
;
;       Revision 1.2  2000/09/04 16:50:36  kupper
;       Bound mode can now be toggled from a menu entry.
;       Added hourglass cursor during plottvscl.
;       re-structured some calls to sub-routines.
;
;       Revision 1.1  1999/09/01 16:43:53  thiel
;           Moved from other directory.
;
;       Revision 2.9  1998/04/14 18:06:12  kupper
;              Bug bei 2-dim. Arrays mit führender 1-Dim.
;
;       Revision 2.8  1998/04/08 16:05:53  kupper
;              kleiner Bug.
;
;       Revision 2.7  1998/04/08 15:57:09  kupper
;              COLOR-Keyword hinzugefügt.
;
;       Revision 2.6  1998/04/07 15:20:08  kupper
;              Kleiner Darstellungsbug.
;
;       Revision 2.5  1998/04/06 17:12:27  kupper
;              NASE, XPOS,YPOS hinzugefügt.
;               Sorry für den NASE-Verarbeitungwust...
;
;       Revision 2.4  1998/03/31 15:12:25  kupper
;            IDL-Versionskonflikt (MODAL)
;
;       Revision 2.3  1998/03/31 14:39:31  kupper
;              Allerlei Schlüsselwörter hinzugefügt.
;       	DELIVER_EVENTS funktioniert noch nicht ganz richtig bei
;       	verschieden großen Fenstern (Umrechnungsfehler. Abhilfe
;       	möglicherweise durch ein spezielles "Normalkoordinaten-Event")
;       	Hab jetzt aber keine Lust, das zu beheben.
;
;       Revision 2.2  1998/03/31 13:38:22  kupper
;              Sicherheits-Commit vor Änderung am Event-Handler.
;
;       Revision 2.1  1997/12/15 16:24:45  kupper
;              Schöpfung.
;
;
;-


Pro examineit_bound_on_handler, event
   ;here arrive button events of the menu buttons.
   uval = Uvalue(event.id)

   info = Uvalue(uval.tv, /no_copy)
   info.bound = 1
   examineit_refresh_plots, info
   Uvalue, uval.tv, info, /no_copy

   ;; make meself desensitive and "other" menu entry sensitive:
   widget_control, event.id, sensitive=0
   widget_control, uval.other, sensitive=1
End
Pro examineit_bound_off_handler, event
   ;here arrive button events of the menu buttons.
   uval = Uvalue(event.id)

   info = Uvalue(uval.tv, /no_copy)
   info.bound = 0
   examineit_refresh_plots, info
   Uvalue, uval.tv, info, /no_copy

   ;; make meself desensitive and "other" menu entry sensitive:
   widget_control, event.id, sensitive=0
   widget_control, uval.other, sensitive=1
End

pro PlotWeights, w, xpos, ypos, zoom, NONASE=nonase, $
                 NOSCALE=noscale, GET_POSITION=get_position, GET_MINOR=get_minor, $
                 COLOR = color;_EXTRA=_extra

   height = (size(w))(2)
   width  = (size(w))(1)

   ticklen = (convert_coord([zoom, zoom], /device, /to_normal))/1.6
   devpos = [xpos-zoom/2, ypos-zoom/2, xpos+zoom*(width+0.5), ypos+zoom*(height+0.5)]

   PrepareNASEPlot, height, width, /OFFSET, GET_OLD=oldplot, NONASE=nonase
   plot, /NODATA, indgen(10), /DEVICE, POSITION=devpos, COLOR=color
   PrepareNASEPlot, RESTORE_OLD=oldplot
   GET_POSITION = devpos
 
;   plotwx = (width+1)*zoom
;   plotwy = (height+1)*zoom
;   devplotpx = xpos-zoom/2
;   devplotpy = ypos-zoom/2
;   devplotpx1 = devplotpx+(width+1)*zoom
;   devplotpy1 = devplotpy+(height+1)*zoom

;   plotpx = (convert_coord([devplotpx, devplotpy], /device, /to_normal))(0)
;   plotpx1 = (convert_coord([devplotpx1, devplotpy1], /device, /to_normal))(0)
;   plotpy = (convert_coord([devplotpx, devplotpy], /device, /to_normal))(1)
;   plotpy1 = (convert_coord([devplotpx1, devplotpy1], /device, /to_normal))(1)

;   plot, indgen(2), /NODATA, position=[plotpx, plotpy, plotpx1, plotpy1], $
;    xrange=[-1, width], /xstyle, xtick_get=xt, $
;    yrange=[-1, height], /ystyle, ytick_get=yt, _EXTRA=_extra
;   plot, indgen(2), /NODATA, position=[plotpx, plotpy, plotpx1, plotpy1], $
;    xrange=[-1, width], /xstyle, xminor=xt(1), $
;    yrange=[-1, height], /ystyle, yminor=yt(1), $
;    xticklen=ticklen(0), yticklen=ticklen(1), _EXTRA=_extra

;   get_position = [devplotpx, devplotpy, devplotpx1, devplotpy1]
;   get_minor = [xt(1), yt(1)]

   utvscl, w, stretch=zoom, xpos, ypos, /DEVICE, NOSCALE=noscale


end

Pro examineit_refresh_plots, info, x_arr, y_arr
   default, x_arr, info.last_x_arr
   default, y_arr, info.last_y_arr
   
   info.last_x_arr = x_arr
   info.last_y_arr = y_arr

         ActWin = !D.Window
         ActCol = !P.Color
         !P.Color = info.color
         
         minrow = min(info.w(*, y_arr))
         maxrow = max(info.w(*, y_arr))
         mincol = min(info.w(x_arr, *))
         maxcol = max(info.w(x_arr, *))
         value  = info.w(x_arr, y_arr)
         allmin = info.wmin
         allmax = info.wmax

         If info.nase then begin ;Entschuldige mich für diesen Wust... sorry...
            If minrow eq 999999 then minrow = "(none)" else minrow = strtrim(string(minrow, FORMAT="(G20.3)"), 2)
            If maxrow eq 999999 then maxrow = "(none)" else maxrow = strtrim(string(maxrow, FORMAT="(G20.3)"), 2)
            If mincol eq 999999 then mincol = "(none)" else mincol = strtrim(string(mincol, FORMAT="(G20.3)"), 2)
            If maxcol eq 999999 then maxcol = "(none)" else maxcol = strtrim(string(maxcol, FORMAT="(G20.3)"), 2)
            If value  eq 999999 then value  = "(none)"
            If allmin eq 999999 then allmin = "(none)" else allmin = strtrim(string(allmin, FORMAT="(G20.3)"), 2)
            If allmax eq 999999 then allmax = "(none)" else allmax = strtrim(string(allmax, FORMAT="(G20.3)"), 2)
            row_nr = info.height-y_arr-1
            y_nr = x_arr
            x_nr = info.height-y_arr-1
         endif else begin
            minrow = strtrim(string(minrow, FORMAT="(G20.3)"), 2)
            maxrow = strtrim(string(maxrow, FORMAT="(G20.3)"), 2)
            mincol = strtrim(string(mincol, FORMAT="(G20.3)"), 2)            
            maxcol = strtrim(string(maxcol, FORMAT="(G20.3)"), 2)
            allmin = strtrim(string(allmin, FORMAT="(G20.3)"), 2)
            allmax = strtrim(string(allmax, FORMAT="(G20.3)"), 2)
            row_nr = y_arr
            y_nr = y_arr
            x_nr = x_arr
         endelse
         wset, info.text_win
         erase
         xyouts, /NORMAL, 0.01, 0.8, "ROW: "+str(row_nr), WIDTH=get_width
         xyouts, /NORMAL, get_width/2+0.05, 0.7, "min = "+minrow
         xyouts, /NORMAL, get_width/2+0.05, 0.9, "max = "+maxrow
         xyouts, /NORMAL, 0.5, 0.2, "COL: "+str(x_arr), ALIGNMENT=0.5
         xyouts, /NORMAL, 0.5, 0.1, "min = "+mincol+"  max = "+maxcol, ALIGNMENT=0.5
         xyouts, /NORMAL, 0.5, 0.5, ALIGNMENT=0.5, "Array("+str(x_nr)+","+str(y_nr)+") = "+str(value)
         if keyword_set(info.bound) then $
          minmaxcolor = rgb("orange", /noalloc) $
         else minmaxcolor = !P.Color
         xyouts, /NORMAL, 0.5, 0.4, "min = "+allmin+"  max = "+allmax, $
          ALIGNMENT=0.5, color=minmaxcolor

         if keyword_set(info.bound) then begin ;Die Begrenzungswerte für die Plots
            rowplotmin = info.range(0)
            colplotmin = info.range(0)
            rowplotmax = info.range(1)
            colplotmax = info.range(1)
         endif else begin
            rowplotmin = 0      ;minrow - Let Plot find it
            rowplotmax = 0      ;maxrow
            colplotmin = 0      ;mincol
            colplotmax = 0      ;maxcol
         endelse

         wset, info.row_win     ;Reihe darstellen
         PrepareNASEPlot, info.height, info.width, /OFFSET, GET_OLD=oldplot, NONASE=1-info.nase, /X_ONLY
         rowpos = info.position
         rowpos(3) = 15*info.zoom-rowpos(1)
         If keyword_set(info.nase) then begin
            plot, indgen(info.Width)+1, info.w(*, y_arr), /DEVICE, POSITION=rowpos, $
             xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
             yrange=[rowplotmin, rowplotmax], MAX_VALUE=999998
            endif else begin
             plot, indgen(info.Width)+1, info.w(*, y_arr),  /DEVICE, POSITION=rowpos, $
             xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
             yrange=[rowplotmin, rowplotmax]
          endelse
          if info.bound then begin
             oplot, indgen(info.Width)+1, replicate(rowplotmin, $
                                                    info.Width), color=rgb("orange", /noalloc), thick=2
             oplot, indgen(info.Width)+1, replicate(rowplotmax, $
                                                    info.Width), $
              color=rgb("orange", /noalloc), thick=2
          endif
         rowplotmin = !Y.CRANGE(0)
         rowplotmax = !Y.CRANGE(1)
         rowrange = rowplotmax-rowplotmin
         plots, [1+x_arr,1+x_arr], [rowplotmin-rowrange, rowplotmax+rowrange] ;ein (aber nicht zu langer!) Strich

         wset, info.pixcol_win     ;Spalte darstellen
         colpos = info.position
         colpos(2) = 15*info.zoom-colpos(0)
         pixcolpos = [info.win_height-colpos(3), $
                      colpos(0), $
                      info.win_height-colpos(1), $
                      colpos(2)]
         PrepareNASEPlot, info.width, info.height, /OFFSET, NONASE=1-info.nase, /X_ONLY
         If not info.nase then !X.TICKNAME = rotate(!X.TICKNAME(0:!X.TICKS), 2)
         If keyword_set(info.nase) then begin
            plot, info.Height-indgen(info.Height), info.w(x_arr, *), /DEVICE, POSITION=pixcolpos, $
             xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
             yrange=[colplotmin, colplotmax], MAX_VALUE=999998
         endif else begin
            plot, info.Height-indgen(info.Height), info.w(x_arr, *), /DEVICE, POSITION=pixcolpos, $
             xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
             yrange=[colplotmin, colplotmax]
         endelse
         if info.bound then begin
            oplot, indgen(info.Width)+1, replicate(colplotmin, $
                                                   info.Height), color=rgb("orange", /noalloc), thick=2
            oplot, indgen(info.Width)+1, replicate(colplotmax, $
                                                   info.Height), $
             color=rgb("orange", /noalloc), thick=2
         endif
         colplotmin = !Y.CRANGE(0)
         colplotmax = !Y.CRANGE(1)
         colrange = colplotmax-colplotmin
         plots, [info.Height-y_arr, info.Height-y_arr], [colplotmin-colrange, colplotmax+colrange]
         PrepareNASEPlot, RESTORE_OLD=oldplot
         tv = tvrd()
         wset, info.col_win           ;copy and rotate
         utv, rotate(Temporary(tv), 3)
         wset, Actwin
         !P.Color = ActCol
                                ;end
End

Pro ExamineIt_Event, Event
   
;   Widget_Control, Event.ID, GET_UVALUE=info, /NO_COPY ;Jedes meiner Widgets hat als UVALUE eine info-Struktur
   
   case TAG_NAMES(Event, /STRUCTURE_NAME) of       

      "WIDGET_DRAW"   : begin  ;Das tv-Widget
         Widget_Control, Event.Top, GET_UVALUE=topuval
         tvid = topuval.tv_id
         Widget_Control, tvID, GET_UVALUE=info, /NO_COPY ;Jedes meiner Widgets hat als UVALUE eine info-Struktur
         if Event.Type eq 0 then Widget_Control, tvID, /DRAW_MOTION_EVENTS ;Button Press
         if Event.Type eq 1 then Widget_Control, tvID, DRAW_MOTION_EVENTS=0 ;Button Release

         ;;------------------> Das ist nötig, damit überlieferte
         ;;Events richtig ausgewertet werden:
         ev_n = Convert_Coord(Event.X, Event.Y, /DEVICE, /TO_NORMAL);Umrechnung basiert auf Ausmaßen des Widgets, von dem das Event kommt
         X = info.xsize*ev_n(0);Umrechnung basiert auf Ausmaßen "unseres" Widgets
         Y = info.ysize*ev_n(1)
         ;;--------------------------------
         
         x_arr =  ( X-info.position(0)-info.zoom/2 ) / info.zoom
         y_arr =  ( Y-info.position(1)-info.zoom/2 ) / info.zoom
         x_arr = fix(x_arr) > 0 < (info.width-1)
         y_arr = fix(y_arr) > 0 < (info.height-1)

         examineit_refresh_plots, info, x_arr, y_arr

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
         Widget_Control, tvID, SET_UVALUE=info, /NO_COPY
      end
                                ;       case TAG_NAMES(Event, /STRUCTURE_NAME) of
                                ;          "WIDGET_TRACKING" : if Event.Enter eq 1 then Widget_Control, Event.ID, /DRAW_MOTION_EVENTS else Widget_Control, Event.ID, DRAW_MOTION_EVENTS=0
                                ;          "WIDGET_DRAW"    : begin
                                ;       endcase
      
   endcase                      ;info.name


End

Pro ExamineIt, _w, _tv_w, ZOOM=zoom, TITLE=title, $; DONT_PLOT=dont_plot, $
               GROUP=group, JUST_REG=just_reg, NO_Block=no_block, MODAL=modal, $
               GET_BASE=get_base, DELIVER_EVENTS=deliver_events, $
               BOUND=bound, RANGE=range, NASE=nase, $
               XPOS=xpos, YPOS=ypos, COLOR=color
   
   MyFont = '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
   MySmallFont = '-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1'


   If (Size(_w))(0) eq 2 then w = _w $ ;Do not change Contents!
   else w = reform(_w) ;Try to get rid of leading 1-dims.
              
   If Keyword_Set(_tv_w) then begin
      If (Size(_tv_w))(0) eq 2 then tv_w = _tv_w $ ;Do not change Contents!
      else tv_w = reform(_tv_w)       ;Try to get rid of leading 1-dims. 
      noscale = 1 
   endif else begin
      If Keyword_Set(nase) then begin
         tv_w = ShowWeights_Scale(w, /setcol)
         noscale = 1
      endif else begin
         tv_w = w
         noscale = 0
      endelse
   endelse

   If keyword_set (nase) then begin
      w = rotate(w, 3)
      tv_w = rotate(tv_w, 3)
      nones = where(w eq !NONE, count)
      If count ne 0 then w(nones) = max(w) ;Finde min ausser NONES
      Default, Range, [min(w), max(w)]
      If count ne 0 then w(nones) = +999999 ;Weil IDL3 noch kein MIN_VALUE kennt
   EndIf
  
   Default, nase, 0
   Default, Range, [min(w), max(w)]
   default, bound, 0
   Default, no_block, 1
   Default, modal, 0
   Default, deliver_events, [-1]
   Default, xpos, 100
   Default, ypos, 100
   Default, color, !P.Color
   w_width = (size(w))(1)
   w_height = (size(w))(2)
   if ((size(tv_w))(1) ne w_width) or ((size(tv_w))(2) ne w_height) then message, "Die TV-Version des Feldes muß die gleichen Ausmaße wie das Original-Feld haben!"

   Default, zoom, 450/max([w_width, w_height]) > 1

   xmargin = 40
   ymargin = 40

   win_width = zoom*w_width+2*xmargin
   win_height = zoom*w_height+2*ymargin

; Dann bauen wir mal ein Widget:
   Default, group, 0
   Default, title, "Examine It!"

   If fix(!VERSION.Release) ge 5 then $ ;Ab IDL 5 ist MODAL ein BASE-Keyword
    base = WIDGET_BASE(GROUP_LEADER=group, /COLUMN, TITLE=title, $
                       MODAL=modal, $
                       SPACE=1, $
                       XOFFSET=xpos, YOFFSET=ypos, $
                       MBAR=menu, $
                       UVALUE={name:"base"}) $
   else base = WIDGET_BASE(GROUP_LEADER=group, /COLUMN, TITLE=title, $
                           SPACE=1, $
                           XOFFSET=xpos, YOFFSET=ypos, $
                           MBAR=menu, $
                           UVALUE={name:"base"})

   GET_BASE = base
      
   
   upper_base = WIDGET_BASE(base, /ROW, $
                            SPACE=7, $
                            UVALUE={name:"upper_base"})

   lower_base = WIDGET_BASE(base, /ROW, $
                            SPACE=7, $
                            UVALUE={name:"lower_base"})

   plot_row = WIDGET_DRAW(upper_base, RETAIN=1, $
                          XSIZE=win_width, YSIZE=15*zoom, $ ;win_height/2, $
                          UVALUE={name:"plot_row"})

   text     = WIDGET_DRAW(upper_base, RETAIN=1, $
                          XSIZE=15*zoom, YSIZE=15*zoom, $ ; Pixel
                          UVALUE={name:"text"})
   
   tv = WIDGET_DRAW(lower_base, RETAIN=1, $
                    XSIZE=win_width, YSIZE=win_height, $
                    UVALUE={name  : "tv"}, $
                    /BUTTON_EVENTS)

   plot_col = WIDGET_DRAW(lower_base, RETAIN=1, $
                          XSIZE=15*zoom, $ ;win_width/2, $
                          YSIZE=win_height, $
                          UVALUE={name:"plot_col"})

   ;; the menu:
   menu_buttons = cw_pdmenu(menu, /Mbar, $
                            ['1\Mode', $
                             '0\BOUND on\examineit_bound_on_handler',$
                             '2\BOUND off\examineit_bound_off_handler'], $
                            IDs=ids, Font=MyFont)
   Uvalue, ids[1], {tv: tv, other: ids[2]}
   Uvalue, ids[2], {tv: tv, other: ids[1]}
   widget_control, ids[2-BOUND], Sensitive=0
   

   WINDOW, /pixmap, /free, $
    XSIZE=win_height, $
    YSIZE=15*zoom
   pixcol_win = !D.Window

   WIDGET_CONTROL, base, /REALIZE
   WIDGET_CONTROL, tv, GET_VALUE=tv_win
   WIDGET_CONTROL, plot_row, GET_VALUE=row_win
   WIDGET_CONTROL, plot_col, GET_VALUE=col_win
   WIDGET_CONTROL, text, GET_VALUE=text_win


   ;; This might take a while, so set hourglass:
   Widget_Control, base, /hourglass

   wset, tv_win
   plotweights, tv_w, xmargin, ymargin, zoom, NOSCALE=noscale, NONASE=1-nase, COLOR=color, GET_POSITION=gp, GET_MINOR=gm
   WIDGET_CONTROL, base, SET_UVALUE={name: "base", tv_id: tv}
   
   info={name    : "tv", $
         width   : w_width, $
         height  : w_height, $
         win_width: win_width, $
         win_height: win_height, $
         zoom    : zoom, $
         position: gp, $
         $ ;; minor   : gm, $
         tv_win  : tv_win, $
         row_win : row_win, $
         col_win : col_win, $
         pixcol_win: pixcol_win, $
         text_win: text_win, $
         w       : w, $
         wmax    : max(w), $
         wmin    : min(w), $
         bound   : bound, $
         range   : range, $
         deliver_events:deliver_events, $
         xsize   : win_width, $
         ysize   : win_height, $
         nase    : nase, $
         color   : color, $
         last_x_arr: w_height/2, $
         last_y_arr: w_width/2}

   WIDGET_CONTROL, tv, SET_UVALUE=info

   examineit_refresh_plots, info

   If fix(!VERSION.Release) ge 5 then XMANAGER, 'ExamineIt', Base,NO_BLOCK=no_block, JUST_REG=just_reg $
    else XMANAGER, "ExamineIt", base, JUST_REG=JUST_REG, MODAL=modal
End
