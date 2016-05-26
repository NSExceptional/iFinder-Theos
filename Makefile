export ARCHS = armv6 arm64
export TARGET = iphone:9.0:9.0
export SDKVERSION = 9.0

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk

APPLICATION_NAME = iFinder
iFinder_FILES = AppDelegate.swift \
	FBFile.swift \
	FileBrowser.swift \
	FileListTableFooterView.swift \
	FileListViewController+TableView.swift \
	FileListViewController.swift \
	FileParser.swift \
	PreviewManager.swift \
	PreviewTransitionViewController.swift \
	UIViewController+Util.swift \
	WebviewPreviewViewContoller.swift

iFinder_FRAMEWORKS = UIKit CoreGraphics QuickLook
#iFinder_CFLAGS = -fobjc-arc

before-stage::
	find . -name ".DS_STORE" -delete

include $(THEOS_MAKE_PATH)/aggregate.mk
