;
; Auto Save File For /.amd/sisko/home/sisko/kupper/IDL/Allerlei/cvs.pro
;



; CODE MODIFICATIONS MADE ABOVE THIS COMMENT WILL BE LOST.
; DO NOT REMOVE THIS COMMENT: BEGIN HEADER

;+
; NAME:
;         CVS
;
; PURPOSE: Einfacheres CVS-Handling
;         
; CATEGORY: Programmierung, NASE
;
; CALLING SEQUENCE: CVS [,CVS_Name] [,NASPATH=Pfad]
; 
; INPUTS: ---
;
; OPTIONAL INPUTS: CVS_Name: Der Name des CVS-Projektes. Default ist "nase"
;	 
; KEYWORD PARAMETERS: NASPATH: Der Pfad, in dem sich das CVS-Directory befindet. Default ist "~/IDL".
;                              Die Defaults verweisen somit auf das CVS-Directory "~/IDL/nase"
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: common_cvs
;                           Dieser Block enthaelt die Variable name, die auf den CVS-Projektnamen gesetzt wird.
;
; SIDE EFFECTS: Die Routine versucht, bei jedem EDIT-Befehl, das zugehörige File im Emacs zu öffnen, sofern dieser läuft und entsprechend eingerichtet ist.
;                          (Dazu muß im .emacs-File die Zeile "(gnuserv-start)" stehen.)
;
; RESTRICTIONS: ---
;
; PROCEDURE: Benutzte Routinen: Default.
;            Das Programm erstellt ein Widget und ruft die entsprechenden cvs-Befehle über "SPAWN" auf.
;            Außerdem spricht es den Emacs über "GnuDoIt" an, und falls das Projekt "nase" heißt, updatet
;            es auch gleich bei jedem commit-Befehl das zentrale Archiv in /usr/ax1303/neuroaedm/nase und
;            ebenfalls das HTML-Helpfile.
;
; EXAMPLE: 1. cvs
;          2. cvs, NASPATH="$HOME/hierstehtnase"
;          3. cvs, "mind", NASPATH="~/nevermind"
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.13  1998/02/18 14:12:23  kupper
;              Verzeichnis hat sich mal wieder geändert...
;
;
;     ------------------------------------------------
;
;       Mon Aug 18 04:49:35 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Tippfehler korrigiert.
;
;       Sun Aug 17 23:42:47 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion fertiggestellt. Sollte voll funktionieren...
;
;-


; DO NOT REMOVE THIS COMMENT: END HEADER
; CODE MODIFICATIONS MADE BELOW THIS COMMENT WILL BE LOST.


; CODE MODIFICATIONS MADE ABOVE THIS COMMENT WILL BE LOST.
; DO NOT REMOVE THIS COMMENT: BEGIN MAIN13


Pro NASE_Special          ;erledigt einige N.A.S.E.-spezifische Dinge (bisher nicht viele...)
   Print
   Print, "=========== Mehr Spaß für N.A.S.E.n:"
   Print, "============= Updating /vol/neuro/nase ..."
   CD, "/vol/neuro/nase", CURRENT=old_dir
   Spawn, "cvs update nase"
   Print, "============= Updating HTML-Help ..."
   CD, "nase"
   MKHTML
   CD, old_dir
   Print, "============= done."
End

PRO MAIN13_Event, Event
common common_cvs, name

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'BUTTON5': BEGIN              ;Update
      Print
      Print, "=========== Updating CVS:"
      Spawn, "cvs update """+Name+""""
      Print, "============= done."
      if name eq "nase" then NASE_Special ;do some nosy things
      END
  'BUTTON25': BEGIN             ;Edit
     n = name
      file = PickFile(TITLE="Select File to Edit", /MUST_EXIST, FILTER="*.pro", PATH=n)
      If file ne "" then begin
         Print
         Print, "=========== Making File Editable: "+file
         Spawn, "cvs edit """+file+""""
         Spawn, "gnudoit -q '(find-file """+file+""")'"
         Print, "============= done."
      endif
      END
  'BUTTON15': BEGIN              ;UnEdit
     n = name
      file = PickFile(TITLE="Select File to UnEdit", /MUST_EXIST, FILTER="*.pro", PATH=n)
      If file ne "" then begin
         Print
         Print, "=========== UnEditing Changes on: "+file
         Spawn, "cvs unedit """+file+""""
         Print, "============= done."
      endif
      END
  'BUTTON19': BEGIN              ;Editors
      Print
      Print, "=========== Current CVS-Editors:"
      Spawn, "cvs editors"
      Print, "============= done."
      END
  'BUTTON35': BEGIN              ;Add
     n = name
      file = PickFile(TITLE="Select File to Add", /MUST_EXIST, FILTER="*.pro", GET_PATH=path, PATH=n)
      If file ne "" then begin
         Print
         Print, "=========== Establishing CVS-Control for: "+file
         parts = str_sep(file, "/")
         file = parts((size(parts))(1)-1); Das gibt den reinen Filenamen ohne Pfad!
         CD, path, CURRENT=olddir
         Spawn, "cvs add """+file+""""
         Spawn, "cvs commit """+file+""""
         CD, olddir
         Print, "============= done."
         if name eq "nase" then NASE_Special ;do some nosy things
      endif
      END
  'BUTTON23': BEGIN              ;Commit All
      Print
      Print, "=========== Committing all your changed CVS-Files:"
      Spawn, "cvs commit"
      Print, "============= done."
      if name eq "nase" then NASE_Special ;do some nosy things
      END
  'BUTTON28': BEGIN              ;Commit File
     n = name
      file = PickFile(TITLE="Select File to Commit", /MUST_EXIST, FILTER="*.pro", PATH=n)
      If file ne "" then begin
         Print
         Print, "=========== Committing File "+file
         Spawn, "cvs commit "+file
         Print, "============= done."
         if name eq "nase" then NASE_Special ;do some nosy things
      endif
   END
  ENDCASE
END


; DO NOT REMOVE THIS COMMENT: END MAIN13
; CODE MODIFICATIONS MADE BELOW THIS COMMENT WILL BE LOST.



PRO cvs, CVS_Name, NASPATH=naspath, GROUP=Group
common common_cvs, name

  default, CVS_Name, "nase"
  default, naspath, "~/IDL"
  name = CVS_Name

  CD, naspath, CURRENT=old_dir

  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

  junk   = { CW_PDMENU_S, flags:0, name:'' }


  MAIN13 = WIDGET_BASE(GROUP_LEADER=Group, $
      MAP=1, $
      TITLE='A Simple ConcurrentVersionSystem Controller', $
      UVALUE='MAIN13', $
      XSIZE=350, $
      YSIZE=364)

  BUTTON5 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON5', $
      VALUE='Update', $
      XOFFSET=10, $
      XSIZE=320, $
      YOFFSET=10)

  BUTTON25 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON25', $
      VALUE='Edit File', $
      XOFFSET=10, $
      XSIZE=150, $
      YOFFSET=90)

  BUTTON15 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON15', $
      VALUE='UnEdit File', $
      XOFFSET=180, $
      XSIZE=150, $
      YOFFSET=90)

  BUTTON19 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON19', $
      VALUE='Show Editors', $
      XOFFSET=70, $
      XSIZE=200, $
      YOFFSET=145)

  BUTTON35 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON35', $
      VALUE='Add File', $
      XOFFSET=100, $
      XSIZE=140, $
      YOFFSET=225)

  BUTTON23 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON23', $
      VALUE='Commit All', $
      XOFFSET=10, $
      XSIZE=150, $
      YOFFSET=305)

  BUTTON28 = WIDGET_BUTTON( MAIN13, $
      FONT='-adobe-helvetica-bold-r-normal--24-240-75-75-p-138-iso8859-1', $
      FRAME=5, $
      UVALUE='BUTTON28', $
      VALUE='Commit File', $
      XOFFSET=180, $
      XSIZE=150, $
      YOFFSET=305)

  WIDGET_CONTROL, MAIN13, /REALIZE

  XMANAGER, 'MAIN13', MAIN13

  CD, old_dir
END
