;+
; NAME: ShowWeights
;
; PURPOSE: formt eine Gewichtsmatrix um und stellt diese auf dem Bildschirm dar
;          dabei werden die Gewichte der Verbindungen NACH Neuron#0 in der linken
;          oberen Ecke des Fensters als grau-schattierte Kaestchen
;          gezeigt, die Gewichte der Verbindungen NACH Neuron#1 rechts
;          daneben usw.
;   
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: ShowWeights, Matrix, Dimension, Titel, Fenstergroesse
;
; INPUTS: Matrix: Gewichtsmatrix, die dargestellt werden soll, G(Target,Source)
;         Dimension: Groesse des Layers 
;         Titel: Titel des Fensters, das die Darstellung enthaelt 
;         Fenstergroesse: ein Mass fuer die Vergroesserung der Darstellung
; 
; OPTIONAL INPUTS: ---
;
; KEYWORD PARAMETERS:
;
; OUTPUTS: separates Fenster, das die Gewichtmatrix enthaelt
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS:  bisher sind nur Matrizen zwischen gleich grossen quadratischen Layern darstellbar
; 
; PROCEDURE: ---
;
; EXAMPLE: ShowWeights, W, 10, 'wunderschoene Matrix', 5
;          stellt die Matrix W zwischen zwei 10x10-Layern 5-fach
;          vergroessert in einem Fenster mit Titel 'wunderschoene
;          Matrix' dar.
;
; MODIFICATION HISTORY: Version vom 24. Juli '97, Andreas.
;
;-

PRO ShowWeights, Matrix, target_b, target_h, source_b, source_h, titel, gr

anzahl = tar_b*tar_h
Max_Amp = max(Matrix)
    
Matrix_gesp = rotate(Matrix,4)
Matrix_ref = reform(255*Matrix_gesp/Max_Amp,source_h,source_b,anzahl)	

Window, /Free, XSize=gr*source_b*target_b, YSize=gr*source_h*target_h, Title=titel   

For nr = 0, (anzahl-1) Do Begin       
	Tv, rebin(Matrix_ref(*,*,nr),gr*source_h,gr*source_b,/sample),nr ,/Order 
EndFor



END        
        
        
