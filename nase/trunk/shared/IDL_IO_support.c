#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <fcntl.h>
#include "export.h"

// IDL_EFS_STDIO was new in IDL 5.3:
#ifndef IDL_EFS_STDIO
#define IDL_EFS_STDIO IDL_EFS_NOT_NOSTDIO
#endif

#include "IDL_IO_support.h"

/*
 * ========================== interne Routinen: ==========================================================
 */
int get_fd_intern (IDL_LONG lun)
{
  IDL_FILE_STAT file_info;

  IDL_FileStat(lun, &file_info);    /*Get file information for lun*/
  return( fileno(file_info.fptr) ); /*Return FileDescriptor*/
}


int get_fd_array (IDL_LONG *lun_array, int n_elements, int *fd_array)
{
  int max_fd = 0;
  int i;
  for (i=n_elements-1 ;i >= 0; i--) 
  {
    fd_array[i]=get_fd_intern(lun_array[i]);
    max_fd = (fd_array[i]>max_fd)? fd_array[i] : max_fd; /* Find greatest used descriptor */
  }
  return (max_fd);
}

/* =======================================================================================================*/


/* ========================= Call_External-Routinen: =====================================================*/

IDL_LONG get_fd (int argc, void* argv[])
{
  int lun, fd;

  if (argc != 1) 
    IDL_Message(IDL_M_NAMED_GENERIC, IDL_MSG_LONGJMP|IDL_MSG_ATTR_BELL,
		"get_fd() erwartet genau eine LUN!");

  lun = * ((IDL_LONG*) argv[0]); /* argv[0] is a pointer to an IDL_LONG*/
  fd = get_fd_intern(lun);

  return( fd );
}

// -------------------------------------------------------------------------------------------------------

IDL_LONG wait_for_data (int argc, void *argv[])
{ 
  IDL_LONG *lun_array=NULL;
  IDL_LONG  n_elements;
  IDL_LONG  secs;
  IDL_LONG  microsecs;
  int *fd_array=NULL; /* array of file descriptors */
  int max_fd;         /* Greatest used descriptor*/
  fd_set readset;
  struct timeval waittime;
  struct timeval *waittimeptr=NULL;
  int number_ready = 0;
  int i;

  if (argc != 4)
  {
    IDL_Message(IDL_M_NAMED_GENERIC, IDL_MSG_LONGJMP|IDL_MSG_ATTR_BELL,
		"wait_for_data() erwartet genau vier Parameter:" "\n" 
		"   1. lun_array            : ein Array von LUNs. Datentyp: ARRAY(LONG)" "\n"  
		"   2. N_ELEMENTS(lun_array): Anzahl der Elemente im Array. Datentyp: LONG" "\n"
		"   3. secs                 : Wartezeit(Sekundenteil). -1 entspricht unendlich. Datentyp: LONG" "\n"
		"   4. microsecs            : Wartezeit(Mikrosekundenteil). Wird eventuell aufgerundet. Datentyp: LONG" "\n"
		" Als Ergebnis liefert wait_for_data()" "\n"
		"   >0 : Die Anzahl der nicht-blockierend lesbaren Units." "\n"
		"        In diesem Fall enthält lun_array eine Boolesche Maske derjenigen LUNs, die lesbar sind." "\n"
		"        In allen anderen Fällen wird lun_array nicht verändert." "\n"
		"    0, falls die Wartezeit um und keine Unit nicht-blockierend lesbar ist" "\n"
		"   -1, falls ein Fehler autrat. Das umfaßt auch das eintreffen eines Signals vor Ablauf der Wartezeit!" "\n"
		"       (IDL-Timer-Signale werden aber für die Dauer der Ausführung blockiert.)" "\n"
		" wait_for_data() markiert eine LUN auch dann als lesbar, wenn der nächste Leseversuch darauf" "\n"
		" EOF liefert. (Der Aufruf blockiert dann ja nicht.) D.h. vor dem Leseversuch muß wie gewöhnlich auf EOF geprüft werden.");
  }
  
  /* Import arguments: ------------ */
  lun_array =   ((IDL_LONG *) argv[0]); /* argv[0] is a pointer to an IDL_LONG, i.e. "the array itself". */
  n_elements = *((IDL_LONG *) argv[1]); /* argv[1] is a pointer to n_elements(array)*/
  secs       = *((IDL_LONG *) argv[2]); /* argv[2] is a pointer to an IDL_LONG*/
  microsecs  = *((IDL_LONG *) argv[3]); /* argv[3] is a pointer to an IDL_LONG*/
  
  /* Check for file properties: ---*/
  for (i=0; i<n_elements; i++) 
    IDL_FileEnsureStatus(IDL_MSG_LONGJMP, lun_array[i], IDL_EFS_OPEN|IDL_EFS_READ|IDL_EFS_STDIO);

  /* Get filedescriptors: ---------*/
  fd_array= (int *)calloc(n_elements,sizeof(int));

  max_fd = get_fd_array(lun_array, n_elements, fd_array); /* Get fildescriptors from LUNs */
  
  /* Prepare fd_sets for select() - */
  
  FD_ZERO (&readset);

  for (i=0; i<n_elements; i++) 
  {
    FD_SET(fd_array[i], &readset);
  }

  
  /* Set time to wait (secs==-1 means forever) */
  waittime.tv_sec = secs;
  waittime.tv_usec = microsecs;
  
  if (secs == -1) 
    waittimeptr=NULL;
  else 
    waittimeptr=&waittime;

  
  /*
   * Call select() and wait
   */
 /* We do not want to be disturbed by IDL-Timer-signals! */
  IDL_TimerBlock(TRUE);
  number_ready = select(max_fd+1, &readset, NULL, NULL, waittimeptr);
  /* Re-allow IDL-Timer-signals! */
  IDL_TimerBlock(FALSE);
  
  /*
   * Return readable LUN in lun_array
   */
  if (number_ready > 0)
  {
    for (i=0; i<n_elements; i++)
    {
      lun_array[i] = FD_ISSET(fd_array[i], &readset) ? IDL_TRUE : IDL_FALSE;
    }
  }

  free(fd_array);
  return(number_ready);
}

IDLBool_t non_block_readable (int argc, void* argv[])
{
  IDLBool_t result = IDL_FALSE;
  IDL_LONG lun;
  IDL_FILE_STAT file_info;
  FILE *fptr;
  int fd=-1;
  int flags=-1;
  int c;

  if (argc != 1) // Exactly two arguments expected
  {
    IDL_Message(IDL_M_NAMED_GENERIC, IDL_MSG_LONGJMP|IDL_MSG_ATTR_BELL,
		"non_block_readable() erwartet genau einen Parameter:" "\n" 
		"   1. lun : Die LUN, die auf Lesbarkeit geprüft werden soll. Datentyp: LONG" "\n" 
		" Als Ergebnis liefert non_block_readable()" "\n"
		"   TRUE,  falls die betreffende LUN nicht-blockierend lesbar ist." "\n"
		"   FALSE, falls ein Leseversuch auf die betreffende LUN blockieren würde."); 
  }
  
  /*
   * Import arguments: ------------
   */
  lun  = *((IDL_LONG*) argv[0]); /* argv[0] is a pointer to an IDL_LONG*/

  
  /*
   * Check for file properties: ---
   */
  IDL_FileEnsureStatus(IDL_MSG_LONGJMP, lun, IDL_EFS_OPEN|IDL_EFS_READ|IDL_EFS_STDIO);

  IDL_FileFlushUnit(lun);

  /* 
   * Get FILE and filedescriptor: -
   */

  IDL_FileStat(lun, &file_info);    /*Get file information for lun*/
  fptr = file_info.fptr;

  assert(fptr != NULL);

  fd = fileno(fptr) ; /*Get FileDescriptor*/

  /*
   * Set Non-Blocking-Flag on this fd:
   */
  flags=fcntl(fd,F_GETFL);
  fcntl(fd,F_SETFL,flags|O_NONBLOCK);

  
  /*
   * Start read attempt on this FILE:
   */
  c = getc(fptr);
  if (!ferror(fptr))
  {
    ungetc(c, fptr);
    result = IDL_TRUE;
  }
  else
  {
    clearerr(fptr);
    result = IDL_FALSE;
  }
  
  /*
   * Reset Fileflags --------------
   */
  fcntl(fd,F_SETFL,flags);


  return(result);
}

// -------------------------------------------------------------------------------------------------------

IDL_LONG set_nonblocking (int argc, void* argv[])
{
  /* 
   * Import arguments: ------------
   */
  IDL_LONG lun  = *((IDL_LONG*) argv[0]);

  IDL_FILE_STAT file_info;
  FILE *fptr;
  int fd;
  int flags;

  /*
   *  Check for file properties: ---
   */
  IDL_FileEnsureStatus(IDL_MSG_LONGJMP, lun, IDL_EFS_OPEN|IDL_EFS_READ|IDL_EFS_STDIO);

  /*
   * Get FILE and filedescriptor: -
   */

  IDL_FileStat(lun, &file_info); 
  fptr = file_info.fptr;
  assert(fptr != NULL);
  fd = fileno(fptr) ;

  /*
   * Set Non-Blocking-Flag on this fd:
   */
  flags=fcntl(fd,F_GETFL);
  fcntl(fd,F_SETFL,flags|O_NONBLOCK);
  
  return 0;
}

IDL_LONG set_blocking (int argc, void* argv[])
{
  IDL_LONG lun;
  IDL_FILE_STAT file_info;
  FILE *fptr;
  int fd;
  int flags;

  /*
   * Import arguments: ------------
   */
  lun  = *((IDL_LONG*) argv[0]);
  
  /*
   * Check for file properties: ---
   */
  IDL_FileEnsureStatus(IDL_MSG_LONGJMP, lun, IDL_EFS_OPEN|IDL_EFS_READ|IDL_EFS_STDIO);

  /*
   * Get FILE and filedescriptor: -
   */
  IDL_FileStat(lun, &file_info); 
  fptr = file_info.fptr;
  assert(fptr != NULL);
  fd = fileno(fptr);

  /* 
   * Clear Non-Blocking-Flag on this fd:
   */
  flags=fcntl(fd,F_GETFL);
  fcntl(fd,F_SETFL,flags & ~(O_NONBLOCK));
  // ------------------------------
  
  return 0;
}

// -------------------------------------------------------------------------------------------------------

char* tmp_nam (int argc, void* argv[])
{
  return tmpnam(NULL);
}

// =======================================================================================================
