;+
; NAME: InformationOverkill()
;
; PURPOSE: Summieren eines Array-Videos über alle Frames. (s. InitVideo für nähere Informationen)
;
; CATEGORY: Visualisierung
;
; CALLING SEQUENCE: Erg = InformationOverkill ( {Title | TITLE=title} )
;
; OPTIONAL INPUTS: Title: Titel und Filename des Videos
;
; KEYWORD PARAMETERS: TITLE: Hat die gleiche Funktion wie Title.
;
; OUTPUTS: Ein Array der im Video gespeicherten Größe des Typs FLOAT,
;          das den Durchschnitt aller Frames des gesamten Videos enthält.
;
; PROCEDURE: Straightforward
;
; EXAMPLE: NaseTvScl, InformationOverkill('Mein_ZellenOutput')
;
; MODIFICATION HISTORY:
;
;       Thu Sep 11 15:58:11 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

function InformationOverkill, _title, TITLE=title

   default, video, _title
   default, video, title

   Default, video, 'The Spiking Neuron'

   vid = loadvideo(video)
 
   erg = replay(vid)

   for f=2l, vid.Length do erg = erg+replay(vid)
   erg = erg/float(vid.Length)

   eject, vid

   return, erg

end
