;+
; NAME:               ReadSim
;
; PURPOSE:            Reads SUA or membrane potentials saved via MIND
;                     allows specific neurons and times to be read.
;                     this routine doesn't care for oversampling.
;                     There is a high level routine called ReadSimu
;                     you probably want to use instead!
;
; CATEGORY:           MIND INTERNAL
;
; CALLING SEQUENCE:   o = ReadSim(file [,/INPUT] [,/OUTPUT]
;                                 [,/MEMBRANE] [,/MUA] [,/LFP] 
;                                 [,TIME=time] [,SELECT=select] $
;                                 [,INFO=info]
;
;
; INPUTS:             file: path/file to be read (without suffices)
;
; KEYWORD PARAMETERS: IINPUT  : read input for layer
;                     OUTPUT  : read spike output of layer (this is default)
;                     MEMBRANE: read membrane potentials of layer
;                     MUA     : read multiple unit activity
;                     TIME    : reads the simulation from BIN start to BIN end specified
;                               as [start,end]. if end is negative,
;                               data is read to the (-end)-last
;                               element. Therefore end=-1 reads to
;                               the file's end. If end is omitted,
;                               data is read from 0 to start.
;                     SELECT  : an array of neuron indices to be read
;
; OPTIONAL OUTPUTS:   INFO    : returns the VIDEO informations
;
; OUTPUTS:            O: array (neuronindex,time) containing the data read
;
; EXAMPLE:            o = ReadSim('~/sim/local_assemblies/bar/gap/v1/_', $
;                                  /MEMBRANE, TIME=[0,1000], SELECT=[0,5,7,3,9])
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#READSIMU>readsimu</A>
;        
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 1.6  2000/05/16 16:16:20  saam
;            extended TIME syntax
;
;      Revision 1.5  2000/04/06 09:34:24  saam
;            + added loading of LFP signals
;            + new info keyword
;
;      Revision 1.4  2000/01/05 13:55:14  saam
;            minus in doc was missing
;
;      Revision 1.3  1999/12/21 09:55:29  saam
;            keyword MUA was not documented
;
;      Revision 1.2  1999/12/21 09:42:38  saam
;            return on error now
;
;      Revision 1.1  1999/12/21 09:02:52  saam
;            moved to internal, but it can be used by
;            the user anyway
;
;
;-
FUNCTION ReadSim, file, INPUT=input, OUTPUT=output, LFP=lfp, MEMBRANE=membrane, MUA=mua, TIME=time, INFO=info, SELECT=select

   On_Error, 2

   IF Set(TIME) THEN BEGIN
      IF N_Elements(TIME) EQ 1 THEN TIME = [0,TIME]
   END 

   IF N_Params() NE 1 THEN Message, 'filename expected'
   kc = Set(INPUT)+Keyword_Set(OUTPUT)+Keyword_Set(MEMBRANE)+Keyword_Set(MUA)
   IF kc EQ 0 THEN BEGIN
      OUTPUT = 1
      kc = 1
   END
   IF kc NE 1 THEN Console, 'can only read one type of data simultanously', /FATAL
   
   IF Set(INPUT) THEN BEGIN
      filename = file+'.'+STR(INPUT)+'.in.sim' 
      console, 'loading input spikes ('+STR(INPUT)+') ...'
   END
   IF Keyword_Set(OUTPUT)   THEN BEGIN
      filename = file+'.o.sim'
      console, 'loading output spikes...'
   END
   IF Keyword_Set(MEMBRANE) THEN BEGIN
      filename = file+'.m.sim'
      console, 'loading membrane potentials...'
   END
   IF Keyword_Set(MUA) THEN BEGIN
      filename = file+'.mua.sim'
      console, 'loading MUA...'
   END
   IF Keyword_Set(LFP) THEN BEGIN
      filename = file+'.lfp'
      console, 'loading LFP...'
   END


   Video = LoadVideo( TITLE=filename, GET_SIZE=anz, GET_LENGTH=max_time, /SHUTUP, GET_STARRING=log1, GET_COMPANY=log2, ERROR=error)
   IF Error THEN BEGIN
       console, 'data doesnt exist...'+filename, /WARN
       console, 'stopping', /FATAL
   END
   INFO = log1 + ', ' + log2
   IF Set(TIME) THEN BEGIN
       IF TIME(1) LT 0 THEN TIME(1)=max_time+TIME(1)
       IF max_time-1 LT TIME(1) THEN BEGIN
           TIME(1) = max_time-1
           console, 'requested time interval larger than actual recorded!!', /WARN
           console, '', /WARN
       END
   END ELSE TIME = [0,max_time-1]
   IF TIME(0) GT TIME(1) THEN Console, 'start time ('+STR(Time(0))+') is larger than stop time ('+STR(Time(1))+')', /FATAL

   anz = anz(1)
   IF Set(Select) THEN BEGIN
      IF (MAX(Select) GE anz) OR (MIN(Select) LT 0) THEN BEGIN
         console, 'illegal SELECT index', /FATAL
      END
      anz =  N_Elements(SELECT)
   END
   IF Keyword_Set(MEMBRANE) OR Keyword_Set(LFP) THEN xt = DblArr(anz, TIME(1)-TIME(0)+1) ELSE xt = BytArr(anz, TIME(1)-TIME(0)+1)

   TIME = LONG(TIME)
   print, 'READSIM REMINDER!! TIME is somewhat corrupted'
   REWIND, Video, TIME(0), /SHUTUP
   IF Set(Select) THEN BEGIN
      FOR t=TIME(0), TIME(1) DO BEGIN
         tmp = Replay(Video)
         xt(*,t-TIME(0)) = tmp(Select)
         IF ((t-time(0)) MOD ((time(1)-time(0))/20)) EQ 0 THEN console, 'loading...'+STR((t-time(0))*100/(time(1)-time(0)))+' %',/UP
      END
   END ELSE BEGIN
      FOR t=TIME(0), TIME(1) DO BEGIN
         xt(*,t-TIME(0)) = Replay(Video)
         IF ((t-time(0)) MOD ((time(1)-time(0))/20)) EQ 0 THEN console, 'loading...'+STR((t-time(0))*100/(time(1)-time(0)))+' %', /UP
      END
   END
   Eject, Video, /SHUTUP


   IF Keyword_Set(INPUT)    THEN console, 'loading input spikes...done', /UP
   IF Keyword_Set(OUTPUT)   THEN console, 'loading output spikes...done', /UP
   IF Keyword_Set(MEMBRANE) THEN console, 'loading membrane potentials...done', /UP
   IF Keyword_Set(MUA)      THEN console, 'loading MUA...done', /UP
   IF Keyword_Set(LFP)      THEN console, 'loading LFP...done', /UP

   RETURN, xt
END
