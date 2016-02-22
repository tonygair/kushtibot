all: kushtibot 

kushtibot:
	 gprbuild  -P/home/tony/opensource/kushtibot/kushtibot.gpr -XDevelopment=Debug -XLegacy=Ada2005 -XAtomic_Access=GCC-long-offsets -XTasking=Multiple -XTraced_objects=Off -XPRJ_TARGET=Unix -XPRJ_BUILD=Debug

clean:
	 gprclean -Pkushtibot.gpr
