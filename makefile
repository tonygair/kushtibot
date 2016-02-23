all: kushtibot 

kushtibot:
	 gprbuild -p -Pkushtibot.gpr

clean:
	 gprclean -Pkushtibot.gpr
