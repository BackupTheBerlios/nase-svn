;+
; NAME:
;  FreeRecall
;
; AIM: Free memory allocated by Recall or Precall structure.
;
; PURPOSE:            FreeRecall gibt den, von einer Recall-Struktur allokierten Speicherplatz wieder frei 
;                     
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE:   FreeRecall, LP
;
; INPUTS:             LP: eine mit InitRecall initialisierte Struktur
;
; EXAMPLE:
;                     LAYER = InitLayer_1(...)
;                     LP = InitRecall( LAYER, EXPO=[1.0, 10.0])
;                     FreeRecall, LP
;
; SEE ALSO:           <A HREF="#INITRECALL">InitRecall</A>, <A HREF="#TOTALRECALL">TotalRecall</A>
;
;-
;
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 2.2  2000/09/26 15:13:43  thiel
;          AIMS added.
;
;      Revision 2.1  1997/12/10 15:55:04  saam
;            Birth
;


PRO FreeRecall, _LP

   Handle_Free, _LP

END
