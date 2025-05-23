.PHONY: all clean c ts

# Include the nanopb provided Makefile rules
include nanopb/extra/nanopb.mk

PROTOC_GEN_TS = /usr/local/bin/protoc-gen-ts

# Compiler flags to enable all warnings & debug info
CFLAGS = -Wall -Werror -g -O0
CFLAGS += "-I$(NANOPB_DIR)"

CSRC = $(NANOPB_DIR)/pb_common.c
CSRC += $(NANOPB_DIR)/pb_encode.c
CSRC += $(NANOPB_DIR)/pb_decode.c

PROTO_SRCS := $(wildcard *.proto)

GENC_DIR := generated/c
GENC_SRCS := $(patsubst %.proto,$(GENC_DIR)/%.pb.c,$(PROTO_SRCS))
$(GENC_DIR):
	mkdir -p $(GENC_DIR)
$(GENC_DIR)/%.pb.c: %.proto | $(GENC_DIR)
	$(PROTOC) $(PROTOC_OPTS) --nanopb_out=$(GENC_DIR) $<

c: $(GENC_SRCS)

GENTS_DIR := generated/ts
GENTS_SRCS := $(patsubst %.proto,$(GENTS_DIR)/%.pb.ts,$(PROTO_SRCS))
$(GENTS_DIR):
	mkdir -p $(GENTS_DIR)
$(GENTS_DIR)/%.pb.ts: %.proto | $(GENTS_DIR)
	$(PROTOC) $(PROTOC_OPTS) --plugin=protoc-gen-ts=$(PROTOC_GEN_TS) --ts_out=$(GENTS_DIR) $<

ts: $(GENTS_SRCS)

all: $(GENC_SRCS) $(GENTS_SRCS)

clean:
	rm -fr generated/*
