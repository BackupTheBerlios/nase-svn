;+
; NAME: 
;   Check_Nase_Lib
;
; VERSION:
;   $Id$
;
; AIM:
;   provides the existence of a recent version of the NASE library
;
; PURPOSE:
;   To extend the functionality of IDL, there are several routines that
;   use external C-programs. This routine tries to compile these files
;   into a shared library called <*>nasec.so</*> (<*>nasec.dll</*> on
;   Windows). After that, it checks, if the library has successfully
;   been built, and issues a warning message if it cannot be found. If
;   all went right, the compilation time is displayed.<BR>
;<BR>
;   <I>You probably do not want to call this routine. It is used
;   during NASE's startup process.</I>
; CATEGORY:
;  NASE
;  Startup
;  OS
;
; CALLING SEQUENCE:
;*  Check_Nase_Lib
;  
; PROCEDURE:
;   This function calls IDL's <C>MAKE_DLL</C>. See the IDL manual for
;   details.
;
; SIDE EFFECTS:
;   Creates a shared object file. The file is created in the location
;   that is given in the system variable <*>!MAKE_DLL</*>. The
;   compiler specified in <*>!MAKE_DLL</*> must be available on the
;   system. See the IDL manual for details, and for how to change the
;   compiler used.
;  
; RESTRICTIONS:
;   The compiler specified in <*>!MAKE_DLL</*> must be available on
;   the system. See the IDL manual for details, and for how to change
;   the compiler used.;
;
; AUTHOR:
;  Ruediger Kupper
;-


Pro Check_NASE_LIB

   files = ['mtime', 'IDL_IO_support']
   export_symbols = ['mtime', $
                     'get_fd', $
                     'wait_for_data', $
                     'non_block_readable', $
                     'set_nonblocking', $
                     'set_blocking', $
                     'tmp_nam']


   ;; This is just for convenience:
   ;; The REUSE_EXISTING keyword to MAKE_DLL has been introduced in
   ;; IDL5.6, and we want to use it when available. Otherwise, the
   ;; library is compiled each time at startup.
   ;; Can be removed, as soon as no-one is using version prior to 5.6.
   if IDLVersion(/float) ge 5.6 then begin
      make_dll, INPUT_DIRECTORY=!NASEPATH+'/shared', $
                files, $
                'nasec', $
                export_symbols, $
                EXTRA_CFLAGS='-I'+getenv("IDL_DIR")+'/external', $
                DLL_PATH=the_library, /verbose, $
                /reuse_existing
   endif else begin
      make_dll, INPUT_DIRECTORY=!NASEPATH+'/shared', $
                files, $
                'nasec', $
                export_symbols, $
                EXTRA_CFLAGS='-I'+getenv("IDL_DIR")+'/external', $
                DLL_PATH=the_library, /verbose
   endelse

   DefSysV, '!NASE_LIB', the_library, 0

   ;; check if all went right:
   If NOT Fileexists(!NASE_LIB) THEN begin
      ;; can still not use console here, is still not re-entrant!
      message, "The NASE support library of C-routines "+!NASE_LIB+" " + $
               "doesn't exist. Something's going wrong " + $
               "here. You will encounter problems using the C-library " + $
               "routines.", /continue
      message, "A possible reason for this error is that on your " + $
               "system the compiler specified by !MAKE_DLL is not " + $
               "available. See !MAKE_DLL in the IDL manual for how to " + $
               "specify another compiler, and set !MAKE_DLL " + $
               "appropriately before calling this routine.", /continue
      return
   End


   dummy = MTime(!NASE_LIB, Date=d)
   Print
   Print, "NASE support library: "+!NASE_LIB
   Print, "compiled on " + d + "."
   Print
;   PopD
End
