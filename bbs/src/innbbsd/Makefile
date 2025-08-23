# ------------------------------------------------------ #
#  innbbsd/Makefile     ( NTHU CS MapleBBS Ver 3.10 )    #
# ------------------------------------------------------ #
#  target : Makefile for 轉信程式 innbbsd                #
#  create : 95/03/29                                     #
#  update : 01/08/26                                     #
#  author : skhuang                                      #
# ------------------------------------------------------ #


# ------------------------------------------------------ #
# 下列的 make rules 不需修改				 #
# ------------------------------------------------------ #

INNOBJS	= channel.o bbslib.o convcode.o inntobbs.o rec_article.o nocem.o history.o

LNKOBJS	= bbslink.o bbslib.o convcode.o inntobbs.o rec_article.o nocem.o history.o

INNBBSD	= innbbsd bbslink

EXE	= $(INNBBSD)


all: 
	@echo "Please enter 'make sys-type', "
	@echo " make sun     : for Sun-OS 4.x and maybe some BSD systems, cc or gcc" 
	@echo " make linux   : for Linux"
	@echo " make solaris : for Sun-OS 5.x gcc" 
	@echo " make sol-x86 : for Solaris 7 x86"
	@echo " make freebsd : for BSD 4.4 systems" 
	@echo " make bsd     : for BSD systems, cc or gcc, if not in the above lists" 
	@echo " make cygwin  : for Microsoft Windows and Cygwin gcc"

sun:
	@$(MAKE) CC=gcc CFLAGS="-m32 -O2 -pipe -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration -I../include" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386" $(EXE)

linux:
	@$(MAKE) CC=gcc CFLAGS="-m32 -O2 -pipe -I../include -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386" $(EXE)

solaris:
	@$(MAKE) CC=gcc CFLAGS="-DSOLARIS -m32 -O2 -pipe -I../include -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386 -lsocket -lnsl -L/usr/ucblib -lucb" $(EXE)

sol-x86:
	@$(MAKE) CC=gcc CFLAGS="-DSOLARIS -m32 -O2 -I../include -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386 -lsocket -lnsl" $(EXE)

freebsd:
	@$(MAKE) CC=gcc CFLAGS="-m32 -O2 -pipe -I../include -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386" $(EXE)

bsd:
	@$(MAKE) CC=gcc CFLAGS="-m32 -O2 -pipe -I../include -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386" $(EXE)

cygwin:
	@$(MAKE) CC=gcc CFLAGS="-DCYGWIN -m32 -O2 -pipe -I../include -fomit-frame-pointer -fno-stack-protector -Wunused-result -Wunused -Wno-implicit-function-declaration" LDFLAGS="-s -L../lib -ldao -Wl,-melf_i386 -lcygipc" $(EXE)



bbslink: $(LNKOBJS)
	$(CC) -m32 -o bbslink $(LNKOBJS) $(OPT) $(LDFLAGS)

innbbsd: $(INNOBJS)
	$(CC) -m32 -o innbbsd $(INNOBJS) $(OPT) $(LDFLAGS)


install: $(INNBBSD)
	install -m 0700 $? $(HOME)/innd

update:
	-csh -c "kill `tail -1 $(HOME)/run/innbbsd.pid | awk '{print $$1}'`";exit 0

clean:
	rm -f $(EXE) *.exe *.o *~
