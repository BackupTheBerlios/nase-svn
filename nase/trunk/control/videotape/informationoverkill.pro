;+
; NAME: InformationOverkill()
;
; PURPOSE: Summieren eines Array-Videos über alle Frames unter
;          optionaler Anwendung einer Funktion. (s. InitVideo für
;          nähere Informationen zu Array-Videos.)
;
; CATEGORY: Visualisierung
;
; CALLING SEQUENCE: Erg = InformationOverkill ( Title 
;                                              [,PROCESS [,p1 .. ,pn] [,KEY1 .. ,KEYx] ]   (n < = 4)
;                                             )
;
; INPUTS: Title: Titel und Filename des Videos
;
; OPTIONAL INPUTS: p1,..pn: Parameter der aufzurufenden Funktion
;
; KEYWORD PARAMETERS: PROCESS: Ein String, der den Namen einer
;                              IDL-Funktion enthält, die vor der
;                              Summation auf jeden einzelnen Frame
;                              angewandt wird. Der aktuelle Frame wird jeweils
;                              als erstes Argument an diese Funktion
;                              übergeben, bis zu drei weitere
;                              Parameter und beliebig viele
;                              Keyword-Parameter können zusätzlich
;                              angegeben werden.
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

function InformationOverkill, title, $
                              PROCESS=process, p1, p2, p3, p4, _EXTRA=_extra

   default, video, title

   Default, video, 'The Spiking Neuron'

   vid = loadvideo(video)
   
   erg = 0
   If not KeyWord_Set(PROCESS) then begin 
      for f=1l, vid.Length do erg = erg+replay(vid)
   endif else begin
      for f=1l, vid.Length do if Set(_EXTRA) then begin
         case n_params() of
            1: erg = erg+Call_Function(process, float(replay(vid)), _EXTRA=_extra)
            2: erg = erg+Call_Function(process, float(replay(vid)), p1, _EXTRA=_extra)
            3: erg = erg+Call_Function(process, float(replay(vid)), p1, p2, _EXTRA=_extra)
            4: erg = erg+Call_Function(process, float(replay(vid)), p1, p2, p3, _EXTRA=_extra)
            5: erg = erg+Call_Function(process, float(replay(vid)), p1, p2, p3, p4, _EXTRA=_extra)
         endcase
      endif else begin
         case n_params() of
            1: erg = erg+Call_Function(process, float(replay(vid)))
            2: erg = erg+Call_Function(process, float(replay(vid)), p1)
            3: erg = erg+Call_Function(process, float(replay(vid)), p1, p2)
            4: erg = erg+Call_Function(process, float(replay(vid)), p1, p2, p3)
            5: erg = erg+Call_Function(process, float(replay(vid)), p1, p2, p3, p4)
         endcase
      endelse
   endelse
   
   erg = erg/float(vid.Length)

   eject, vid

   return, erg

end
