;+
; NAME:
;  ForEach
;
; AIM:
;  iterates a procedure for several loops
;
; PURPOSE: 
;  Performs a special action for various iterations and over several
;  loop variables.
;  The LoopValues have to be given by __TVxxx, the corresponding tag
;  names by __TNxxx in the AP-structure, where xxx may be an arbitrary
;  string.
;
; CATEGORY:
;  MIND / CONTROL ROUTINES
;
; CALLING SEQUENCE:
;  iter = ForEach(procedure [,p1[,p2[,p3[,p4[,p5[,p6[,p7[p8[,p9]]]]]]]]] $
;                           [,LSKIP=lskip] [,LCONST=lconst]
;                           [,SEP=sep]
;                           [,__XX (see below!)]
;                           [,ZZYY (see below!)]
;                           [,SKEL=skel]
;                           [,/W] [,VALUES=values]
;                           [,/FAKE] [,/QUIET] [,_EXTRA=E] )
;
; INPUTS:
;  procedure: the string of the procedure to be performed for each
;             iteration
;
; OPTIONAL INPUTS:
;  p[1-9]: optional arguments for procedure
;
; KEYWORD PARAMETERS:
;  W     : wait for a keystroke after each iteration
;  VALUES: return the index of the tag where the loopcondition resides
;          (does not work at the moment)
;  QUIET : supresses the output of the latest iteration
;  FAKE  : simulates the routine without actually calling procedure
;  LSKIP : various loops in a hierarchie can be skipped, this is
;          especially useful for metaroutines that evaluate data
;          accross multiple iterations. You can specify a scalar or an
;          array of loop indices to be skipped (1 denotes the
;          innermost loop). negative values mean: skip all but this
;          index. Note that the loop is completely omitted (including
;          the filename). See also LCONST.
;  LCONST: While LSKIP skips various loops, LCONST just assumes a
;          constant value for them (the one they currently have). The
;          syntax is the same as for LSKIP.  
;  SEP   : iteration separator for filenames (default '_')
;  SKEL  : string added to filename after iteration info (default '_')
;  __XX  : Loop Variables may be modified/set as keywords. If you have
;          a loop variable ITER, you can change the default value by passing
;          __ITER={whatever_you_like}. ForEach will then use your
;          KeywordOptions.
;  ZZYY  : Keyword values to the client procedure can be dependent on
;          the current value of the loop. IF you want the Keyword
;          MYPARA to have the value of loop PARA, you simply call
;          foreach ZZMYPARA='PARA'. 
;  E     : all other keywords are passed to procedure
;         
; OUTPUTS:
;  iter  : the number of performed iterations 
;
; COMMON BLOCKS:
;  ATTENTION
;
; RESTRICTIONS:
;  all Keywords beginning with __ will not be passed to the client
;  PROCEDURE
; 
; EXAMPLE:
;  see <A HREF=http://neuro.physik.uni-marburg.de/mind/demo#DFOREACH>dforeach</A>
;
; SEE ALSO:
;  <A HREF=http://neuro.physik.uni-marburg.de/mind/control#FAKEEACH>fakeeach</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#INITLOOP>initloop</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#LOOPVALUE>loopvalue</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/control/loops#LOOPTAGS>looptags</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.12  2000/10/03 13:29:57  saam
;     + extended to process several parameters, simultaneously
;     + still undocumented
;
;     Revision 1.11  2000/09/29 08:10:28  saam
;     added the AIM tag
;
;     Revision 1.10  2000/08/14 14:37:14  thiel
;         Added 'SEP'-Keyword to description in header.
;
;     Revision 1.9  2000/08/11 10:24:52  thiel
;         Now it really WAITS for keypress if wanted.
;
;     Revision 1.8  2000/06/08 10:32:13  saam
;           + keyword SKEL added
;
;     Revision 1.7  2000/04/12 13:28:41  saam
;           modified the undocumented I- and OSKIP
;           thing to the more flexible and easier to
;           implement LSKIP/LCONST mechanims
;
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

FUNCTION ForEach, procedure, p1,p2,p3,p4,p5,p6,p7,p8,p9 $
                  , W=w, values=values, ltags=ltags, fake=fake, quiet=quiet $
                  , LSKIP=_lskip, LCONST=_lconst, SKEL=skel, SEP=sep, _EXTRA=e

   COMMON ATTENTION
   
   
   IF ExtraSet(AP.SIMULATION, 'SKEL') THEN Default, skel, AP.SIMULATION.skel ELSE Default, skel, '_'
   IF ExtraSet(AP.SIMULATION, 'SEP') THEN Default, sep, AP.SIMULATION.sep ELSE Default, sep, '_'
   ; scan AP for loop instructions __?
   TST = ExtraDiff(AP, '__TV', /SUBSTRING, /LEAVE) ; temporary 
   TSN = ExtraDiff(AP, '__TN', /SUBSTRING, /LEAVE)
   loopc = N_Tags(TST)



   ; loops : an array containing the indices to be iterated over
   IF Set(_LSKIP) THEN BEGIN            
       IF ((N_Elements(_LSKIP) GT 1) AND (MIN(_LSKIP) LT 1)) THEN Console, 'LSKIP: inverse syntax with multiple arguments ??', /FATAL
       IF (_LSKIP(0) LT 0) THEN BEGIN
           LSKIP=Indgen(loopc)+1
           LSKIP=Diffset(LSKIP, -_LSKIP)
       END ELSE LSKIP = _LSKIP
   END ELSE lskip=!NONE
   
   IF Set(_LCONST) THEN BEGIN            
       IF ((N_Elements(_LCONST) GT 1) AND (MIN(_LCONST) LT 1)) THEN Console, 'LCONST: inverse syntax with multiple arguments ??', /FATAL
       IF (_LCONST(0) LT 0) THEN BEGIN
           LCONST=Indgen(loopc)+1
           LCONST=Diffset(LCONST, -_LCONST)
       END ELSE LCONST = _LCONST
   END ELSE lconst=!NONE
   

   TS = {____XXX : 0}
   FOR i = 0, loopc-1 DO BEGIN
       IF Inset(loopc-i, lconst) THEN BEGIN
           ; get current value for the loop to be set constant
           GetHTag, P, TSN.(i), val
           ; a set the loop containing only this value (for correct filenames...)
           command = "SetTag, TS, '"+StrMid((Tag_Names(TST))(i),4,StrLen((Tag_Names(TST))(i))-4)+"', "+STR(val)
           IF NOT Execute(command) THEN Console, "Execute failed: "+command, /FATAL
       END ELSE BEGIN
           ; set normal loop if not in lskip
           IF NOT Inset(loopc-i, lskip) THEN SetTag, TS, StrMid((Tag_Names(TST))(i),4,StrLen((Tag_Names(TST))(i))-4), TST.(i)  
       END
   END
   DelTag, TS, "____XXX"
       

   ; if the users sets loopvalues on the commandline (or elsewhere)
   uset = ExtraDiff(e, '__', /SUBSTRING)  ; and also removes these keywords!
   IF TYPEOF(uset) EQ 'STRUCT' THEN BEGIN
       FOR i=0, N_Tags(uset)-1 DO BEGIN
           SetTag, TS, StrMid((Tag_Names(uset))(i),2, StrLen((Tag_Names(uset))(i))-2), uset.(i)
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
            P.file = StrCompress(AP.FILE+LoopName(LS,SEP=sep)+skel, /REMOVE_ALL)  ; pname=pname
            ;P.pfile = pname
            ;Set loop values, if requested
            FOR i=0, N_Tags(LV)-1 DO BEGIN
                FOR j=0, N_Elements(TSN.(i))-1 DO BEGIN
                    SetHTag, P, (TSN.(i))(j), REFORM((LV.(i))(j,*))
                END
            END
            
            IF TypeOF(kset) EQ 'STRUCT' THEN BEGIN
                FOR i=0,N_TAGS(kset)-1 DO BEGIN
                    GetHTag, P, kset.(i), val
                    FOR i=0,N_TAGS(kset)-1 DO IF Set(e) THEN SetTag, e, StrMid((Tag_Names(kset))(i),2,strlen((Tag_Names(kset))(i))-2), val $
                                                        ELSE e = Create_Struct(StrMid((Tag_Names(kset))(i),2, StrLen((Tag_Names(kset))(i))-2), val)
                END
            END
            IF NOT Keyword_Set(QUIET) THEN Console, LoopName(LS, /PRINT, SEP=sep)
            
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
            IF Keyword_Set(w) THEN BEGIN
               Console, ' Press any key.', /MSG
               key = Get_KBrd(1)
            ENDIF

            SimTimeStep
            Looping, LS, dizzy
         END UNTIL dizzy
         SimTimeStop
         
      END
      RETURN, iter
   END ELSE BEGIN
      IF NOT Keyword_Set(FAKE) THEN BEGIN
         P = AP
         P.file = Str(AP.FILE+skel)
         
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
