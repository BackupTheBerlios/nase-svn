;------------------------------------------------------------------------
;
;       Name               :
;       Projekt            :
;
;       Autor              : Rüdiger Kupper
;
;       erstellt am        : 
;       letze Modifikation :
;
;       Funktion           :
;
;------------------------------------------------------------------------


FUNCTION RGB_berechnen, R,G,B  ; je 0..255      
   Return, long(R) + long(256)*G + long(65536)*B      
END   
   
FUNCTION RGB, R,G,B, INDEX=index, $; je 0..255
                      START=start
Common common_RGB, My_freier_Farbindex   
  
   
   if !D.N_Colors LE 256 then begin  ; 256-Farb-Display mit Color-Map   
       if Not(Keyword_Set(My_freier_Farbindex))or keyword_set(START) then My_freier_Farbindex = 1
 
       My_Color_Map = bytarr(!D.Table_Size,3) 
       TvLCT, My_Color_Map, /GET  
          
       if set(index) then SetIndex = index else SetIndex = My_freier_Farbindex

       My_Color_Map (SetIndex,*) = [R,G,B]  
       TvLCT, My_Color_Map  
       
       if not set(index) then begin
          My_freier_Farbindex = (My_freier_Farbindex+1) mod !D.Table_Size  
          if My_freier_Farbindex eq 0 then print, "!Farbpalette voll!"  
          return, My_Freier_Farbindex-1
       end
       return,  SetIndex

    endif else Return, RGB_berechnen(R,G,B) ; True-Color-Display   
END      



