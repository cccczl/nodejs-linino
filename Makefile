#
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=node
PKG_VERSION:=v0.10.13
PKG_RELEASE:=1

PKG_SOURCE:=node-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://nodejs.org/dist/${PKG_VERSION}
PKG_MD5SUM:=4c8185732680fc70c90a4c39789e4ff0

include $(INCLUDE_DIR)/package.mk

define Package/node
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Node.js is a platform built on Chrome's JavaScript runtime
  URL:=http://nodejs.org/
endef

define Package/node/description
Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.
endef

define Build/Configure
	(cd $(PKG_BUILD_DIR); \
	rm -rf deps/v8; \
	git clone https://github.com/brimstone/v8m-rb deps/v8; \
	./configure --dest-cpu=mips --dest-os=linux --without-ssl --without-snapshot --with-arm-float-abi=soft; \
	);
endef

define Build/Compile
	export CFLAGS="$(TARGET_CFLAGS)"
	export CXXFLAGS="$(TARGET_CXXFLAGS)"
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" || touch $(PKG_BUILD_DIR)/deps/v8/build/common.gypi
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)"
endef


define Package/node/install
	$(CP) $(PKG_BUILD_DIR)/out/Release/node $(1)/usr/bin/
	ln -s /usr/bin/node $(1)/usr/bin/nodejs
endef

$(eval $(call BuildPackage,node))
