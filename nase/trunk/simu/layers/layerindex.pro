;+
; NAME: LayerIndex()
;
; PURPOSE: Rechnet den zweidimensionalen Layerindex (Zeile/Spalte) in den eindimensionalen um.
;
;	   Diese Funktion ist das Gegenst�ck zum Fubktionenpaar LayerRow() und LayerCol().
;
;	   Die Umrechnung ist kompatibel zur IDL-Funktion REFORM().
;
; CATEGORY: Simulation, Basic
;
; CALLING SEQUENCE: Index_1D = Layerindex( Struktur [,/SOURCE] [,/TARGET], ROW=Row, COL=Col )
;
; INPUTS: Struktur   : eine mit InitLayer_? initialisierte Layer-Struktur
;                      ODER eine mit InitDW initialisierte DW-Struktur
;	  Row  : Der Zeilenindex
;         Col  : Der Spaltenindex
;
; KEYWORDS: Ist die �bergebene Struktur eine DW-Struktur, so mu� durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;           ROW, COL,  Angabe notwendig, s.o.
;
; OPTIONAL INPUTS: WIDTH, HEIGHT: sollten nur benutzt werden, wenn keine Struktur vorliegt.
;                                 Hier kann H�he und breite explizit
;                                 angegeben werden. In diesem Fall
;                                 kann die Angabe von Struktur entfallen!  
;
; OUTPUTS: Index_1D: Der Eindimensionale Arrayindex. Mit diesem Index kann auch
;                    direkt auf die Arrays in der Layer-Struktur zugegriffen werden.
;
; RESTRICTIONS: Die Indizes sollten Integers sein, m�ssen aber nicht!
;
; EXAMPLE: Bspl 1:    Print, LayerIndex( My_Layer, ROW=1, COL=2)
;          Bspl 2:    Print, My_Layer.F( LayerIndex (My_Layer, ROW=1, COL=2) )   
;					-> liefert Feedingpotential des Neurons in Zeile 1, Spalte 2 des Layers My_Layer.
;	   Bspl 3:    Print, LayerIndex( My_Layer, ROW=LayerRow(My_Layer,5), COL=LayerCol(My_Layer,5) )
;					-> Ausgabe: 5
;       
; MODIFICATION HISTORY: Urversion, 25.7.1997, R�diger Kupper
;
;       $Log$
;       Revision 1.3  1997/11/11 09:42:03  thiel
;              Syntax Error korrigiert.
;
;       Revision 1.2  1997/11/08 14:35:15  kupper
;              Die layer...-Routinen k�nnen nun auch auf
;               DW-Strukturen angewandt werden.
;
;
;       Mon Jul 28 17:32:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Keywords WIDTH und HEIGHT zugef�gt.
;
;-

Function LayerIndex, Layer, ROW=row, COL=col, $
                               WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target
   
   IF set(WIDTH) THEN return, col*height + row

        if contains(Layer.info, 'LAYER', /IGNORECASE) then begin
           if row ge Layer.h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu gro�!'
           if col ge Layer.w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu gro�!'

           return, col*Layer.h + row
        endif

	if contains(Layer.info, 'DW', /IGNORECASE) then begin
           if Keyword_set(SOURCE) then begin
              if row ge Layer.Source_h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu gro�!'
              if col ge Layer.Source_w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu gro�!'
              return, col * Layer.Source_h + row
           endif
           if Keyword_set(TARGET) then begin
              if row ge Layer.Target_h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu gro�!'
              if col ge Layer.Target_w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu gro�!'
              return, col * Layer.Target_h + row
           endif
            message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif

	
end
