;
; this is an internal routine used by ForEach and partners
;
;  GO AWAY !!!!!!!!!!!!!!!!!
;
FUNCTION _eval_skip, loopc, var

IF ((N_Elements(var) GT 1) AND (MIN(var) LT 1)) THEN Console, 'inverse syntax with multiple arguments ??', /FATAL
IF (var(0) LT 0) THEN BEGIN
    res=Indgen(loopc)+1
    res=Diffset(res, -_var)
END ELSE res = var

END



PRO SkipSyntax, loopc, _skip, _const, _EXTRA=e



IF ExtraSet(e, _LSKIP) THEN skip = _eval_skip(loopc, e._LSKIP)
IF ExtraSet(e, _LCONST) THEN const = _eval_skip(loopc, e._LCONST)

IF ExtraSet(e, _OSKIP) THEN BEGIN
    IF N_Elements(_OSKIP) NE 1 THEN Console,'OSKIP has to be scalar!', /FATAL
    Indgen(_OSKIP)


IF Set(_LCONST) THEN BEGIN            
    IF ((N_Elements(_LCONST) GT 1) AND (MIN(_LCONST) LT 1)) THEN Console, 'LCONST: inverse syntax with multiple arguments ??', /FATAL
    IF (_LCONST(0) LT 0) THEN BEGIN
        LCONST=Indgen(loopc)+1
        LCONST=Diffset(LCONST, -_LCONST)
    END ELSE LCONST = _LCONST
END ELSE lconst=!NONE







END
