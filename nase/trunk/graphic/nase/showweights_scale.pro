;+
; NAME: ShowWeights_Scale()
;
; VERSION:
;  $Id$
;
; AIM: Scale array to be plotted using one of the predefined NASE
;      color tables.
;
; PURPOSE: 
;  An outsourced part of <A>ShowWeights</A>. An array is scaled such
;  that it can be displayed with <A>UTV</A> and will look the same as
;  drawn by <A>ShowWeights</A>. All array entries are substituted by
;  the corresponding color indices. An exeption is the <*>!NONE</*>
;  value, which is left unchanged since <A>UTV</A> uses a separate
;  color index to display <*>!NONE</*>s.<BR>
;  As an optional feature, the colortable may be set accordingly.
;
; CATEGORY:
;  Array
;  Color
;  Connections
;  Graphic
;  Image
;  NASE
;
; CALLING SEQUENCE:
;*  utv_array = ShowWeights_Scale( array [,SETCOL={1|2}] ,[/PRINTSTYLE]
;*                                [,COLORMODE=...]
;*                                [,RANGE_IN=...]
;*                                [,GET_COLORMODE={+1|-1}]
;*                                <I>obsolete: </I>[,GET_MAXCOL=...]
;*                                [,GET_RANGE_IN =...]
;*                                <I>obsolete: </I>[,GET_RANGE_OUT=...])
;
; INPUTS: 
;  array:: An array of numerical type that may also contain
;          <*>!NONE</*> values. 
;
; INPUT KEYWORDS:
;  SETCOL:: When set to 1, <C>ShowWeigthsSacle()</C> initializes the
;           colortable and adjusts the values of <*>!P.Background</*>
;           und <*>Set_Shading</*> (greyscale for positive arrays, red
;           /green for arrays of mixed sign).<BR>
;           If set to 2, <C>ShowWeigthsSacle()</C> initializes the
;           colortable and adjusts the values of <*>!P.Background</*>
;           und <*>Set_Shading</*>, while the array itself it
;           <I>not</I> scaled. The function returns 0 in this case.
;  COLORMODE:: With this keyword it is possible to force either the
;              greyscale <*>COLORMODE=+1</*> or red/green
;              <*>COLORMODE=-1</*> display no matter what the
;              values in <*>array</*> are.
;  /PRINTSTYLE:: This switch causes the whole available color palette
;                to be used for greyscales. The colors orange and blue
;                are not set. This option is intended for generating
;                printable greyscale graphics.
;  RANGE_IN:: The <I>positive scalar value</I> given in <*>RANGE_IN</*> will be
;             scaled to the maximum color (white / full green). Note
;             that this exact value does not have to be contained in
;             the array. If the array contains values greater than
;             <*>RANGE_IN</*>, the result will contain invalid color
;             indices.<BR>
;             By default, this value will be determined from the
;             arrays contents such as to span the whole available
;             color range.<BR>
;             Please note that this expects a scalar value, in
;             contrary to the <*>RANGE_IN</*> keywords in other
;             routines like <A>UTvScl</A> or <A>PlotTvScl</A>.
;
; OUTPUTS:
;  utv_array:: A suitably scaled array that may be directly displayed
;              using <A>UTV</A>.
;
; OPTIONAL OUTPUTS:
;  GET_MAXCOL:: <A>ShowWeights</A> uses the colors blue for showing
;               <*>!NONE</*> connections and orange for drawing a line
;               grid. Therefore, not all color indices are available
;               for displaying the data. With <*>GET_MAXCOL</*>, the
;               last free color index can be returned.<BR>
;                 <I>The keyword <C>GET_MAXCOL</C> is obsolete, but
;                 maintained for backwards compatibility.<BR>
;                 The value returned is always
;                 <*>GET_MAXCOL = !TOPCOLOR</*></I>.
;  GET_COLORMODE:: Returns <*>+1</*>, if the greyscale mode was used
;                  for displaying the data, ie, the array only
;                  contained positive values. Returns <*>-1</*> if the
;                  red/green mode was used, ie the array also
;                  contained negative values.
;  GET_RANGE_IN, GET_RANGE_OUT:: These values may be passed directly
;                                to the <A>Scl</A> command to scale
;                                multiple arrays in such a way that
;                                their colors are directly comparable.<BR>
;                 <I>The keyword <C>GET_RANGE_OUT</C> is obsolete, but
;                 maintained for backwards compatibility.<BR>
;                 The value returned is always
;                 <*>GET_RANGE_OUT = [0, !TOPCOLOR]</*></I>.<BR>
;<BR>
;                 The following relations apply:<BR>
;*  GET_RANGE_IN  = [0, Range_In       ], if Range_In was set,
;*                = [0, max(abs(Array))]  otherwise
;*  GET_RANGE_OUT = [0, !TOPCOLOR]
;
; SIDE EFFECTS: 
;  The color table is changed if necessary. Furthermore,
;  <*>!P.BACKGROUND</*> is set to the color index of black and
;  <*>SET_SHADING</*> is suitably initialized such that subsequent
;  Surface-Plots don't look strange.
;
; PROCEDURE:
;  Outsourced from <A>ShowWeights</A>, Rev. 2.15.
;
; EXAMPLE:
; 1.
;* UTV, /NORDER, ShowWeights_Scale( GetWeight( MyDW, T_INDEX=0 ), /SETCOL ), STRETCH=10
; 2. 
;* Window, /FREE, TITLE="Membranpotential"
;*     LayerData, MyLayer, POTENTIAL=M
;*     UTV, /NORDER, ShowWeights_Scale( M, /SETCOL), STRETCH=10
;3. 
;* a = gauss_2d(100,100)
;*     WINDOW, 0
;*     UTV, ShowWeights_Scale( a, /SETCOL, $
;*                                GET_RANGE_IN=ri, GET_RANGE_OUT=ro )
;*     WINDOW, 1
;*     UTV, Scl( 0.5*a, ro, ri )
; The arrays' values displayed in both windows are now comparable. The
; last command is identical to:
;*     UTV, ShowWeights_Scale( 0.5*a, RANGE_IN=ri(1) )
;
; SEE ALSO: <A>ShowWeights</A>, <A>UTvScl</A>, <A>PlotTvScl</A>.
;-

Function ShowWeights_Scale, Matrix, SETCOL=setcol, GET_MAXCOL=get_maxcol, $
                            COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                            PRINTSTYLE=printstyle, $
                            RANGE_IN=range_in, $
                            GET_RANGE_IN=get_range_in, GET_RANGE_OUT=get_range_out


   Default, SETCOL, 0

   ;;------------------> Make local copy and wipe out !NONEs
   MatrixMatrix = NoNone_Func( Matrix, NONES=no_connections, COUNT=count )
   ;;Named MatrixMatrix for historical reasons...
   ;;--------------------------------
   
   min = min(MatrixMatrix)
   max = max(MatrixMatrix)
   
   ;;------------------> The Range value will be scaled to white/green:
   If Keyword_Set(Range_In) then Range = Range_In ;Range_In should not be changed.
                                ;cannot use "Default", by the way,
                                ;as Range_In=0 should be
                                ;interpreted as not set (not as
                                ;literal 0)
   Default, Range, max([max, -min]) ; for positive Arrays this equals max.

   ;; Is this possible to work around range=0 for "empty" arrays???
   ;; at least leaving range eq 0 does not work fine
   IF range EQ 0 THEN range = 1

   assert, N_Elements(Range) eq 1, "Range_In must be a positive scalar value for this routine."
   assert, Range gt 0, "Range_In must be a positive scalar value for this routine."



   ;;--------------------------------
   
   ;;------------------> Optional Outputs
   GET_MAXCOL = !TOPCOLOR       ;since the revised NASE color
                                ;management (see proceedings of the
                                ;first NASE workshop 2000)
   GET_RANGE_OUT = [0, !TOPCOLOR]
   ;; GET_RANGE_OUT see below!
   ;;--------------------------------
   
   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enthält!
   



   If not Keyword_Set(COLORMODE) then $
    If min ge 0 then COLORMODE = 1 else COLORMODE = -1



   if COLORMODE eq 1 then begin ;positives Array

      GET_COLORMODE = 1
      GET_RANGE_IN  = [0, Range]
      If Keyword_Set(SETCOL) then begin
         If !D.NAME eq "PS" then begin
            ;;umgedrehte Graupalette laden:
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.PAPER_POS
         endif else uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.POS ;utvlct, g, g, g ;Grauwerte
      Endif
      
      If (SETCOL lt 2) then Scl, MatrixMatrix, [0, !TOPCOLOR], [0, Range]

   endif else begin             ;pos/neg Array

      GET_COLORMODE = -1
      GET_RANGE_IN  = [-Range, Range]
      If Keyword_Set(SETCOL) then begin
         If !D.Name eq "PS" then begin ;helle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.PAPER_NEGPOS
         endif else begin       ;dunkle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.NEGPOS
         endelse
         Set_Shading, VALUES=[!TOPCOLOR/2, !TOPCOLOR] ;Grüne Werte für Shading nehmen
      EndIf

      If (SETCOL lt 2) then Scl, MatrixMatrix, [0, !TOPCOLOR], [-Range, Range]

   endelse



   ;; NONEs wiederherstellen:
   If not keyword_set(PRINTSTYLE) then begin

      IF count NE 0 THEN MatrixMatrix(no_connections) = !NONE

   EndIf

   If (SETCOL lt 2) then Return, MatrixMatrix else Return, 0
End
