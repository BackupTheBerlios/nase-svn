;+
; NAME: 
;  ScreenDevice()
;
; AIM: Return the platform-dependent Windows-Device ('X', 'MAC' or 'WIN').
;  
; PURPOSE:
;  Determine the device to use for windows output. This depends on the
;  operating system: For the Windows OS this is 'WIN', for UNIX/LINUX
;  and VMS OS this is 'X', for the Macintosh OS this is 'MAC'.
;  This function is intended for use with the Set_Plot command (see
;  calling sequence).
;  
; CATEGORY:
;  GRAPHIC
;  
; CALLING SEQUENCE:
;  Set_Plot, ScreenDevice()
;  
; PROCEDURE:
;  Check !Version.OS_Family for running OS type.
;  
; EXAMPLE:
;  Set_Plot, ScreenDevice()
;  
; SEE ALSO:
;  All the "U..." graphic routines.
;  
;-
; 
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  2000/09/01 19:47:52  gabriel
;            Bug Fix: !Version.OS_Family not exists in IDL Version 3.6x
;            For IDL Version 3.6 ScreenDevice returns always 'X' as device
;
;        Revision 1.5  2000/08/31 15:01:18  kupper
;        oops. Typos.
;
;        Revision 1.4  2000/08/31 09:58:58  kupper
;        Added space to turn watch on.
;
;        Revision 1.3  2000/08/31 09:58:00  kupper
;        Renamed from XorWIN to ScreenDevice as MAC is now also supported.
;
;        Revision 1.2  2000/08/31 09:53:25  kupper
;        Now returns correct value for all operating systems.
;
;        Revision 1.1  2000/08/30 22:35:20  kupper
;        Changed Set_Plot, 'X' to Set_Plot, XorWIN().
;
;
Function ScreenDevice
IF idlversion() GE 4 then begin
   case strupcase(!Version.OS_Family) of
      "MACOS": return, "MAC"
      "VMS": return, "X"
      "WINDOWS": return, "WIN"
      "UNIX": return, "X"
      else: Message, "Connot determine windows device - unrecognized " + $
       "operating system."
   endcase
end else return, "X"
End
