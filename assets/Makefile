# Programs:
# Install cssnano with npm install -g cssnano-cli
# Copy the jar of the closure compiler to some folder
CSSNANO=/usr/local/bin/cssnano
CLOSURE_COMPILER=/Users/miguel/Applications/closure-compiler/compiler.jar

# JS config
JS_SRC_DIR=src/js
JS_FILES=jquery.min.js jquery.scrolly.min.js jquery.scrollzer.min.js jqmath-etc-0.4.3.min.js jquery.tipsy.js skel.js util.js main.js
JS_IN=$(addprefix $(JS_SRC_DIR)/,$(JS_FILES))

JS_DEST_DIR=js
JS_OUT=$(JS_DEST_DIR)/everything.min.js

# CSS config
CSS_SRC_DIR=src/css
CSS_FILES=font-awesome.css main.css tipsy.css jqmath-0.4.3.css
CSS_IN=$(addprefix $(CSS_SRC_DIR)/,$(CSS_FILES))
CSS_MIN=$(addsuffix .min,$(CSS_IN))

CSS_DEST_DIR=css
CSS_OUT=$(CSS_DEST_DIR)/everything.min.css
CSS_TMP_DIR=/tmp


# Rules:
.PHONY: all clean

all: $(CSS_OUT) $(JS_OUT)
	@echo "Done?"

$(CSS_OUT): $(CSS_MIN)
	@echo "Joining css..."
	cat $^ > $@

$(CSS_MIN): %.css.min: %.css
	$(CSSNANO) $< $@

$(JS_OUT): $(JS_IN)
	@echo "Compiling Javascript..."
	java -jar $(CLOSURE_COMPILER) --compilation_level ADVANCED \
	   	--js $^ --js_output_file $@

$(JS_IN):;

clean:
	@echo "Do I need this?"
