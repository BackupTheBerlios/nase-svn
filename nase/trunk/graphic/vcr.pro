;+
; NAME:
;  VCR
;
; VERSION:
;  $Id$
; 
; AIM:
;  Interactively display animated timesequence of one- or
;  two-dimensional array data.
;
; PURPOSE:
;  Display of a 1- or 2-dimensional sequence with
;  controls similar to those of a videoplayer (not
;  recorder!).<BR>
;  One can find a similar routine in IDL
;  (<C>CW_ANIMATE</C>, at least suitable for 2D
;  sequences). Unfortunately this routine has the following
;  disadvantages:<BR>
;  * it takes an eternity to initialize for long sequences <BR>
;  * with long sequences it is impossible to jump to particular time
;    steps <BR>
;  * if you may want to zoom it will engage a huge amount of memory 
;    <*>VCR</*> displays 2D-sequences via <A>UTV</A> (and partners),
;    for 1D-sequences it uses the <C>Plot</C> procedure.
;                    
; CATEGORY:
;  Animation
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;
; dim(seq) eq 3:
;* VCR, seq [,TITLE=...] [,DELAY=...]
;*          [,ZOOM=...] [,/SCALE], [TAUMEMO=...]
;*
; dim(seq) eq 2:
;* VCR, seq [,TITLE=...] [,DELAY=...]
;*          [,XSIZE=...] [,YSIZE=...]
;
; INPUTS:
;  seq:: either a 3d array of the form(t,x,y) or a 2d array
;        of the form (t, x) 
;
; INPUT KEYWORDS:
;  DELAY:: minimal delay between 2 frames in
;          msec, this will fix just the startvalue,
;          you can still change the
;          delay by dragging a slider while the
;          simulation is running
;  TITLE:: you may provide a title<BR>
;
;  SCALE:: Usually the whole video is scaled such
;          that one intensity of colour corresponds
;          to  one value in the array. SCALE can be used to scale
;          every single frame.
;  ZOOM :: One can enlarge the display by the chosen zoomfactor.
;  TAUMEMO :: Set this keyword to receive a decaying
;             impression of your video, corresponding to the
;             chosen value for the time constant.
;   XSIZE, YSIZE:: Determines the size of the plot
;                  (Default: 320x200).  
;
; EXAMPLE:
;* l = RANDOMU(seed,100,40,10)
;* VCR, l, ZOOM=5, DELAY=150, TITLE='TEST ME', TAUMEMO=2.0
;* l = RANDOMU(seed,2000,10)
;* VCR, l
;
;-
PRO VCR_DISPLAY, UD

   Handle_Value, UD._a, a, /NO_COPY

 oId = !D.Window
   IF UD.modus EQ 0 THEN BEGIN
      WSet, UD.pm
      !P.Multi = [0,0,1]
      plot, a(UD.t,*), YRANGE=[UD.min, UD.max]
      WSet, UD.did
      Device, COPY=[0,0,UD.xsize-1, UD.ysize, 0, 0, UD.pm]

   END ELSE BEGIN
      WSet, UD.did

      IF UD.ismemory THEN BEGIN
      faktor=EXP(-1.0/UD.taumemo)
      UD.memo= reform(a(UD.t,*,*))+faktor*UD.memo
      IgnoreUnderflows
      ENDIF ELSE BEGIN
      UD.memo= reform(a(UD.t,*,*))
      ENDELSE 

      IF UD.scale THEN BEGIN
         UTvScl, UD.memo, STRETCH=ud.zoom
      END ELSE BEGIN
         UTv, UD.memo, STRETCH=ud.zoom
      END
   END
   WSet, oId

   Handle_Value, UD._a, a, /NO_COPY, /SET

END



PRO VCR_Event, Event


  WIDGET_CONTROL,Event.Id, GET_UVALUE=Ev
  WIDGET_CONTROL, Event.Top, GET_UVALUE=ud

  
  IF Ev EQ 'LABEL44' THEN  BEGIN ;TIMER EVENT
     
     ; work out loop conditions
     IF (UD.play EQ 1) AND (UD.t EQ UD.MT-1) THEN BEGIN
        IF UD.loop EQ 1 THEN UD.t = 0 ELSE IF UD.loop EQ 2 THEN UD.play = -1
     END
     IF (UD.play EQ -1) AND (UD.t EQ 0) THEN BEGIN
        IF UD.loop EQ 1 THEN UD.t = UD.mt-1 ELSE IF UD.loop EQ 2 THEN UD.play = 1
     END

     IF ((UD.Play EQ -1) AND (UD.t GT 0)) OR ((UD.Play EQ 1) AND (UD.t LT UD.MT-1)) THEN BEGIN
        UD.t = UD.t + UD.play
        VCR_Display, UD
        Widget_Control, UD.Timer, TIMER=UD.Delay/1000.
     END ELSE UD.play = 0
  END ELSE BEGIN


     CASE Ev OF 
        
        'DRAW4': BEGIN
           Print, 'Event for DRAWAREA'
        END
        'BMPBTNPLAYBACK': BEGIN
           IF UD.Play NE -1 THEN BEGIN
              UD.Play = -1
              Widget_Control, UD.Timer, TIMER=UD.Delay/1000.
           END
        END
        'BMPBTNPLAY': BEGIN
           IF UD.Play NE 1 THEN BEGIN
              UD.play = 1
              Widget_Control, UD.Timer, TIMER=UD.Delay/1000.
           END
        END
        'BMPBTNPAUSE': BEGIN
           UD.Play = 0
        END
        'BMPBTNREWIND': BEGIN
           UD.Play = 0
           UD.t = 0
           VCR_Display, UD
        END
        'BMPBTNFASTFORWARD': BEGIN
           UD.Play = 0
           UD.t = UD.mt-1
           VCR_Display, UD
        END
        'BMPBTNEJECT': BEGIN
           UD.Play = 0
           Handle_Free, UD._A
           Widget_Control, Event.Top, /DESTROY
           return
        END
        'SLIDERDELAY': BEGIN
           Widget_Control, Event.ID, Get_VALUE=tmp
           UD.delay = LONG(tmp)
        END
        'BGROUPLOOP': BEGIN
           CASE Event.Value OF
              0: UD.loop = 0
              1: UD.loop = 1
              2: UD.loop = 2
              ELSE: Message,'Unknown button pressed'
           ENDCASE
        END
        'BMPBTNM1': BEGIN
           UD.Play = 0
           IF UD.t GT 0 THEN BEGIN
              UD.t = UD.t - 1
              VCR_Display, UD
           END
        END
        'BMPBTNP1': BEGIN
           UD.Play = 0
           IF UD.t LT UD.mt-1 THEN BEGIN
              UD.t = UD.t + 1
              VCR_Display, UD
           END
        END
        'BMPBTNM10': BEGIN
           UD.Play = 0
           IF UD.t GT 9 THEN BEGIN
              UD.t = UD.t - 10
              VCR_Display, UD
           END
        END
        'BMPBTNP10': BEGIN
           UD.Play = 0
           IF UD.t LT UD.mt-10 THEN BEGIN
              UD.t = UD.t + 10
              VCR_Display, UD
           END
        END
        'BMPBTNM100': BEGIN
           UD.Play = 0
           IF UD.t GT 99 THEN BEGIN
              UD.t = UD.t - 100
              VCR_Display, UD
           END
        END
        'BMPBTNP100': BEGIN
           UD.Play = 0
           IF UD.t LT UD.mt-100 THEN BEGIN
              UD.t = UD.t + 100
              VCR_Display, UD
           END
        END
        'FIELDTIME': BEGIN
           UD.Play = 0
           Widget_Control, Event.ID, Get_VALUE=tmp
           IF (LONG(tmp) LT UD.mt) AND (LONG(tmp) GE 0) THEN BEGIN
              UD.t = LONG(tmp)
              VCR_Display, UD
           END
        END
     ENDCASE
     
  END
  WIDGET_CONTROL, UD.TIMEID, SET_VALUE=ud.t

  WIDGET_CONTROL, Event.Top, SET_UVALUE=ud
END




PRO VCR, GROUP=Group, A, zoom=zoom, DELAY=delay, TITLE=title, SCALE=scale, XSIZE=xsize, YSIZE=ysize, TAUMEMO=taumemo

   On_Error,2 


  ; COMPLETE COMMAND LINE SYNTAX
  Default, zoom , 1
  Default, delay, 500
  Default, title, 'Videoplayer'
  Default, scale, 0
  Default, XSIZE, 320
  Default, YSIZE, 200
  Default, taumemo, 0.0
  
  IF N_Params() NE 1 THEN Message, 'exactly one argument expected'
  IF ((SIZE(A))(0) LT 2) OR ((SIZE(A))(0) GT 3) THEN Message, 'array is neither 2d nor 3d!'


  ; CREATE HANDLE TO VIDEO
  S = Size(A)
  TMP = A
  tmin = MIN(TMP)
  tmax = MAX(TMP)
  IF ((SIZE(A))(0) EQ 3) AND (NOT Keyword_Set(SCALE)) THEN TMP = BYTE((TMP-tmin)/(tmax-tmin)*(!D.TABLE_SIZE-1))
  _A = Handle_Create(!MH, VALUE=TMP, /NO_COPY)

  
  ; DETERMINE WINDOW SIZE
  ; xsize and ysize are already set for 2darrays
  IF S(0) EQ 3 THEN BEGIN
     xsize = S(2)*zoom
     ysize = S(3)*zoom
  END
  
  ;----->
  ;-----> SET PARAEMTERS FOR 2d OR 3d DATA
  ;----->
  IF (s(0) EQ 2) THEN BEGIN
     w = xsize
     h = ysize
     mt = s(1)
     modus = 0
  END ELSE BEGIN
     w = s(2)
     h = s(3)
     mt = s(1)
     modus = 1
  END

      


  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

  junk   = { CW_PDMENU_S, flags:0, name:'' }


  MAIN_VCR = WIDGET_BASE(GROUP_LEADER=Group, $
      ROW=1, $
      MAP=1, $
      TITLE=title, $
      UVALUE='MAIN_VCR')

  BASE2 = WIDGET_BASE(MAIN_VCR, $
      COLUMN=1, $
      MAP=1, $
      /ALIGN_CENTER,$
      TITLE='DRAWBASE', $
      UVALUE='BASE2')

  DRAW4 = WIDGET_DRAW( BASE2, $
      RETAIN=2, $
      UVALUE='DRAW4', $
      XSIZE=xsize, $
      YSIZE=ysize)


  BASE3 = WIDGET_BASE(MAIN_VCR, $
      COLUMN=1, $
      MAP=1, $
      TITLE='CONTROLBASE', $
      UVALUE='BASE3')

  BASE43 = WIDGET_BASE(BASE3, $
      ROW=1, $
      MAP=1, $
      TITLE='info', $
      UVALUE='BASE43')

  LABEL44 = WIDGET_LABEL( BASE43, $
      UVALUE='LABEL44', $
      VALUE='max time: '+STRCOMPRESS(mt, /REMOVE_ALL ))


  BASE5 = WIDGET_BASE(BASE3, $
      COLUMN=1, $
      FRAME=1, $
      MAP=1, $
      TITLE='CONTROLBUTTONS', $
      UVALUE='BASE5')

  BASE7 = WIDGET_BASE(BASE5, $
      ROW=1, $
      MAP=1, $
      TITLE='BUTTONROW1', $
      UVALUE='BASE7')

  BMPPLAYBACK = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 12b ], $
    [ 0b, 15b ], $
    [ 192b, 15b ], $
    [ 240b, 15b ], $
    [ 240b, 15b ], $
    [ 192b, 15b ], $
    [ 0b, 15b ], $
    [ 0b, 12b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNPLAYBACK = WIDGET_BUTTON( BASE7,VALUE=BMPPLAYBACK, $
      UVALUE='BMPBTNPLAYBACK')

  BMPPLAY = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 48b, 0b ], $
    [ 240b, 0b ], $
    [ 240b, 3b ], $
    [ 240b, 15b ], $
    [ 240b, 15b ], $
    [ 240b, 3b ], $
    [ 240b, 0b ], $
    [ 48b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNPLAY = WIDGET_BUTTON( BASE7,VALUE=BMPPLAY, $
      UVALUE='BMPBTNPLAY')

  BMPPAUSE = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 96b, 6b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNPAUSE = WIDGET_BUTTON( BASE7,VALUE=BMPPAUSE, $
      UVALUE='BMPBTNPAUSE')


  BASE8 = WIDGET_BASE(BASE5, $
      ROW=1, $
      MAP=1, $
      TITLE='BUTTONROW2', $
      UVALUE='BASE8')

  BMPREWIND = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 192b, 57b ], $
    [ 224b, 28b ], $
    [ 112b, 14b ], $
    [ 56b, 7b ], $
    [ 156b, 3b ], $
    [ 56b, 7b ], $
    [ 112b, 14b ], $
    [ 224b, 28b ], $
    [ 192b, 57b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNREWIND = WIDGET_BUTTON( BASE8,VALUE=BMPREWIND, $
      UVALUE='BMPBTNREWIND')

  BMPFASTFORWARD = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 156b, 3b ], $
    [ 56b, 7b ], $
    [ 112b, 14b ], $
    [ 224b, 28b ], $
    [ 192b, 57b ], $
    [ 224b, 28b ], $
    [ 112b, 14b ], $
    [ 56b, 7b ], $
    [ 156b, 3b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNFASTFORWARD = WIDGET_BUTTON( BASE8,VALUE=BMPFASTFORWARD, $
      UVALUE='BMPBTNFASTFORWARD')

  BMPEJECT = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 128b, 1b ], $
    [ 192b, 3b ], $
    [ 224b, 7b ], $
    [ 240b, 15b ], $
    [ 248b, 31b ], $
    [ 0b, 0b ], $
    [ 248b, 31b ], $
    [ 248b, 31b ], $
    [ 248b, 31b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNEJECT = WIDGET_BUTTON( BASE8,VALUE=BMPEJECT, $
      UVALUE='BMPBTNEJECT')

  SLIDERDELAY = WIDGET_SLIDER(BASE5, $
      MINIMUM=0, $
      MAXIMUM=1000, $
      VALUE=delay, $
      TITLE='Delay (ms)', $
      UVALUE='SLIDERDELAY')



  BASE9 = WIDGET_BASE(BASE3, $
      ROW=1, $
      MAP=1, $
      UVALUE='BASE9')

  BtnsLoop = [ $
    'None',$
    'Loop', $
    'Bounce']
  BGROUPLOOP = CW_BGROUP( BASE9, BtnsLoop, $
      ROW=3, $
      EXCLUSIVE=1, $
      FRAME=1, $
      SET_VALUE=0, $
      UVALUE='BGROUPLOOP')
  

  BASE6 = WIDGET_BASE(BASE3, $
      COLUMN=1, $
      FRAME=1, $
      MAP=1, $
      TITLE='TIMESTEPS', $
      UVALUE='BASE6')

  BASE17 = WIDGET_BASE(BASE6, $
      ROW=1, $
      MAP=1, $
      TITLE='STEP1', $
      UVALUE='BASE17')

  BMPM1 = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 3b ], $
    [ 192b, 3b ], $
    [ 192b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 3b ], $
    [ 60b, 3b ], $
    [ 60b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNM1 = WIDGET_BUTTON( BASE17,VALUE=BMPM1, $
      UVALUE='BMPBTNM1')

  BMPP1 = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 3b ], $
    [ 192b, 3b ], $
    [ 192b, 3b ], $
    [ 0b, 3b ], $
    [ 12b, 3b ], $
    [ 12b, 3b ], $
    [ 63b, 3b ], $
    [ 63b, 3b ], $
    [ 12b, 3b ], $
    [ 12b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 3b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNP1 = WIDGET_BUTTON( BASE17,VALUE=BMPP1, $
      UVALUE='BMPBTNP1')


  BASE18 = WIDGET_BASE(BASE6, $
      ROW=1, $
      MAP=1, $
      TITLE='STEP10', $
      UVALUE='BASE18')

  BMPM10 = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 128b, 253b ], $
    [ 224b, 253b ], $
    [ 224b, 205b ], $
    [ 128b, 205b ], $
    [ 128b, 205b ], $
    [ 158b, 205b ], $
    [ 158b, 205b ], $
    [ 128b, 205b ], $
    [ 128b, 205b ], $
    [ 128b, 253b ], $
    [ 128b, 253b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNM10 = WIDGET_BUTTON( BASE18,VALUE=BMPM10, $
      UVALUE='BMPBTNM10')

  BMPP10 = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 128b, 113b ], $
    [ 128b, 249b ], $
    [ 128b, 217b ], $
    [ 140b, 217b ], $
    [ 140b, 217b ], $
    [ 191b, 217b ], $
    [ 191b, 217b ], $
    [ 140b, 217b ], $
    [ 140b, 217b ], $
    [ 128b, 217b ], $
    [ 128b, 249b ], $
    [ 128b, 113b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNP10 = WIDGET_BUTTON( BASE18,VALUE=BMPP10, $
      UVALUE='BMPBTNP10')


  BASE19 = WIDGET_BASE(BASE6, $
      ROW=1, $
      MAP=1, $
      TITLE='STEP100', $
      UVALUE='BASE19')

  BMPM100 = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 96b, 102b ], $
    [ 120b, 255b ], $
    [ 120b, 153b ], $
    [ 96b, 153b ], $
    [ 96b, 153b ], $
    [ 103b, 153b ], $
    [ 103b, 153b ], $
    [ 96b, 153b ], $
    [ 96b, 153b ], $
    [ 96b, 153b ], $
    [ 96b, 255b ], $
    [ 96b, 102b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNM100 = WIDGET_BUTTON( BASE19,VALUE=BMPM100, $
      UVALUE='BMPBTNM100')

  BMPP100 = [ $
    [ 0b, 0b ], $
    [ 0b, 0b ], $
    [ 128b, 108b ], $
    [ 224b, 254b ], $
    [ 224b, 146b ], $
    [ 134b, 146b ], $
    [ 134b, 146b ], $
    [ 159b, 146b ], $
    [ 159b, 146b ], $
    [ 134b, 146b ], $
    [ 134b, 146b ], $
    [ 128b, 146b ], $
    [ 128b, 254b ], $
    [ 128b, 108b ], $
    [ 0b, 0b ], $
    [ 0b, 0b ]  $
  ]
  BMPBTNP100 = WIDGET_BUTTON( BASE19,VALUE=BMPP100, $
      UVALUE='BMPBTNP100')


  FieldValTIME = [ $
    'time' ]
  FIELDTIME = CW_FIELD( BASE6,VALUE=FieldValTIME, $
      ROW=1, $
      INTEGER=1, $
      RETURN_EVENTS=1, $
      XSIZE=6, $
      TITLE='time', $
      UVALUE='FIELDTIME')



  WIDGET_CONTROL, DRAW4, GET_VALUE=drawid, /REALIZE



  ;----->
  ;-----> CREATE A PIXMAP IF NEEDED
  ;----->
  IF (s(0) EQ 2) THEN BEGIN
     Window, /FREE, /PIXMAP, XSIZE=xsize, YSIZE=ysize 
     pm = !D.WINDOW
  END ELSE pm = 0
 
 WIDGET_CONTROL, MAIN_VCR,$
   SET_UVALUE={info  : 'VCR_BASE',$
               _A    : _A            ,$
               w     : w             ,$
               h     : h             ,$
               mt    : mt            ,$
               min   : tmin          ,$
               max   : tmax          ,$
               xsize : xsize         ,$
               ysize : ysize         ,$
               pm    : pm            ,$
               modus : modus         ,$
               t     : 0l            ,$
               zoom  : zoom          ,$
               did   : drawid        ,$ ;id of drawing area
              timeid : FIELDTIME     ,$
               timer : LABEL44       ,$ ;its a trick, a label cant generate a timer event
               play  : 0             ,$
               scale : scale         ,$
               delay : delay         ,$
               loop  : 0             ,$
             taumemo : taumemo       ,$
            ismemory : taumemo GT 0  ,$
               memo  : FLTARR(w,h)          }

  XMANAGER, 'VCR', MAIN_VCR
END
