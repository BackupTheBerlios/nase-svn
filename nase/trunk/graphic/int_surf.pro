;------------------------------------------------------------------------
;
;       Name               : Int_Surf  (Interaktiver Surface-Plot)
;       Projekt            : Allgemein, Darstellung
;
;       Autor              : RÅdiger Kupper
;
;       erstellt am        : 20.7.1997
;       letze Modifikation : 21.7.1997
;
;       Funktion           : Die Prozedur realisiert einen mit der Maus drehbaren Surface-Plot.
;                            Sie fragt Cursor-Position ab und ruft Shade_Surf() mit
;           		     mit entsprechenden Winkeln auf.
;			     (Die Werte fÅr die Parameter AX und AZ werden ausgegeben.)
;
;			     Aufruf: Int_Surf, Array,
;                   			       XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize     (optionale Fensterkoordinaten)
;
;			     Die Routine wird mit einem Knopfdruck beendet.
;
;------------------------------------------------------------------------

pro int_surf, data, XPos=xpos, YPos=ypos, XSize=xsize, YSize=ysize    
      
Default, xpos, 500
Default, ypos, 100
Default, xsize, 500
Default, ysize, 500     
   
window, 1, /pixmap ,xsize=xsize, ysize=ysize, xpos=xpos, ypos=ypos  
window, 0 ,xsize=xsize, ysize=ysize, xpos=xpos, ypos=ypos, Title="Interactive ShadeSurf - Press Button to exit"  
shade_surf, data
xyouts, /device, 0, 0, "AX="+string(30.0)+"      AZ="+string(30.0)
 
 
tvcrs, 0.5+30d/360d, 0.5+30d/360d, /normal 

knopf=0
   
while knopf eq 0 do begin      
      
    cursor, x,y, /normal ,/change   
    knopf = !err   
       
    wset, 1         
      shade_surf,data ,ax=(y-0.5)*360,az=(x-0.5)*360
      xyouts, /device, 0, 0, "AX="+string((y-0.5)*360)+"      AZ="+string((x-0.5)*360)
    wset,0   
  device, copy=[0,0,xsize-1,ysize-1,0,0,1]    
end      
        
      
end      
