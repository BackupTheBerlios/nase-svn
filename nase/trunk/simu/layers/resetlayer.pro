;+
; NAME: ResetLayer
;
; PURPOSE: Zur�cksetzen der Neuronen eines Leyers (Re-Initialisierung)
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: ResetLayer, Layer
;
; INPUTS: Layer: Eine initialisierte Layer-Struktur beliebigen Typs.
;
; OUTPUTS: Layer wird neu initialisiert (mit identischen Parametern)
;          und so zur�ckgegeben.
;
; SIDE EFFECTS: Aufruf von FreeLayer, InitLayer - > Handles ver�ndern
;               sich wohl.
;
; PROCEDURE: Layerdaten lesen, (Typ, Gr��e, Parameter)
;            Layer freigeben
;            Layer neu initialisieren
;
; EXAMPLE: ResetLayer, MyLayer
;
; SEE ALSO: <A>FreeLayer_1</A>, <A>InitLayer_1</A>,
;           <A>LayerData</A>.
;
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/09/27 15:59:41  saam
;        service commit fixing several doc header violations
;
;        Revision 2.2  2000/03/12 16:52:09  kupper
;        Changed to use the neuron-type independent "FreeLayer" and "InitLayer".
;
;        Revision 2.1  1998/03/10 16:03:18  kupper
;               Sch�pfung.
;


Pro ResetLayer, Layer

   TestInfo, Layer, "LAYER"

   LayerData, Layer, TYPE=Layertyp, PARAMETERS=Parameter, WIDTH=width, HEIGHT=height

   FreeLayer, Layer

   Layer = InitLayer( WIDTH=width, HEIGHT=height, TYPE=Parameter )

End
