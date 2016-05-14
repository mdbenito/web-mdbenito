# Programs:
# Install cssnano with npm install -g cssnano-cli
# Copy the jar of the closure compiler to some folder
CSSNANO=/usr/local/bin/cssnano
CLOSURE_COMPILER=/Users/miguel/Applications/closure-compiler/compiler.jar
TMP=/tmp

# JS config
JS_SRC_DIR=src/js
JS_PRECOMPILED=jquery.min.js jquery.scrolly.min.js jquery.scrollzer.min.js jqmath-etc-0.4.3.min.js
JS_SRC=jquery.tipsy.js jquery.lazyloadxt.js skel.js util.js main.js
JS_IN=$(addprefix $(strip $(JS_SRC_DIR))/,$(JS_SRC))
JS_PRE=$(addprefix $(strip $(JS_SRC_DIR))/,$(JS_PRECOMPILED))

JS_DEST_DIR=public/assets/js
JS_OUT=$(JS_DEST_DIR)/everything.min.js

# CSS config
CSS_SRC_DIR=src/css
CSS_SRC=font-awesome.css main.css tipsy.css jqmath-0.4.3.css jquery.lazyloadxt.fadein.css
CSS_IN=$(addprefix $(strip $(CSS_SRC_DIR))/,$(CSS_SRC))
CSS_MIN=$(addsuffix .min,$(CSS_IN))

CSS_DEST_DIR=public/assets/css
CSS_OUT=$(CSS_DEST_DIR)/everything.min.css


# Rules:
.PHONY: all clean

all: $(CSS_OUT) $(JS_OUT)
	$(info Done)

$(CSS_OUT): $(CSS_MIN)
	$(info Joining minified CSS)
	@cat $^ > $@

$(CSS_MIN): %.css.min: %.css
	$(info Minifying $(notdir $<))
	@$(CSSNANO) $< $@
	@# Add a newline at the end for nicer concatenation
	@echo >> $@

$(JS_OUT): $(JS_IN)
	$(info Compiling $^)
	@# NOTE: things break with --compilation_level ADVANCED
	@java -jar $(CLOSURE_COMPILER) --js $^ --js_output_file $(TMP)/$(notdir $@)
	@cat $(JS_PRE) $(TMP)/$(notdir $@) > $@

$(JS_IN):;

clean:
	rm $(CSS_MIN)

