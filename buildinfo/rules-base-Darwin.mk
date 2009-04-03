##############################################################################
# OS specific rules
##############################################################################

%.dylib : %.shared.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(TARGET_ARCH) $(filter %.o %a,$^) $(LOADLIBES) $(LDLIBS) -dynamiclib -Wl,-headerpad_max_install_names,-undefined,dynamic_lookup,-compatibility_version,1.0,-current_version,1.0,-install_name,/usr/local/lib/$(SHARED_SONAME) -o $@

