/*
** NAME:         mtime
**
** INPUTS: 
**               1: idl-string containing the filepath
**               2: optional idl-string which will contain the date-string 
**                  after call
**        
** OUTPUTS:      file modification time (in seconds past 1970 as idl-long) or 
**               -1 if an error occured
**
** AUTHOR:       Mirko Saam
**
** MODIFICATION HISTORY:
**
**       $Log$
**       Revision 1.2  1999/03/04 16:30:26  saam
**            + works for alpha, problems with i386 architecture
**
**       Revision 1.1  1999/02/25 20:49:21  saam
**             + added optional outputstring
**             + memory holes fixed
**
**       Revision 1.2  1999/02/24 20:42:26  saam
**             removed debug messages
**
**       Revision 1.1.1.1  1999/02/24 19:39:32  saam
**             NEXT GENERATION: NASE uses C
**
*/
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include "/vol/graphic/idl_5/external/export.h"


#define ERROR -1


IDL_LONG mtime(int   argc  ,
	       void *argv[])
{
  IDL_STRING	     *arg0str; 	/* Pointer to IDL STRING (FILE) */
  IDL_STRING         *arg1str;  /* Pointer to IDL STRING (DATE) */

  struct stat         mystat;
  int                 error ;
  extern int          errno ;   
  extern long int     timezone;
  char	             *filestr;    /* pointer to a C string (FILE) */
  char               *datestr;    /* pointer to a C string (DATE) */
  char               *returnstr;
  time_t              time  ;

  if ((argc < 1) || (argc > 2)){
    fprintf(stderr, "mtime: expected 1 or 2 and got %i elements!", argc);
    return(ERROR);
  }


  /*
  ** convert IDL-String to C-String
  */
  arg0str = (IDL_STRING *) argv[0];
  if( (filestr=(char*)malloc((unsigned)sizeof(char)* (arg0str->slen)+1) ) == (char*)NULL ){
    /*fprintf(stderr,"mtime: malloc error\r\n");*/
    return(ERROR);
  }
  filestr = strcpy(filestr, arg0str->s);


  error = stat(filestr, &mystat);
  free(filestr);
  if (error){
    /*fprintf(stderr, "fstat: %s, %s\n", filestr, strerror(errno));*/
    return(ERROR);
  } 

  fprintf(stderr, "timezone: %i\n", timezone);
  time=mystat.st_mtime+timezone+3600;
  fprintf(stderr, "mm: %i\n", time);

  if (argc == 2){
    arg1str = (IDL_STRING *) argv[1];
    
    datestr = ctime(&time);
    if( (returnstr = (char*)malloc(strlen(datestr)+1) ) == (char *)NULL){
      fprintf(stderr,"mtime: malloc error.\r\n");
      return(ERROR);
    }
    returnstr = strcpy(returnstr, datestr);

    free(arg1str->s);
    arg1str->slen=strlen(returnstr);
    arg1str->s=returnstr;
  }

  
  /*printf("%i\n", mystat.st_mtime);*/
  return(time);
}   
