;+
; NAME: REM_Step
;
; PURPOSE: Eine Funktion, die das Auswaehlen von Bildausschnitten 
;          auf hoffentlich etwas realistischere Weise ermoeglicht. 
;          Bildausschnitte werden in festen Abstaenden zufaellig 
;          ermittelt (nachempfundene Sakkaden), dazwischen findet 
;          nur eine kleine Verschiebung des Bildausschnittes statt. 
;
; CATEGORY: INPUT
;
; CALLING SEQUENCE: nextcut = REM_Step(remstructure)
;
; INPUTS: remstructure : Struktur, die mit <A HREF="#REM_INIT">REM_Init</A>
;                        geschaffen wurde.
;
; OUTPUTS: nextcut : Ein Ausschnitt aus dem bei der <A HREF="#REM_INIT">REM_Init</A>tialisierung
;                    bestimmten Arrays.
;
; PROCEDURE: 1. Wieviel REM-Steps wurden bisher ausgefuehrt?
;               mehr als SaccTime => zufaelliger Ausschnitt
;               mehr als FixTime  => leicht verschobener Ausschnitt
;               sonst => gleicher Ausschnitt
;            2. gucken, ob der Ausschnitt auch passt
;            3. aktualisieren
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
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  1998/06/24 13:12:20  thiel
;               Bugfix: Jetzt keine Positionen kleiner 0 mehr m"oglich.
;
;        Revision 2.2  1998/05/11 13:32:20  thiel
;               Neues Schluesselwort FORCE
;
;        Revision 2.1  1998/04/09 14:21:17  thiel
;               Michael Stipe laesst gruessen...
;
;-

FUNCTION REM_Step, REM_Structure

COMMON Common_Random, seed

IF (REM_Structure.ti MOD REM_Structure.st) EQ 0 THEN BEGIN
   REPEAT BEGIN
      xpos = Floor((REM_Structure.pw-REM_Structure.cw)*RandomU(seed))
      ypos = Floor((REM_Structure.ph-REM_Structure.ch)*RandomU(seed))
      ausschnitt = REM_Structure.pa(XPos:Xpos+REM_Structure.cw-1,YPos:Ypos+REM_Structure.ch-1,*)
   ENDREP UNTIL Max(ausschnitt) GE REM_Structure.ia
   REM_Structure.ti = 1l
   REM_Structure.xp = xpos
   REM_Structure.yp = ypos
   Return, ausschnitt
ENDIF ELSE BEGIN
   IF (REM_Structure.ti MOD REM_Structure.ft) EQ 0 THEN BEGIN
      xpos = REM_Structure.xp + (1-REM_Structure.fo)*(Round((2.0*RandomU(seed)-1.0)*Abs(REM_Structure.sm(0)))) + (REM_Structure.fo)*(REM_Structure.sm(0))
      ypos = REM_Structure.yp + (1-REM_Structure.fo)*(Round((2.0*RandomU(seed)-1.0)*Abs(REM_Structure.sm(1)))) + (REM_Structure.fo)*(REM_Structure.sm(1))
   ENDIF ELSE BEGIN
      xpos = REM_Structure.xp
      ypos = REM_Structure.yp
   ENDELSE
ENDELSE

xpos = xpos < (REM_Structure.pw-REM_Structure.cw-1) > 0
ypos = ypos < (REM_Structure.ph-REM_Structure.ch-1) > 0

ausschnitt = REM_Structure.pa(XPos:Xpos+REM_Structure.cw-1,YPos:Ypos+REM_Structure.ch-1,*)

REM_Structure.ti = REM_Structure.ti+1 
REM_Structure.xp = xpos
REM_Structure.yp = ypos

Return, ausschnitt

END
