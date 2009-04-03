##############################################################################
# OS specific rules
##############################################################################

%.so : %.shared.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(TARGET_ARCH) $(filter %.o %.a,$^) $(LOADLIBES) $(LDLIBS) -shared -Wl,-soname,$(SHARED_SONAME) -o $@
