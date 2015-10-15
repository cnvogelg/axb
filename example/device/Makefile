# example for creating a device

AXB_PROJECT = device
AXB_COMPILERS = GCC

# define device name
AXB_DEVICE = example.device
AXB_DEVICE_VERSION = 0
AXB_DEVICE_REVISION = 1
AXB_DEVICE_DATE = $(shell date '+%d.%m.%Y')

# device library size
AXB_DEVICE_LIBSIZE_HEADER = exbase.h
AXB_DEVICE_LIBSIZE_NAME = ExBase

# source files for device
DEVICE_C_SRCS = example.c
DEVICE_C_HDRS = exbase.h

# config device build
USER_CFLAGS = -DUSE_DOS -DDEBUG

# include rules for device building
AXB_TOP ?= $(PWD)/../..
include $(AXB_TOP)/axb.mk
