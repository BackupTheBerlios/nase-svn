;+
; NAME: Remaster
;
; PURPOSE: Nachbearbeitung eines (abgeschlossenen) Arrayvideos
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Remaster, {Title | TITLE=VideoTitel} ,SCALE=Faktor
;
; INPUTS: Title: Filename und Videotitel. Dieser Parameter hat
;                      exakt die gleiche Funktion wie das
;                      TITLE-Keyword. Nur eines von beiden muß (und
;                      sollte) angegeben werden! (Bzw. keines für den Defaulttitel.)
;
; KEYWORD PARAMETERS: TITLE: Filename, der auch der Videotitel ist.
;                            Wird weder Title noch TITLE angegeben, so
;                            wird der Defaulttitel benutzt.
;
; SIDE EFFECTS: Der Videoinhalt wird entsprechend verändert.
;
; RESTRICTIONS: Bisher ist nur die SCALE-Option implementiert, und die
;               funktioniert natürlich nur bei numerischen Daten.
;
; PROCEDURE: Auf ein Assoziiertes Array frameweise die entsprechende
;            Operation anwenden.
;
; EXAMPLE: My_Video = InitVideo( 0.0, "TestVideo" )
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
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1997/12/09 16:21:54  kupper
;               Schöpfung.
;
;-

Pro Remaster, _Title, TITLE=__title, SCALE=scale

   if not set(SCALE) then message, "Bitte Skalierungsfaktor mit SCALE angeben!"

   Video = LoadVideo( _Title, TITLE=__title, /EDIT, $
                      GET_SIZE=FrameSize, GET_TITLE=VideoTitle, GET_LENGTH=VideoLength)
   Data = Assoc(Video.unit, Make_Array(SIZE=FrameSize, /NOZERO))

   for frame=0, VideoLength-1 do Data(frame) = Data(frame)*scale

   Eject, Video

   message, /INFORM, 'Now out: Video "'+VideoTitle+'" in a new DIGITALLY REMASTERED Version!' 

End
