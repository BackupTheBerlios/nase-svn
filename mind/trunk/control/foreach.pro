;+
; NAME:               ForEach
;
; PURPOSE:            Performs a special action for various iterations and over several loop
;                     variables.
;                     The LoopValues have to be given by __TVxxx, the corresponding tag names by
;                     __TNxxx in the AP-structure, where xxx may be an arbitrary string.
;
; CATEGORY:           MIND CONTROL
;
; CALLING SEQUENCE:   iter = ForEach(procedure [,p1 [,p2 [,p3 [,p4 [,p5 [,p6 [,p7 [p8 [,p9]]]]]]]]] $
;                                     [,ISKIP=iskip] [,OSKIP=oskip] [,/W] [,VALUES=values] [,/FAKE] [,/QUIET] [,_EXTRA=e] )
;
; INPUTS:             procedure: the string of the procedure to be performed for each iteration
;
; OPTIONAL INPUTS:    p[1-9]: optional arguments for procedure
;
; KEYWORD PARAMETERS: W     : wait for a keystroke after each iteration
;                     VALUES: return the index of the tag where the loopcondition resides (does not work at the moment)
;                     QUIET : supresses the output of the latest iteration
;                     FAKE  : simulates the routine without actually calling procedure
;                     E     : all other keywords are passed to procedure
;                     ISKIP ,
;                     OSKIP : skips the specified number of inner and
;                             outer loop hierarchies, this is
;                             espacially useful for metaroutines that
;                             evaluate data accross multiple iterations
;
; OUTPUTS:            iter  : the number of performed iterations 
;
; COMMON BLOCKS:      ATTENTION
;
; EXAMPLE:            see <A HREF=http://neuro.physik.uni-marburg.de/mind/demo#DFOREACH>dforeach</A>
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FAKEEACH>fakeeach</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#INITLOOP>initloop</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#LOOPVALUE>loopvalue</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#LOOPTAGS>looptags</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/04/03 12:50:57  saam
;           added ISKIP and OSKIP to skip loop hierarchies
;
;     Revision 1.2  1999/12/21 09:42:03  saam
;           docheader now includes fakeeach
;
;     Revision 1.1  1999/12/08 14:38:32  saam
;           not fully documented YET (handle/value missing)
;
;
;-
FUNCTION ForEach, procedure, p1,p2,p3,p4,p5,p6,p7,p8,p9, w=w, values=values, ltags=ltags, fake=fake, quiet=quiet, setvalues=setvalues, pname=pname, $
                  ISKIP=iskip, OSKIP=oskip, _EXTRA=e

   COMMON ATTENTION
   
   
   ; scan AP for loop instructions __?
   TST = ExtraDiff(AP, '__TV', /SUBSTRING, /LEAVE) ; temporary 
   TSN = ExtraDiff(AP, '__TN', /SUBSTRING, /LEAVE)
   
   
   Default, ISKIP, 0
   IF (ISKIP GT N_Tags(TST)) THEN Console, 'skipping more inner loops ('+STR(ISKIP)+') than currently availible ('+STR(N_TAGS(TST))+')', /FATAL
   IF ISKIP GT 0 THEN Console, 'skipping '+STR(ISKIP)+' inner loop hierarchy/ies'

   Default, OSKIP, 0
   IF (OSKIP GT N_Tags(TST)) THEN Console, 'skipping more outer loops ('+STR(OSKIP)+') than currently availible ('+STR(N_TAGS(TST))+')', /FATAL
   IF OSKIP GT 0 THEN Console, 'skipping '+STR(OSKIP)+' outer loop hierarchy/ies'

   IF ISKIP+OSKIP GT N_TAGS(TST) THEN Console, 'skipping more than available', /WARN

   ; cut that __TV stuff away
   TS = {____XXX : 0}
   FOR i=0+OSKIP, N_TAGS(TST)-1-ISKIP DO BEGIN
       SetTag, TS, StrMid((Tag_Names(TST))(i),4), TST.(i)
   END
   DelTag, TS, "____XXX"


   ltags = 0
   IF TYPEof(TS) EQ 'STRUCT' THEN BEGIN
      LS = InitLoop(TS)
      iter = LoopIter(LS)
      
      SimTimeInit, /PRINT, MAXSTEPS=iter, /CLEAR
      
      lt_c = LoopTags(LS, ltags)
      ltags = TagPos(P, (Tag_Names(TS))(ltags))
      IF Set(values) THEN BEGIN
         Message, 'keyword VALUES currently out of order'
      END
      IF LT_c NE 0 THEN ltags = [LT_c, ltags] ELSE ltags = [LT_c]
      IF NOT Keyword_Set(FAKE) THEN BEGIN
         REPEAT BEGIN
            LV = LoopValue(LS)
            
            ;ATTENTION
            P = AP
            P.file = StrCompress(AP.FILE+LoopName(LS, pname=pname), /REMOVE_ALL)
            P.pfile = pname
            ;Set values
            FOR i=0, N_Tags(LV)-1 DO BEGIN
               coms = Str_Sep(TSN.(i), '/')
               IF N_Elements(coms) EQ 1 THEN BEGIN ;old syntax
                  command = "P."+STRING(coms(0))+" = "+STRING(LV.(i))
                  IF NOT Execute(command) THEN Message, 'Strange...execution (old) failed'
               END ELSE IF N_Elements(coms) EQ 2 THEN BEGIN ;latest syntax                  
                  ;use if handle
                  command = "Handle_Value, P."+STRING(coms(1))+", xxx"
                  IF NOT Execute(command) THEN Message, 'Strange...execution (new1) failed'
                  command = "xxx."+STR(coms(0))+" = "+STRING(LV.(i))
                  IF NOT Execute(command) THEN Message, 'Strange...execution (new2) failed'
                  command = "Handle_Value, P."+STRING(coms(1))+", xxx, /SET"
                  IF NOT Execute(command) THEN Message, 'Strange...execution (new3) failed'
               END ELSE IF N_Elements(coms) EQ 3 THEN BEGIN
                  command = "P."+STRING(coms(1))+"."+STRING(coms(0))+" = "+STRING(LV.(i))
                  IF NOT Execute(command) THEN Message, 'Strange...execution (new4) failed'
               END ELSE Message, 'syntax error in loop variable description'
            END
            
            
            IF NOT Keyword_Set(QUIET) THEN Console, LoopName(LS, /PRINT)
            
            IF Keyword_Set(SETVALUES) THEN BEGIN
               IF Set(E) THEN newextra = Create_Struct(e, 'LOOPVALUE', LV) ELSE newextra = {LOOPVALUE : LV}
            END ELSE IF SET(E) THEN newextra = e
            CASE N_Params() OF
               1: CALL_PROCEDURE, procedure,_EXTRA=newextra
               2: CALL_PROCEDURE, procedure,p1,_EXTRA=newextra
               3: CALL_PROCEDURE, procedure,p1,p2,_EXTRA=newextra
               4: CALL_PROCEDURE, procedure,p1,p2,p3,_EXTRA=newextra
               5: CALL_PROCEDURE, procedure,p1,p2,p3,p4,_EXTRA=newextra
               6: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,_EXTRA=newextra
               7: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,_EXTRA=newextra
               8: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,p7,_EXTRA=newextra
               9: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,p7,p8,_EXTRA=newextra
               10: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,p7,p8,p9,_EXTRA=newextra
            END
            IF Keyword_Set(w) THEN Waiting
            SimTimeStep
            Looping, LS, dizzy
         END UNTIL dizzy
         SimTimeStop
         
      END
      RETURN, iter
   END ELSE BEGIN
      IF NOT Keyword_Set(FAKE) THEN BEGIN
         P = AP
         P.file = Str(AP.FILE+'_')
         P.pfile = Str(AP.pFILE+'_')
         
         CASE N_Params() OF
            1: CALL_PROCEDURE, procedure,_EXTRA=e
            2: CALL_PROCEDURE, procedure,p1,_EXTRA=e
            3: CALL_PROCEDURE, procedure,p1,p2,_EXTRA=e
            4: CALL_PROCEDURE, procedure,p1,p2,p3,_EXTRA=e
            5: CALL_PROCEDURE, procedure,p1,p2,p3,p4,_EXTRA=e
            6: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,_EXTRA=e
            7: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,_EXTRA=e
            8: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,p7,_EXTRA=e
            9: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,p7,p8,_EXTRA=e
            10: CALL_PROCEDURE, procedure,p1,p2,p3,p4,p5,p6,p7,p8,p9,_EXTRA=e
         END
      END
      RETURN, 0
   END
END
