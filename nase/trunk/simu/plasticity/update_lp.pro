;+
; NAME:
;  update_lp
;
; VERSION:
;  $Id$
;
; AIM:
;  Updates an initialized MemoryTrace
;
; PURPOSE:
;  Updates an initialized MemoryTrace
;
;
; CATEGORY:
;  NASE
;  Plasticity
;  Simulation
;
; CALLING SEQUENCE:
;* update_lp, learn_struct, TARGET_L=target_l
;
; INPUTS:
;  learn_struct: an initialized learn-structure
;  target_l    : the target layer
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>RoutineName</A>
;-

PRO update_lp, _LP, TARGET_L=target_l

Handle_Value, _LP, LP, /NO_COPY
for i=0,n_elements(lp.values)-1 do begin
    LP.values(i)=LP.values(i)*LP.dec
endfor

Post = Handle_Val(LayerOut(target_l))

if post(0) ne 0 then begin

    if (LP.delay eq 0) then begin
        LP.values(Post(2:*))=LP.values(Post(2:*))+LP.v
    end else begin
;        print,"im in a delay loop... yippie"
;        print,"popping"
;        print,LP.trace(0)
        tmp = LP.trace(1)
        LP.trace = shift(LP.trace,-1)
;        print,"pushing"
;        print,Post(2:*)
        LP.trace(LP.delay) = Handle_Create(!MH,VALUE = Post(2:*),/NO_COPY)
        if (tmp ne -1) then begin
            Handle_Value, tmp, bla,/NO_COPY
;            print,"popped"
;            print,bla
            LP.values(bla)=LP.values(bla)+LP.v
        endif
        ;LP.values = reform(LP.trace(*,0))
        ;LP.trace = shift(LP.trace,-1)
        ;LP.trace(*,delay-1)=0.
        ;LP.trace(LP.values(Post(2:*)))=0
        
    end ; delay case

endif
Handle_Value, _LP,LP,/NO_COPY,/SET
end
