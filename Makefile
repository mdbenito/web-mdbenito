# Programs:
# Install htmlmin with npm install -g html-minifier-cli
# Install cssnano with npm install -g cssnano-cli
# Copy the jar of the closure compiler to some folder
HTMLMIN=/usr/local/bin/htmlmin
CSSNANO=/usr/local/bin/cssnano
CLOSURE_COMPILER=/Users/miguel/Applications/closure-compiler/compiler.jar
TMP=/tmp
JAVA="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java"

#### HTML config
HTML_SRC_DIR=src
HTML_SRC=index.html
HTML_DEST_DIR=public
HTML_OUT=$(HTML_DEST_DIR)/index.html
HTML_IN=$(addprefix $(strip $(HTML_SRC_DIR))/,$(HTML_SRC))

#### JS config
JS_SRC_DIR=src/js
JS_PRECOMPILED=jquery.min.js jquery.scrolly.min.js jquery.scrollzer.min.js jqmath-etc-0.4.3.min.js
JS_SRC=jquery.tipsy.js jquery.lazyloadxt.js skel.js util.js main.js
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
CSS_IN_IE=$(addprefix $(strip $(CSS_SRC_DIR))/,$(CSS_SRC_IE))
CSS_MIN_IE=$(addsuffix .min.css,$(basename $(CSS_IN_IE)))

#### Rules:
.PHONY: all clean

all: $(CSS_OUT) $(CSS_MIN_IE) $(JS_OUT) $(HTML_OUT)
	$(info Done)

$(CSS_OUT): $(CSS_MIN)
	$(info Joining minified CSS)
	@cat $^ > $@

$(CSS_MIN): %.css.min: %.css
	$(info Minifying $(notdir $<))
	@$(CSSNANO) $< $@
	@# Add a newline at the end for nicer concatenation
	@echo >> $@

# FIXME: HACK: should use some CSS_OUT_IE 
$(CSS_MIN_IE): %.min.css: %.css
	$(info Minifying and copying $(notdir $<) (FIXME))
	@$(CSSNANO) $< $@
	@mv $@ $(addprefix $(strip $(CSS_DEST_DIR))/,$(notdir $@))

# FIXME: I should compile files separately then join them...
$(JS_OUT): $(JS_IN)
	$(info Compiling $^)
	@# NOTE: things break with --compilation_level ADVANCED
	@$(JAVA) -jar $(CLOSURE_COMPILER) --js $^ --js_output_file $(TMP)/$(notdir $@)
	@cat $(JS_PRE) $(TMP)/$(notdir $@) > $@

$(JS_IN):;

$(HTML_OUT): $(HTML_IN)
	$(info Minifying $<)
	@$(HTMLMIN) $< -o $@

clean:
	rm $(CSS_MIN)

