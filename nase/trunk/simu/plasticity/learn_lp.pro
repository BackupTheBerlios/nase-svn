pro learn_lp, _DW,_LP,source_l=source_l,target_l=target_l
Handle_Value, _LP, LP, /NO_COPY
Handle_Value, _DW, DW, /NO_COPY
Post = Handle_Val(LayerOut(target_l))
Pre = Handle_Val(LayerOut(source_l))

dw.w=dw.w - LP.delearn
if pre(0) ne 0 then begin
    for ti = 2, pre(0)+1 do begin
        tn = pre(ti)
        handle_value,dw.s2c(tn),wi
        if dw.s2c(tn) ne -1 then begin
            deltaw = lp.values(dw.c2t(wi))
            dw.w(wi) = ( dw.w(wi) + deltaw) < 1.0
        endif
    endfor
endif
handle_value,_lp,lp,/NO_COPY,/SET
handle_value,_dw,dw,/NO_COPY,/SET
end

