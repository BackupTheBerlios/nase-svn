w = 20
h = 20
p = 0.05


NTyp = InitPara_1()

L1 = InitLayer_1(Type=NTyp, WIDTH=w, HEIGHT=w)   
L2 = InitLayer_1(Type=NTyp, WIDTH=h, HEIGHT=h)

DW = InitDW (S_Layer=L1, T_Layer=L2, $
             D_LINEAR=[1,2,10], /D_TRUNCATE, $
;             /D_NONSELF, $
;              WEIGHT = 1.0,$
;               DELAY=5.0,$
             W_GAUSS=[1,5], /W_TRUNCATE, $
;             W_RANDOM=[0,0.3], $
;            /W_NONSELF,$
             NOCON=10)

SDW = InitDW (S_Layer=L1, T_Layer=L2, $
             D_LINEAR=[1,2,10], /D_TRUNCATE, $
;             /D_NONSELF, $
;              WEIGHT = 1.0,$
;               DELAY=5.0,$
             W_GAUSS=[1,5], /W_TRUNCATE, $
;             W_RANDOM=[0,0.3], $
;            /W_NONSELF,$
             NOCON=10)




time = systime(1)
FOR t=0l,100 DO BEGIN
   In = FltArr(w*w)
   In((w*w-1)*RandomU( seed, w*w*p)) =  1.0
   SpIn = Norm2SSparse(In)
  
   SOut = DelayWeigh(SDW, SpIn)

;   Out = OldDelWei(DW, In)

;   diff =  WHERE(Out NE Sparse2Norm(SOut), count)
;   IF count NE 0 THEN print, 'Error', count 
   
END
print, systime(1) - time
FreeDW, DW
FreeDW, SDW
;Window, 1, TITLE='Out / Sparse'
;!P.Multi = [0,1,2,0,0]
;Plot, Out
;Plot, Sparse2Norm(SOut)





END
