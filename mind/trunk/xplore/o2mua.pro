;+
; NAME:                     O2MUA
;  
; PURPOSE:                  Computes MUA from action potentials for
;                           all neurons. It uses exponential weighing
;                           of output spikes und bandpass
;                           filtering for signal generation.
;                           As default it uses toroidal boundary
;                           conditions. 
;
; CATEGORY:                 MIND 
;                            
; CALLING SEQUENCE:         O2MUA [,M] [,LAYER=layer]
;                                [,/S]
;                                [BANDPASS=[flow,fhigh]] [/NOWRAP]
;                                [,MUAHMW=lfphmw]
;  
; OPTIONAL INPUTS:          M : the temporal development of the
;                               layer's action potentials. They
;                               will be loaded if omitted.
;
; KEYWORD PARAMETERS:       flow   ,
;                           fhigh  : lower and upper frequency for bandpass
;                                    filtering (Default: [30,70])
;                           layer  : the layer to be calculated,
;                                    important for loading and saving
;                                    data (Default: 0)
;                           lfphmw : the half mean width for collecting
;                                    membrane potentials (exponential
;                                    decay). IF not set the routine
;                                    uses P.MUAHMW, or if not set MUAHMW=1.        
;                           nowrap : non-toroidal boundaries, lfps
;                                    will fade out at the layer's edges
;                           S      : already calculated data will be displayed
;                                    via PlotTVSCL
;                           VCR    : a video will be show (implies S)
;  
; OUTPUTS:                  written to file ( *.mua.vid* )
;                           can be read by lfp = ReadSimu(/LFP)
;  
; COMMON BLOCKS:            ATTENTION: simulation parameters
;                           SHMLFP   : sheet organization
;  
; SEE ALSO:                 ReadSimu, LFP, Filter
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/06/21 08:39:39  saam
;              + stupidly copied from m2lfp
;
;
;



PRO _O2MUA, M, LAYER=layer, BANDPASS=bp, NOWRAP=nowrap, MUAHMW=muahmw, _EXTRA=e
COMMON ATTENTION


IF NOT Set(bp) THEN bp=[30,70]
IF N_Elements(BP) NE 2 THEN Console, 'illegal format for BANDPASS', /FATAL
Default, LAYER,    0

IF ExtraSet(P,"MUAHMW") THEN Default, MUAHMW, P.MUAHMW ELSE Default, MUAHMW, 1.0

; load membrane potentials, if not passed as argument
IF NOT SET(m) THEN M = ReadSimu(Layer, /OUT, /TD, FILE=P.file)

; generate MUA signals
IF Keyword_Set(NOWRAP) THEN l = MUA(m, /FULL, HMW_EXP=MUAHMW, LOG=llog) $
                       ELSE l = MUA(m, /FULL, HMW_EXP=MUAHMW, /WRAP, LOG=llog, roi=roi)


; band pass filtering
mlog =  "bandpass ("+STR(bp(0))+"-"+STR(bp(1))+" Hz)" 
Console, mlog+"..."
f = Filter(bp(0), bp(1), 50, 20, SAMPLEPERIOD=P.SIMULATION.SAMPLE)      ;To get coefficients (same as ANDI)
lf = l

h = (SIZE(m))(1)
w = (SIZE(m))(2)
t = (SIZE(m))(3)

FOR i=0,h-1 DO BEGIN
    FOR j=0,w-1 DO BEGIN
        lf(i,j,*) = CONVOL(REFORM(l(i,j,*)), f)
    END
END
Console, mlog+"...done", /UP


Console, 'Saving MUA...'
curLayer= Handle_Val(P.LW(layer))
Vid = InitVideo( DblArr(w*h), TITLE=P.File+'.'+curLayer.FILE+'.mua', STARRING=llog, COMPANY=mlog, /SHUTUP)
FOR i=0,t-1 DO dummy = CamCord( Vid, REFORM(DOUBLE(LF(*,*,i)), w*h))
Eject, Vid, /NOLABEL, /SHUTUP
Console, 'Saving MUA...done', /UP


END



PRO _SO2MUA, LAYER=layer, VCR=vcr, _EXTRA=e

COMMON Attention
COMMON SH_O2MUA, O2MUAwins, O2MUA_1

Default, File, ''
Default, layer, 0

;----->
;-----> ORGANIZE THE SHEETS
;----->
IF ExtraSet(e, 'NEWWIN') THEN BEGIN
    DestroySheet, O2MUA_1
    O2MUAwins = 0
END
IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
    O2MUA_1 = DefineSheet(/NULL)
    O2MUAwins = 0
END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
    O2MUA_1 = DefineSheet(/PS, /ENCAPSULATED, FILENAME=P.File+'o2mua')
    O2MUAwins = 0
END ELSE BEGIN
    IF (SIZE(O2MUAwins))(1) EQ 0 THEN BEGIN
        O2MUA_1 = DefineSheet(/Window, XSIZE=1000, YSIZE=300, TITLE='O2MUA')
        O2MUAwins = 1
    END
END


L = ReadSimu(LAYER=layer, INFO=info, /RMUA, /TD)

OpenSheet, O2MUA_1
PlotTVScl, REFORM(L, (SIZE(L))(1)*(SIZE(L))(2), (SIZE(L))(3)), /FULL, /LEGEND, TITLE='O2MUA, '+INFO, XRANGE=[0,(SIZE(L))(3)*(1000.*P.SIMULATION.SAMPLE)], XTITLE='time / ms', YTITLE='neuron #', /NASE
Inscription, P.file, /INSIDE, /RIGHT, /TOP, CHARSIZE=0.4, CHARTHICK=1
CloseSheet, O2MUA_1


IF Keyword_Set(VCR) THEN BEGIN
    VCR, L, ZOOM=5, _EXTRA=e
END



END



PRO O2MUA, M, S=S, _EXTRA=e

IF Keyword_Set(S) THEN BEGIN
    _SO2MUA, _EXTRA=e 
END ELSE BEGIN
    IF Set(M) THEN _O2MUA, M, _EXTRA=e $
              ELSE _O2MUA, _EXTRA=e
END

END
