AS.target=ca65
LD.target=ld65

%.nes : $(TARGET_DIR)/%.prg %.chr
	cp $(filter %.prg,$^) $@
	dd if=$(filter %.prg,$^) of=$@ conv=notrunc bs=16400 seek=1

%.prg : %.o
	$(LD.target) -o $@ -C nes.lds $^

%.chr : %.png
	pngtochr -o $@ $^

$(TARGET_DIR)/%.o : %.s
	$(AS.target) -o $@ $^

$(TARGET_DIR)/%-pal.o : %.s
	$(AS.target) -o $@ -D PAL=1 $^
