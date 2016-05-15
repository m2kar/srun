#srun3.0
#still_night@163.com

include $(TOPDIR)/rules.mk

LUCI_TITLE:=luci-app-srun
LUCI_DEPENDS:=+luci
LUCI_PKGARCH:=all


define Package/$(PKG_NAME)/preinst
	#!/bin/sh
	chmod +x /etc/init.d/srun /etc/rc.d/S50srun
	uci delete network.wan
	uci set network.wan=interface
	uci set network.wan._orig_bridge=false
	uci set network.wan._orig_ifname=eth1
	uci set network.wan.ifname=eth1
	uci set network.wan.password=111111
	uci set network.wan.proto=pppoe
	uci set network.wan.mtu=1250
	uci set network.wan.username={SRUN2}444444
	uci set wireless.@wifi-iface[0].ssid=CMU-WIFI
	uci set wireless.@wifi-iface[0].encryption=psk2
	uci set wireless.@wifi-iface[0].key=1234567890
	uci set wireless.@wifi-iface[0].wps_pushbutton=0
	uci delete wireless.@wifi-iface[1]
	uci delete wireless.@wifi-iface[1]
	uci commit wireless
	uci commit network
	uci show network.wan
	echo "uci change"
	exit 0
endef

include ../../luci.mk


#define Package/$(PKG_NAME)/install
#	if [ -d $(PKG_BUILD_DIR)/luasrc ]; then \
#	  $(INSTALL_DIR) $(1)$(LUCI_LIBRARYDIR); \
#	  cp -pR $(PKG_BUILD_DIR)/luasrc/* $(1)$(LUCI_LIBRARYDIR)/; \
#	  $(FIND) $(1)$(LUCI_LIBRARYDIR)/ -type f -name '*.luadoc' | $(XARGS) rm; \
#	  $(if $(CONFIG_LUCI_SRCDIET),$(call SrcDiet,$(1)$(LUCI_LIBRARYDIR)/),true); \
#	else true; fi
#	if [ -d $(PKG_BUILD_DIR)/htdocs ]; then \
#	  $(INSTALL_DIR) $(1)$(HTDOCS); \
#	  cp -pR $(PKG_BUILD_DIR)/htdocs/* $(1)$(HTDOCS)/; \
#	else true; fi
#	if [ -d $(PKG_BUILD_DIR)/root ]; then \
#	  $(INSTALL_DIR) $(1)/; \
#	  cp -pR $(PKG_BUILD_DIR)/root/* $(1)/; \
#	else true; fi
#	if [ -d $(PKG_BUILD_DIR)/src ]; then \
#	  $(call Build/Install/Default) \
#	  $(CP) $(PKG_INSTALL_DIR)/* $(1)/; \
#	else true; fi
#	chmod +x $(1)/etc/init.d/srun $(1)/etc/rc.d/S50srun	
##	uci delete network.wan
##	uci set network.wan=interface
##	uci set network.wan._orig_bridge=false
##	uci set network.wan._orig_ifname=eth1
##	uci set network.wan.password=111111
##	uci set network.wan.proto=pppoe
##	uci set network.wan.mtu=1250
##	uci set network.wan.username={SRUN2K}444444
##	uci commit
#endef


# call BuildPackage - OpenWrt buildroot signature
