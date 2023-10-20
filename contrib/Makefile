# SPDX-FileCopyrightText: © 2023 Peter G. <sailfish@nephros.org>
#
# SPDX-License-Identifier: CC0-1.0

BASE_DIR := /etc/monit.d
CONFIG_DIR := $(BASE_DIR)/available
SCRIPT_DIR := $(BASE_DIR)/scripts

CONFIG_FILES := $(wildcard conf/*.conf)
SCRIPT_FILES := $(wildcard scripts/*)
README_FILES := conf/README.md

INSTALL_CMD=/usr/bin/install

all: install

.PHONY: install
.PRECIOUS: $(CONFIG_FILES) $(SCRIPT_FILES) $(README_FILES)


install: install-conf install-bin install-readme

install-readme:
	$(INSTALL_CMD) -d $(DESTDIR)$(PREFIX)$(BASE_DIR)
	$(foreach f,$(README_FILES), $(INSTALL_CMD) -D -m 644 $f $(DESTDIR)$(PREFIX)$(BASE_DIR)/$(subst conf/,,$f); )

install-conf:
	$(INSTALL_CMD) -d $(DESTDIR)$(PREFIX)$(CONFIG_DIR)
	$(foreach f,$(CONFIG_FILES), $(INSTALL_CMD) -D -m 644 $f $(DESTDIR)$(PREFIX)$(CONFIG_DIR)/$(subst conf/,,$f); )

install-bin:
	$(INSTALL_CMD) -d $(DESTDIR)$(PREFIX)$(SCRIPT_DIR)
	$(foreach f,$(SCRIPT_FILES), $(INSTALL_CMD) -D -m 750 $f $(DESTDIR)$(PREFIX)$(SCRIPT_DIR)/$(subst scripts/,,$f); )
