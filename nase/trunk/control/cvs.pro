;
; Auto Save File For /.amd/sisko/home/sisko/kupper/IDL/Allerlei/cvs.pro
;



; CODE MODIFICATIONS MADE ABOVE THIS COMMENT WILL BE LOST.
; DO NOT REMOVE THIS COMMENT: BEGIN HEADER

;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;	
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-


; DO NOT REMOVE THIS COMMENT: END HEADER
; CODE MODIFICATIONS MADE BELOW THIS COMMENT WILL BE LOST.


; CODE MODIFICATIONS MADE ABOVE THIS COMMENT WILL BE LOST.
; DO NOT REMOVE THIS COMMENT: BEGIN MAIN13


Pro NASE_Special          ;erledigt einige N.A.S.E.-spezifische Dinge (bisher nicht viele...)
   Print
   Print, "----------- Mehr Spaß für N.A.S.E.n:"
   Print, "            Updating /usr/ax1303/neuroadm/nase ..."
   CD, "/usr/ax1303/neuroadm", CURRENT=old_dir
   Spawn, "cvs update nase"
   Print, "            Updating HTML-Help ..."
   MKHTML
   CD, old_dir
End

PRO MAIN13_Event, Event
common common_cvs, name

  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  'BUTTON5': BEGIN              ;Update
      Print
      Print, "----------- Updating CVS:"
      Spawn, "cvs update """+Name+""""
      END
  'BUTTON25': BEGIN             ;Edit
      file = PickFile(TITLE="Select File to Edit", /MUST_EXIST, FILTER="*.pro", PATH=name)
      If file ne "" then begin
         Print
         Print, "----------- Making File Editable: "+file
         Spawn, "cvs edit """+file+""""
         Spawn, "gnudoit -q '(find-file """+file+""")'"
      endif
      END
  'BUTTON15': BEGIN              ;UnEdit
      file = PickFile(TITLE="Select File to UnEdit", /MUST_EXIST, FILTER="*.pro", PATH=name)
      If file ne "" then begin
         Print
         Print, "----------- UnEditing Changes on: "+file
         Spawn, "cvs unedit """+file+""""
      endif
      END
  'BUTTON19': BEGIN              ;Editors
      Print
      Print, "----------- Current CVS-Editors:"
      Spawn, "cvs editors"
      END
  'BUTTON35': BEGIN              ;Add
      file = PickFile(TITLE="Select File to Add", /MUST_EXIST, FILTER="*.pro", GET_PATH=path, PATH=name)
      If file ne "" then begin
         Print
         Print, "----------- Establishing CVS-Control for: "+file
         parts = str_sep(file, "/")
         file = parts((size(parts))(1)-1); Das gibt den reinen Filenamen ohne Pfad!
         CD, path, CURRENT=olddir
         Spawn, "cvs add """+file+""""
         Spawn, "cvs commit "+file+""""
         CD, olddir
      endif
      END
  'BUTTON23': BEGIN              ;Commit All
      Print
      Print, "----------- Committing all your changed CVS-Files:"
      Spawn, "cvs commit"
      if name eq "nase" then NASE_Special ;do some nosy things
      END
  'BUTTON28': BEGIN              ;Commit File
      file = PickFile(TITLE="Select File to Commit", /MUST_EXIST, FILTER="*.pro", PATH=name)
      If file ne "" then begin
         Print
         Print, "----------- Committing File "+file
         Spawn, "cvs commit "+file
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
