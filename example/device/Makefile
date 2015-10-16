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
AXB_DEVICE_SRCS_C = example.c
AXB_DEFINES = USE_DOS DEBUG

# include rules for device building
AXB_TOP ?= $(PWD)/../..
include $(AXB_TOP)/axb.mk
