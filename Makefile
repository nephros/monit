# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: CC0-1.0

#SUBDIRS := $(wildcard */.)
SUBDIRS := contrib

default: $(SUBDIRS)

install: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: default install $(SUBDIRS)
