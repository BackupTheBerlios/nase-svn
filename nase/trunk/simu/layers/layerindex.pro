;+
; NAME: LayerIndex()
;
;
;
; PURPOSE: Rechnet den zweidimensionalen Layerindex (Zeile/Spalte) in den eindimensionalen um.
;
;	   Diese Funktion ist das Gegenstück zum Fubktionenpaar LayerRow() und LayerCol().
;
;	   Die Umrechnung ist kompatibel zur IDL-Funktion REFORM().
;
; CATEGORY: Simulation, Basic
;
;
;
; CALLING SEQUENCE: Index_1D = Layerindex( Layer, ROW=Row, COL=Col )
;
;
; 
; INPUTS: Layer: eine mit InitLayer_? initialisierte Layer-Struktur
;	  Row  : Der Zeilenindex
;         Col  : Der Spaltenindex
;
;
;
; OPTIONAL INPUTS: WIDTH, HEIGHT: sollten nur benutzt werden, wenn keine Layer-Struktur vorliegt.
;                                 Hier kann Höhe und breite explizit
;                                 angegeben werden. In diesem Fall
;                                 kann die Angabe von Layer entfallen!  
;
;
;	
; KEYWORD PARAMETERS: ROW, COL,  Angabe notwendig, s.o.
;
;
;
; OUTPUTS: Index_1D: Der Eindimensionale Arrayindex. Mit diesem Index kann auch
;                    direkt auf die Arrays in der Layer-Struktur zugegriffen werden.
;
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: ---
;
;
;
; SIDE EFFECTS: ---
;
;
;
; RESTRICTIONS: Die Indizes sollten Integers sein, müssen aber nicht!
;
;
;
; PROCEDURE: ---
;
;
;
; EXAMPLE: Bspl 1:    Print, LayerIndex( My_Layer, ROW=1, COL=2)
;          Bspl 2:    Print, My_Layer.F( LayerIndex (My_Layer, ROW=1, COL=2) )   
;					-> liefert Feedingpotential des Neurons in Zeile 1, Spalte 2 des Layers My_Layer.
;	   Bspl 3:    Print, LayerIndex( My_Layer, ROW=LayerRow(My_Layer,5), COL=LayerCol(My_Layer,5) )
;					-> Ausgabe: 5
;       
;
;
; MODIFICATION HISTORY: Urversion, 25.7.1997, Rüdiger Kupper
;
;       Mon Jul 28 17:32:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Keywords WIDTH und HEIGHT zugefügt.
;
;-

Function LayerIndex, Layer, ROW=row, COL=col, $
                               WIDTH=width, HEIGHT=height
   
   IF set(WIDTH) THEN return, col*height + row


   if row ge Layer.h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu groß!'
   if col ge Layer.w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu groß!'

   return, col*Layer.h + row
	
end
