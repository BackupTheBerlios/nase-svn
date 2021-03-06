;+
; NAME: ExamineIt
;
; AIM:
;  Interactively investigate the contents of a two-dimensional array.
;
; PURPOSE: Darstellung und interaktive Abfrage eines zweidimensionalen
;          Arrays. (S. auch PROCEDURE-Abschnitt)
;
; CATEGORY:
;  Array
;  Graphic
;  Help
;  NASE
;  Widgets
;
; CALLING SEQUENCE: 
;*  ExamineIt, Array [,TV_Array] [,ZOOM=Faktor] [,TITLE=Fenstertitel]
;*                   [,COLOR=PlotColor]
;*                   [,XPOS=xoffset] [,YPOS=yoffset]
;*                   [,/BOUND]
;*                   [,RANGE=...]
;*                   { {[,/NORDER] [,/NSCALE]} | [,/NASE] }
;*                   [,GROUP=Widget_Leader [,/MODAL]] [,/JUST_REG], [,NO_BLOCK=0]
;*                   [,GET_BASE=BaseID]
;*                   [,DELIVER_EVENTS=Array_of_Widget_IDs]
;  
; INPUTS: Array:: Das zu untersuchende Array (ein numerischer Typ!)
;
; OPTIONAL INPUTS: TV_Array:: Die Version des Arrays, die tats�chlich
;                            mit TV auf den Bildschirm gebracht
;                            wird. Die kann sich ja eventuell vom
;                            Original unterscheiden, wenn
;                            beispielsweise bestimmten Arraywerten
;                            besondere Farbindizes zugeordnet werden
;                            sollen.<BR>
;                            Passing this parameter implies setting of
;                            <C>/NOSCALE</C>.
;	
; OPTIONAL OUTPUTS: GET_BASE:: Hier kann die ID des produzierten Widgets erfahren werden.
;
; INPUT KEYWORDS:     ZOOM::   Vergr��erungsfaktor (Ein Arraypixel im
;                             TV-Feld wird als Quadrat der Gr��e ZOOM
;                             Bildschirmpixel dargestellt).
;                             Bei Nichtangabe wird ein mehr oder weniger
;                             guter Default gew�hlt.
;                     TITLE::  Der Fenstertitel. Default: "Examine It!"
;                     COLOR::  PlotFarbe f�r die Koordinatensysteme (Default: !P.Color)
;                 XPOS,YPOS::  Position von der linken oberen Bildschirmecke (Default: 100,100)
;                     BOUND::  Bei Angabe dieses Schl�sselwortes sind
;                             die Grenzen der Plotbereiche fest auf
;                             das Minimum/Maximum des Arrays
;                             eingestellt.
;                             Ansonsten sind die Grenzen das
;                             Minimum/Maximum der gerade untersuchten
;                             Reihe/Spalte, was den zur Verf�gung
;                             stehenden Platz besser ausnutzt, aber
;                             beim "Durchfahren" des Arrays etwas
;                             irritierend wirken kann.
;                             The <C>BOUND</C> mode can also be toggled
;                             "online" via a widget menu entry.
;      NOSCALE:: Do not perform any color scaling. Array contents will
;                be directly interpreted as color indices. (Cf.
;                <C>NOSCALE</C> keyword in <A>UTVScl</A>.)
;         NASE:: Setting this keyword is equivalent to setting
;                <C>NORDER</C> and <C>NSCALE</C> (see below). It is
;                maintained for backwards compatibility.<BR>
;                <I>Note: In general, newer applications sould use the
;                         <C>NORDER</C> and <C>NSCALE</C> keywords to
;                         indicate array ordering and color scaling
;                         according to NASE conventions.</I>
;       NORDER:: Indicate that array ordering conforms to the NASE
;                convention: The indexing order is <*>[row,column]</*>, and
;                the origin will be displayed on the UPPER left corner
;                (unless <C>ORDER</C> is set, cf. IDL help on
;                <C>TvScl</C>).<BR>
;                If this keyword is not set, the indexing order is
;                <*>[column,row]</*>, and the origin will be displayed
;                on the LOWER left corner (unless <C>ORDER</C> is
;                set).
;       NSCALE:: Request that colorscaling shall be done according to
;                NASE conventions: Before display, the array contents
;                will be scaled for display with the NASE colortables
;                (b/w linear or red/green linear by default). The
;                value <*>0</*> will always be mapped to black. In
;                addition, the appropriate NASE color table will be
;                loaded, unless <C>SETCOL</C><*>=0</*> is passed. (For
;                further information cf. <A>Showweights_Scale</A>.)<BR>
;                This keyword has no effect, if <C>/NOSCALE</C> is set.<BR>
;                If this keyword is set, the <C>TV_Array</C> parameter
;                will be ignored.
;     RANGE_IN:: A two element array defining<BR>
;<BR>
;                (1) the lower and upper bound of the plot-windows
;                    showing the cross-sections of the array, and<BR>
;<BR>
;                (2) the control points for color scaling:<BR>
;                    <*>RANGE_IN[0]</*> will be scaled to color index
;                    <*>0</*>, and <*>RANGE_IN[1]</*> will be scaled to
;                    color index <*>!TOPCOLOR</*>.<BR>
;                    If <C>/NSCALE</C> (or <C>/NASE</C>) is
;                    set, the value <*>0</*> will always be scaled
;                    to the color index corresponding to black in the
;                    respective NASE color table. The value
;                    <*>max(abs(RANGE_IN))</*> will be scaled to
;                    <*>!TOPCOLOR</*>.<BR>
;                    If <C>/NSCALE</C> (or <C>/NASE</C>) is set, and
;                    the range passed in <C>RANGE_IN</C> extends into
;                    the negative, the red/green colortable will be
;                    loaded, even if the array is positive. (Unless
;                    <*>SETCOL=0</*> is passed.)
;<BR>
;     GROUP:: Eine Widget-ID des Widgets, das als �bervater dienen
;             soll.
;     MODAL:: Wenn angegeben, ist das Widget modal, d.h. alle anderen
;             Widgets sind deaktiviert, solange dieses existiert. 
;             <C>MODAL</C> erfordert die Angabe eines Group-Leaders in
;             <C>GROUP</C>.
;     JUST_REG:: Wird direkt an den <C>XMANAGER</C> weitergereicht und
;                dient dazu, mehrere Instanzen von <C>ExamineIt</C>
;                gleichzeitig zu benutzen. (Vgl. <A>SurfIt</A> oder
;                Beispiel.)
;     NO_BLOCK:: Wird ab IDL 5 an den <C>XMANAGER</C> weitergegeben. 
;                (Beschreibung s. IDL-Hilfe) Der Default ist <*>1</*>,
;                also kein Blocken. Wird Blocken gew�nscht, so mu�
;                <C>NO_BLOCK</C> explizit auf <*>0</*> gesetzt werden.
;     DELIVER_EVENTS:: Hier kann ein Array von Widget-Indizes
;                      �bergeben werden, an die alle ankommenden
;                      Events weitergereicht werden. (<B>VORSICHT,
;                      BUGGY!</B> (s.u.))
;
; PROCEDURE: Nach dem Aufruf kann mit der Maus in der TV-Darstellung
;            herumgeklickt oder gefahren werden, wobei der aktuelle
;            Arraywert ausgegeben, die jeweils
;            aktuelle Zeile/Spalte geplottet und deren jeweiliges Minimum
;            und Maximum sowie das Minimum/Maximum des gesamten Arrays
;            ausgegeben werden.
;
; EXAMPLE: 
;* ExamineIt, Gauss_2D(20,30), ZOOM=10, /JUST_REG
;* ExamineIt, DOG(40,30,5,10), /BOUND
;
; SEE ALSO: <A>SurfIt</A>
;-


Pro examineit_bound_on_handler, event
   COMPILE_OPT HIDDEN

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
   COMPILE_OPT HIDDEN

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
                 NOSCALE=noscale, GET_POSITION=get_position, $
                 COLOR = color, RANGE_IN=range_in
   COMPILE_OPT HIDDEN

   height = (size(w))(2)
   width  = (size(w))(1)

   ticklen = (convert_coord([zoom, zoom], /device, /to_normal))/1.6
   devpos = [xpos-zoom/2, ypos-zoom/2, xpos+zoom*(width+0.5), ypos+zoom*(height+0.5)]

   PrepareNASEPlot, height, width, /OFFSET, GET_OLD=oldplot, NONASE=nonase
   plot, /NODATA, indgen(10), /DEVICE, POSITION=devpos, COLOR=color
   PrepareNASEPlot, RESTORE_OLD=oldplot
   GET_POSITION = devpos
 
   utvscl, w, stretch=zoom, xpos, ypos, /DEVICE, NOSCALE=noscale, RANGE_IN=range_in
end

Pro examineit_refresh_plots, info, x_arr, y_arr
   COMPILE_OPT HIDDEN

   default, x_arr, info.last_x_arr
   default, y_arr, info.last_y_arr
   
   info.last_x_arr = x_arr
   info.last_y_arr = y_arr

         ActWin = !D.Window
         ActCol = !P.Color
         !P.Color = info.color
         
         minrow = min(info.w(*, y_arr), /NAN)
         maxrow = max(info.w(*, y_arr), /NAN)
         mincol = min(info.w(x_arr, *), /NAN)
         maxcol = max(info.w(x_arr, *), /NAN)
         value  = info.w(x_arr, y_arr)
         allmin = info.wmin
         allmax = info.wmax

         minrow = strtrim(string(minrow, FORMAT="(G20.3)"), 2)
         maxrow = strtrim(string(maxrow, FORMAT="(G20.3)"), 2)
         mincol = strtrim(string(mincol, FORMAT="(G20.3)"), 2)
         maxcol = strtrim(string(maxcol, FORMAT="(G20.3)"), 2)
         allmin = strtrim(string(allmin, FORMAT="(G20.3)"), 2)
         allmax = strtrim(string(allmax, FORMAT="(G20.3)"), 2)
         ;; value is not shortened, to have the exact value displayed.
         
         If info.norder then begin ;Entschuldige mich f�r diesen Wust... sorry...
            row_nr = info.height-y_arr-1
            y_nr = x_arr
            x_nr = info.height-y_arr-1
         endif else begin
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

         if keyword_set(info.bound) then begin ;Die Begrenzungswerte f�r die Plots
            rowplotmin = info.range_in(0)
            colplotmin = info.range_in(0)
            rowplotmax = info.range_in(1)
            colplotmax = info.range_in(1)
         endif else begin
            rowplotmin = 0      ;minrow - Let Plot find it
            rowplotmax = 0      ;maxrow
            colplotmin = 0      ;mincol
            colplotmax = 0      ;maxcol
         endelse

         wset, info.row_win     ;Reihe darstellen
         PrepareNASEPlot, info.height, info.width, /OFFSET, GET_OLD=oldplot, NONASE=1-Keyword_Set(info.norder), /X_ONLY
         rowpos = info.position
         rowpos(3) = info.win_height/3-rowpos(1);15*info.zoom-rowpos(1)
         ;; check if all is !NONE:
         If (where(finite(info.w(*, y_arr))))[0] eq -1 then begin
            ;; all values are !NONE or NaN
            ;; do empty plot:
            plot, /NODATA, indgen(info.Width)+1, fltarr(info.Width), /DEVICE, POSITION=rowpos, $
                  xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
                  yrange=[rowplotmin, rowplotmax]
         endif else begin
            ;; there is something plottable
            plot, indgen(info.Width)+1, info.w(*, y_arr), /DEVICE, POSITION=rowpos, $
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
         
         wset, info.pixcol_win  ;Spalte darstellen
         colpos = info.position
         colpos(2) = info.win_width/3-colpos(1);15*info.zoom-colpos(0)
         pixcolpos = [info.win_height-colpos(3), $
                      colpos(0), $
                      info.win_height-colpos(1), $
                      colpos(2)]
         PrepareNASEPlot, info.width, info.height, /OFFSET, NONASE=1-Keyword_Set(info.nase), /X_ONLY
         If not info.norder then !X.TICKNAME = rotate(!X.TICKNAME(0:!X.TICKS), 2)
         ;; check if all is !NONE:
         If (where(finite(info.w(x_arr, *))))[0] eq -1 then begin
            ;; all values are !NONE or NaN
            ;; do empty plot:
            plot, /NODATA, indgen(info.Height)+1, fltarr(info.Height), /DEVICE, POSITION=rowpos, $
                  xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
                  yrange=[rowplotmin, rowplotmax]
         endif else begin
            ;; there is something plottable
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

         If Pseudocolor_Visual() then begin
            ;; we have a pseudocolor display, array is [x,y]
            tv = tvrd()
            wset, info.col_win  ;copy and rotate
            utv, rotate(Temporary(tv), 3), /Allowcolors
         endif else begin
            ;; we have a truecolor display, array is [3,x,y]
            tv = tvrd(/TRUE)
            ;; make array of swapped dimensions x/y:
            tv_size = size(tv, /Dimensions)
            tv2 = make_array(/Byte, /Nozero, 3, tv_size[2], tv_size[1])
            tv2[0, *, *] = rotate(reform(tv[0, *, *]), 3)
            tv2[1, *, *] = rotate(reform(tv[1, *, *]), 3)
            tv2[2, *, *] = rotate(reform(tv[2, *, *]), 3)
            wset, info.col_win  ;copy and rotate
            utv, tv2, /TRUE
         endelse
         wset, Actwin
         !P.Color = ActCol
                                ;end
End

Pro ExamineIt_Event, Event
   COMPILE_OPT HIDDEN
   
;   Widget_Control, Event.ID, GET_UVALUE=info, /NO_COPY ;Jedes meiner Widgets hat als UVALUE eine info-Struktur
   
   case TAG_NAMES(Event, /STRUCTURE_NAME) of       

      "WIDGET_DRAW"   : begin  ;Das tv-Widget
         Widget_Control, Event.Top, GET_UVALUE=topuval
         tvid = topuval.tv_id
         Widget_Control, tvID, GET_UVALUE=info, /NO_COPY ;Jedes meiner Widgets hat als UVALUE eine info-Struktur
         if Event.Type eq 0 then Widget_Control, tvID, /DRAW_MOTION_EVENTS ;Button Press
         if Event.Type eq 1 then Widget_Control, tvID, DRAW_MOTION_EVENTS=0 ;Button Release

         ;;------------------> Das ist n�tig, damit �berlieferte
         ;;Events richtig ausgewertet werden:
         WSet, info.tv_win
         ev_n = Convert_Coord(Event.X, Event.Y, /DEVICE, /TO_NORMAL);Umrechnung basiert auf Ausma�en des Widgets, von dem das Event kommt
         X = info.xsize*ev_n(0);Umrechnung basiert auf Ausma�en "unseres" Widgets
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
               BOUND=bound, RANGE_IN=range_in, $
               NASE=nase, SETCOL=setcol, NORDER=norder, NSCALE=nscale, $
               NOSCALE = _noscale, $
               XPOS=xpos, YPOS=ypos, COLOR=color
   
   ;; The font definition has been moved to the DefGlobVars routine
   ;;   MyFont = '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
   ;;   MySmallFont = '-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1'

   ;;NASE implies NORDER and NSCALE:
   Default, NASE, 0
   Default, NORDER, NASE
   Default, NSCALE, NASE
   Default, SETCOL, 1;; this is the default in PlotTvScl, so we want
   ;; to have it the same here. It only applies when NSCALE or NASE is
   ;; set.
   
   ;; do not change NOSCALE argument, for safety:
   Default, noscale, _noscale

   If (Size(_w))(0) eq 2 then w = _w $ ;Do not change Contents!
   else w = reform(_w)        ;Try to get rid of leading 1-dims.


   If Set(_tv_w) then begin
      If (Size(_tv_w))(0) eq 2 then tv_w = _tv_w $ ;Do not change Contents!
      else tv_w = reform(_tv_w) ;Try to get rid of leading 1-dims. 
      noscale = 1 
   endif

   If Keyword_Set(NSCALE) and not Keyword_Set(noscale) then begin
      if keyword_set(RANGE_IN) then begin
         ;; use red/green table, if range_in extends into negative:
         if min(range_in) lt 0 then colormode = -1
         tv_w = ShowWeights_Scale(w, SETCOL=setcol, $
                                  COLORMODE=colormode, $
                                  RANGE_IN=max(abs(RANGE_IN)))
      endif else begin
         tv_w = ShowWeights_Scale(w, SETCOL=setcol)
      endelse
      noscale = 1
   endif

   ;; if tv_w is not set until now, it defaults to w:
   Default, tv_w, w


   If keyword_set (NORDER) then begin
      w = rotate(Temporary(w), 3)
      tv_w = rotate(Temporary(tv_w), 3)
   Endif

   ;; replace !NONES by NaN
   ;; this allows easy computing of min and max, and easy plotting.
   ;; COde will break on IDL3, but we don't care any more.
   NoNone, w, Value=!VALUES.D_NAN

   Default, Range_In, [min(w, /NAN), max(w, /NAN)] 
   default, bound, 1
   Default, no_block, 1
   Default, modal, 0
   Default, deliver_events, [-1]
   Default, xpos, 100
   Default, ypos, 100
   Default, color, !P.Color
   w_width = (size(w))(1)
   w_height = (size(w))(2)
   if ((size(tv_w))(1) ne w_width) or ((size(tv_w))(2) ne w_height) then message, "Die TV-Version des Feldes mu� die gleichen Ausma�e wie das Original-Feld haben!"

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

   plot_row = WIDGET_DRAW(upper_base, $
                          XSIZE=win_width, YSIZE=win_height/3, $
                          UVALUE={name:"plot_row"})

   text     = WIDGET_DRAW(upper_base, $
                          XSIZE=win_width/3, YSIZE=win_height/3, $ ; Pixel
                          UVALUE={name:"text"})
   
   tv = WIDGET_DRAW(lower_base, $
                    XSIZE=win_width, YSIZE=win_height, $
                    UVALUE={name  : "tv"}, $
                    /BUTTON_EVENTS)

   plot_col = WIDGET_DRAW(lower_base, $
                          XSIZE=win_width/3, $
                          YSIZE=win_height, $
                          UVALUE={name:"plot_col"})

   ;; the menu:
   menu_buttons = cw_pdmenu(menu, /Mbar, $
                            ['1\Mode', $
                             '0\BOUND on\examineit_bound_on_handler',$
                             '2\BOUND off\examineit_bound_off_handler'], $
                            IDs=ids, Font=!NASEWIDGETFONT)
   Uvalue, ids[1], {tv: tv, other: ids[2]}
   Uvalue, ids[2], {tv: tv, other: ids[1]}
   widget_control, ids[2-BOUND], Sensitive=0
   

   WINDOW, /pixmap, /free, $
    XSIZE=win_height, $
    YSIZE=win_width/3
   pixcol_win = !D.Window

   WIDGET_CONTROL, base, /REALIZE
   WIDGET_CONTROL, tv, GET_VALUE=tv_win
   WIDGET_CONTROL, plot_row, GET_VALUE=row_win
   WIDGET_CONTROL, plot_col, GET_VALUE=col_win
   WIDGET_CONTROL, text, GET_VALUE=text_win


   ;; This might take a while, so set hourglass:
   Widget_Control, base, /hourglass

   wset, tv_win
   plotweights, tv_w, xmargin, ymargin, zoom, NOSCALE=noscale, $
                RANGE_IN=range_in, NONASE=1-Keyword_Set(NORDER), $
                COLOR=color, GET_POSITION=gp
   WIDGET_CONTROL, base, SET_UVALUE={name: "base", tv_id: tv}
   
   info={name    : "tv", $
         width   : w_width, $
         height  : w_height, $
         win_width: win_width, $
         win_height: win_height, $
         zoom    : zoom, $
         position: gp, $
         $
         tv_win  : tv_win, $
         row_win : row_win, $
         col_win : col_win, $
         pixcol_win: pixcol_win, $
         text_win: text_win, $
         w       : w, $
         wmax    : max(w, /NAN), $
         wmin    : min(w, /NAN), $
         bound   : bound, $
         range_in: range_in, $
         deliver_events:deliver_events, $
         xsize   : win_width, $
         ysize   : win_height, $
         nase    : nase, $
         norder  : norder, $
         nscale  : nscale, $
         setcol  : setcol, $
         color   : color, $
         last_y_arr: w_height/2, $
         last_x_arr: w_width/2}

   WIDGET_CONTROL, tv, SET_UVALUE=info

   examineit_refresh_plots, info

   If fix(!VERSION.Release) ge 5 then XMANAGER, 'ExamineIt', Base,NO_BLOCK=no_block, JUST_REG=just_reg $
    else XMANAGER, "ExamineIt", base, JUST_REG=JUST_REG, MODAL=modal
End
