;+
; NAME: FadeToGrey
;
; AIM: Turn a color indexed BMP into greylevel image, using linear
;      sorted colortable.   
;
; PURPOSE: Einlesen eines Bitmap-Bildes mit 8 Bit Farbtiefe
;          und Speichern einer Grauwert-Bitmap dieses Bildes
;          mit gleichzeitiger Rueckgabe der Grauwert-Bitmap
;          als Funktionsergebnis
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: array = FadeToGrey('bitmapfilename')
;
; INPUTS: bitmapfilename : Ein Bitmap-File mit 8 Bit Farbtiefe,
;                          darf sowohl farbig als auch schwarzweiss
;                          sein. Die '.bmp'-Endung ist optional.
;
; OUTPUTS: array : Ein Array, das die Grauwert-Version der
;                  urspruenglichen Bitmap enthaelt.
;
;          bitmapfilename_greyscale.bmp : Ein Bitmap-File, das die
;                  Grauwert-Version des uebergebenen Bildes enthaelt.
;                  Dieses File besitzt lineare Farbtabelleneintraege, 
;                  kann spaeter also problemlos mit Read_BMP eingelesen
;                  und weiterverwendet werden.
;
; PROCEDURE: 1. Bitmap zusammen mit der Farbtabelle einlesen
;            2. RGB-Farbtabelle in YIC-Farbtabelle umwandeln
;               (Y gibt dann den Grauwert an, dieses Farbmodell
;                wurde damals uebrigens fuer den Uebergang vom 
;                Schwarzweiss- zum Farbfernsehen eingefuehrt,
;                sagt Manfred Sommer...)
;            3. Grauwerte anstatt den Farbtabellenindizes in
;               die Bitmap reinschreiben
;            4. Lineare Farbtabelle fuer die zu speichernde
;               Bitmap erzeugen
;            5. Write_BMP...
;            6. Array als Funktionsergebnis zurueckgeben
;
; EXAMPLE: Entweder ohne Farbtabelle, sieht irgendwie falsch aus:
;          bitmap=Read_BMP(Getenv('NASEPATH')+'/graphic/nonase/alison.bmp')
;          TV, bitmap
;          
;          oder mit Farbtabelle:
;          bitmap=Read_BMP(Getenv('NASEPATH')+'/graphic/nonase/alison.bmp', r,g,b)
;          UTVlct, R,G,B
;          TV, bitmap
;          
;          oder mit der superpraktischen FadeToGrey-Funktion:
;          LoadCt, 0
;          bitmap=fadetogrey(Getenv('NASEPATH')+'/graphic/nonase/alison.bmp')
;          TV, bitmap
;
;          und jetzt geht das auch ganz einfach mit Read_BMP:
;          bitmap=Read_BMP(Getenv('NASEPATH')+'/graphic/nonase/alison_greyscale.bmp')
;          TV, bitmap
;
; SEE ALSO: Standard-IDL-Routinen READ_BMP und WRITE_BMP
;            
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/10/01 14:50:42  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 2.1  1998/04/02 15:19:37  thiel
;               Nie wieder Aerger mit Farbtabellen von
;               eingelesenen Bitmaps!
;
;-

FUNCTION FadeToGrey, filename

sepfilename = Str_Sep(filename, '.')
filenameparts = N_Elements(sepfilename)

IF filenameparts EQ 1 THEN BEGIN
   loadfilename = filename+'.bmp'
   savefilename = filename+'_greyscale.bmp'
ENDIF ELSE BEGIN
   IF sepfilename(filenameparts-1) EQ 'bmp' THEN BEGIN
      loadfilename = filename
      savefilename = StrMid(filename, 0, StrLen(filename)-4)+'_greyscale.bmp'
   ENDIF ELSE Message, 'Sorry, this seems to be no BMP-File.'
ENDELSE
         
bitmap = Read_Bmp(loadfilename, r, g, b)

New_Color_Convert, r, g, b, y, i, c, /RGB_YIC

bitmap = y(bitmap)

colortable = Indgen(256)

Write_BMP, savefilename, bitmap, colortable, colortable, colortable
Message, 'Wrote new Bitmap-File '+savefilename, /INFORM


RETURN, bitmap

END
