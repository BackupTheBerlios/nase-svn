;+
; NAME: ExamineIt
;
; PURPOSE: Darstellung und interaktive Abfrage eines zweidimensionalen
;          Arrays. (S. auch PROCEDURE-Abschnitt)
;
; CATEGORY: Visualisierung, Auswertung
;
; CALLING SEQUENCE: ExamineIt, Array [,TV_Array] [,ZOOM=Faktor] [,TITLE=Fenstertitel] 
;                                        [,/BOUND]
;                                        [,GROUP=Widget_Leader [,/MODAL]] [,/JUST_REG], [,NO_BLOCK=0]
;                                        [,GET_BASE=BaseID]
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
;                             weitergereicht werden.
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
;       Revision 2.2  1998/03/31 13:38:22  kupper
;              Sicherheits-Commit vor Änderung am Event-Handler.
;
;       Revision 2.1  1997/12/15 16:24:45  kupper
;              Schöpfung.
;
;
;-


pro PlotWeights, w, xpos, ypos, zoom, GET_POSITION=get_position, GET_MINOR=get_minor, $
                 _EXTRA=_extra
   
   height = (size(w))(2)
   width  = (size(w))(1)

   ticklen = (convert_coord([zoom, zoom], /device, /to_normal))/1.6
 
   plotwx = (width+1)*zoom
   plotwy = (height+1)*zoom
   devplotpx = xpos-zoom/2
   devplotpy = ypos-zoom/2
   devplotpx1 = devplotpx+(width+1)*zoom
   devplotpy1 = devplotpy+(height+1)*zoom

   plotpx = (convert_coord([devplotpx, devplotpy], /device, /to_normal))(0)
   plotpx1 = (convert_coord([devplotpx1, devplotpy1], /device, /to_normal))(0)
   plotpy = (convert_coord([devplotpx, devplotpy], /device, /to_normal))(1)
   plotpy1 = (convert_coord([devplotpx1, devplotpy1], /device, /to_normal))(1)

   plot, indgen(2), /NODATA, position=[plotpx, plotpy, plotpx1, plotpy1], $
    xrange=[-1, width], /xstyle, xtick_get=xt, $
    yrange=[-1, height], /ystyle, ytick_get=yt, _EXTRA=_extra
   plot, indgen(2), /NODATA, position=[plotpx, plotpy, plotpx1, plotpy1], $
    xrange=[-1, width], /xstyle, xminor=xt(1), $
    yrange=[-1, height], /ystyle, yminor=yt(1), $
    xticklen=ticklen(0), yticklen=ticklen(1), _EXTRA=_extra

   get_position = [devplotpx, devplotpy, devplotpx1, devplotpy1]
   get_minor = [xt(1), yt(1)]

   tvscl, rebin(w, zoom*width, zoom*height, /sample), xpos, ypos


end

Pro ExamineIt_Event, Event
   
   Widget_Control, Event.ID, GET_UVALUE=info, /NO_COPY
   
   case info.name of            ;Jedes meiner Widgets hat als UVALUE eine info-Struktur

      "tv"   : begin            ;Das tv-Widget
                                ;       case TAG_NAMES(Event, /STRUCTURE_NAME) of
                                ;          "WIDGET_TRACKING" : if Event.Enter eq 1 then Widget_Control, Event.ID, /DRAW_MOTION_EVENTS else Widget_Control, Event.ID, DRAW_MOTION_EVENTS=0
                                ;          "WIDGET_DRAW"    : begin
         if Event.Type eq 0 then Widget_Control, Event.ID, /DRAW_MOTION_EVENTS ;Button Press
         if Event.Type eq 1 then Widget_Control, Event.ID, DRAW_MOTION_EVENTS=0 ;Button Release
         
         
         x_arr =  ( Event.X-info.position(0)-info.zoom/2 ) / info.zoom
         y_arr =  ( Event.Y-info.position(1)-info.zoom/2 ) / info.zoom
         x_arr = fix(x_arr) > 0 < (info.width-1)
         y_arr = fix(y_arr) > 0 < (info.height-1)

         minrow = min(info.w(*, y_arr))
         maxrow = max(info.w(*, y_arr))
         mincol = min(info.w(x_arr, *))
         maxcol = max(info.w(x_arr, *))

         wset, info.text_win
         erase
         xyouts, /NORMAL, 0.01, 0.8, "ROW: "+strtrim(y_arr, 2), WIDTH=get_width
         xyouts, /NORMAL, get_width/2+0.05, 0.7, "min = "+strtrim(string(minrow, FORMAT="(G20.3)"), 2)
         xyouts, /NORMAL, get_width/2+0.05, 0.9, "max = "+strtrim(string(maxrow, FORMAT="(G20.3)"), 2)
         xyouts, /NORMAL, 0.5, 0.2, "COL: "+strtrim(x_arr, 2), ALIGNMENT=0.5
         xyouts, /NORMAL, 0.5, 0.1, "min = "+strtrim(string(mincol, FORMAT="(G20.3)"), 2)+"  max = "+strtrim(string(maxcol, FORMAT="(G20.3)"), 2), ALIGNMENT=0.5
         xyouts, /NORMAL, 0.5, 0.5, ALIGNMENT=0.5, "Array("+strtrim(x_arr, 2)+","+strtrim(y_arr, 2)+") = "+strtrim(info.w(x_arr, y_arr), 2)
         xyouts, /NORMAL, 0.5, 0.4, "min = "+strtrim(string(info.wmin, FORMAT="(G20.3)"), 2)+"  max = "+strtrim(string(info.wmax, FORMAT="(G20.3)"), 2), ALIGNMENT=0.5

         if keyword_set(info.bound) then begin ;Die Begrenzungswerte für die Plots
            rowplotmin = info.wmin
            colplotmin = info.wmin
            rowplotmax = info.wmax
            colplotmax = info.wmax
         endif else begin
            rowplotmin = minrow
            rowplotmax = maxrow
            colplotmin = mincol
            colplotmax = maxcol
         endelse

         wset, info.row_win     ;Reihe darstellen
         rowpos = info.position
         rowpos(3) = 15*info.zoom-rowpos(1)
            plot, info.w(*, y_arr), xrange=[-1, info.width], /XSTYLE, /DEVICE, POSITION=rowpos, XMINOR=info.minor(0), $
             xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
             yrange=[rowplotmin, rowplotmax]
            rowrange = rowplotmax-rowplotmin
            plots, [x_arr,x_arr], [rowplotmin-rowrange, rowplotmax+rowrange] ;ein (aber nicht zu langer!) Strich

         wset, info.col_win     ;Spalte darstellen
         colpos = info.position
         colpos(2) = 15*info.zoom-colpos(0)
            plot, info.w(x_arr, *), indgen(info.height), yrange=[-1, info.height], /YSTYLE, /DEVICE, POSITION=colpos, YMINOR=info.minor(1), $
             xticklen=1.0, yticklen=1.0, xgridstyle=1, ygridstyle=1, $
             xrange=[colplotmin, colplotmax]
            colrange = colplotmax-colplotmin
            plots, [colplotmin-colrange, colplotmax+colrange], [y_arr, y_arr]


                                ;end
                                ;       endcase
      end                       ;tv
      
   endcase                      ;info.name

   Widget_Control, Event.ID, SET_UVALUE=info, /NO_COPY
End

Pro ExamineIt, w, tv_w, ZOOM=zoom, TITLE=title, $; DONT_PLOT=dont_plot, $
               GROUP=group, JUST_REG=just_reg, NO_Block=no_block, MODAL=modal, $
               GET_BASE=get_base, DELIVER_EVENTS=deliver_events, $
               BOUND=bound
   
   Default, no_block, 1
   Default, modal, 0
   Default, deliver_events, [-1]
   Default, tv_w, w
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

   base = WIDGET_BASE(GROUP_LEADER=group, /COLUMN, TITLE=title, $
                      MODAL=modal, $
                      SPACE=1, $
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
 
   WIDGET_CONTROL, base, /REALIZE
   WIDGET_CONTROL, tv, GET_VALUE=tv_win
   WIDGET_CONTROL, plot_row, GET_VALUE=row_win
   WIDGET_CONTROL, plot_col, GET_VALUE=col_win
   WIDGET_CONTROL, text, GET_VALUE=text_win

   wset, tv_win
   plotweights, w, xmargin, ymargin, zoom, GET_POSITION=gp, GET_MINOR=gm

   default, bound, 0
   WIDGET_CONTROL, tv, SET_UVALUE={name    : "tv", $
                                   width   : w_width, $
                                   height  : w_height, $
                                   zoom    : zoom, $
                                   position: gp, $
                                   minor   : gm, $
                                   row_win : row_win, $
                                   col_win : col_win, $
                                   text_win: text_win, $
                                   w       : w, $
                                   wmax    : max(w), $
                                   wmin    : min(w), $
                                   bound   : bound, $
                                   deliver_events:deliver_events}

;   wset, row_win
;   plot, w(*, w_height/2), xrange=[0, w_width-1], /XSTYLE, POSITION=gp, XMINOR=gm(0)

   If fix(!VERSION.Release) ge 5 then XMANAGER, 'ExamineIt', Base,NO_BLOCK=no_block, JUST_REG=just_reg $
    else XMANAGER, "ExamineIt", base, JUST_REG=JUST_REG
End
