;+
; NAME: N_Spikes()
;
; PURPOSE: Ermittelt die Anzahl der spikenden Neuronen in einem Layer
;          zum aktuellen Zeitpunkt.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Anzahl = N_Spikes ( Layer )
;
; INPUTS: Layer: Eine NASE-Layer-Struktur
;
; OUTPUTS: Anzahl: Anzahl der gerade spikenden Neuronen
;
; PROCEDURE: Auswertung des SSpaß-Arrays
;
; EXAMPLE: If N_Spikes(MyLayer) ge 30 then print, "Burst!"
;
; SEE ALSO: <A HREF="#INITLAYER_1">InitLayer_?</A>, <A HREF="#LAYERDATA">LayerData</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  1999/03/24 12:41:48  thiel
;               War noch nicht auf Layer=Handle umgestellt.
;
;        Revision 2.1  1998/02/26 16:32:13  kupper
;               Schöpfung.
;
;-

Function N_Spikes, _Layer

   Handle_Value, _Layer, Layer, /NO_COPY

   TestInfo, Layer, 'LAYER'
   
   Handle_Value, Layer.O, SSOut

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
  
   Return, SSOut(0)             ;SSpaß-Array enthält Anzahl der einsen im 0. Element

End

   
