;+
; NAME:
;  REM_Init
;
; AIM: Init a structure that chooses image parts in a saccade-like way.
;
; PURPOSE: Vorbereiten einer Struktur, die das Auswaehlen von 
;          Bildausschnitten auf hoffentlich etwas realistischere
;          Weise ermoeglicht. Bildausschnitte werden von der 
;          zugehoerigen Funktion <A HREF="#REM_STEP">REM_Step</A> in festen
;          Abstaenden zufaellig ermittelt (nachempfundene Sakkaden),
;          dazwischen findet nur eine kleine Verschiebung des 
;          Bildausschnittes statt. 
;
; CATEGORY: Simulation / Input
;
; CALLING SEQUENCE: 
;         
;    remstructure = REM_Init(PICARRAY=bildarray,
;                            CUTWIDTH=auschnittsbreite, CUTHEIGHT=ausschnittsheohe, 
;                            SACCTIME=sakkadenintervall 
;                            [, FIXTIME=festzeit]
;                            [, SMALLMOVE=[xrichtung, yrichtung]]
;                            [, INTERESTING=interessant]
;                            [, /FORCE]
;
;
; INPUTS: bildarray : Das Array, aus dem die Ausschnitte ausgesucht werden sollen.
;                     Erlaubt sind sowohl zweidimensionale Arrays (Breite,Hoehe)
;                     als auch dreidimensionale, also Arrays von Bildern
;                     (Breite, Hoehe, Index_des_Bildes)
;         ausschnittsbreite/-hoehe : Breite und Hoehe der zurueckgelieferten 
;                                    Ausschnitte
;         sakkadenintervall : Zeit, die zwischen zwei Sakkaden vergehen
;                             soll. (Zeit bedeutet hier eigentlich die Zahl der
;                             <A HREF="#REM_STEP">REM_Step</A>-Aufrufe.) Nach einem 
;                             Sakkadenintervall ermittelt <A HREF="#REM_STEP">REM_Step</A> einen 
;                             zufaellig gewaehlten Bildausschnitt. 
;
; OPTIONAL INPUTS: festzeit : Zeit, waehrend der derselbe Bildauschnitt ohne
;                             irgendeine Verschiebung zurueckgeliefert wird.
;                             Default = 1, d.h. nach jedem <A HREF="#REM_STEP">REM_Step</A>-Aufruf
;                             findet eine Verschiebung statt.
;                  xrichtung, yrichtung : Verschiebung des Bildausschnitts nach einem 
;                            Festzeit-Intervall. Bei gesetztem FORCE-Schluesselwort
;                            gibt das Array [xrichtung, yrichtung] die jeweilige
;                            Verschiebung an. Ist FORCE nicht gesetzt, wird die Verschiebung
;                            sowohl in X- als auch in Y-Richtung durch eine Zufallszahl aus 
;                            dem Intervall [- abs(richtung),+ abs(richtung)] bestimmt 
;                            (gleichverteilt gezogen). 
;                            Default = [1,1]
;                  interessant : falls das Maximum des nach einer Sakkade ermittelten
;                                Ausschnitts kleiner als der hier angegebene Wert ist,
;                                wird ein neuer Ausschnitt gewaehlt.
;                                Default = Min(bildarray), d.h. jeder Ausschnitt
;                                wird zurueckgeliefert.
;
; KEYWORD PARAMTERES: FORCE: Erzwingt die Verschiebung in die mit x/y-richtung angegebene
;                            Richtung nach einem Festzeitintervall. Vorsicht am Bildrand!
;                            Hier wird eventuell immer der gleiche Ausschnitt zurueckgeliefert,
;                            wenn eine weitere Verschiebung in die angegebene Richtung nicht
;                            moeglich ist.
;
; OUTPUTS: remstructure : Eine Datenstruktur, die spaeter von <A HREF="#REM_STEP">REM_Step</A>
;                         verwendet wird. Enthaelt im einzelnen folgende Tags:
;                         REM_Structure = { ti : 0l ,$                  ; Zahl der REM_Step-Aufrufe
;                                           xp : 0l ,$                  ; Aktueller Ausschnitt
;                                           yp : 0l ,$    
;                                           pa : picarray ,$            ; Das Bild
;                                           pw : (Size(picarray))(1) ,$ ; Bildgroesse
;                                           ph : (Size(picarray))(2) ,$
;                                           cw : cutwidth ,$            
;                                           ch : cutheight ,$
;                                           st : sacctime ,$
;                                           ft : fixtime ,$
;                                           sm : smallmove ,$
;                                           ia : interesting, $
;                                           fo : force }  
;
; SIDE EFFECTS: Das Bildarray wird innerhalb der Struktur gespeichert. 
;               Falls das urspruengliche Bildarray nicht mehr gebraucht wird, 
;               sollte man es loeschen, um Speicherplatz zu sparen. 
;
; PROCEDURE: 1. Syntaxkontrolle
;            2. Defaultwerte belegen
;            3. Bildinformationen ermitteln
;            4. Struktur erzeugen und zurueckgeben
;
; EXAMPLE: bitmap = FadeToGrey(Getenv('NASEPATH')+'/graphic/nonase/alison.bmp')
;          
;          remstruc = REM_Init(PICARRAY=bitmap, CUTWIDTH=50, CUTHEIGHT=50, $
;                              SACCTIME=5, FIXTIME=1, SMALLMOVE=[5,5])
;
;          bitmap = 0
;
;          FOR t=1,20 DO BEGIN
;             a = REM_Step(remstruc)
;             utvscl, a, stretch=10
;             IF remstruc.ti MOD 5 EQ 1 THEN print, 'Saccade!' ELSE print, 'Small Movement.'
;             dummy = get_kbrd(1)
;          ENDFOR
;
; SEE ALSO: <A HREF="#REM_STEP">REM_Step</A>
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/09/25 14:30:24  thiel
;            Added AIMS.
;
;        Revision 2.2  1998/05/11 13:32:21  thiel
;               Neues Schluesselwort FORCE
;
;        Revision 2.1  1998/04/09 14:02:45  thiel
;               Da wird sich der Mike Stipe freuen...
;


FUNCTION REM_Init, PICARRAY=picarray, $
              CUTWIDTH=cutwidth, CUTHEIGHT=cutheight, $
              SACCTIME=sacctime, FIXTIME=fixtime, $
              SMALLMOVE=smallmove, $
              INTERESTING=interesting, $
              FORCE=force



IF NOT Set(PICARRAY) THEN Message, 'Specify picture-array.'
IF NOT Set(CUTWIDTH) OR NOT Set(CUTHEIGHT) THEN Message, 'Specify width and height.'
IF NOT Set(SACCTIME) THEN Message, 'Specify Saccade-Interval.'

Default, fixtime, 1
Default, smallmove, [1,1]
Default, interesting, Min(picarray)
Default, force, 0

picheight = (Size(picarray))(2)
picwidth = (Size(picarray))(1)

REM_Structure = { ti : 0l ,$
                  xp : 0l ,$
                  yp : 0l ,$
                  pa : picarray ,$
                  pw : (Size(picarray))(1) ,$
                  ph : (Size(picarray))(2) ,$
                  cw : cutwidth ,$
                  ch : cutheight ,$
                  st : sacctime ,$
                  ft : fixtime ,$
                  sm : smallmove ,$
                  ia : interesting, $
                  fo : force}

RETURN, REM_Structure

END
