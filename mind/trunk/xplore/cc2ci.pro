;+
; NAME:                     CC2CI
;  
; PURPOSE:                  Computes the correlation index from
;                           given correlations. The correlations
;                           can either be passed or else will be
;                           loaded.
;
; CATEGORY:                 MIND XPLORE
;                            
; CALLING SEQUENCE:         compute: CC2CI [,CC] [,FILE=file] [,LAYER=layer]
;                           show   : CC2CI [,FILE=file] [,LAYER=layer],/S 
;                           load   : CC2CI, CI [,FILE=file] [,LAYER=layer],/R 
;  
; OPTIONAL INPUTS:          CC     : an array containing to
;                                    correlation functions
;
; KEYWORD PARAMETERS:       file   :
;                           layer  : the layer to be calculated,
;                                    important for loading and saving
;                                    data (Default: 0)
;  
; OUTPUTS:                  CI     : the array of correlation indices
;                                    if /R is set.
;                           written to file ( FILE.ci.vid* )
;  
; COMMON BLOCKS:            ATTENTION: simulation parameters
;                           SHMLFP   : sheet organization
;  
; SEE ALSO:                 CorrIndex
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/04/06 12:24:51  saam
;              finally
;
;
;
PRO _CC2CI, cc, FILE=file, LAYER=layer

COMMON ATTENTION

Default, file, ''
Default, layer, 0

cL= Handle_Val(P.LW(layer))
IF NOT Set(CC) THEN cc = CCI(IX='.'+cL.File+file, /R)

S = size(cc)
dim    = S(0)-1    ; without pshift
pshift = S(dim+1)  ; elements in last dimension

IF (dim LT 1) THEN Console, 'illegal dimension ('+STR(dim)+')', /FATAL
cc = REFORM(cc, N_Elements(cc)/pshift, pshift, /OVERWRITE) ; to handle arbitrary dimensions

Console, 'processing...'
FOR i=0,N_Elements(cc)/pshift-1 DO BEGIN
    IF Set(CI) THEN ci=[ci,CorrIndex(REFORM(cc(i,*)))] ELSE ci = CorrIndex(REFORM(cc(i,*)))
END
ci = REFORM(ci, S(1:dim), /OVERWRITE)
Console, 'processing...done', /UP


Console, 'saving...'
V = InitVideo( ci, TITLE=P.File+'.'+cL.File+file+'.ci', STARRING='', COMPANY='', /SHUTUP)
dummy = CamCord(V, ci)
Eject, V, /NOLABEL, /SHUTUP
Console, 'saving...done', /UP


END


FUNCTION _RCC2CI, FILE=file, LAYER=layer

COMMON ATTENTION

Default, file, ''
Default, layer, 0

cL= Handle_Val(P.LW(layer))
Video = LoadVideo( TITLE=P.File+'.'+cL.File+file+'.ci', GET_SIZE=anz, GET_LENGTH=max_time, /SHUTUP, ERROR=error)
IF Error THEN BEGIN
    Console, 'data doesnt exist...'+P.File+'.'+cL.File+file+'.ci', /WARN
    Console, 'READSIM: stopping', /FATAL
END
ci = Replay(Video)
Eject, Video, /SHUTUP

RETURN, ci
END




PRO _SCC2CI, FILE=file, LAYER=layer

COMMON ATTENTION
COMMON SH_CC2CI, CC2CIwins, CC2CI_1

Default, File, ''
Default, layer, 0

;----->
;-----> ORGANIZE THE SHEETS
;----->
IF ExtraSet(e, 'NEWWIN') THEN BEGIN
    DestroySheet, CC2CI_1
    CC2CIwins = 0
END
IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
    CC2CI_1 = DefineSheet(/NULL)
    CC2CIwins = 0
END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
    CC2CI_1 = DefineSheet(/PS, /ENCAPSULATED, FILENAME=P.File+'cclfpm')
    CC2CIwins = 0
END ELSE BEGIN
    IF (SIZE(CC2CIwins))(1) EQ 0 THEN BEGIN
        CC2CI_1 = DefineSheet(/Window, XSIZE=400, YSIZE=300, TITLE='CC2CI')
        CC2CIwins = 1
    END
END


ci=_RCC2CI(FILE=file, LAYER=layer)
dim = (SIZE(ci))(0)

OpenSheet, CC2CI_1
ULoadCt, 1
CASE dim OF 
    1: Plot, CI, XTITLE='neuron #', YTITLE='correlation index', TITLE='Correlation Index (CC2CI)', XSTYLE=1
    2: PlotTVScl, CI, /FULL, /LEGEND, TITLE='Correlation Index (CC2CI)', XTITLE='neuron #', YTITLE='neuron #'
    ELSE: Console, 'cannot plot, wrong dimensions ('+STR(dim)+')', /FATAL
END
Inscription, P.file, /INSIDE, /RIGHT, /TOP, CHARSIZE=0.4, CHARTHICK=1
CloseSheet, CC2CI_1

END




PRO CC2CI, cc_or_ci, FILE=FILE, S=S, R=R, _EXTRA=e

Default, FILE,  ''
Default, layer, 0

if Keyword_Set(R) THEN BEGIN
    cc_or_ci = _RCC2CI(FILE=file, _EXTRA=e)
END ELSE BEGIN
    IF NOT Keyword_Set(S) THEN BEGIN
        IF Set(cc_or_ci) THEN _CC2CI, cc_or_ci, FILE=file, _EXTRA=e  ELSE _CC2CI, FILE=file, _EXTRA=e
    END ELSE _SCC2CI, FILE=file, _EXTRA=e 
END

END
