# Nanopb Protocol Buffers Code Generation Makefile
# Generates C and TypeScript code from Protocol Buffer definitions

# Enable parallel jobs by default (can be overridden with make -j N)
MAKEFLAGS += --jobs

.PHONY: all clean c ts help

# Include the nanopb provided Makefile rules
include nanopb/extra/nanopb.mk

# Configuration
PROTOC_GEN_TS := /usr/local/bin/protoc-gen-ts
PROTO_DIR := proto
GENERATED_DIR := generated
GENC_DIR := $(GENERATED_DIR)/c
GENTS_DIR := $(GENERATED_DIR)/ts

# Compiler flags to enable all warnings & debug info
CFLAGS := -Wall -Werror -g -O0
CFLAGS += -I$(NANOPB_DIR)

# Nanopb source files (defined but not currently used in compilation)
CSRC := $(NANOPB_DIR)/pb_common.c
CSRC += $(NANOPB_DIR)/pb_encode.c
CSRC += $(NANOPB_DIR)/pb_decode.c

# Find all proto files and derive output filenames
PROTO_SRCS := $(wildcard $(PROTO_DIR)/*.proto)
PROTO_BASENAMES := $(notdir $(PROTO_SRCS))
GENC_SRCS := $(patsubst %.proto,$(GENC_DIR)/%.pb.c,$(PROTO_BASENAMES))
GENC_HDRS := $(patsubst %.proto,$(GENC_DIR)/%.pb.h,$(PROTO_BASENAMES))
GENTS_SRCS := $(patsubst %.proto,$(GENTS_DIR)/%.ts,$(PROTO_BASENAMES))

# Derive copied nanopb source files in GENC_DIR
CSRC_COPIED := $(patsubst $(NANOPB_DIR)/%.c,$(GENC_DIR)/%.c,$(CSRC))
CSRC_HDRS := $(patsubst %.c,%.h,$(CSRC))
CSRC_HDRS_COPIED := $(patsubst $(NANOPB_DIR)/%.h,$(GENC_DIR)/%.h,$(CSRC_HDRS))

# Check if required tools are available
ifeq ($(shell which $(PROTOC) 2>/dev/null),)
$(error Protocol buffer compiler (protoc) not found in PATH)
endif

# Check TypeScript plugin (warning only, not error)
ifeq ($(shell test -x $(PROTOC_GEN_TS) && echo yes),)
$(warning TypeScript plugin ($(PROTOC_GEN_TS)) not found or not executable. TypeScript generation may fail.)
endif

# Default target
all: c ts

# Create output directories
$(GENC_DIR) $(GENTS_DIR):
	mkdir -p $@

# Generate C code from proto files
$(GENC_DIR)/%.pb.c $(GENC_DIR)/%.pb.h: $(PROTO_DIR)/%.proto | $(GENC_DIR)
	$(PROTOC) $(PROTOC_OPTS) --nanopb_out=$(GENC_DIR) --proto_path=$(PROTO_DIR) $<

# Copy nanopb source files to GENC_DIR
$(GENC_DIR)/%.c: $(NANOPB_DIR)/%.c | $(GENC_DIR)
	cp $< $@

$(GENC_DIR)/%.h: $(NANOPB_DIR)/%.h | $(GENC_DIR)
	cp $< $@

# C code generation target
c: $(GENC_SRCS) $(GENC_HDRS) $(CSRC_COPIED) $(CSRC_HDRS_COPIED)
	@echo "C code generation complete"

# Generate TypeScript code from proto files
$(GENTS_DIR)/%.ts: $(PROTO_DIR)/%.proto | $(GENTS_DIR)
	@if [ ! -x "$(PROTOC_GEN_TS)" ]; then \
		echo "Error: TypeScript plugin ($(PROTOC_GEN_TS)) not found or not executable"; \
		echo "Please install it with: npm install -g protoc-gen-ts"; \
		exit 1; \
	fi
	$(PROTOC) $(PROTOC_OPTS) --plugin=protoc-gen-ts=$(PROTOC_GEN_TS) --ts_out=$(GENTS_DIR) --proto_path=$(PROTO_DIR) $<

# Generate index.ts that re-exports all TypeScript files
$(GENTS_DIR)/index.ts: $(GENTS_SRCS) | $(GENTS_DIR)
	@echo "Generating TypeScript index file"
	@echo "// Auto-generated index file that re-exports all generated TypeScript modules" > $@
	@$(foreach file,$(GENTS_SRCS),echo "export * from './$(basename $(notdir $(file)).ts)';" >> $@;)

# TypeScript code generation target
ts: $(GENTS_SRCS) $(GENTS_DIR)/index.ts
	@echo "TypeScript code generation complete"

# Clean generated files
clean:
	@echo "Cleaning generated files"
	@rm -rf $(GENERATED_DIR)/*

# Help target
help:
	@echo "Nanopb Protocol Buffers Code Generator"
	@echo ""
	@echo "Available targets:"
	@echo "  all       - Generate both C and TypeScript code (default)"
	@echo "  c         - Generate C code only"
	@echo "  ts        - Generate TypeScript code only"
	@echo "  clean     - Remove all generated files"
	@echo "  help      - Display this help message"
	@echo ""
	@echo "Options:"
	@echo "  -j N      - Run N parallel jobs (default: auto)"
	@echo ""
	@echo "Example usage:"
	@echo "  make              # Generate all code"
	@echo "  make clean        # Remove all generated files"
	@echo "  make c            # Generate C code only"
	@echo "  make ts           # Generate TypeScript code only"
