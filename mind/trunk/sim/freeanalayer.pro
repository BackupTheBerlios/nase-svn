PRO CloseAnalayer, _AS, _EXTRA=e

   Handle_Value, _AS, AS, /NO_COPY

   DestroySheet, AS.Sh
   AS = -1

   Handle_Value, _AS, AS, /NO_COPY, /SET
   Handle_Free, _AS

END
