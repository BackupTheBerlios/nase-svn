;+
; NAME:               FreeRecall
;
; PURPOSE:            FreeRecall gibt den, von einer Recall-Struktur allokierten Speicherplatz wieder frei 
;                     
; CATEGORY:           SIMULATION PLASTICITY
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
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 2.1  1997/12/10 15:55:04  saam
;            Birth
;
;
;-

PRO FreeRecall, _LP

   Handle_Free, _LP

END
