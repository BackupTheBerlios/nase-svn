;+
; NAME:
;  csMindMovieFileHeader()
;
; VERSION:
;  $Id$
;
; AIM:
;  return MindMovieFileHeader-Structure
;
; PURPOSE:
;  when the file header in the crystal application is changed only
;  the function csMindMovieFileHeader() has to be adapted and all
;  programs which load a movie file will stil work without the need to
;  be changed as well
;
; CATEGORY:
;  Animation
;  DataStructures
;  Files
;  Graphic
;  Input
;  IO
;  MIND
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*result=csMindMovieFileHeader()
;
; INPUTS:
;  
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

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function csMindMovieFileHeader

csMindMovieFileHeader = {csMindMovieFileHeaderType $
                  ,FileTypeString:  STRING(REPLICATE(32b, 12))$
                  ,VersionString: STRING(REPLICATE(32b, 8))$
                  ,Width: 0l $
                  ,Height: 0L $
                  ,NFilter: 0L $
}

return, csMindMovieFileHeader

end
