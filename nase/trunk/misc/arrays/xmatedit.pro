;+
; NAME: XMatEdit
;
; AIM: interactive tool for editing two dimensional arrays
;
; PURPOSE: Interaktives Editieren eines zweidimensionalen Arrays
;
; CATEGORY: Array
;
; CALLING SEQUENCE: XMatEdit, Matrix, [GROUP=Base_ID]
;
; INPUTS: Matrix: klar!
;
; OPTIONAL Inputs: ID eines Wisgets, das als Parent dienen soll.
;
; COMMON BLOCKS: XMAT_Widgets
;
; SIDE EFFECTS: Die Matrix wird ver‰ndert.
;
; RESTRICTIONS: Matrix muﬂ definiert und zweidimensional sein!
; 
; EXAMPLE: m = Indgen(10,10)
;          XMatEdit, m
;          Print, m
;
; SEE ALSO: XVarEdit (Standard IDL-Routine)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  2000/11/07 15:43:49  saam
;        fixed wrong categories
;
;        Revision 1.5  2000/09/25 09:12:56  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.4  1998/02/21 15:30:17  kupper
;               Grummel... altes IDL 3.6... Mist...
;
;        Revision 1.3  1998/02/19 15:36:34  kupper
;               Fehlerchen...
;
;        Revision 1.2  1998/02/19 15:31:26  kupper
;               Header geschrieben.
;
;-

PRO MAIN13_Event, Event          
Common XMAT_Widgets, Matrix, Felder, MSize        
            
 WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev          
          
  CASE Ev OF           
          
  'BUTTON79': BEGIN ; Event for ACCEPT        
      for y=0,MSize(2)-1 do begin         
        for x=0,MSize(1)-1 do begin         
          Widget_Control, Felder(x,y), GET_VALUE=temp 
          Matrix(x,y)=temp        
        endfor         
      endfor         
      Widget_Control,Event.Top, /destroy          
      END          
  'BUTTON42': BEGIN      ; Event for CANCEL         
      Widget_Control,Event.Top, /destroy          
      END          
         
    ENDCASE          
END          
          
          
PRO XMATEDIT, M, GROUP=Group        
Common XMAT_Widgets, Matrix, Felder, MSize  
  Matrix=M      
  MSize = Size(M)         
  Felder = lonarr(MSize(1),MSize(2))         
          
  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0          
          
  junk   = { CW_PDMENU_S, flags:0, name:'' }          
          
          
  MAIN13 = WIDGET_BASE(GROUP_LEADER=Group, $          
      COLUMN=2, $          
      MAP=1, $          
      TITLE='XMatEdit', $          
      UVALUE='MAIN13')          
          
;  BASE40 = WIDGET_BASE(MAIN13, $          
;      COLUMN=2, $          
;      MAP=1, $          
;      TITLE='Knoepfe', $          
;      UVALUE='BASE40')          
          
          
  BASE43 = WIDGET_BASE(MAIN13, $          
      ROW=MSize(2)+1, $          
      MAP=1, $          
      TITLE='Felder', $          
      UVALUE='BASE43')          
          
  for y=0,MSize(2)-1 do begin         
   for x=0,MSize(1)-1 do begin         
     Felder(x,y) = Cw_Field(Base43,Value=M(x,y),/Row,/Frame,XSize=5,Title=" ")        
   endfor         
  endfor         

  BUTTON79 = WIDGET_BUTTON( BASE43, $   ;BASE40, $          
      UVALUE='BUTTON79', $          
      VALUE='Accept')          
          
  BUTTON42 = WIDGET_BUTTON( BASE43, $ ;BASE40, $          
      UVALUE='BUTTON42', $          
      VALUE='Cancel')          
           
         
WIDGET_CONTROL, MAIN13, /REALIZE          
          
  XMANAGER, 'MAIN13', MAIN13  
    
  M=Matrix                  
END          
