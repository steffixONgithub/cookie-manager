SOURCES = $(wildcard cookie-manager.* cookie-manager-firefox.js icons/*.png) background.js datetime-local-polyfill.js options.js

CHROME_ZIP = cookie-manager-chrome.zip
FIREFOX_ZIP = cookie-manager-firefox.zip
FIREFOX_DIR = cookie-manager-firefox

.PHONY: all clean run-firefox

all: $(CHROME_ZIP) $(FIREFOX_ZIP)

$(CHROME_ZIP): $(SOURCES) manifest.json
	7z u $@ $(SOURCES) manifest.json

$(FIREFOX_DIR): $(SOURCES) manifest_firefox.json
	[ -d $(FIREFOX_DIR) ] || mkdir $(FIREFOX_DIR)
	rsync -Rt $(SOURCES) $(FIREFOX_DIR)/
	cp --preserve=timestamps manifest_firefox.json $(FIREFOX_DIR)/manifest.json

$(FIREFOX_ZIP): $(FIREFOX_DIR)
	cd $(FIREFOX_DIR) && 7z u ../$@ $(SOURCES) manifest.json

run-firefox: $(FIREFOX_DIR)
	cd $(FIREFOX_DIR) && web-ext run

clean:
	rm -rf $(FIREFOX_DIR)
	rm -f $(CHROME_ZIP) $(FIREFOX_ZIP)
