PRO TomWaits_Event, Event

   EventType = Tag_Names(Event, /STRUCTURE_NAME)

   Widget_Control, Event.Id, GET_UVALUE=uval
   Widget_Control, Event.Top, GET_UVALUE=data
   
   Case EventType of
      'WIDGET_BUTTON': begin
         Case uval.info of
            'TOMWAITS_WEIGHTS': begin
               data.delay = 0
               ShowWeights, data.DW, ZOOM=data.zoom, WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode
               data.colormode = get_colormode
            end
            'TOMWAITS_DELAYS': begin
               data.delay = 1
               ShowWeights, data.DW, /DELAYS, ZOOM=data.zoom, WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode
               data.colormode = get_colormode
            end
            'TOMWAITS_PROJECTIVE': begin
               Widget_Control, uval.id_other, SET_BUTTON=0 ;explizit machen, da sie nicht in der gleichen Base sind!
               data.projective = 1
               data.receptive  = 0
               ShowWeights, data.DW, DELAYS=data.delay, ZOOM=data.zoom, WINNR=data.win, /PROJECTIVE
            end
            'TOMWAITS_RECEPTIVE': begin
               Widget_Control, uval.id_other, SET_BUTTON=0
               data.projective = 0
               data.receptive  = 1
               ShowWeights, data.DW, DELAYS=data.delay, ZOOM=data.zoom, WINNR=data.win, /RECEPTIVE
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
         If Event.Type eq 0 then begin ;Mouse Button Press
;            If (Event.Press and 1) eq 1 then begin ;Left Mouse Button
;               print, event.clicks
;               If data.projective then begin
;                  col = Event.X/(DWDim(data.DW, /SW)*data.zoom+1)
;                  row = Event.Y/(DWDim(data.DW, /SH)*data.zoom+1)
;                  mag = Widget_Draw(Event.Top, $
;                                    XOFFSET=col*DWDim(data.DW, /SW), $
;                                    YOFFSET=row*DWDim(data.DW, /SH))
;                  W = ShowWeights_Scale(Weights(data.DW, /DIMENSIONS))
;                  nasetv, W(row, col, *, *), ZOOM=data.magnify
;               Endif 
;                                ;Cursor, dummy, dummy, 4 ;Wait for Button up
;               Widget_Control, mag, /DESTROY
;            Endif               ;Left Button
            
            If (Event.Press and 2) eq 2 then begin ;Middle Mouse Button
               If data.projective then begin
                  col = Event.X/(DWDim(data.DW, /SW)*data.zoom+1)
                  row = DWDim(data.DW, /SH)-1-Event.Y/(DWDim(data.DW, /SH)*data.zoom+1)
                  print,  row, col
                  Surfit, /NASE, TITLE="Projective Field of Source-Neuron ("+str(row)+","+str(col)+")", $
                   GROUP=Event.Top, (Weights(data.dw, /DIMENSIONS))(row, col, *, *), /JUST_REG
               Endif
               If data.receptive then begin
                  col = Event.X/(DWDim(data.DW, /TW)*data.zoom+1)
                  row = DWDim(data.DW, /TH)-1-Event.Y/(DWDim(data.DW, /TH)*data.zoom+1)
                  Surfit, /NASE, TITLE="Receptive Field of Target-Neuron ("+str(row)+","+str(col)+")", $
                   GROUP=Event.Top, (Weights(data.dw, /DIMENSIONS))(*, *, row, col), /JUST_REG
               Endif
            Endif               ;Middle Button

            If (Event.Press and 4) eq 4 then begin ;Right Mouse Button
               If data.projective then begin
                  col = Event.X/(DWDim(data.DW, /SW)*data.zoom+1)
                  row = DWDim(data.DW, /SH)-1-Event.Y/(DWDim(data.DW, /SH)*data.zoom+1)
                  ExamineIt, GROUP=Event.Top, reform(/OVERWRITE, (Weights(data.dw, /DIMENSIONS))(row, col, *, *)), ZOOM=data.magnify, /JUST_REG
               Endif
               If data.receptive then begin
                  col = Event.X/(DWDim(data.DW, /TW)*data.zoom+1)
                  row = DWDim(data.DW, /TH)-1-Event.Y/(DWDim(data.DW, /TH)*data.zoom+1)
                  ExamineIt, GROUP=Event.Top, (Weights(data.dw, /DIMENSIONS))(*, *, row, col), ZOOM=data.magnify, /JUST_REG
               Endif
            Endif               ;Middle Button

         endif                  ;Button Press
      end                       ;WIDGET_DRAW event
      else: message, /INFO, "I don't know this Event!"
   endcase
END 


PRO TomWaits, GROUP=Group, $
              DW, titel=TITEL, TITLE=title, groesse=GROESSE, ZOOM=zoom, $
              GET_BASE=get_base, $
              FROMS=froms,  TOS=tos, DELAYS=delay, $
              PROJECTIVE=projective, RECEPTIVE=receptive, $
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

  Default, MAGNIFY, 10

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

  If ((xsize+x_else) gt maxsize(0)) and ((ysize+y_else) gt maxsize(1)) then begin
     x_scroll_size = maxsize(0)-x_else
     y_scroll_size = maxsize(1)-y_else
  Endif else begin
     if (xsize+x_else) gt maxsize(0) then begin
        x_scroll_size = maxsize(0)-x_else
        y_scroll_size = ysize
     endif
     If (ysize+y_else) gt maxsize(1) then begin
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

  Draw = WIDGET_DRAW( Base, $
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

  ShowWeights, DW, ZOOM=zoom, WINNR=DrawId, PROJECTIVE=projective, RECEPTIVE=receptive, DELAYS=delay, GET_MAXCOL=get_maxcol, GET_COLORMODE=get_colormode

  Widget_Control, Base, SET_UVALUE={info    : 'TOMWAITS_BASE', $
                                    DW : DW, $ ;EinHandle...
                                    win: DrawId, $ ; Die Fensternummer des Draw-Widgets
                                    zoom: zoom, $
                                    projective: projective, $
                                    receptive: receptive, $
                                    delay: delay, $
                                    colormode: get_colormode, $
                                    magnify: magnify}

  If fix(!VERSION.Release) ge 5 then XMANAGER, 'TomWaits', Base, /NO_BLOCK, JUST_REG=just_reg $
  else XMANAGER, 'TomWaits', Base, JUST_REG=just_reg
END
