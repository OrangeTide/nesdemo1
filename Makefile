#!/usr/bin/make -f

##############################################################################
# universal settings for all platforms and architectures
##############################################################################
BUILDINFO_DIR?=buildinfo
TARGET_DIR?=target

CFLAGS:=-Wall -Wextra -Wshadow -Wsign-compare -Wconversion -Wstrict-prototypes -Wstrict-aliasing -Wpointer-arith -Wcast-align  -Wold-style-definition -Wredundant-decls -Wnested-externs -std=gnu99 -pedantic -g
# Uninitialized/clobbered variable warning
#CFLAGS+=-Wuninitialized -O1
# profiling
#CFLAGS+=-pg
# optimization
#CFLAGS+=-Os
# enable the following for dead code elimination
#CFLAGS+=-ffunction-sections -fdata-sections -Wl,--gc-sections
# enable for warnings to stop compilation
# CFLAGS+=-Werror

# turn on BSD things
CPPFLAGS:=-D_BSD_SOURCE

#CPPFLAGS+=-DNDEBUG
#CPPFLAGS+=-DNTRACE

#LDLIBS:=

-include $(BUILDINFO_DIR)/config-local.mk

##############################################################################
# OS specific settings
##############################################################################
HOST_OS:=$(shell uname -s)

-include $(BUILDINFO_DIR)/host-$(HOST_OS).mk
##############################################################################
# Basic rules
##############################################################################

all ::

clean ::
	$(RM) $(CLEAN_LIST)

clean-all : clean
	$(RM) $(BUILDINFO_DIR)/config-local.mk
	$(RM) -rf stripped/
	$(RM) *~

.PHONY : all clean clean-all

##############################################################################
# Configuration
##############################################################################

$(BUILDINFO_DIR)/config-local.mk : $(BUILDINFO_DIR)/genconfig.sh
	(cd $(BUILDINFO_DIR) ; ./genconfig.sh )

##############################################################################
# Rules
##############################################################################

-include $(BUILDINFO_DIR)/rules-*-common.mk

##############################################################################
# OS specific rules
##############################################################################

-include $(BUILDINFO_DIR)/rules-*-$(HOST_OS).mk

##############################################################################
# Targets
##############################################################################
include $(wildcard $(BUILDINFO_DIR)/target-*.mk)
