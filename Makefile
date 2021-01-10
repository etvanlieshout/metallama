.PHONY: all clean run

VIC_IMAGE = "bin/metallama.prg"
VIC_ORIG_IMAGE = "orig/metallama.prg"
XVIC = xvic

all: clean run
original: clean run_orig

metallama.prg: src/metallama.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/metallama.prg -L bin/list-co1.txt -l bin/labels.txt src/metallama.asm
	md5sum bin/metallama.prg orig/metallama.prg

run: metallama.prg
	$(XVIC) -verbose $(VIC_IMAGE)

run_orig:
	$(XVIC) -verbose -moncommands bin/labels.txt $(VIC_ORIG_IMAGE)

clean:
	-rm $(VIC_IMAGE)
	-rm bin/metallama.prg
	-rm bin/*.txt
