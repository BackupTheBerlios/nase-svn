;+
; NAME:                 InitLayer
;
; PURPOSE:              Initialisiert eine Schicht aus Neuronen vom Typ i.
;                       Der Neuronentyp wird in der Parameterstruktur
;                       festgelegt, diese muß mit <A HREF="#INITPARA_1">InitPara_i</A> 
;                       erzeugt werden.
;          
;                       InitLayer ist lediglich eine Rahmenfunktion, die
;                       selbständig die für den jeweiligen Neuronentyp
;                       spezifische <A HREF="#INITLAYER_1">InitLayer_i</A>-Funktion aufruft.
;
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     Layer = InitLayer( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische
;                                       Parameter enthält;
;                                       definiert in InitPara_i
;
; OUTPUTS:              Layer : Struktur namens Layer, die folgende Tags enthält:
;
;                                Layer = { info   : 'LAYER'
;                                          type   : 'i'    
;                                          w      : width
;                                          h      : height
;                                          para   : type
;                                          decr   : 1      ;decides if potentials are to be decremented or not
;                                          F      : DblArr(width*height) 
;                                          L      : DblArr(width*height) 
;                                          I      : DblArr(width*height)
;                                          M      : DblArr(width*height)
;                                          S      : DblArr(width*height)
;                                          O      : handle}
;
; PROCEDURE:          InitLayer schaut nach dem Typ der übergebenen Parameter
;                     (aus dem type.type-String) und ruft mit CALL_FUNCTION die
;                     jeweilige spezielle InitLayer_i-Funktion auf.
;
; EXAMPLE:            para1 = InitPara_1(tauf=10.0, vs=1.0)
;                     mylayer = InitLayer(WIDTH=5, HEIGHT=5, TYPE=para1)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.3  1998/11/06 14:28:38  thiel
;              Hyperlinks.
;
;       Revision 2.2  1998/11/06 14:14:30  thiel
;              Hyperlink-Fehler
;
;       Revision 2.1  1998/11/04 16:32:54  thiel
;              Rahmen fuer InitLayer_i-Funktionen.
;
;
;-

FUNCTION InitLayer, WIDTH=width, HEIGHT=height, TYPE=type

	Layer = Call_Function('InitLayer_'+type.type, WIDTH=width, HEIGHT=height, TYPE=type)

	RETURN, Layer

END 
