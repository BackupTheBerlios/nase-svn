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
;                                     [,ISKIP=iskip] [,OSKIP=oskip]
;                                     [,__XX (see below!)]
;                                     [,ZZYY (see below!)]
;                                     [,/W] [,VALUES=values]
;                                     [,/FAKE] [,/QUIET] [,_EXTRA=e] )
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
;                             negative values mean: skip all but  
;                     __XX  : Loop Variables may be modified/set as
;                             Keywords. If you have a loop variable
;                             ITER, you can change the default value by passing
;                             __ITER={whatever_you_like}. ForEach will
;                             then use your KeywordOptions.
;                     ZZYY  : Keyword values to the client procedure can be
;                             dependent on the current value of the
;                             loop. IF you want the Keyword MYPARA to have
;                             the value of loop PARA, you simply call
;                             foreach ZZMYPARA='PARA'. 
; 
;         
;
; OUTPUTS:            iter  : the number of performed iterations 
;
; COMMON BLOCKS:      ATTENTION
;
; RESTRICTIONS:       all Keywords beginning with __ will not be
;                     passed to the client PROCEDURE 
;
; EXAMPLE:            see <A HREF=http://neuro.physik.uni-marburg.de/mind/demo#DFOREACH>dforeach</A>
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FAKEEACH>fakeeach</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#INITLOOP>initloop</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#LOOPVALUE>loopvalue</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#LOOPTAGS>looptags</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  2000/04/06 09:32:13  saam
;           new keyword setting system
;
;     Revision 1.5  2000/04/04 15:05:18  saam
;           added the Commandline modification tool
;           by keywords __
;
;     Revision 1.4  2000/04/04 13:35:44  saam
;           + ISKIP and OSKIP now takes negative values
;           + handle/struct story now works and is put to NASE
;             routines [G|S]etHTag
;           + pname keyword eliminated
;
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
FUNCTION ForEach, procedure, p1,p2,p3,p4,p5,p6,p7,p8,p9, w=w, values=values, ltags=ltags, fake=fake, quiet=quiet,$; setvalues=setvalues ,$;, pname=pname, $
                  ISKIP=_iskip, OSKIP=_oskip, _EXTRA=e

   COMMON ATTENTION
   
   
   ; scan AP for loop instructions __?
   TST = ExtraDiff(AP, '__TV', /SUBSTRING, /LEAVE) ; temporary 
   TSN = ExtraDiff(AP, '__TN', /SUBSTRING, /LEAVE)
   loops = N_Tags(TST)
   

   Default, _ISKIP, 0
   IF _ISKIP LT 0 THEN ISKIP = loops+_iskip ELSE ISKIP = _iskip
   IF (ISKIP GT loops) THEN Console, 'skipping more inner loops ('+STR(ISKIP)+') than currently availible ('+STR(loops)+')', /FATAL
   IF ISKIP GT 0 THEN Console, 'skipping '+STR(ISKIP)+' inner loop hierarchy/ies'

   Default, _OSKIP, 0
   IF _OSKIP LT 0 THEN OSKIP = loops+_oskip ELSE OSKIP = _oskip
   IF (OSKIP GT loops) THEN Console, 'skipping more outer loops ('+STR(OSKIP)+') than currently availible ('+STR(loops)+')', /FATAL
   IF OSKIP GT 0 THEN Console, 'skipping '+STR(OSKIP)+' outer loop hierarchy/ies'

   IF ISKIP+OSKIP GT loops THEN Console, 'skipping more than available', /WARN

   ; cut that __TV stuff away
   ; set skipped loops to their current values
   TS = {____XXX : 0}
   FOR i=0,OSKIP-1 DO BEGIN
       ; get current value for the loop to be ignored
       GetHTag, P, TSN.(i), val
       ; a set a loop containing only this value for correct filenames...
       command = "SetTag, TS, '"+StrMid((Tag_Names(TST))(i),4)+"', "+STR(val)
       IF NOT Execute(command) THEN Console, "Execute failed: "+command, /FATAL
   END
   FOR i=OSKIP, N_TAGS(TST)-1-ISKIP DO SetTag, TS, StrMid((Tag_Names(TST))(i),4), TST.(i)
   DelTag, TS, "____XXX"


   ; if the users sets loopvalues on the commandline (or elsewhere)
   uset = ExtraDiff(e, '__', /SUBSTRING)  ; and also removes these keywords!
   IF TYPEOF(uset) EQ 'STRUCT' THEN BEGIN
       FOR i=0, N_Tags(uset)-1 DO BEGIN
           SetTag, TS, StrMid((Tag_Names(uset))(i),2), uset.(i)
       END
   END

   ; if the users sets keyword parameters on the commandline (or elsewhere)
   kset = ExtraDiff(e, 'ZZ', /SUBSTRING)  ; and also removes these keywords!



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
            P.file = StrCompress(AP.FILE+LoopName(LS), /REMOVE_ALL)  ; pname=pname
            ;P.pfile = pname
            ;Set loop values, if requested
            FOR i=0, N_Tags(LV)-1 DO BEGIN
                SetHTag, P, TSN.(i), LV.(i)
            END
            
            IF TypeOF(kset) EQ 'STRUCT' THEN BEGIN
                FOR i=0,N_TAGS(kset)-1 DO BEGIN
                    GetHTag, P, kset.(i), val
                    FOR i=0,N_TAGS(kset)-1 DO IF Set(e) THEN SetTag, e, StrMid((Tag_Names(kset))(i),2), val $
                                                        ELSE e = Create_Struct(StrMid((Tag_Names(kset))(i),2), val)
                END
            END
            IF NOT Keyword_Set(QUIET) THEN Console, LoopName(LS, /PRINT)
            
;            IF Keyword_Set(SETVALUES) THEN BEGIN
;               IF Set(E) THEN newextra = Create_Struct(e, 'LOOPVALUE', LV) ELSE newextra = {LOOPVALUE : LV}
;            END ELSE 
            IF SET(E) THEN newextra = e
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
