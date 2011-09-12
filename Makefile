.PHONEY: all

all: thin_repair thin_dump thin_restore

SOURCE=\
	checksum.cc \
	endian_utils.cc \
	error_set.cc \
	metadata.cc \
	metadata_disk_structures.cc \
	space_map_disk.cc \
	transaction_manager.cc

OBJECTS=$(subst .cc,.o,$(SOURCE))
TOP_DIR:=$(PWD)
CPPFLAGS=-Wall -g -I$(TOP_DIR)
#CPPFLAGS=-Wall -std=c++0x -g -I$(TOP_DIR)
LIBS=-lz -lstdc++

.PHONEY: test-programs

test-programs: $(TEST_PROGRAMS)

.SUFFIXES: .cc .o .d

%.d: %.cc
	g++ -MM $(CPPFLAGS) $< > $@.$$$$;                  \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

.cc.o:
	g++ -c $(CPPFLAGS) $(INCLUDES) -o $@ $<

thin_dump: $(OBJECTS) thin_dump.o
	g++ $(CPPFLAGS) -o $@ $+ $(LIBS)

thin_restore: $(OBJECTS) thin_restore.o
	g++ $(CPPFLAGS) -o $@ $+ $(LIBS)

thin_repair: $(OBJECTS) thin_repair.o
	g++ $(CPPFLAGS) -o $@ $+ $(LIBS)

include unit-tests/Makefile.in
include $(subst .cc,.d,$(SOURCE))
include $(subst .cc,.d,$(TEST_SOURCE))
