;+
; NAME: RFScan_Init()
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/01/29 14:45:05  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Function RFScan_Init, INLAYER=InLayer, OUTLAYER=OutLayer, Picture, $
               WIDTH=width, HEIGHT=height, $
               AUTO_RANDOMDOTS=auto_randomdots, $
               AUTO_VERTICALEDGE=auto_verticaledge, $
               AUTO_HORIZONTALEDGE=auto_horizontaledge, $
               AUTO_VERTICALLINE=auto_verticalline, $
               AUTO_HORIZONTALLINE=auto_horizontalline, $
               SHIFT_VERTICAL=shift_vertical, SHIFT_HORIZONTAL=shift_horizontal, $
               OBSERVE_SPIKES=observe_spikes, OBSERVE_POTENTIALS=observe_potentials, $
               VISUALIZE=visualize

   If keyword_set(InLayer) then begin
      WIDTH = LayerWidth(InLayer)
      HEIGHT = LayerHeight(InLayer)
   endif   

   ;;------------------> Implementation of AUTO-LINE-MODES:
   If keyword_set(AUTO_HORIZONTALLINE) then begin
      Picture = fltarr(HEIGHT, WIDTH)
      Picture(0:AUTO_HORIZONTALLINE-1, *) = 1.0
      SHIFT_VERTICAL = 1
      SHIFT_HORIZONTAL = 0
   Endif
   If keyword_set(AUTO_VERTICALLINE) then begin
      Picture = fltarr(HEIGHT, WIDTH)
      Picture(*, 0:AUTO_VERTICALLINE-1) = 1.0
      SHIFT_VERTICAL = 0
      SHIFT_HORIZONTAL = 1
   Endif
   ;;--------------------------------

   ;;------------------> Will Picture be manually defined?
   MANUAL = not set(Picture) and not keyword_set(AUTO_RANDOMDOTS) and not keyword_set(AUTO_VERTICALEDGE) and not keyword_set(AUTO_HORIZONTALEDGE)
   If MANUAL then message, /INFORM, "No Input Picture defined - will expect manual specification..."
   ;;--------------------------------

   ;;------------------> Will Picture be shifted in both directions?
   If (not keyword_set(SHIFT_VERTICAL) and not Keyword_Set(SHIFT_HORIZONTAL) ) OR $
    (keyword_set(SHIFT_VERTICAL) and Keyword_Set(SHIFT_HORIZONTAL) ) then begin
      SHIFT_BOTH = 1
      SHIFT_VERTICAL = 0
      SHIFT_HORIZONTAL = 0
                                ;From this point on, SHIFT_VERTICAL
                                ;and SHIFT_HORIZONTAL will mean "shift 
                                ;in this direction ONLY"
   EndIf
   ;;--------------------------------

   If Keyword_Set(SHIFT_BOTH) then shiftpositions = all_random(WIDTH*HEIGHT)
   If Keyword_Set(SHIFT_VERTICAL) or Keyword_Set(AUTO_HORIZONTALEDGE) then shiftpositions = all_random(HEIGHT)
   If Keyword_Set(SHIFT_HORIZONTAL) or Keyword_Set(AUTO_VERTICALEDGE) then shiftpositions = all_random(WIDTH)

   ;;------------------> The Default is to observe Spikes...
   If not Keyword_Set(OBSERVE_SPIKES) and not Keyword_Set(OBSERVE_POTENTIALS) then begin
      OBSERVE_SPIKES = 1
      OBSERVE_POTENTIALS = 0
   endif
   ;;--------------------------------

   ;;------------------> I want them all to be defined...
   Default, Picture, fltarr(HEIGHT, WIDTH)
   Default, AUTO_RANDOMDOTS, 0
   Default, AUTO_VERTICALEDGE, 0
   Default, AUTO_HORIZONTALEDGE, 0
   Default, SHIFT_VERTICAL, 0
   Default, SHIFT_HORIZONTAL, 0
   Default, SHIFT_BOTH, 0
   Default, VISUALIZE, 0
   Default, shiftpositions, -1
   Default, OBSERVE_SPIKES, 1
   Default, OBSERVE_POTENTIALS, 0
   ;;--------------------------------
   
   Return, {info:                "RFSCAN", $
            width:               WIDTH, $
            height:              HEIGHT, $
            RFs:                 InitDW(S_WIDTH = WIDTH, S_HEIGHT=HEIGHT, T_LAYER=OUTLAYER), $
            original:            Picture, $
            picture:             fltarr(HEIGHT, WIDTH), $
            manual:              MANUAL, $
            auto_randomdots:     AUTO_RANDOMDOTS, $
            auto_verticaledge:   AUTO_VERTICALEDGE, $
            auto_horizontaledge: AUTO_HORIZONTALEDGE, $
            shift_vertical:      SHIFT_VERTICAL, $
            shift_horizontal:    SHIFT_HORIZONTAL, $
            shift_both:          SHIFT_BOTH, $
            visualize:           VISUALIZE, $
            count:               0l, $ ;This will count the number of Input-Pictures
            divide:              0l, $ ;This will count the number of observed Outputs
            shiftpositions:      shiftpositions, $
            observe_spikes:      OBSERVE_SPIKES, $
            observe_potentials:  OBSERVE_POTENTIALS}
   
   
End
