LIBS_FOLDER = "./libs"

install:
	rm -rf $(LIBS_FOLDER)
	mkdir -p $(LIBS_FOLDER)
	wget -q -P $(LIBS_FOLDER)/ https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
	tar -C $(LIBS_FOLDER) -xjf $(LIBS_FOLDER)/*.tar.bz2


