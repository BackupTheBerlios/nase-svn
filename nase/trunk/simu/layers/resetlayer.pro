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
; SEE ALSO: <A HREF="#FREELAYER_1">FreeLayer_?</A>, <AHREF="#INITLAYER_1">InitLayer_?</A>,
;           <A HREF="#LAYERDATA">LayerData</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/03/10 16:03:18  kupper
;               Sch�pfung.
;
;-

Pro ResetLayer, Layer

   TestInfo, Layer, "LAYER"

   LayerData, Layer, TYPE=Layertyp, PARAMETERS=Parameter, WIDTH=width, HEIGHT=height

   InitFunktion = "InitLayer_"+Layertyp ;ergibt Strings wie "InitLayer_1" usw.
   FreePro = "FreeLayer_"+Layertyp

   Call_Procedure, FreePro, Layer

   Layer = Call_Function( InitFunktion, WIDTH=width, HEIGHT=height, TYPE=Parameter )

End
