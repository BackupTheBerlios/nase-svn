;+
; NAME: 
;  FullVideo()
;
; AIM: Return the full array associated with the video file
;
; PURPOSE: The function returns an array that is associated ( see
;          IDL-function ASSOC() ) with the video data file. The whole
;          video data may be accessed or modified by reading/writing
;          this array, on a frame-by-frame basis.
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: VideoArr = FullVideo ( Video )
; 
; INPUTS: Video: Eine mit LoadVideo() initialisierte Videostruktur
;
; OUTPUTS: VideoArr: One-dimensional associated array containing the
;          whole video frame-by-frame:
;          VideoArr[0] yields the first frame,
;          VideoArr[i] yields frame #i
;
; RESTRICTIONS: Note that no data is kept in memory. Each read/write
;               access to the array results in a disk operation.
;               See also IDL help for function ASSOC().
;
; PROCEDURE: A Simple ASSOC() command.
;
; EXAMPLE: VidArray = FullVideo ( MyVideo )
;          TVScl, VidArray[0] ; show the first frame.
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.1  2000/06/14 13:51:15  kupper
;       Checked in at last!
;
;
;-

Function FullVideo, _Video

   Handle_Value, _Video, Video, /NO_COPY

   If Video.VideoMode ne 'PLAY' then message, 'Das Video ist nicht zur Wiedergabe geöffnet!'


   Data = Assoc(Video.unit, Make_Array(SIZE=Video.FrameSize, /NOZERO))

   Handle_Value, _Video, Video, /NO_COPY, /SET

   return, Data

End
