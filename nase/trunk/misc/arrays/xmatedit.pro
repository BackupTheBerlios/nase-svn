;------------------------------------------------------------------------
;
;       Name               :
;       Projekt            :
;
;       Autor              : R�diger Kupper
;
;       erstellt am        : 
;       letze Modifikation :
;
;       Funktion           :
;
;------------------------------------------------------------------------


; Interaktives Editieren eines zweidimensionalen Arrays


PRO MAIN13_Event, Event          
Common Widgets, Matrix, Felder, MSize        
            
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
Common Widgets, Matrix, Felder, MSize  
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
          
  BASE40 = WIDGET_BASE(MAIN13, $          
      COLUMN=2, $          
      MAP=1, $          
      TITLE='Knoepfe', $          
      UVALUE='BASE40')          
          
  BUTTON79 = WIDGET_BUTTON( BASE40, $          
      UVALUE='BUTTON79', $          
      VALUE='Accept')          
          
  BUTTON42 = WIDGET_BUTTON( BASE40, $          
      UVALUE='BUTTON42', $          
      VALUE='Cancel')          
          
          
  BASE43 = WIDGET_BASE(MAIN13, $          
      ROW=MSize(2), $          
      MAP=1, $          
      TITLE='Felder', $          
      UVALUE='BASE43')          
          
  for y=0,MSize(2)-1 do begin         
   for x=0,MSize(1)-1 do begin         
     Felder(x,y) = Cw_Field(Base43,Value=M(x,y),/Row,/Frame,XSize=5,Title=" ")        
   endfor         
  endfor         
           
         
WIDGET_CONTROL, MAIN13, /REALIZE          
          
  XMANAGER, 'MAIN13', MAIN13  
    
  M=Matrix                  
END          
