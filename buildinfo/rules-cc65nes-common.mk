AS.target=ca65
LD.target=ld65

%.nes : $(TARGET_DIR)/%.prg %.chr
	cat $^ >$@

%.prg : %.o
	$(LD.target) -o $@ -C nes.lds $^

$(TARGET_DIR)/%.o : %.s
	$(AS.target) -o $@ $^

$(TARGET_DIR)/%-pal.o : %.s
	$(AS.target) -o $@ -D PAL=1 $^
