;+
; NAME:                     M2LFP
;  
; PURPOSE:                  Computes LFP from membrane potential for
;                           all neurons. It uses exponential weighing
;                           of membrane potentials und bandpass
;                           filtering for signal generation.
;                           As default it uses toroidal boundary
;                           conditions. 
;
; CATEGORY:                 MIND 
;                            
; CALLING SEQUENCE:         M2LFP [,M] [,LAYER=layer]
;                                [,/S]
;                                [BANDPASS=[flow,fhigh]] [/NOWRAP]
;                                [,LFPHMW=lfphmw]
;  
; OPTIONAL INPUTS:          M : the temporal development of the
;                               layer's mebrane potentials. They
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
;                                    uses P.LFPHMW, or if not set LFPHMW=1.        
;                           nowrap : non-toroidal boundaries, lfps
;                                    will fade out at the layer's edges
;                           S      : already calculated data will be displayed
;                                    via PlotTVSCL
;                           VCR    : a video will be show (implies S)
;  
; OUTPUTS:                  written to file ( *.lfp.vid* )
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
;        Revision 1.1  2000/04/06 09:31:26  saam
;              finally
;
;



PRO _M2LFP, M, LAYER=layer, BANDPASS=bp, NOWRAP=nowrap, LFPHMW=lfphmw, _EXTRA=e
COMMON ATTENTION


IF NOT Set(bp) THEN bp=[30,70]
IF N_Elements(BP) NE 2 THEN Console, 'illegal format for BANDPASS', /FATAL
Default, LAYER,    0
Default, LFPHMW, 1.0


; load membrane potentials, if not passed as argument
IF NOT SET(m) THEN M = ReadSimu(L, /MEMBRANE, /TD, FILE=P.file)


; generate LFP signals
IF Keyword_Set(NOWRAP) THEN l = LFP(m, /FULL, HMW_EXP=LFPHMW, LOG=llog) $
                       ELSE l = LFP(m, /FULL, HMW_EXP=LFPHMW, /WRAP, LOG=llog)


; band pass filtering
mlog =  "bandpass ("+STR(bp(0))+"-"+STR(bp(1))+" Hz)" 
Console, mlog+"..."
f = Filter(bp(0), bp(1), 50, 20, SAMPLEPERIOD=P.SIMULATION.SAMPLE)      ;To get coefficients (same as ANDI)
lf = l

w = (SIZE(m))(1)
h = (SIZE(m))(2)
t = (SIZE(m))(3)

FOR i=0,h-1 DO BEGIN
    FOR j=0,w-1 DO BEGIN
        lf(i,j,*) = CONVOL(REFORM(l(i,j,*)), f)
    END
END
Console, mlog+"...done", /UP



Console, 'Saving LFP...'
curLayer= Handle_Val(P.LW(layer))
Vid = InitVideo( DblArr(w*h), TITLE=P.File+'.'+curLayer.FILE+'.lfp', STARRING=llog, COMPANY=mlog, /SHUTUP)
FOR i=0,t-1 DO dummy = CamCord( Vid, REFORM(DOUBLE(LF(*,*,i)), w*h))
Eject, Vid, /NOLABEL, /SHUTUP
Console, 'Saving LFP...done', /UP


END



PRO _SM2LFP, LAYER=layer, VCR=vcr, _EXTRA=e

COMMON Attention
COMMON SH_MLFP, MLFPwins, MFLP_1

Default, File, ''
Default, layer, 0

;----->
;-----> ORGANIZE THE SHEETS
;----->
IF ExtraSet(e, 'NEWWIN') THEN BEGIN
    DestroySheet, MFLP_1
    MLFPwins = 0
END
IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
    MFLP_1 = DefineSheet(/NULL)
    MLFPwins = 0
END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
    MFLP_1 = DefineSheet(/PS, /ENCAPSULATED, FILENAME=P.File+'mlfp')
    MLFPwins = 0
END ELSE BEGIN
    IF (SIZE(MLFPwins))(1) EQ 0 THEN BEGIN
        MFLP_1 = DefineSheet(/Window, XSIZE=1000, YSIZE=300, TITLE='MLFP')
        MLFPwins = 1
    END
END


L = ReadSimu(LAYER=layer, INFO=info, /LFP, /TD)

OpenSheet, MFLP_1
PlotTVScl, REFORM(L, (SIZE(L))(1)*(SIZE(L))(2), (SIZE(L))(3)), /FULL, /LEGEND, TITLE='MLFP, '+INFO, XRANGE=[0,(SIZE(L))(3)*(1000.*P.SIMULATION.SAMPLE)], XTITLE='time / ms', YTITLE='neuron #', /NASE
Inscription, P.file, /INSIDE, /RIGHT, /TOP, CHARSIZE=0.4, CHARTHICK=1
CloseSheet, MFLP_1


IF Keyword_Set(VCR) THEN BEGIN
    VCR, L, ZOOM=5, _EXTRA=e
END



END



PRO M2LFP, M, S=S, _EXTRA=e

IF Keyword_Set(S) THEN BEGIN
    _SM2LFP, _EXTRA=e 
END ELSE BEGIN
    IF Set(M) THEN _M2LFP, M, _EXTRA=e $
              ELSE _M2LFP, _EXTRA=e
END

END
