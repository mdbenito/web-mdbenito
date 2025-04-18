# Programs:
# Install htmlmin with npm install -g html-minifier-cli
# Install cssnano with npm install -g cssnano-cli
# Copy the jar of the closure compiler to some folder
HTMLMIN=npx htmlmin
CSSNANO=npx cssnano
CLOSURE_COMPILER=npx google-closure-compiler
RM=rm -f
TMP=/tmp

#### HTML config
HTML_SRC_DIR=src
HTML_SRC=index.html
HTML_DEST_DIR=public
HTML_OUT=$(HTML_DEST_DIR)/index.html
HTML_IN=$(addprefix $(strip $(HTML_SRC_DIR))/,$(HTML_SRC))

#### JS config
JS_SRC_DIR=src/js
JS_PRECOMPILED=jquery.min.js jquery.scrolly.min.js jquery.scrollzer.min.js jqmath-etc-0.4.3.min.js
JS_SRC=jquery.tipsy.js jquery.lazyloadxt.js skel.js util.js zmain.js
# TODO: Enable jquery.lazyloadxt.autoload.js *with* fadein

JS_DEST_DIR=public/assets/js
JS_OUT=$(JS_DEST_DIR)/everything.min.js
JS_IN=$(addprefix $(strip $(JS_SRC_DIR))/,$(JS_SRC))
JS_PRE=$(addprefix $(strip $(JS_SRC_DIR))/,$(JS_PRECOMPILED))

#### CSS config
CSS_SRC_DIR=src/css
CSS_SRC=fa-mini.css main.css tipsy.css jqmath-0.4.3.css jquery.lazyloadxt.fadein.css
CSS_SRC_IE=fa-mini-ie7.css ie8.css
CSS_DEST_DIR=public/assets/css
CSS_OUT=$(CSS_DEST_DIR)/everything.min.css

CSS_IN=$(addprefix $(strip $(CSS_SRC_DIR))/,$(CSS_SRC))
CSS_MIN=$(addsuffix .min,$(CSS_IN))

# CSS files for IE are not joined into CSS_OUT.
# Instead they are loaded separately from index.html if needed.
CSS_MIN_IE=$(addsuffix .min.css,$(basename $(CSS_SRC_IE)))
CSS_OUT_IE=$(addprefix $(strip $(CSS_DEST_DIR))/,$(CSS_MIN_IE))

#### Rules:
.PHONY: all clean

all: $(CSS_OUT) $(CSS_OUT_IE) $(JS_OUT) $(HTML_OUT)
	$(info Done)

$(CSS_OUT): $(CSS_MIN)
	$(info Joining minified CSS)
	@mkdir -p $(CSS_DEST_DIR)
	@cat $^ > $@

$(CSS_MIN): %.css.min: %.css
	$(info Minifying $(notdir $<))
	@$(CSSNANO) $< $@
	@# Add a newline at the end for nicer concatenation
	@echo >> $@

# This target is $(CSS_OUT_IE):
$(CSS_DEST_DIR)/%.min.css: $(CSS_SRC_DIR)/%.css
	$(info Minifying $(notdir $<))
	@$(CSSNANO) $< $@

# FIXME: I should compile files separately then join them...
$(JS_OUT): $(JS_IN)
	$(info Compiling $^)
	@mkdir -p $(JS_DEST_DIR)
	@# NOTE: things break with --compilation_level ADVANCED
	@$(CLOSURE_COMPILER) $^ > $(TMP)/$(notdir $@)
	@cat $(JS_PRE) $(TMP)/$(notdir $@) > $@

$(JS_IN):;

$(HTML_OUT): $(HTML_IN)
	$(info Minifying $<)
	@$(HTMLMIN) $< -o $@

clean:
	$(RM) $(CSS_MIN) 
	$(RM) $(CSS_OUT)
	$(RM) $(JS_OUT)
	$(RM) $(HTML_OUT)
	$(RM) $(CSS_OUT_IE)
