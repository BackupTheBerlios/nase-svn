;+
; NAME:                FreeLearn
;
; PURPOSE:             Frees dynamic memory used by LEARN. This routine
;                      is called from SIM. It makes nearly no sense to call it directly.
;
; CATEGORY:            MIND SIM INTERNAL
;
; COMMON BLOCKS:
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#INITLEARN>initlearn</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#LEARN>learn</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/08/11 14:09:31  thiel
;         Now supports freeing for EXTERN rules.
;
;     Revision 1.1  1999/12/10 09:36:46  saam
;           * hope these are all routines needed
;           * no test, yet
;
;
;-
PRO FreeLearn, _LS

   Handle_Value, _LS, LS, /NO_COPY

   ; CLOSE VIDEO
   Eject, LS._vidDist, /NOLABEL, /SHUTUP
   DelTag, LS, '_VIDDIST'

   ; FREE PLOT
   FreePlotcilloscope, LS._PCW
   DelTag, LS, '_PCW'

   ; FREE LEARNING INFOS
   IF InSet(LS.TYPE, [1,2]) THEN BEGIN
      FreeRecall, LS._WIN
      DelTag, LS, '_WIN'
   END ELSE IF LS.TYPE EQ 3 THEN BEGIN
      DelTag, LS, '_WIN'
      DelTag, LS, '_WIN2'
   END ELSE IF LS.TYPE EQ 4 THEN BEGIN
      name = LS.FREE.NAME
      CALL_PROCEDURE, name, LS._WIN
      DelTag, LS, '_WIN'
   END ELSE Message, 'unknown Learning Rule'
   DelTag, LS, 'TYPE'

   ; FREE LOOP CONTROL DATA
   CASE LS.cTYPE OF 
      1: BEGIN
         DelTag, LS, '_CONTROLLER'
         DelTag, LS, '_CONT_MW'
         FreePlotcilloscope, LS._PCLC
         DelTag, LS, '_PCLC'
      END
      ELSE: dummy = 1
   END
   DelTag, LS, 'CTYPE'

   ; FREE WEIGHT CONVERGENCE INFO
   DelTag, LS, '_DISTMAT'

   Handle_Value, _LS, LS, /NO_COPY, /SET
END
