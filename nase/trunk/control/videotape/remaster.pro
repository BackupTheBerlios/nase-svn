;+
; NAME: Remaster
;
; AIM: postprocessing of a (closed) array-video.
;
; PURPOSE: Nachbearbeitung eines (abgeschlossenen) Arrayvideos
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Remaster, Title  [   ,SCALE=Faktor
;                                     | ,PROCESS=FuncName [,p1 .. ,pn] [,KEY1 .. ,KEYx]    (n < = 3)
;                                   ]
;                                    [/NOLABEL] 
; INPUTS: Title: Filename, der auch der Videotitel ist.
;                 Bei Nichtangabe wird der Defaulttitel "The Spiking Neuron"
;                 benutzt.
;
; OPTIONAL INPUTS: p1,..pn: Parameter der aufzurufenden Funktion
;                           (s. unter Keyword PROCESS)
;
; KEYWORD PARAMETERS: SCALE  : Ein Faktor, mit dem jeder Frame
;                              multipliziert wird.
;
;                     PROCESS: Ein String, der den Namen einer
;                              IDL-Funktion enthält, die
;                              auf jeden einzelnen Frame des Videos
;                              angewandt wird. Der aktuelle Frame wird jeweils
;                              als erstes Argument an diese Funktion
;                              übergeben, bis zu drei weitere
;                              Parameter und beliebig viele
;                              Keyword-Parameter können zusätzlich
;                              angegeben werden.
;                     NOLABEL: Erspart dem Benutzer die leidige Label-Eingabe
;                              beim Video-<A HREF="#EJECT">Eject</A>.
;
; SIDE EFFECTS: Der Videoinhalt wird entsprechend verändert.
;
; RESTRICTIONS: Die SCALE-Option
;               funktioniert natürlich nur bei numerischen Daten.
;
; PROCEDURE: Auf ein Assoziiertes Array frameweise die entsprechende
;            Operation anwenden.
;
; EXAMPLE:
;      (1) My_Video = InitVideo( 0.0, "TestVideo" )
;          
;          dummy = CamCord ( My_Video, 1.0 )
;          dummy = CamCord ( My_Video, 2.0 )
;          dummy = CamCord ( My_Video, 3.0 )
;
;          Eject, My_Video, /NOLABEL
;
;          Remaster, "TestVideo", SCALE=23
;
;          Remastered_Video = LoadVideo( "TestVideo" )
;
;          print, Replay( Remastered_Video )                -> Ausgabe: 23.0
;          print, Replay( Remastered_Video )                -> Ausgabe: 46.0
;          print, Replay( Remastered_Video )                -> Ausgabe: 69.0
;
;          Eject, Remastered_Video
;
;      (2) Dieses Beispiel demonstriert eine nachträgliche
;          Tiefpaßfilterung eines existierenden Videos.
;          Das Video "Film" enthalte beispielsweise eine Folge von
;          zweidimensionalen Arrays (Ausmaße beispielsweise 100x100) von Floats,
;          die Graustufen repräsentieren.
;          Zur Filterung soll eine Gaussmaske des Typs Gauss_2D(11,11)
;          benutzt werden. Dazu muß also jeder Frame des Videos
;          mittels CONVOL() mit dieser Maske gefaltet werden.
;          Der entsprechende Aufruf wäre:
;
;          Remaster, "Film", PROCESS="CONVOL", Gauss_2D(11,11), /EDGE_TRUNCATE
;
;          Man beachte vor allem, daß alle Argumente (ausser dem
;          Videotitel) an die Funktion CONVOL durchgereicht werden.
;          Für jeden einzelnen Frame F des Videos wird durchgeführt:
;                 F = CONVOL( F, Gauss_2D(11,11), /EDGE_TRUNCATE )
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.6  2000/09/28 13:23:28  alshaikh
;              added AIM
;
;        Revision 2.5  1999/02/16 15:46:33  thiel
;               Jetzt auch mit NOLABEL-Keyword.
;
;        Revision 2.4  1998/11/08 14:51:39  saam
;              + video-structure made a handle
;              + ZIP-handling replaced by UOpen[RW]
;
;        Revision 2.3  1998/05/03 12:56:58  kupper
;               HTML-Header-Bug entfernt.
;
;        Revision 2.2  1997/12/10 17:54:26  kupper
;               PROCESS-Keywort implementiert.
;
;        Revision 2.1  1997/12/09 16:21:54  kupper
;               Schöpfung.
;
;-

Pro Remaster, Title, SCALE=scale, NOLABEL=nolabel, $
                PROCESS=process, p1, p2, p3, _EXTRA=_extra

   ON_Error, 2
   
   if (not set(SCALE)) and (not keyword_set(PROCESS)) then $
    message, "Bitte Skalierungsfaktor mit SCALE oder eine Funktion in PROCESS angeben!"

   Video = LoadVideo( Title, /EDIT, $
                      GET_SIZE=FrameSize, GET_TITLE=VideoTitle, GET_LENGTH=VideoLength)

   Handle_Value, Video, tmp, /NO_COPY
   VU =  tmp.unit
   Handle_Value, Video, tmp, /NO_COPY, /SET

   Data = Assoc(VU, Make_Array(SIZE=FrameSize, /NOZERO))

   print, "   ...remastering..."

   if set(SCALE) then for frame=0l, VideoLength-1 do Data(frame) = Data(frame)*scale

   if Keyword_Set(PROCESS) then begin
      if Set(_EXTRA) then begin
         for f=0l, VideoLength-1 do begin
            case n_params() of
               1: Data(f) = Call_Function(process, Data(f), _EXTRA=_extra)
               2: Data(f) = Call_Function(process, Data(f), p1, _EXTRA=_extra)
               3: Data(f) = Call_Function(process, Data(f), p1, p2, _EXTRA=_extra)
               4: Data(f) = Call_Function(process, Data(f), p1, p2, p3, _EXTRA=_extra)
            endcase
         endfor
      endif else begin          ;kein _EXTRA!
         for f=0l, VideoLength-1 do begin
            case n_params() of
               1: Data(f) = Call_Function(process, Data(f))
               2: Data(f) = Call_Function(process, Data(f), p1)
               3: Data(f) = Call_Function(process, Data(f), p1, p2)
               4: Data(f) = Call_Function(process, Data(f), p1, p2, p3)
            endcase
         endfor
      endelse
   endif                        ;PROCESS
         
   Eject, Video, NOLABEL=nolabel

   print
   print, 'Now out: Video "'+VideoTitle+'" in a new DIGITALLY REMASTERED Version!' 

End
