SHELL=/bin/sh
CFLAGS=
FFLAGS=

OBJECTS=mtime.o IDL_IO_support.o

SHL_EXT=so
SHL_LIBS=nasec.$(SHL_EXT)
LIB_VER=0.0.1
# INSTALL_DIR=/vol/lib/nase



all : 
	@echo "OS type detected: "`uname`
	@case `uname` in \
	   "OSF1" )  make libs \
			"CC=cc" \
			"C_LD=ld" \
			"CFLAGS=-DOSF1 -I$(IDL_DIR)/external" \
			"C_LD_FLAGS=-S -shared" ;; \
	   "Linux" ) make libs \
			"CC=cc" \
			"C_LD=ld" \
			"CFLAGS=-fPIC -shared -I$(IDL_DIR)/external" \
			"C_LD_FLAGS=-shared" ;; \
	   "SunOS" ) make libs \
			"CC=/opt2/Forte7/SUNWspro/bin/cc" \
			"C_LD=/usr/ccs/bin/ld"\
			"CFLAGS=-xarch=generic64 -Kpic -G -I$(IDL_DIR)/external" \
			"C_LD_FLAGS=-G -Bdynamic" ;; \
	   *) echo "This system is not supported" ;; \
       esac


libs : $(SHL_LIBS)



nasec.$(SHL_EXT) : $(OBJECTS)
	$(C_LD) $(C_LD_FLAGS) -o nasec.$(SHL_EXT) $(OBJECTS) $(C_LD_POST)


# install: nasec.$(SHL_EXT)
# 	  @case `uname` in \
# 		  "OSF1" )  make _install "INSTALL=/usr/bin/installbsd" ;; \
# 		  "Linux" ) make _install "INSTALL=/usr/bin/install" ;;\
# 		  *) echo "This system is not supported" ;; \
# 	  esac
# 
# _install:
# 	  $(INSTALL)  -m 0777 nasec.$(SHL_EXT) $(INSTALL_DIR)/nasec.$(SHL_EXT).$(LIB_VER)
# 	  ln -sf $(INSTALL_DIR)/nasec.$(SHL_EXT).$(LIB_VER) $(INSTALL_DIR)/nasec.$(SHL_EXT)
 

tidy :
	rm -f *.o

clean :
	rm -f *.o *.so *.sl *.a so_locations
	rm -rf sunos_sparc
	rm -rf linux_x86
	rm -rf OSF_alpha

#  Rules for building the object files.

.SUFFIXES: .c .o .cc

.c.o :
	$(CC) $(CFLAGS) -c $*.c

.cc.o :
	$(CXX) $(CFLAGS) -c $*.cc
