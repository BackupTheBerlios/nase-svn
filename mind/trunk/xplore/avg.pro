;+
; NAME:                     AVG
;  
; PURPOSE:                  Computes the Moment of data iterated
;                           over a certain loop variable.
;
; CATEGORY:                 MIND XPLORE
;                            
; CALLING SEQUENCE:         AVG [,FILE=file] [,LOOP=loop] [,/S]
;  
; KEYWORD PARAMETERS:       file   : file suffix appended loop
;                                    specific values
;                           loop   : the index of the loop to be
;                                    iterated over, 1 denotes the
;                                    most inner loop (Default: 1)
;                           S      : previously calculated results
;                                    will be shown
;  
; OUTPUTS:                  written to file ( *FILE.avg.vid* )
;  
; COMMON BLOCKS:            ATTENTION: simulation parameters
;                           SH_AVG   : sheet organization
;  
; SEE ALSO:                 CorrIndex
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/06/20 13:21:38  saam
;              + changed internal file format
;              + slightly changed figure captions
;
;        Revision 1.1  2000/04/07 09:45:11  saam
;              wow, i got it
;
;
;
PRO _AVG, FILE=file, LAYER=layer, VIDEO=v

COMMON ATTENTION

Default, file, ''

Video = LoadVideo( TITLE=P.File+file, GET_SIZE=anz, GET_LENGTH=max_time, /SHUTUP, ERROR=error)
IF Error THEN BEGIN
    Console, 'data doesnt exist...'+P.File+file, /WARN
    Console, 'READSIM: stopping', /FATAL
END
val = Replay(Video)
Eject, Video, /SHUTUP

dummy = CamCord(V, [UMoment(val), N_ELEMENTS(val)])

END


FUNCTION _RAVG, FILE=file, LAYER=layer, INFO=info

COMMON ATTENTION

Default, file, ''
Default, layer, 0

Video = LoadVideo( TITLE=P.File+FILE+'.avg', GET_SIZE=anz, GET_LENGTH=iter, GET_COMPANY=info, /SHUTUP, ERROR=error)
IF Error THEN BEGIN
    Console, 'data doesnt exist...'+P.File+File+'.avg', /WARN
    Console, 'READSIM: stopping', /FATAL
END

nanz = [anz(0)+1, iter, anz(1:anz(0)), anz(anz(0)+1), anz(anz(0)+2)*iter]
vals = Make_Array(SIZE=nanz)
FOR i=0, iter-1 DO vals(i,*) = Replay(Video)
Eject, Video, /SHUTUP

RETURN, vals
END




PRO _SAVG, FILE=file, LAYER=layer, TITLE=title, LO=lo, _EXTRA=e

COMMON ATTENTION
COMMON SH_AVG, AVGwins, AVG_1

Default, File, ''
Default, layer, 0
Default, Title, ''
Title = Title + '(AVG)'

;----->
;-----> ORGANIZE THE SHEETS
;----->
IF ExtraSet(e, 'NEWWIN') THEN BEGIN
    DestroySheet, AVG_1
    AVGwins = 0
END
IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
    AVG_1 = DefineSheet(/NULL)
    AVGwins = 0
END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
    AVG_1 = DefineSheet(/PS, /ENCAPSULATED, FILENAME=P.File+'cclfpm')
    AVGwins = 0
END ELSE BEGIN
    IF (SIZE(AVGwins))(1) EQ 0 THEN BEGIN
        AVG_1 = DefineSheet(/Window, XSIZE=400, YSIZE=300, TITLE='AVG')
        AVGwins = 1
    END
END


vals=_RAVG(FILE=file, INFO=info)
sd = sqrt(vals(*,1))

OpenSheet, AVG_1
abszissa = ValEach(LCONST=-lo)
Plot, abszissa, REFORM(vals(*,0)), TITLE=title, _EXTRA=e
Errplot, abszissa, REFORM(vals(*,0))-sd, REFORM(vals(*,0))+sd
Inscription, 'N = '+STR(LONG(vals(0,4))), /INSIDE, /RIGHT, /TOP
Inscription, P.file+File, /INSIDE, /RIGHT, /BOTTOM, CHARSIZE=0.4, CHARTHICK=1
CloseSheet, AVG_1

END



PRO AVG_IL, FILE=file, LO=lo, _EXTRA=e ; inner loop
COMMON ATTENTION
Default, FILE, ''

                           ; just a sample frame
V = InitVideo( [UMoment([0.2,0.4,0.2]),1.0], TITLE=P.File+FILE+'.avg', STARRING='umoment avergaged data', COMPANY='abszissa values: '+STR(N_Elements(valeach(LCONST=-lo))), /SHUTUP)
iter = ForEach("_AVG", FILE=file, VIDEO=V, LCONST=-lo, _EXTRA=e)
Eject, V, /NOLABEL, /SHUTUP

END



PRO AVG, avg, S=S, LOOP=loop, _EXTRA=e

Default, LOOP, 1

if Keyword_Set(S) THEN BEGIN
    iter = ForEach("_SAVG", LSKIP=loop, LO=loop, _EXTRA=e) 
END ELSE BEGIN
    iter = ForEach("AVG_IL", LSKIP=loop, LO=loop, _EXTRA=e)    
END

END
