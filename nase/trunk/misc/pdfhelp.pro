;+
; NAME:
;  pdfHelp
;
; VERSION:
;  $Id$
;
; AIM:
;  Display the IDL online guide as PDF file.
;
; PURPOSE:
;  <C>PdfHelp</C> spawns <I>Acrobat Reader</I> as a subprocess and
;  displays the file <*>onlguide.pdf</*> form the IDL distributions's
;  <*>docs</*> subdirectory.<BR>
;  OS-dependent modifications to the <C>SPAWN</C> command are used to
;  get a parallel process on Unix and Windows systems.
;
; CATEGORY:
;  Help
;
; CALLING SEQUENCE:
;*pdfHelp
;
; RESTRICTIONS:
;  <I>Acrobat Reader</I> needs to be installed on the system. It must
;  be accessible as <*>acroread</*> from the system's search path.
;
; PROCEDURE:
;  Spawn <*>acroread</*> as subprocess.
;
; EXAMPLE:
;*pdfhelp
;-



Pro pdfHelp
   case StrUpCase(!VERSION.OS_FAMILY) of
      "UNIX": spawn, "acroread "+filepath("onlguide.pdf", $
                               subdirectory="docs")+"&"

      "WINDOWS": spawn, "acroread "+filepath("onlguide.pdf", $
                               subdirectory="docs"), /NOSHELL, /NOWAIT

      else: spawn, "acroread "+filepath("onlguide.pdf", $
                               subdirectory="docs")
   endcase

End
