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
;        Revision 1.2  2000/08/31 09:53:25  kupper
;        Now returns correct value for all operating systems.
;
;        Revision 1.1  2000/08/30 22:35:20  kupper
;        Changed Set_Plot, 'X' to Set_Plot, XorWIN().
;
;
Function XorWIN

   cas strupcase(!Version.OS_Family) of
   "MACOS": return, "MAC"
   "VMS": return, "X"
   "WINDOWS": return, "WIN"
   "UNIX": return, "X"
   else: Message, "Connot determine windows device - unrecognized " + $
    "operating system."

End
