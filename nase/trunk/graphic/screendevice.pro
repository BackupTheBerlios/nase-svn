;+
; NAME: 
;  XorWIN()
;
; AIM: Return the platform-dependent Windows-Device ('X' or 'WIN').
;  
; PURPOSE:
;  Determine the device to use for windows output. This depends on the
;  operating system: For the Windows OS this is 'WIN', for UNIX/LINUX
;  OS this is 'X'.
;  This function is intended for use with the Set_Plot command (see
;  calling sequence).
;  
; CATEGORY:
;  GRAPHIC
;  
; CALLING SEQUENCE:
;  Set_Plot, XorWIN()
;  
; PROCEDURE:
;  Check !Version.OS_Family for running OS type.
;  
; EXAMPLE:
;  Set_Plot, XorWin()
;  
; SEE ALSO:
;  All the "U..." graphic routines.
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/08/30 22:35:20  kupper
;        Changed Set_Plot, 'X' to Set_Plot, XorWIN().
;
;
Function XorWIN

   if strupcase(!Version.OS_Family) eq "WINDOWS" then $
    return, "WIN" $
   else $
    return, "X"

End
