;+
; NAME:
;  FreeLearn
;
; VERSION:
;   $Id$
;
; AIM:
;  Cleans up after learning (used by <A>Sim</A>).
;
; PURPOSE:
;  Free dynamic memory used by the learning rule in a MIND
;  simulation. This routine is called from SIM. It makes nearly no
;  sense to call it directly.
;
; CATEGORY:
;  Internal
;  MIND
;  Plasticity
;  Simulation
;
; SEE ALSO: 
;  <A>Sim</A>, <A>InitLearn</A>, <A>Learn</A>.
;-



PRO FreeLearn, _LS

   Handle_Value, _LS, LS, /NO_COPY

   IF ls.reccon GT 0 THEN BEGIN
      ;; CLOSE VIDEO
      Eject, LS._vidDist, /NOLABEL, /SHUTUP
      DelTag, LS, '_VIDDIST'

      ;; FREE PLOT
      FreePlotcilloscope, LS._PCW
      DelTag, LS, '_PCW'
   ENDIF ;; ls.reccon GT 0

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
