PRO TomWaits_Event, Event

   EventType = Tag_Names(Event, /STRUCTURE_NAME)

   Widget_Control, Event.Id, GET_UVALUE=uval
   Widget_Control, Event.Top, GET_UVALUE=data
   
   Case EventType of
      'WIDGET_BUTTON': begin
         Case uval.info of
            'TOMWAITS_WEIGHTS': begin
               data.delay = 0
               ShowWeights, data.DW, ZOOM=data.zoom, WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode, GET_INFO=get_info, GET_COLORS=get_colors
               data.colormode = get_colormode
               data.tvinfo = get_info
               data.colors = get_colors
               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_DELAYS': begin
               data.delay = 1
               ShowWeights, data.DW, /DELAYS, ZOOM=data.zoom, WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode, GET_INFO=get_info, GET_COLORS=get_colors
               data.colormode = get_colormode
               data.tvinfo = get_info
               data.colors = get_colors
               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_PROJECTIVE': begin
               Widget_Control, uval.id_other, SET_BUTTON=0 ;explizit machen, da sie nicht in der gleichen Base sind!
               data.projective = 1
               data.receptive  = 0
               ShowWeights, data.DW, DELAYS=data.delay, ZOOM=data.zoom, WINNR=data.win, /PROJECTIVE, GET_INFO=get_info, GET_COLORS=get_colors
               data.tvinfo = get_info
               data.colors = get_colors
               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_RECEPTIVE': begin
               Widget_Control, uval.id_other, SET_BUTTON=0
               data.projective = 0
               data.receptive  = 1
               ShowWeights, data.DW, DELAYS=data.delay, ZOOM=data.zoom, WINNR=data.win, /RECEPTIVE, GET_INFO=get_info, GET_COLORS=get_colors
               data.tvinfo = get_info
               data.colors = get_colors
               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_PRINT': message, /INFO, "Print-Event not yet implemented!"
            'TOMWAITS_DONE': begin
               Widget_Control, Event.Top, /DESTROY
               return
            end
            else: message, /INFO, "I don't know this Button!"
         endcase
         Widget_Control, Event.Top, SET_UVALUE=data
      end
      
      'WIDGET_DRAW': begin   
         !TopColor = data.my_TopColor
         If Event.Type eq 1 then begin ;Mouse Button Release
            If (Event.Release and 1) eq 1 then begin ;Left Button
               mag = Widget_Info(Event.ID, /SIBLING)
               If mag ne 0 then Widget_Control, mag, /DESTROY 
            endif
         Endif                  ;Mouse Button Release

         If Event.Type eq 0 then begin ;Mouse Button Press
            ;;------------------> Neuronennummer bestimmen:
            col = fix((Event.X-data.tvinfo.x0)/data.tvinfo.subxsize)
            row = fix((Event.Y-data.tvinfo.y00)/data.tvinfo.subysize)
            If data.projective then begin
               col = col > 0 < (DWDim(data.DW, /SW)-1)
               row = row > 0 < (DWDim(data.DW, /SH)-1)
               row = (DWDim(data.DW, /SH)-1) - row
            endif else begin
               col = col > 0 < (DWDim(data.DW, /TW)-1)
               row = row > 0 < (DWDim(data.DW, /TH)-1)
               row = (DWDim(data.DW, /TH)-1) - row
            endelse
            ;;--------------------------------
            Widget_Control, Event.Top, TLB_GET_OFFSET=BaseOffset ;von OBEN links
            Widget_Control, Event.ID,  GET_DRAW_VIEW=ViewPos ;von UNTEN links
            If data.yscroll then ViewPos(1) = data.ysize-ViewPos(1)-data.y_scroll_size ;jetzt isses von OBEN links
           ;;------------------> Position für Surfit und Examineit:
            xpos = BaseOffset(0)+10+data.tvinfo.x0+col*data.tvinfo.subxsize-ViewPos(0)
            ypos = BaseOffset(1)+20+data.tvinfo.y00+row*data.tvinfo.subysize-ViewPos(1)
            ;;--------------------------------
            ;;------------------> Position und Größe für Magnify:
            If data.projective then begin
               xmsize = data.magnify*(1+DWDim(data.dw, /TW))*1.25
               ymsize = data.magnify*(1+DWDim(data.dw, /TH))*1.25
            endif else begin
               xmsize = data.magnify*(1+DWDim(data.dw, /SW))*1.25
               ymsize = data.magnify*(1+DWDim(data.dw, /SH))*1.25
            endelse
            xmpos = data.tvinfo.x0+(col+0.5)*data.tvinfo.subxsize-ViewPos(0)-xmsize/2
            ympos = data.tvinfo.y00+(row+0.5)*data.tvinfo.subysize-ViewPos(1)-ymsize/2
             ;;--------------------------------
            ;;------------------> Untermatrix auslesen:
            If data.projective then begin ;Projective
               If data.delay then begin ;Delays
                  title="Projective Delay-Field of Source-Neuron ("+str(row)+","+str(col)+")"
                  w = (Delays(data.dw, /DIMENSIONS))(*, *, row, col)
                  If data.colorscaling eq 0 then $ ;global ColorScaling
                   tv_w = (ShowWeights_Scale(Delays(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(*, *, row, col) 
               endif else begin ;Weights
                  title="Projective Weight-Field of Source-Neuron ("+str(row)+","+str(col)+")"
                  w = (Weights(data.dw, /DIMENSIONS))(*, *, row, col)
                  If data.colorscaling eq 0 then $ ;global ColorScaling
                   tv_w = (ShowWeights_Scale(Weights(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(*, *, row, col) 
               endelse
            endif else begin    ;Receptive
               If data.delay then begin ;Delays
                  title="Receptive Delay-Field of Target-Neuron ("+str(row)+","+str(col)+")"
                  w = (Delays(data.dw, /DIMENSIONS))(row, col, *, *)
                  If data.colorscaling eq 0 then $ ;global ColorScaling
                   tv_w = (ShowWeights_Scale(Delays(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(row, col, *, *) 
               endif else begin ;Weights
                  title="Receptive Weight-Field of Target-Neuron ("+str(row)+","+str(col)+")"
                  w = (Weights(data.dw, /DIMENSIONS))(row, col, *, *)
                  If data.colorscaling eq 0 then $ ;global ColorScaling
                   tv_w = (ShowWeights_Scale(Weights(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(row, col, *, *) 
               endelse
            endelse
            If data.colorscaling eq 1 then $ ;individual Colorscaling
             tv_w = ShowWeights_Scale(w, COLORMODE=data.colormode)
           ;;--------------------------------

            If (Event.Press and 1) eq 1 then begin ;Left Mouse Button
               mag = Widget_Draw(data.drawbase, $
                                 XOFFSET=xmpos, $
                                 YOFFSET=ympos, $
                                 XSIZE=xmsize, YSIZE=ymsize, $
                                 FRAME=3)
;               nasetv, tv_w, ZOOM=data.magnify
               PrepareNASEPlot, (size(reform(w, /OVERWRITE)))(1), (size(reform(w, /OVERWRITE)))(2), /OFFSET, GET_OLD=oldplot
               plot, indgen(10), /NODATA, POSITION=[0.1, 0.1, 0.9, 0.9]
               nxpixelgr = (convert_coord(data.magnify, 0, 0, /DEVICE, /TO_NORMAL))(0)
               nypixelgr = (convert_coord(0, data.magnify, 0, /DEVICE, /TO_NORMAL))(1)
               NaseTv, tv_w, 0.1+nxpixelgr/2., 0.1+nypixelgr/2., ZOOM=data.magnify
               PrepareNASEPlot, Restore_old=oldplot
            Endif               ;Left Button
            
            If (Event.Press and 2) eq 2 then begin ;Middle Mouse Button
                  Surfit, xpos=xpos, ypos=ypos, xsize=300, ysize=300, /NASE, w, $
                   GROUP=Event.Top, TITLE=title, /JUST_REG
            Endif               ;Middle Button

            If (Event.Press and 4) eq 4 then begin ;Right Mouse Button
                  ExamineIt, xpos=xpos, ypos=ypos, /NASE, TITLE=title, $
                   GROUP=Event.Top, w, tv_w, ZOOM=data.magnify, /JUST_REG
            Endif               ;Middle Button

         endif                  ;Button Press
         !TOPCOLOR = data.old_TopColor
      end                       ;WIDGET_DRAW event
      else: message, /INFO, "I don't know this Event!"
   endcase
END 


PRO TomWaits, GROUP=Group, $
              DW, titel=TITEL, TITLE=title, groesse=GROESSE, ZOOM=zoom, $
              GET_BASE=get_base, $
              FROMS=froms,  TOS=tos, DELAYS=delay, $
              PROJECTIVE=projective, RECEPTIVE=receptive, $
              COLORSCALING=colorscaling, $
              GET_MAXCOL=get_maxcol, GET_COLORMODE=get_colormode, $
              JUST_REG=just_reg

  Default, GROUP, 0
  Default, TITLE, TITEL
  Default, TITLE, "Tom Waits"
  Default, ZOOM, GROESSE       ;Die Schlüsselworte können alternativ verwendet werden.
  Default, ZOOM, 1
  device, Get_screen_size=MAXSIZE ;Wußte früher nicht, daß es diese Funktion gibt, sorry...
  Default, PROJECTIVE, FROMS   ;Können alternativ benutzt werden.
  Default, RECEPTIVE, TOS
  Default, PROJECTIVE, 0
  Default, RECEPTIVE, 1-PROJECTIVE               ;By Default show Receptive Fields
  Default, Delay, 0
  Default, GET_MAXCOL, -99
  Default, GET_COLORMODE, -99

  Default, MAGNIFY, 15
  Default, COLORSCALING, 1;individual Colorscaling

  ;;------------------> Größe des Draw-Widgets:
  xsize = DWDim(DW, /SW)*DWDim(DW, /TW)*zoom
  ysize = DWDim(DW, /SH)*DWDim(DW, /TH)*zoom
  xsize = xsize+max([DWDim(DW, /TW), DWDim(DW, /SW)])
  ysize = ysize+max([DWDim(DW, /TH), DWDim(DW, /SH)])

  ;;------------------> Richtige Ausmaße für ?SIZE,?_SCROLL_SIZE bestimmen (knifflig!)
  x_scroll_size = xsize-27      ;27 Pixel sind sonst für Rollbalken vorgesehen!
  y_scroll_size = ysize-27

  x_else = 42+2*7+2*10          ;pixel, die nicht vom draw-Widget eingenommen werden: 42 Fensterrand,2*7 Rahmen, 2*10 XPAD
  y_else = 42+4*10+3*53         ;42 Fensterrand,2*7 Rahmen, 4*10 XPAD und SPACE,3*53 Knopfhöhe

  yscroll = 0;Merken, ob Ausschnitt in y-Richtung voll sichtbar (nur für Positionsbestimmung später...)
  If ((xsize+x_else) gt maxsize(0)) and ((ysize+y_else) gt maxsize(1)) then begin
     yscroll = 1
     x_scroll_size = maxsize(0)-x_else
     y_scroll_size = maxsize(1)-y_else
  Endif else begin
     if (xsize+x_else) gt maxsize(0) then begin
        x_scroll_size = maxsize(0)-x_else
        y_scroll_size = ysize
     endif
     If (ysize+y_else) gt maxsize(1) then begin
        yscroll = 1
        y_scroll_size = maxsize(1)-y_else
        x_scroll_size = xsize
     endif
  endelse
  ;;--------------------------------
  ;;--------------------------------


If fix(!VERSION.Release) lt 4 then $ ;IDL 3.6-Version:
 Base = WIDGET_BASE(GROUP_LEADER=Group, $
                    /COLUMN, $
                    XPAD=10, $
                    YPAD=10, $
                    MAP=1, $
                    TITLE=title) $ ;UVALUE wird unten gesetzt!
else $;höhere IDL-Versionen kennen BASE_ALIGN:
 Base = WIDGET_BASE(GROUP_LEADER=Group, $
                    /COLUMN, /BASE_ALIGN_CENTER, $
                    XPAD=10, $
                    YPAD=10, $
                    MAP=1, $
                    TITLE=title) ;UVALUE wird unten gesetzt!

  DrawBase = WIDGET_BASE(Base, Frame=0)
  Draw = WIDGET_DRAW( DrawBase, $
                      BUTTON_EVENTS=1, $
                      FRAME=7, $
                      RETAIN=1, $
                      XSIZE=xsize, $ ;virtuelle größe
                      YSIZE=ysize, $
                      X_SCROLL_SIZE=x_scroll_size, $;sichtbare größe
                      Y_SCROLL_SIZE=y_scroll_size)

If fix(!VERSION.Release) lt 4 then begin ;IDL 3.6-Version:
   Base_Buttons = WIDGET_BASE(Base, /COLUMN, SPACE=10)
   Base_Buttons_Mode = WIDGET_BASE(FRAME=4, Base_Buttons, /ROW, SPACE=10)
Endif else begin                ;höhere IDL-Versionen kennen BASE_ALIGN:
   Base_Buttons = WIDGET_BASE(Base, /COLUMN, /BASE_ALIGN_CENTER, SPACE=10)
   Base_Buttons_Mode = WIDGET_BASE(FRAME=4, Base_Buttons, /ROW, /BASE_ALIGN_CENTER, SPACE=10)
endelse
  Base_Buttons_Do   = WIDGET_BASE(Base_Buttons, /ROW, SPACE=50)
  Base_Buttons_Left  = WIDGET_BASE(Base_Buttons_Mode, /COLUMN, /EXCLUSIVE)
  Base_Buttons_Mid   = WIDGET_BASE(Base_Buttons_Mode, /COLUMN, /EXCLUSIVE)
  Base_Buttons_Right = WIDGET_BASE(Base_Buttons_Mode, /COLUMN, /EXCLUSIVE)

  Button_Projective = WIDGET_BUTTON( Base_Buttons_Left, $
                               FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
                               UVALUE={info: 'TOMWAITS_PROJECTIVE'}, $
                               VALUE='Projective Fields', $
                               XSIZE=170, /NO_RELEASE)

  Button_Receptive = WIDGET_BUTTON( Base_Buttons_Right, $
                              FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
                              UVALUE={info: 'TOMWAITS_RECEPTIVE', id_other: Button_Projective}, $
                              VALUE='Receptive Fields', $
                              XSIZE=170, /NO_RELEASE)
  Widget_Control, Button_Projective, SET_UVALUE={info: 'TOMWAITS_PROJECTIVE', id_other: Button_Receptive}

  Button_Print = WIDGET_BUTTON( Base_Buttons_Do, $
                                FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
                                UVALUE={info: 'TOMWAITS_PRINT'}, $
                                VALUE='Print It!', $
                                XSIZE=150)
  
  Button_Done = WIDGET_BUTTON( Base_Buttons_Do, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE={info: 'TOMWAITS_DONE'}, $
      VALUE='Buzz Off!', $
      XSIZE=150)

  Button_Weights = WIDGET_BUTTON( Base_Buttons_Mid, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE={info: 'TOMWAITS_WEIGHTS'}, $
      VALUE='Weights', $
      XSIZE=100, /NO_RELEASE)

  Button_Delays = WIDGET_BUTTON( Base_Buttons_Mid, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE={info: 'TOMWAITS_DELAYS'}, $
      VALUE='Delays', $
      XSIZE=100, /NO_RELEASE)

      If not contains(info(DW), "DELAY") then Widget_Control, Button_Delays, SENSITIVE=0
      If Keyword_Set(DELAY) then Widget_Control, Button_Delays, SET_BUTTON=1 else Widget_Control, Button_Weights, SET_BUTTON=1
      If Keyword_Set(PROJECTIVE) then Widget_Control, Button_Projective, SET_BUTTON=1 else Widget_Control, Button_Receptive, SET_BUTTON=1
      Widget_Control, Button_Print, SENSITIVE=0


  WIDGET_CONTROL, Base, /REALIZE

  ; Get drawable window index

  WIDGET_CONTROL, Draw, GET_VALUE=DrawId

  get_colors = 0
  tvinfo = 0
  get_colormode = 0
  get_maxcol = 0

  ShowWeights, DW, ZOOM=zoom, WINNR=DrawId, PROJECTIVE=projective, RECEPTIVE=receptive, DELAYS=delay, GET_MAXCOL=get_maxcol, GET_COLORMODE=get_colormode, $
   GET_INFO=tvinfo, GET_COLORS=get_colors

  old_TopColor = !TOPCOLOR

  Widget_Control, Base, SET_UVALUE={info    : 'TOMWAITS_BASE', $
                                    DW : DW, $ ;EinHandle...
                                    win: DrawId, $ ; Die Fensternummer des Draw-Widgets
                                    xsize: xsize, ysize: ysize, $ ;Die virtuelle Größe
                                    x_scroll_size: x_scroll_size, y_scroll_size: y_scroll_size, $ ;Die sichtbare Größe
                                    yscroll: yscroll, $
                                    DrawBase: DrawBase, $ ;Base des Draw-Widgets
                                    zoom: zoom, $
                                    projective: projective, $
                                    receptive: receptive, $
                                    delay: delay, $
                                    colormode: get_colormode, $
                                    magnify: magnify, $
                                    tvinfo: tvinfo, $
                                    colors:get_colors, $
                                    old_TopColor:old_TopColor, $
                                    my_TopColor: get_colors(4), $ ;preserve ShowWeights-Colors
                                    colorscaling: colorscaling}

  If fix(!VERSION.Release) ge 5 then XMANAGER, 'TomWaits', Base, /NO_BLOCK, JUST_REG=just_reg $
  else XMANAGER, 'TomWaits', Base, JUST_REG=just_reg
END
