;------------------------------------------------------------------------
;
;       Name               :
;       Projekt            :
;
;       Autor              : RÅdiger Kupper
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
   
FUNCTION RGB, R,G,B ; je 0..255   
Common common_RGB, My_Color_Map, My_freier_Farbindex
   
   if !D.N_Colors LE 256 then begin  ; 256-Farb-Display mit Color-Map   
       if Not(Keyword_Set(My_freier_Farbindex)) then begin 
           My_Color_Map = intarr(256,3) 
           TvLCT, My_Color_Map, /GET  
           My_freier_Farbindex = 1  
       endif   
       My_Color_Map (My_freier_Farbindex,*) = [R,G,B]  
       TvLCT, My_Color_Map  
       My_freier_Farbindex = (My_freier_Farbindex+1) mod 256  
       if My_freier_Farbindex eq 0 then print, "!Farbpalette voll!"  
       return, (My_Freier_Farbindex-1) mod 256  
    endif else Return, RGB_berechnen(R,G,B) ; True-Color-Display   
END      
