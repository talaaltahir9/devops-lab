SRC_DIR := src
OUT_DIR := out
SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all check build test clean ci

all: test

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt | $(OUT_DIR)
	@echo " BUILD $< -> $@"
	@tr '[:lower:]' '[:upper:]' < $< > $@

check:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "ERROR: source directory $(SRC_DIR) does not exist"; \
		exit 1; \
	fi
	@if [ -z "$(SOURCES)" ]; then \
		echo "ERROR: no .txt files found in $(SRC_DIR)"; \
		exit 1; \
	fi
	@echo "CHECK PASSED: $(words $(SOURCES)) source files found"

build: $(OUTPUTS)

test: build
	@if grep -l '[a-z]' $(OUTPUTS) >/dev/null 2>&1; then \
		echo "TEST FAILED: lowercase characters remain"; \
		exit 1; \
	fi
	@echo "TEST PASSED"

clean:
	rm -rf $(OUT_DIR)

ci: clean check test
count: build ## count the source files
	@ls -1 $(SRC_DIR)/*.txt | wc -l
