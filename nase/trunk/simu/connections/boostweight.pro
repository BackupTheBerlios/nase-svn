;+
; NAME:     BOOSTWEIGHT
;
;
; PURPOSE:  Multipliziert die Gewichte einer DWS-Struktur mit einem Faktor
;
;
; CATEGORY: Connections
;
;
; CALLING SEQUENCE:   BOOSTWEIGHT, D_W_Struktur, FACTOR
;
; 
; INPUTS:     D_W_Struktur   ein mit InitDW initialisierte Struktur
;             FACTOR         Faktor mit dem die Gewichte der Struktur multipliziert werden soll
;             
;
;
;
; OPTIONAL INPUTS:  ---
;
;	
; KEYWORD PARAMETERS: ---
;
;
; OUTPUTS: ---
;
;
; OPTIONAL OUTPUTS: ---
;
;
; COMMON BLOCKS: ---
;
;
; SIDE EFFECTS: ---
;
;
; RESTRICTIONS: ---
;
; PROCEDURE: ---
;
;
; EXAMPLE:                 p = initpara_1()
;                          l1 = initlayer_1(width=2,  height=3,  type=p)
;                          l2 = initlayer_1(width=40, height=50, type=p)
;                          My_DWS = DelayWeigh(source_cl=l1, target_cl=l2, init_weights=dblarr(40*50,2*3) )
;                          SetGaussWeight, My_DWS, S_ROW=1, S_COL=0, T_HS_ROW=25, t_HS_COL=20
;                          BOOSTWEIGHT,My_DWS,2.0
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  1997/12/08 17:41:41  gabriel
;           wohl eine schwere ... docu erweitert
;
;     Revision 2.1  1997/12/08 17:36:30  gabriel
;          eine Geburt
;
;
;-

PRO BOOSTWEIGHT,V_Matrix, factor


   index = where(V_Matrix.Weights NE !NONE,count)
     
   IF count GT 0 THEN BEGIN  V_Matrix.Weights(index) = V_Matrix.Weights(index)*factor
   END ELSE MESSAGE,'Irgendwas ist faul mit der Gewichtsmatrix: alle Gewichte !NONE' 
   

END
