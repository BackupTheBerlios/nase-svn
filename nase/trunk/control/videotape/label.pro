;+
; NAME: Label
;
; PURPOSE: Anf�gen eines Label-Textes an ein erstelltes und
;          geschlossenes Array-Video.
;          Besitzt das Video bereits ein Label, so wird dieses
;          entsprechend erweiter.
;
;          Sofern nicht das FILE-Keyword (s.u.) benutzt wird, ruft
;          diese Prozedur zur interaktiven Eingabe den Editor auf, der
;          in der $EDITOR-Umgebungsvariablen definiert ist. Falls
;          diese Variable nicht existiert, wird vi aufgerufen.
;
; CATEGORY: Simulation
; 
; CALLING SEQUENCE: Label [,Title | TITLE] [,FILE] [,TEMPLATE]
;
; OPTIONAL INPUTS: Title : hat dieselbe Fubktion wie TITLE! (s.u.)
;	
; KEYWORD PARAMETERS:         TITLE: Filename (und Titel) des Videos
;                              FILE: Ein Textfile, in dem das Label
;                                    gespeichert wurde (also keine
;                                    interaktive Eingabe!)
;                          TEMPLATE: Ein Textfile, das als Template
;                                    f�r die interaktive Eingabe
;                                    benutzt wird.
;
; SIDE EFFECTS: Erzeugt tempor�re Files namens LABEL_TEMP.label und
;               LABEL_NEW.vidinf im aktuellen Verzeichnis. Dort mu�
;               also Schreibrecht bestehen!
;
; RESTRICTIONS: Schreibrecht im aktuellen Verzeichnis mu� bestehen!
;
;               Man beachte, da� '~' als Abk�rzung f�r das
;               Homeverzeichnis nicht funktioniert, da die Strings in
;               Anf�hrungszeichen �bergeben werden.
;
;               Das Videofile mu� auf jeden fall mit Eject geschlossen
;               sein, bevor man Label aufruft!
;
; PROCEDURE: Die ganze Prozedur ist rein UNIX-basiert (lauter
;            Spawn-Befehle), auf dieser Basis aber straightforward.
;
; EXAMPLE: Label, 'The quiet Neuron', TEMPLATE='leeres Label.txt'
;
; MODIFICATION HISTORY:
;
;       Tue Sep 9 15:52:44 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro Label, _Title, TITLE=title, FILE=file, TEMPLATE=template

   Default, title, _Title
   Default, title, 'The Spiking Neuron'

   title = title+'.vidinf'


   If Keyword_Set(FILE) then begin
      Spawn, "cp '"+file+"' LABEL_TEMP.label"
   endif else begin
      If keyword_Set(TEMPLATE) then Spawn, "cp '"+template+"' LABEL_TEMP.label" 
      
      editor = GetEnv('EDITOR')
      If editor eq '' then editor = 'vi'
      
      Spawn, editor+" LABEL_TEMP.label"
   endelse

   Spawn, "cat '"+title+"' LABEL_TEMP.label > LABEL_NEW.vidinf"

   Spawn, "cp LABEL_NEW.vidinf '"+title+"'"

   Spawn, 'rm LABEL_NEW.vidinf'
   Spawn, 'rm LABEL_TEMP.label'

End
