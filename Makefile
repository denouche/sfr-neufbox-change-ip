LIBS_FOLDER = "./libs"
TMP_FOLDER="./tmp"

install: clean
	mkdir -p $(LIBS_FOLDER)
	wget -q -P $(LIBS_FOLDER)/ https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
	tar -C $(LIBS_FOLDER) -xjf $(LIBS_FOLDER)/*.tar.bz2


clean:
	rm -rf $(LIBS_FOLDER)
	rm -rf $(TMP_FOLDER)
