##############################################################################
# Rules
##############################################################################

# creates executables that are stripped
stripped/% : %
	mkdir -p stripped
	$(STRIP) -o $@ $^

stripped/%.$(SOEXT) : %.$(SOEXT)
	mkdir -p stripped
	$(STRIP) -o $@ $^

#makes objects useful for tracing/debugging
#%.debug.o : CPPFLAGS:=$(filter-out -DNDEBUG,$(CPPFLAGS))
#%.debug.o : %.c
#	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -o $@ $<
# creates executables that have debug symbols
#%.debug : CPPFLAGS:=$(filter-out -DNDEBUG,$(CPPFLAGS))
#%.debug : %.c
#	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ -o $@ $(LOADLIBES) $(LDLIBS)

%: %.o
	$(CC) $(LDFLAGS) $(TARGET_ARCH) $(filter %.c %.o %.a,$^) -o $@ $(LOADLIBES) $(LDLIBS)

% : %.c
	$(CC) $(LDFLAGS) $(TARGET_ARCH) $(filter %.c %.o %.a,$^) -o $@ $(LOADLIBES) $(LDLIBS)

%.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -o $@ $(filter %.c %.o %.a,$<)

#Make position indepedent objects for shared libraries
%.shared.o : CFLAGS+=-fPIC
%.shared.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -o $@ $<

