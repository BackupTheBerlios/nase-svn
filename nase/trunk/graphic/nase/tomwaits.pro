;
; Auto Save File For /.amd/ax1303/usr/ax1303/saam/idl_pro/devel/graphic/tomwaits.pro
;



; CODE MODIFICATIONS MADE ABOVE THIS COMMENT WILL BE LOST.
; DO NOT REMOVE THIS COMMENT: BEGIN HEADER


;          TEST!

; DO NOT REMOVE THIS COMMENT: END HEADER
; CODE MODIFICATIONS MADE BELOW THIS COMMENT WILL BE LOST.


; CODE MODIFICATIONS MADE ABOVE THIS COMMENT WILL BE LOST.
; DO NOT REMOVE THIS COMMENT: BEGIN MAIN13




PRO MAIN13_Event, Event


  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'DRAW2': BEGIN
      Print, 'Event for DRAW2'
      END
  'BUTTON44': BEGIN
      Print, 'Event for froms'
      END
  'BUTTON40': BEGIN
      Print, 'Event for tos'
      END
  'BUTTON47': BEGIN
      Print, 'Event for print'
      END
  'BUTTON54': BEGIN
      Print, 'Buzz Off!'
      END
  ENDCASE
END


; DO NOT REMOVE THIS COMMENT: END MAIN13
; CODE MODIFICATIONS MADE BELOW THIS COMMENT WILL BE LOST.



PRO tomwaits, GROUP=Group


  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

  junk   = { CW_PDMENU_S, flags:0, name:'' }


  MAIN13 = WIDGET_BASE(GROUP_LEADER=Group, $
      XPAD=10, $
      YPAD=10, $
      MAP=1, $
      TITLE='Tom Waits', $
      UVALUE='MAIN13', $
      XSIZE=530, $
      YSIZE=610)

  DRAW2 = WIDGET_DRAW( MAIN13, $
      BUTTON_EVENTS=1, $
      FRAME=7, $
      RETAIN=1, $
      UVALUE='DRAW2', $
      XOFFSET=10, $
      XSIZE=496, $
      YOFFSET=10, $
      YSIZE=496)

  BUTTON44 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE='BUTTON44', $
      VALUE='Show Froms', $
      XOFFSET=10, $
      XSIZE=150, $
      YOFFSET=530)

  BUTTON40 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE='BUTTON40', $
      VALUE='Show Tos', $
      XOFFSET=370, $
      XSIZE=150, $
      YOFFSET=530)

  BUTTON47 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE='BUTTON47', $
      VALUE='Print It!', $
      XOFFSET=10, $
      XSIZE=150, $
      YOFFSET=570)

  BUTTON54 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-medium-r-normal--18-180-75-75-p-98-iso8859-1', $
      UVALUE='BUTTON54', $
      VALUE='Buzz Off!', $
      XOFFSET=370, $
      XSIZE=150, $
      YOFFSET=570)

  WIDGET_CONTROL, MAIN13, /REALIZE

  ; Get drawable window index

  COMMON DRAW2_Comm, DRAW2_Id
  WIDGET_CONTROL, DRAW2, GET_VALUE=DRAW2_Id

  XMANAGER, 'MAIN13', MAIN13
END
