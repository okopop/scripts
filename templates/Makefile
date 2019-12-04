.PHONY: all

src_files := $(shell find src/ -name '*.sh')
transpiled_files := $(patsubst src/%,lib/%,$(src_files))

all: $(transpiled_files)

lib/%: src/%
        cp -f $< $@
