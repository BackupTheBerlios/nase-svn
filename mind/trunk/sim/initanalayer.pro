FUNCTION InitAnalayer, w, h, TITLE=title, STRETCH=stretch, OVERSAMPLING=oversampling, _EXTRA=e

   On_Error, 2

   Default, TITLE  , 'Analayer'
   Default, STRETCH, 5
   Default, Oversampling, 1

   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      Sh = DefineSheet(/NULL, MULTI=[2,1,2])
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      Sh = DefineSheet(/NULL, MULTI=[2,1,2])
   END ELSE BEGIN
      Sh = DefineSheet(/Window, MULTI=[2,1,2], XSIZE=50+w*stretch, YSIZE=50+h*stretch, TITLE=title)
   END

   OpenSheet, Sh, 0
   ULoadCt, 1
   CloseSheet, Sh, 0
   OpenSheet, Sh, 1
   ULoadCt, 1
   CloseSheet, Sh, 1
   tmp = {   w      : w          ,$
             h      : h          ,$
             tot    : LonArr(h,w),$
             t      : 0l         ,$
             stretch: stretch    ,$
             Sh     : Sh         ,$
             OS     : oversampling}

   RETURN, Handle_Create(!MH, VALUE=tmp)

END
