;+
; NAME:
;  LayerBoxIndices()
;
; AIM:
;  Return onedimensional indices of neurons in layer around given neuron.
;
;
; PURPOSE: Ermitteln der eindimensionalen Indizes der Neuronen, die 
;          rechteckfoermig um ein zentrales Neuron in einer Layer 
;          angeordnet sind.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: 
;      indexarray = LayerBoxIndices({layer | WIDTH=layerbreite, HEIGHTlayerhoehe} 
;                                   [, CENTERROW=xmittelpunkt][, CENTERCOL=ymittelpunkt]
;                                   [, BOXWIDTH=kastenbreite][, BOXHEIGHT=kastenhoehe]
;
; INPUTS: layer:                   Eine NASE-Layer, erzeugt mit InitLayer_x.
;         layerbreite, layerhoehe: Gibt es keine initialisierte Layer, sondern 
;                                  sind nur deren Ausmasse bekannt, so koennen 
;                                  diese hier angegeben werden.
;
; OPTIONAL INPUTS: x-/ymittelpunkt: Spalte und Zeile des zentralen Neurons, um 
;                                   das herum der Kasten angeordnet sein soll. 
;                                   Default: die Mitte der Layer.
;                  kastenbreite, -hoehe: Hoehe und Breite des Ausschnitts.
;                                        Default: 3, d.h. der Index des zentralen
;                                        Neurons und die seiner direkten Nachbarn.
;
; KEYWORD PARAMETERS: noch keine
;
; OUTPUTS: indexarray: ein zweidimensionales Array, das die eindimensionalen
;                       Indizes enthaelt, die Anordnung der Indizes im Indexarray
;                       entspricht dabei der Anordnung der Neuronen in der Layer.
;
; RESTRICTIONS: - Bisher wird nur die NASE-spezifische Indizierung der Neuronen 
;                  im Layer beachtet.
;               - Es gelten zyklische Randbedingungen, ragt also die Box ueber 
;                  den Arrayrand hinaus, werden die Indizes der Neuronen am 
;                  gegenueberliegenden Rand zurueckgegeben.
;
; PROCEDURE: 1. Syntaxkontrolle
;            2. Indexarray entsprechend der Layergroesse erzeugen
;            3. Indexarray entsprechend des 'Hot-Spots' verschieben
;            4. Gewuenschte Box aus dem Indexarray ausschneiden und zurueckgeben
;
; EXAMPLE: print, layerboxindices(width=7, height=5, boxwidth=5, boxheight=3)
;          
;          liefert:       6      11      16      21      26
;                         7      12      17      22      27
;                         8      13      18      23      28
;
; SEE ALSO: <A HREF="#LAYERINDEX">LayerIndex()</A>, <A HREF="#LAYERSIZE">LayerSize()</A>, <A HREF="#LAYERWIDTH">LayerWidth()</A>, <A HREF="#LAYERHEIGHT">LayerHeight()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/09/28 13:05:26  thiel
;            Added types '9' and 'lif', also added AIMs.
;
;        Revision 2.2  1998/02/16 16:31:44  thiel
;               NASE-Indizierung gilt auch fuer CENTER-Schluesselworte.
;
;        Revision 2.1  1998/01/31 17:00:09  thiel
;               Jetzt kann ichs comitten, jetzt ist auch der
;               Header fertig.
;
;-


FUNCTION LayerBoxIndices, Layer, $
                          WIDTH=width, HEIGHT=height, $
                          BOXWIDTH=boxwidth, BOXHEIGHT=boxheight, $
                          CENTERROW=centerrow, CENTERCOL=centercol

CASE N_Params() OF
   0: IF NOT (Set(WIDTH) AND Set(Height)) THEN Message, 'Specify either Layer Or WIDTH and HEIGHT!'
   1: BEGIN
      width = LayerWidth(layer)
      height = LayerHeight(layer)
      END
      ELSE: Message, 'Wrong umber of arguments!'
   END


Default, boxwidth, 3
Default, boxheight, 3
Default, centerrow, width/2
Default, centercol, height/2

IF (boxwidth GT width) OR (boxheight GT height) THEN Message,'Box is too large.'

groesse = boxwidth*boxheight



totalindex = Transpose(indgen(height,width))

;print, (totalindex)


oben = centercol-boxwidth/2
links = centerrow-boxheight/2

totalindex = Shift(totalindex,-oben,-links)

;print
;print, (totalindex)


boxindex = totalindex(0:boxwidth-1, 0:boxheight-1)
;boxindex = (boxindex)

;print
return, boxindex

END
