;+
; NAME: TomWaits
;
; AIM: Interactively investigate contents of a DW matrix.
;
; PURPOSE: Interaktive Darstellung einer NASE-DW-Matrix.
;
; CATEGORY: Graphic, NASE, Widgets
;
; CALLING SEQUENCE: TomWaits, DW [,/DELAYS] [,/EFFICACY] 
;                             [,(/FROMS|/PROJECTIVE) | ,(/TOS|/RECEPTIVE)]
;                             [,(TITEL|TITLE)=Fenstertitel]
;                             [,(GROESSE|ZOOM)=ZFaktor] [,MAGNIFY=MFaktor]
;                             [,/COLORSCALING] [,/MAGINWIN]
;                             [,GET_MAXCOL=weiß]
;                             [,GROUP=GroupLeader] [,GET_BASE=BaseID]
;                             [,/JUST_REG] [,NO_BLOCK=0]
;
; INPUTS: DW: Eine NASE DW- oder SDW-Struktur, mit oder ohne Delays.
;
; KEYWORD PARAMETERS: TITEL/TITLE  : Ein Fenstertitel für's Widget
;                    GROESSE/ZOOM  : Vergrößerungsfaktor für die
;                                    Darstellung mit ShowWeights (darf
;                                    gebrochen sein)
;                                    Default: 1
;                         MAGNIFY  : Vergrößerungsfaktor für die
;                                    Magnify-Option (linke Maustaste)
;                                    Default: 12
;                    COLORSCALING  : Wenn gesetzt (Default), wird für
;                                    Magnify und Examineit
;                                    individuelles ColorScaling
;                                    verwendet, d.h. das größte
;                                    Gewicht jedes einzelnen
;                                    rezeptiven Feldes erscheint weiß
;                                    in der Vergrößerung. Wird
;                                    COLORSCALING explizit auf 0
;                                    gesetzt, so sind die Farben genau 
;                                    wie bei ShowWeights auf das
;                                    Maximum der gesamten
;                                    Verbindungsmatrix normiert.
;                        MAGINWIN  : Wenn gesetzt, wird für die
;                                    Magnify-Option ein Fenster
;                                    verwendet, sonst ein Draw-Widget.
;                                    Dieses Schlüsselwort wird unter
;                                    IDL 3 stets als gesetzt
;                                    betrachtet (Weil die
;                                    DrawWidget-Variante nicht
;                                    funktioniert)
;                            GROUP : Ein GroupLeader für unser Widget.
;                         JUST_REG : s. XMANAGER-Hilfe. Default 0
;                         NO_BLOCK : ab
;                                    IDL_5. s. XMANAGER-Hilfe. Default 1
;                         EFFICACY : start mit der anzeige der 'syn. efficacies' u_se 
;                 
;
; OPTIONAL OUTPUTS:    GET_MAXCO  : Index der hellsten Farbe ("weiß")
;                        GET_BASE : ID des Base-Widgets
;
; SIDE EFFECTS: Farbrtabelle wird verändert.
;
; PROCEDURE: Basiert auf <A HREF="#SHOWWEIGHTS">ShowWeights</A>, <A HREF="nonase/#SURFIT">Surfit</A>, <A HREF="nonase/#EXAMINEIT">Examineit</A>.
;
; EXAMPLE: Ausprobieren!
;
; SEE ALSO: <A HREF="#SHOWWEIGHTS">ShowWeights</A>, <A HREF="nonase/#SURFIT">Surfit</A>, <A HREF="nonase/#EXAMINEIT">Examineit</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.18  2001/01/24 13:59:42  kupper
;        Oops! Was still using greyscale-PS for grey images. Shall not be used
;        any more!
;
;        Revision 1.17  2001/01/22 19:31:51  kupper
;        Removed !PSGREY and !REVERTPSCOLORS handling, as greyscale PostScripts
;        shall not be used any longer (according to colormanagement guidelines
;        formed during first NASE workshop, fall 2000).
;
;        Revision 1.16  2000/10/01 14:51:09  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.15  2000/09/07 10:30:48  kupper
;        Added hourglass at longer operations.
;
;        Revision 1.14  2000/09/01 12:57:39  kupper
;        Added hourglass cursor during SHowweights call.
;
;        Revision 1.13  1999/11/26 14:08:59  alshaikh
;              bugfix
;
;        Revision 1.12  1999/11/17 09:51:01  alshaikh
;              fehler beim umschalten zwischen weights und efficacy
;              berichtigt...
;
;        Revision 1.11  1999/11/16 15:14:44  alshaikh
;              kann jetzt auch Transmitterfreisetzungswarscheinlichkeiten
;              (U_se) darstellen...
;
;        Revision 1.10  1998/04/16 16:53:22  kupper
;               Der Print-Knopf geht jetzt.
;        	Erzeugt zwar nur ein Standard-File mit Namen "TomWaits_Printed_Output" aber immerhin...
;
;        Revision 1.9  1998/04/08 16:30:17  kupper
;               Beta 2
;        	Sorry, hatte bisher keinen Header...
;
;-

PRO TomWaits_Event, Event

   EventType = Tag_Names(Event, /STRUCTURE_NAME)

   Widget_Control, Event.Id, GET_UVALUE=uval
   Widget_Control, Event.Top, GET_UVALUE=data
   
   Case EventType of
      'WIDGET_BUTTON': begin
         Case uval.info of
            'TOMWAITS_WEIGHTS': begin
               data.delay = 0
               data.uses = 0
               ShowWeights, data.DW, ZOOM=data.zoom, WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode, GET_INFO=get_info, GET_COLORS=get_colors
               data.colormode = get_colormode
               data.tvinfo = get_info
               data.colors = get_colors
;               data.my_TopColor = get_colors(4)
            end

            'TOMWAITS_USES': begin
               data.delay = 0
               data.uses = 1
               ShowWeights, data.DW, ZOOM=data.zoom, /EFFICACY,WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode, GET_INFO=get_info, GET_COLORS=get_colors
               data.colormode = get_colormode
               data.tvinfo = get_info
               data.colors = get_colors
;               data.my_TopColor = get_colors(4)
            end


            'TOMWAITS_DELAYS': begin
               data.delay = 1
               data.uses = 0
               ShowWeights, data.DW, /DELAYS, ZOOM=data.zoom, WINNR=data.win, PROJECTIVE=data.projective, RECEPTIVE=data.receptive, GET_COLORMODE=get_colormode, GET_INFO=get_info, GET_COLORS=get_colors
               data.colormode = get_colormode
               data.tvinfo = get_info
               data.colors = get_colors
;               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_PROJECTIVE': begin
               Widget_Control, uval.id_other, SET_BUTTON=0 ;explizit machen, da sie nicht in der gleichen Base sind!
               data.projective = 1
               data.receptive  = 0
               ShowWeights, data.DW, DELAYS=data.delay, EFFICACY=data.uses,ZOOM=data.zoom, WINNR=data.win, /PROJECTIVE, GET_INFO=get_info, GET_COLORS=get_colors
               data.tvinfo = get_info
               data.colors = get_colors
;               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_RECEPTIVE': begin
               Widget_Control, uval.id_other, SET_BUTTON=0
               data.projective = 0
               data.receptive  = 1
               ShowWeights, data.DW, DELAYS=data.delay, EFFICACY=data.uses, ZOOM=data.zoom, WINNR=data.win, /RECEPTIVE, GET_INFO=get_info, GET_COLORS=get_colors
               data.tvinfo = get_info
               data.colors = get_colors
;               data.my_TopColor = get_colors(4)
            end
            'TOMWAITS_PRINT': begin
               ;message, /INFO, "Print-Event not yet implemented!"
;               oldtopcolor = !TOPCOLOR
               If data.colormode eq -1 then color = 1 else color = 0
;               If color then !TOPCOLOR = !D.Table_Size-1 ;use full color range!
               s1 = DefineSheet(/PS, XSIZE=15, YSIZE=15, BITS_PER_PIXEL=8, FILENAME="TomWaits_printed_Output")
               OpenSheet, s1
               ShowWeights, /NOWIN, PRINTSTYLE=1-color, data.DW, DELAYS=data.delay, ZOOM=data.zoom, RECEPTIVE=data.receptive, PROJECTIVE=data.projective
               CloseSheet, s1
               s2 = DefineSheet(/PS, /ENCAPS, XSIZE=15, YSIZE=15, BITS_PER_PIXEL=8, FILENAME="TomWaits_printed_Output")
               OpenSheet, s2
               ShowWeights, /NOWIN, PRINTSTYLE=1-color, data.DW, DELAYS=data.delay, ZOOM=data.zoom, RECEPTIVE=data.receptive, PROJECTIVE=data.projective
               CloseSheet, s2
;               !TOPCOLOR = oldtopcolor
               print, "--->   Output saved to File 'TomWaits_printed_Output'."
               ;DestroySheet, s
            end
            'TOMWAITS_DONE': begin
               Widget_Control, Event.Top, /DESTROY
               return
            end
            else: message, /INFO, "I don't know this Button!"
         endcase
      end
      
      'WIDGET_DRAW': begin   
;         !TopColor = data.my_TopColor
         If Event.Type eq 1 then begin ;Mouse Button Release
            If (Event.Release and 1) eq 1 then begin ;Left Button
               If not data.maginwin then begin ;IDL 4 oder höher
                  mag = Widget_Info(Event.ID, /SIBLING)
                  If mag ne 0 then Widget_Control, mag, /DESTROY 
               Endif else begin ;IDL 3
                  If !D.Window eq data.magwin then Wdelete
               endelse
            endif
         Endif                  ;Mouse Button Release

         If Event.Type eq 0 then begin ;Mouse Button Press
            ;;This might take a while, so display hourglass:
            Widget_Control, /Hourglass
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
            xpos = BaseOffset(0)+18+data.tvinfo.x0+col*data.tvinfo.subxsize-ViewPos(0)
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
                  w = reform(/OverWrite, w, DwDim(data.dw, /TH), DwDim(data.dw, /TW))
                  If data.colorscaling eq 0 then begin ;global ColorScaling
                     tv_w = (ShowWeights_Scale(Delays(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(*, *, row, col) 
                     tv_w = reform(/OverWrite, tv_w, DwDim(data.dw, /TH), DwDim(data.dw, /TW))
                  ENDIF

               END ELSE IF data.uses THEN BEGIN ; synaptic efficacies
                  title="Projective Efficacy-Field of Source-Neuron ("+str(row)+","+str(col)+")"
                  w = (Use(data.dw, /DIMENSIONS))(*, *, row, col)
                  w = reform(/OverWrite, w, DwDim(data.dw, /TH), DwDim(data.dw, /TW))
                  If data.colorscaling eq 0 then begin ;global ColorScaling
                     tv_w = (ShowWeights_Scale(Use(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(*, *, row, col) 
                     tv_w = reform(/OverWrite, tv_w, DwDim(data.dw, /TH), DwDim(data.dw, /TW))
                  ENDIF
                  
               endif else begin ;Weights
                  title="Projective Weight-Field of Source-Neuron ("+str(row)+","+str(col)+")"
                  w = (Weights(data.dw, /DIMENSIONS))(*, *, row, col)
                  w = reform(/OverWrite, w, DwDim(data.dw, /TH), DwDim(data.dw, /TW))
                  If data.colorscaling eq 0 then begin ;global ColorScaling
                     tv_w = (ShowWeights_Scale(Weights(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(*, *, row, col) 
                     tv_w = reform(/OverWrite, tv_w, DwDim(data.dw, /TH), DwDim(data.dw, /TW))
                  endif
               endelse
            endif else begin    ;Receptive
               If data.delay then begin ;Delays
                  title="Receptive Delay-Field of Target-Neuron ("+str(row)+","+str(col)+")"
                  w = (Delays(data.dw, /DIMENSIONS))(row, col, *, *)
                  w = reform(/OverWrite, w, DwDim(data.dw, /SH), DwDim(data.dw, /SW))
                  If data.colorscaling eq 0 then begin ;global ColorScaling
                     tv_w = (ShowWeights_Scale(Delays(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(row, col, *, *) 
                     tv_w = reform(/OverWrite, tv_w, DwDim(data.dw, /SH), DwDim(data.dw, /SW))
                  endif
                END ELSE IF data.uses THEN BEGIN ; synaptic efficacies
                   title="Receptive Efficacy-Field of Target-Neuron ("+str(row)+","+str(col)+")"
                   w = (Use(data.dw, /DIMENSIONS))(row, col, *, *)
                   w = reform(/OverWrite, w, DwDim(data.dw, /SH), DwDim(data.dw, /SW))
                   If data.colorscaling eq 0 then begin ;global ColorScaling
                   tv_w = (ShowWeights_Scale(Use(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(row, col, *, *) 
                   tv_w = reform(/OverWrite, tv_w, DwDim(data.dw, /SH), DwDim(data.dw, /SW))
                   ENDIF

              end else begin ;Weights
                  title="Receptive Weight-Field of Target-Neuron ("+str(row)+","+str(col)+")"
                  w = (Weights(data.dw, /DIMENSIONS))(row, col, *, *)
                  w = reform(/OverWrite, w, DwDim(data.dw, /SH), DwDim(data.dw, /SW))
                  If data.colorscaling eq 0 then begin ;global ColorScaling
                   tv_w = (ShowWeights_Scale(Weights(data.dw, /DIMENSIONS), COLORMODE=data.colormode))(row, col, *, *) 
                   tv_w = reform(/OverWrite, tv_w, DwDim(data.dw, /SH), DwDim(data.dw, /SW))
                endif
               endelse
            endelse
            If data.colorscaling eq 1 then $ ;individual Colorscaling
             tv_w = ShowWeights_Scale(w, COLORMODE=data.colormode)
             tv_w = reform(/OverWrite, tv_w, (size(w))(1), (size(w))(2))
           ;;--------------------------------

            If (Event.Press and 1) eq 1 then begin ;Left Mouse Button
               If not data.maginwin then begin 
                  mag = Widget_Draw(data.drawbase, $
                                    XOFFSET=xmpos, $
                                    YOFFSET=ympos, $
                                    XSIZE=xmsize, YSIZE=ymsize, $
                                    FRAME=3)
                  Endif else begin
                     DEVICE, GET_SCREEN_SIZE=ss
                     winxpos = xpos-xmsize/2+data.tvinfo.subxsize/2
                     winypos = ss(1)-ypos-ymsize/2+data.tvinfo.subysize/2
                     Window, XPOS=winxpos, YPOS=winypos, /FREE, XSIZE=xmsize, YSIZE=ymsize, TITLE=title
                     data.magwin = !D.WINDOW
                  endelse
;               nasetv, tv_w, ZOOM=data.magnify
                  uheight = (size(w))(1)
                  uwidth = (size(w))(2)
               PrepareNASEPlot, uheight, uwidth, /OFFSET, GET_OLD=oldplot
               plot, indgen(10), /NODATA, COLOR=data.colors(2), XTHICK=2, YTHICK=2, POSITION=[0.1, 0.1, 0.9, 0.9]
               nxpixelgr = (convert_coord(data.magnify, 0, 0, /DEVICE, /TO_NORMAL))(0)
               nypixelgr = (convert_coord(0, data.magnify, 0, /DEVICE, /TO_NORMAL))(1)
               NaseTv, tv_w, 0.1+nxpixelgr/2., 0.1+nypixelgr/2., ZOOM=data.magnify
               PrepareNASEPlot, Restore_old=oldplot
            Endif               ;Left Button
            
            If (Event.Press and 2) eq 2 then begin ;Middle Mouse Button
                  Surfit, COLOR=data.colors(2), xpos=xpos, ypos=ypos, xsize=300, ysize=300, /NASE, w, $
                   GROUP=Event.Top, TITLE=title, /JUST_REG
            Endif               ;Middle Button

            If (Event.Press and 4) eq 4 then begin ;Right Mouse Button
                  ExamineIt, COLOR=data.colors(2), xpos=xpos, ypos=ypos, /NASE, /BOUND, TITLE=title, $
                   GROUP=Event.Top, w, tv_w, ZOOM=data.magnify, /JUST_REG
            Endif               ;Middle Button

         endif                  ;Button Press
;         !TOPCOLOR = data.old_TopColor
      end                       ;WIDGET_DRAW event
      else: message, /INFO, "I don't know this Event!"
   endcase
   Widget_Control, Event.Top, SET_UVALUE=data
END 


PRO TomWaits, GROUP=Group, $
              DW, titel=TITEL, TITLE=title, groesse=GROESSE, ZOOM=zoom, $
              GET_BASE=get_base, $
              FROMS=froms,  TOS=tos, DELAYS=delay, EFFICACY=Uses,$
              PROJECTIVE=projective, RECEPTIVE=receptive, $
              MAGNIFY=magnify, $
              COLORSCALING=colorscaling, MAGINWIN=maginwin, $
              GET_MAXCOL=get_maxcol, $
              JUST_REG=just_reg, NO_BLOCK=no_block

  Default, GROUP, 0
  Default, JUST_REG, 0
  Default, NO_BLOCK, 1
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
  Default, Uses,0
  Default, GET_MAXCOL, -99

  Default, MAGNIFY, 12
  Default, COLORSCALING, 1;individual Colorscaling
  If fix(!VERSION.Release) le 3 then maginwin = 1 else Default, maginwin, 0


  ;;------------------> Größe des Draw-Widgets:
  xsize = DWDim(DW, /SW)*DWDim(DW, /TW)*zoom
  ysize = DWDim(DW, /SH)*DWDim(DW, /TH)*zoom
  xsize = xsize+max([DWDim(DW, /TW), DWDim(DW, /SW)])
  ysize = ysize+max([DWDim(DW, /TH), DWDim(DW, /SH)])
  xsize = xsize+50
  ysize = ysize+50              ;erschlägt so ungefähr den Plot-Rand
  ;;------------------> Richtige Ausmaße für ?SIZE,?_SCROLL_SIZE bestimmen (knifflig!)
  x_scroll_size = xsize-27      ;27 Pixel sind sonst für Rollbalken vorgesehen!
  y_scroll_size = ysize-27

  x_else = 42+2*7+2*10          ;pixel, die nicht vom draw-Widget eingenommen werden: 42 Fensterrand,2*7 Rahmen, 2*10 XPAD
  y_else = 42+4*10+3*53+47         ;42 Fensterrand,2*7 Rahmen, 4*10 XPAD und SPACE,3*53 Knopfhöhe,47 Labelwidget

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
                    TITLE=title, $
                    MBAR=MenuBar) ;UVALUE wird unten gesetzt!

  Text = Widget_Label(Base, FONT='-adobe-helvetica-bold-r-normal--14-140-75-75-p-77-iso8859-1', $
                     FRAME=2, $;XSIZE=55, $
                     VALUE="Left Button: Magnify    Middle Button: SurfIt!    Right Button: ExamineIt!")

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

 Button_Uses = WIDGET_BUTTON( Base_Buttons_Mid, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE={info: 'TOMWAITS_USES'}, $
      VALUE='Efficacy', $
      XSIZE=100, /NO_RELEASE)


  Button_Delays = WIDGET_BUTTON( Base_Buttons_Mid, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE={info: 'TOMWAITS_DELAYS'}, $
      VALUE='Delays', $
      XSIZE=100, /NO_RELEASE)

Handle_Value, DW, TEMP, /NO_COPY ; this one is just for the depression check

      If not contains(info(TEMP), "DELAY") then Widget_Control, Button_Delays, SENSITIVE=0
      If Keyword_Set(DELAY) then Widget_Control, Button_Delays, SET_BUTTON=1 
      IF (TEMP.depress EQ 0) THEN  Widget_Control, Button_USES, SENSITIVE=0 
      IF Keyword_Set(Uses) THEN Widget_Control, Button_USES,SET_BUTTON=1
      IF (NOT Keyword_set(DELAY) AND NOT Keyword_set(Uses)) THEN  Widget_Control, $
       Button_Weights, SET_BUTTON=1

Handle_Value, DW, TEMP, /NO_COPY,/SET

      If Keyword_Set(PROJECTIVE) then Widget_Control, Button_Projective, SET_BUTTON=1 else Widget_Control, Button_Receptive, SET_BUTTON=1


      ;;------------------> Define Menubar:
;      Mode = CW_PDMENU(/MBAR, MenuBar, FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
;                       ['1\Menu', $
;                        '2\Entry 1', $
;                        '1\Menu 2', $
;                        '0\Entry 2', $
;                        '0\Entry 23'])
      ;;--------------------------------


  WIDGET_CONTROL, Base, /REALIZE

  ; Get drawable window index

  WIDGET_CONTROL, Draw, GET_VALUE=DrawId

  get_colors = 0
  tvinfo = 0
  get_colormode = 0
  get_maxcol = 0

  ;; This showweights call  might take a long time (esp. with SDWs):
  Widget_Control, /Hourglass
  ShowWeights, DW, ZOOM=zoom, WINNR=DrawId, PROJECTIVE=projective, RECEPTIVE=receptive, EFFICACY=uses, DELAYS=delay, GET_MAXCOL=get_maxcol, GET_COLORMODE=get_colormode, $
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
                                    uses : uses, $
                                    colormode: get_colormode, $
                                    magnify: magnify, $
                                    tvinfo: tvinfo, $
                                    colors:get_colors, $
;                                    old_TopColor:old_TopColor, $
;                                    my_TopColor: get_colors(4), $ ;preserve ShowWeights-Colors
                                    colorscaling: colorscaling, $
                                    magwin:-99, $
                                    maginwin: maginwin} ;für das blöde IDL 3...

  GET_BASE = Base

  If fix(!VERSION.Release) ge 5 then XMANAGER, 'TomWaits', Base, NO_BLOCK=no_block, JUST_REG=just_reg $
  else XMANAGER, 'TomWaits', Base, JUST_REG=just_reg

END
