;+
; NAME: LayerIndex()
;
; PURPOSE: Rechnet den zweidimensionalen Layerindex (Zeile/Spalte) in den eindimensionalen um.
;
;	   Diese Funktion ist das Gegenstück zum Fubktionenpaar LayerRow() und LayerCol().
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
; KEYWORDS: Ist die übergebene Struktur eine DW-Struktur, so muß durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;           ROW, COL,  Angabe notwendig, s.o.
;
; OPTIONAL INPUTS: WIDTH, HEIGHT: sollten nur benutzt werden, wenn keine Struktur vorliegt.
;                                 Hier kann Höhe und breite explizit
;                                 angegeben werden. In diesem Fall
;                                 kann die Angabe von Struktur entfallen!  
;
; OUTPUTS: Index_1D: Der Eindimensionale Arrayindex. Mit diesem Index kann auch
;                    direkt auf die Arrays in der Layer-Struktur zugegriffen werden.
;
; RESTRICTIONS: Die Indizes sollten Integers sein, müssen aber nicht!
;
; EXAMPLE: Bspl 1:    Print, LayerIndex( My_Layer, ROW=1, COL=2)
;          Bspl 2:    Print, My_Layer.F( LayerIndex (My_Layer, ROW=1, COL=2) )   
;					-> liefert Feedingpotential des Neurons in Zeile 1, Spalte 2 des Layers My_Layer.
;	   Bspl 3:    Print, LayerIndex( My_Layer, ROW=LayerRow(My_Layer,5), COL=LayerCol(My_Layer,5) )
;					-> Ausgabe: 5
;       
; MODIFICATION HISTORY: Urversion, 25.7.1997, Rüdiger Kupper
;
;       $Log$
;       Revision 1.4  1998/11/08 17:34:02  saam
;             adapted to new layer type
;
;       Revision 1.3  1997/11/11 09:42:03  thiel
;              Syntax Error korrigiert.
;
;       Revision 1.2  1997/11/08 14:35:15  kupper
;              Die layer...-Routinen können nun auch auf
;               DW-Strukturen angewandt werden.
;
;
;       Mon Jul 28 17:32:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Keywords WIDTH und HEIGHT zugefügt.
;
;-

Function LayerIndex, Layer, ROW=row, COL=col, $
                               WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target
   
   IF set(WIDTH) THEN return, col*height + row

   
   if contains(Info(Layer), 'LAYER', /IGNORECASE) then begin
      h = LayerHeight(Layer)
      w = LayerWidth(Layer)
      if row ge h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu groß!'
      if col ge w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu groß!'
      
      return, col*h + row
   endif
   
   if contains(Info(Layer), 'DW', /IGNORECASE) then begin
      if Keyword_set(SOURCE) then begin
         h = LayerHeight(Layer, /SOURCE)
         w = LayerWidth(Layer, /SOURCE)
         if row ge h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu groß!'
         if col ge w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu groß!'
         return, col * h + row
      endif
      if Keyword_set(TARGET) then begin
         h = LayerHeight(Layer, /TARGET)
         w = LayerWidth(Layer, /TARGET)
         if row ge h then print, 'LayerIndex WARNUNG: Zeilenindex (Row) ist zu groß!'
         if col ge w then print, 'LayerIndex WARNUNG: Spaltenindex (Col) ist zu groß!'
         return, col * h + row
      endif
      message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
   endif
   
	
end
