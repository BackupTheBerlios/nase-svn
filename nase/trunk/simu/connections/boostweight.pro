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
;     Revision 2.5  1998/02/11 17:08:42  kupper
;            Tippfehler korrigiert.
;
;     Revision 2.4  1998/02/05 13:15:59  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.3  1997/12/10 15:53:36  saam
;           Es werden jetzt keine Strukturen mehr uebergeben, sondern
;           nur noch Tags. Das hat den Vorteil, dass man mehrere
;           DelayWeigh-Strukturen in einem Array speichern kann,
;           was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;     Revision 2.2  1997/12/08 17:41:41  gabriel
;           wohl eine schwere ... docu erweitert
;
;     Revision 2.1  1997/12/08 17:36:30  gabriel
;          eine Geburt
;
;
;-

PRO BOOSTWEIGHT, DW, factor

   W = Weights(DW)
   index = where(W NE !NONE,count)
     
   IF count GT 0 THEN BEGIN  W(index) = W(index)*factor
   END ELSE MESSAGE,'Irgendwas ist faul mit der Gewichtsmatrix: alle Gewichte !NONE' 
   
   SetWeights, DW, W

END
