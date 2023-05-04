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
	$(foreach f,$(README_FILES), $(INSTALL_CMD) -D -m 644 $f $(DESTDIR)$(PREFIX)$(BASE_DIR)/$f; )

install-conf:
	$(foreach f,$(CONFIG_FILES), $(INSTALL_CMD) -D -m 644 $f $(DESTDIR)$(PREFIX)$(CONFIG_DIR)/$(subst conf/,,$f);)

install-bin:
	$(foreach f,$(SCRIPT_FILES), $(INSTALL_CMD) -D -m 750 $f $(DESTDIR)$(PREFIX)$(SCRIPT_DIR)/$f; )
