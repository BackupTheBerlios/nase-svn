
TARGET = idlparse

BYACC      = /usr/bin/pbyacc
BYACC_OPTS = -d -v

SHELL = /bin/bash

all: $(TARGET)


$(TARGET): IDLparser.pm 

%.pm: %.y
	$(BYACC) $(BYACC_OPTS) -P $* $<
