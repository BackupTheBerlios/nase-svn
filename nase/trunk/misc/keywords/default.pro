;+
; NAME:             Default
;
; AIM:              defines a default value for an unspecified parameter
;
; PURPOSE:          Sets a variable VAR to specified value VAL, if VAR is
;                   undefined. If defined, the variable will not be touched.
;                   This procedure is often used to define default
;                   values for unspecified keywords in functions or procedures.
;
; CATEGORY:         MISC KEYWORDS
;
; CALLING SEQUENCE: Default, VAR, VAL
;
; INPUTS:           VAR: If undefined, VAR will be set to
;                        VAL. Otherwise nothing is done.
;                   VAL: Default value for VAR
;
; EXAMPLE:          
;                   IDL> print, title
;                   % PRINT: Variable is undefined: TITLE.
;                   IDL> Default, title, 'Ghostdog'
;                   IDL> print, title
;                   Ghostdog
;                   IDL> Default, title, 'Dead Man'
;                   IDL> print, title
;                   Ghostdog
; 
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  2000/09/25 09:13:08  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.5  2000/06/21 14:33:34  saam
;              + corrected a silly typo
;
;        Revision 1.4  2000/06/21 14:07:22  saam
;              + translated & updated docheader
;
;        Revision 1.3  1997/11/04 12:25:07  kupper
;               Nur Dokumentation in den Header geschrieben!
;
;
;               Seit Version 1.2 kann sowohl die erste als
;                auch die zweite Variable undefiniert
;                sein, ohne daﬂ ein Fehler auftritt.
;

PRO default, var, val

IF (n_elements(var) EQ 0) and (n_elements(val) ne 0) then var = val

END
