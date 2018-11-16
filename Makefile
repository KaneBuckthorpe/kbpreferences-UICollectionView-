TARGET = iphone:11.2:11.0
export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = KBPreferences
KBPreferences_FILES = KBListController.m cells/KBCollectionCell.m supplementaryViews/KBHeaderView.m supplementaryViews/KBFooterView.m
KBPreferences_INSTALL_PATH = /Library/Frameworks

KBPreferences_LDFLAGS = -ObjC
KBPreferences_CFLAGS = -fobjc-arc
KBPreferences_PRIVATE_FRAMEWORKS=Preferences
include $(THEOS_MAKE_PATH)/framework.mk
