ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = Appellancy_API_sample
Appellancy_API_sample_FILES = Tweak.xm
Appellancy_API_sample_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
