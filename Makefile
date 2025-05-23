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

# Enable verbose output if V=1 is set
V ?= 0
ifeq ($(V),1)
  Q :=
  E := @true
else
  Q := @
  E := @echo
endif

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
	$(E) "  PROTOC  $<"
	$(Q)$(PROTOC) $(PROTOC_OPTS) --nanopb_out=$(GENC_DIR) --proto_path=$(PROTO_DIR) $<

# C code generation target
c: $(GENC_SRCS) $(GENC_HDRS)
	$(E) "C code generation complete"

# Generate TypeScript code from proto files
$(GENTS_DIR)/%.ts: $(PROTO_DIR)/%.proto | $(GENTS_DIR)
	$(E) "  TS-GEN  $<"
	$(Q)if [ ! -x "$(PROTOC_GEN_TS)" ]; then \
		echo "Error: TypeScript plugin ($(PROTOC_GEN_TS)) not found or not executable"; \
		echo "Please install it with: npm install -g protoc-gen-ts"; \
		exit 1; \
	fi
	$(Q)$(PROTOC) $(PROTOC_OPTS) --plugin=protoc-gen-ts=$(PROTOC_GEN_TS) --ts_out=$(GENTS_DIR) --proto_path=$(PROTO_DIR) $<

# TypeScript code generation target
ts: $(GENTS_SRCS)
	$(E) "TypeScript code generation complete"

# Clean generated files
clean:
	$(E) "  CLEAN   $(GENERATED_DIR)"
	$(Q)rm -rf $(GENERATED_DIR)/*

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
	@echo "  V=1       - Enable verbose output"
	@echo "  -j N      - Run N parallel jobs (default: auto)"
	@echo ""
	@echo "Example usage:"
	@echo "  make              # Generate all code"
	@echo "  make V=1          # Generate all code with verbose output"
	@echo "  make clean        # Remove all generated files"
	@echo "  make c            # Generate C code only"
	@echo "  make ts           # Generate TypeScript code only"
