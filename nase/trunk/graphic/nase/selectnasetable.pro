;+
; NAME:
;  SelectNASEtable
;
; VERSION:
;  $Id$
;
; AIM:
;  Select one of the predefined sets of NASE color tables.
;
; PURPOSE:
;  Select one of the predefined sets of NASE color tables (for screen
;  and postscript output). These color tables will be used by all NASE
;  graphic routines that do color scaling. (See
;  <A>ShowWeights_Scale</A> for further information on NASE color scaling.)
;
; CATEGORY:
;  Color
;  Graphic
;  NASE
;
; CALLING SEQUENCE:
;*SelectNASEtable [,number] 
;*                [,/STANDARD | ,/EXPONENTIAL | ,/MULTICOLOR]
;*                [,GET_NAMES=... [,/EXIT]]
;
; OPTIONAL INPUTS:
;  number:: Number of the NASE color table to select.<BR>
;           (Use the GET_NAMES=... keyword for retrieving the names of
;           the color tables.)
;
; INPUT KEYWORDS:
;  EXIT::        Setting this keywords causes the routine to exit
;                <I>without</I> selecting any new color table. This is
;                intended for use together with the <*>GET_NAMES</*>
;                keyword.
;  STANDARD::    Table set #0. <BR>
;                The good-old linear color tables are
;                selected. Linear grey scale for pure positive und
;                linear red-green scale for positive/negative arrays.
;                This is the default table to select, if neither
;                <*>number</*> nor any of the table keywords are
;                specified.
;  EXPONENTIAL:: Table set #1. <BR>
;                Same colors as with <*>STANDARD</*>, but using an
;                exponential profile. This enhances color
;                resolution for small array values.
;  MULTICOLOR::  Table set #2. <BR>
;                Multicolor tables. These tables are currently only
;                available for screen display. A postscript version
;                (fading towards white, instead of black for small
;                values) is still to be defined. Currently, the same
;                tables will be used for postscript output as for
;                screen display.
;
; OPTIONAL OUTPUTS:
;  GET_NAMES:: Set this keyword to a named variable to return an array
;              of strings set to the names of NASE color table
;              sets. The first element of the returned array will
;              contain the name of table set #0 ("standard"), the
;              second element will contain the name of table set #1
;              ("exponential"), and so on.
;
; SIDE EFFECTS:
;  The <*>!NASETABLE</*> system variable is modified. This variable is
;  intended for internal use only and shall not be modified directly
;  by the user. Use the <C>SelectNASEtable</C> routine instead.
;
; PROCEDURE:
;  Set the internal system varaible <*>!NASETABLE</*> to appropriate values
;  and issue an informative message.
;
; EXAMPLE:
;*SelectNASEtable, /EXPONENTIAL
;*>(10)SELECTNASETABLE:Selecting exponential NASE tables.
;*
;*SelectNASEtable, 2
;*>(10)SELECTNASETABLE:Selecting multicolor NASE tables.
;*
;*SelectNASEtable, GET_NAMES=names, /EXIT
;*>(5)SELECTNASETABLE:Exiting without modifying color table selection.
;*print, names
;*>standard exponential multicolor
;
; SEE ALSO:
;  ShowWeights_Scale, PlotTvScl, ShowWeights, ExamineIt
;-

Pro SelectNASETable, number, $
                     STANDARD=standard, EXPONENTIAL=exponential, $
                     MULTICOLOR=multicolor, $
                     GET_NAMES=get_names, EXIT=exit
   
   GET_NAMES = ["standard", $
                "exponential", $
                "multicolor"]
   
   If Keyword_Set(EXIT) then begin;;for use with the GET_NAMES keyword
      DMsg, "Exiting without modifying color table selection."
      return
   EndIf



   Default, number, 0 ;;standard table by default

   If Keyword_Set(STANDARD)    then number = 0
   If Keyword_Set(EXPONENTIAL) then number = 1
   If Keyword_Set(MULTICOLOR)  then number = 2

   
   Case number of

      0: begin ;;STANDARD
         !NASETABLE.POS          =  0
         !NASETABLE.NEGPOS       =  1
         !NASETABLE.PAPER_POS    =  2
         !NASETABLE.PAPER_NEGPOS =  3
         Console, /MSG, "Selecting linear standard NASE tables."
      End

      1: begin ;;EXPONENTIAL
         !NASETABLE.POS          =  4
         !NASETABLE.NEGPOS       =  5
         !NASETABLE.PAPER_POS    =  6
         !NASETABLE.PAPER_NEGPOS =  7
         Console, /MSG, "Selecting exponential NASE tables."
      End
      
      2: begin ;;MULTICOLOR
         !NASETABLE.POS          =  8
         !NASETABLE.NEGPOS       =  9
         !NASETABLE.PAPER_POS    =  8
         !NASETABLE.PAPER_NEGPOS =  9
         Console, /MSG, "Selecting multicolor NASE tables."
      End

   Endcase

End
