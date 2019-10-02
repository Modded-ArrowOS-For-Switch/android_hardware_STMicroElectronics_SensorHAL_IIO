#
# Copyright (C) 2013-2019 STMicroelectronics
# Denis Ciocca - Motion MEMS Product Div.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#/

ifneq ($(TARGET_SIMULATOR),true)

LOCAL_PATH := $(call my-dir)
ST_HAL_ROOT_PATH := $(call my-dir)

include $(CLEAR_VARS)
include $(ST_HAL_ROOT_PATH)/../hal_config

ANDROID_VERSION_CONFIG_HAL=$(LOCAL_PATH)/../android_data_config
$(shell source $(ANDROID_VERSION_CONFIG_HAL))

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libhardware \
	libhardware_legacy \
	libutils \
	liblog \
	libdl \
	libc

LOCAL_HEADER_LIBRARIES := \
	libhardware_headers

ifeq ($(shell test $(ST_HAL_ANDROID_VERSION) -gt 4; echo $$?),0)
LOCAL_SHARED_LIBRARIES += libstagefright_foundation
LOCAL_HEADER_LIBRARIES += libstagefright_foundation_headers
endif # ST_HAL_ANDROID_VERSION

LOCAL_VENDOR_MODULE := true

LOCAL_PRELINK_MODULE := false
LOCAL_PROPRIETARY_MODULE := true

ifdef TARGET_BOARD_PLATFORM
LOCAL_MODULE := sensors.$(TARGET_BOARD_PLATFORM)
else # TARGET_BOARD_PLATFORM
LOCAL_MODULE := sensors.default
endif # TARGET_BOARD_PLATFORM

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
else # ST_HAL_ANDROID_VERSION
LOCAL_MODULE_RELATIVE_PATH := hw
endif # ST_HAL_ANDROID_VERSION

LOCAL_MODULE_OWNER := STMicroelectronics

LOCAL_C_INCLUDES := $(LOCAL_PATH)/ \
			$(LOCAL_PATH)/../ \
			$(LOCAL_PATH)/../../../../hardware/libhardware/modules/sensors/dynamic_sensor/

LOCAL_CFLAGS += -DLOG_TAG=\"SensorHAL\" -Wall \
		-Wunused-parameter -Wunused-value -Wunused-function

ifeq ($(DEBUG),y)
LOCAL_CFLAGS += -g -O0
LOCAL_LDFLAGS += -Wl,-Map,$(LOCAL_PATH)/../$(LOCAL_MODULE).map
endif # DEBUG

ifdef CONFIG_ST_HAL_HAS_6AX_FUSION
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lib/iNemoEnginePRO

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_STATIC_LIBRARIES += iNemoEnginePRO_$(TARGET_ARCH)
else # ST_HAL_ANDROID_VERSION
LOCAL_STATIC_LIBRARIES += iNemoEnginePRO
endif # ST_HAL_ANDROID_VERSION
else # CONFIG_ST_HAL_HAS_6AX_FUSION
ifdef CONFIG_ST_HAL_HAS_9AX_FUSION
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lib/iNemoEnginePRO

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_STATIC_LIBRARIES += iNemoEnginePRO_$(TARGET_ARCH)
else # ST_HAL_ANDROID_VERSION
LOCAL_STATIC_LIBRARIES += iNemoEnginePRO
endif # ST_HAL_ANDROID_VERSION
else # CONFIG_ST_HAL_HAS_9AX_FUSION

endif # CONFIG_ST_HAL_HAS_9AX_FUSION
endif # CONFIG_ST_HAL_HAS_6AX_FUSION

ifdef CONFIG_ST_HAL_HAS_GYRO_GBIAS_ESTIMATION
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lib/iNemoEngine_gbias_Estimation

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_STATIC_LIBRARIES += iNemoEngine_gbias_Estimation_$(TARGET_ARCH)
else # ST_HAL_ANDROID_VERSION
LOCAL_STATIC_LIBRARIES += iNemoEngine_gbias_Estimation
endif # ST_HAL_ANDROID_VERSION
endif # CONFIG_ST_HAL_HAS_GYRO_GBIAS_ESTIMATION

ifdef CONFIG_ST_HAL_HAS_GEOMAG_FUSION
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lib/iNemoEngine_GeoMag_Fusion

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_STATIC_LIBRARIES += iNemoEngine_GeoMag_Fusion_$(TARGET_ARCH)
else # ST_HAL_ANDROID_VERSION
LOCAL_STATIC_LIBRARIES += iNemoEngine_GeoMag_Fusion
endif # ST_HAL_ANDROID_VERSION
endif # CONFIG_ST_HAL_HAS_GEOMAG_FUSION

ifdef CONFIG_ST_HAL_HAS_MAGN_CALIB
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lib/STMagCalibration

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_STATIC_LIBRARIES += STMagCalibration_$(TARGET_ARCH)
else # ST_HAL_ANDROID_VERSION
LOCAL_STATIC_LIBRARIES += STMagCalibration
endif # ST_HAL_ANDROID_VERSION
endif # CONFIG_ST_HAL_HAS_MAGN_CALIB

ifdef CONFIG_ST_HAL_HAS_ACCEL_CALIB
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lib/STAccCalibration

ifeq ($(ST_HAL_ANDROID_VERSION),0)
LOCAL_STATIC_LIBRARIES += STAccCalibration_$(TARGET_ARCH)
else # ST_HAL_ANDROID_VERSION
LOCAL_STATIC_LIBRARIES += STAccCalibration
endif # ST_HAL_ANDROID_VERSION
endif # CONFIG_ST_HAL_HAS_ACCEL_CALIB

LOCAL_SRC_FILES := \
		SensorHAL.cpp \
		utils.cpp \
		CircularBuffer.cpp \
		FlushBufferStack.cpp \
		FlushRequested.cpp \
		ChangeODRTimestampStack.cpp \
		SensorBase.cpp \
		HWSensorBase.cpp \
		SWSensorBase.cpp

ifdef CONFIG_ST_HAL_DIRECT_REPORT_SENSOR
LOCAL_SRC_FILES += RingBuffer.cpp
endif # CONFIG_ST_HAL_DIRECT_REPORT_SENSOR

ifdef CONFIG_ST_HAL_ACCEL_ENABLED
LOCAL_SRC_FILES += Accelerometer.cpp
endif # CONFIG_ST_HAL_ACCEL_ENABLED

ifdef CONFIG_ST_HAL_MAGN_ENABLED
LOCAL_SRC_FILES += Magnetometer.cpp
endif # CONFIG_ST_HAL_MAGN_ENABLED

ifdef CONFIG_ST_HAL_GYRO_ENABLED
LOCAL_SRC_FILES += Gyroscope.cpp
endif # CONFIG_ST_HAL_GYRO_ENABLED

ifdef CONFIG_ST_HAL_STEP_DETECTOR_ENABLED
LOCAL_SRC_FILES += StepDetector.cpp
endif # CONFIG_ST_HAL_STEP_DETECTOR_ENABLED

ifdef CONFIG_ST_HAL_STEP_COUNTER_ENABLED
LOCAL_SRC_FILES += StepCounter.cpp
endif # CONFIG_ST_HAL_STEP_COUNTER_ENABLED

ifdef CONFIG_ST_HAL_SIGN_MOTION_ENABLED
LOCAL_SRC_FILES += SignificantMotion.cpp
endif # CONFIG_ST_HAL_SIGN_MOTION_ENABLED

ifdef CONFIG_ST_HAL_TILT_ENABLED
LOCAL_SRC_FILES += TiltSensor.cpp
endif # CONFIG_ST_HAL_TILT_ENABLED

ifneq ($(or $(CONFIG_ST_HAL_GLANCE_GESTURE_ENABLED),\
	    $(CONFIG_ST_HAL_WAKEUP_GESTURE_ENABLED),\
	    $(CONFIG_ST_HAL_PICKUP_GESTURE_ENABLED),\
	    $(CONFIG_ST_HAL_NO_MOTION_GESTURE_ENABLED),\
	    $(CONFIG_ST_HAL_WRIST_TILT_GESTURE_ENABLED),\
	    $(CONFIG_ST_HAL_MOTION_GESTURE_ENABLED)),)
LOCAL_SRC_FILES += Gesture.cpp
endif

ifdef CONFIG_ST_HAL_DEVICE_ORIENTATION_ENABLED
LOCAL_SRC_FILES += DeviceOrientation.cpp
endif # CONFIG_ST_HAL_DEVICE_ORIENTATION_ENABLED

ifdef CONFIG_ST_HAL_MAGN_UNCALIB_AP_ENABLED
LOCAL_SRC_FILES += SWMagnetometerUncalibrated.cpp
endif # CONFIG_ST_HAL_MAGN_UNCALIB_AP_ENABLED

ifdef CONFIG_ST_HAL_GYRO_UNCALIB_AP_ENABLED
LOCAL_SRC_FILES += SWGyroscopeUncalibrated.cpp
endif # CONFIG_ST_HAL_GYRO_UNCALIB_AP_ENABLED

ifdef CONFIG_ST_HAL_ACCEL_UNCALIB_AP_ENABLED
LOCAL_SRC_FILES += SWAccelerometerUncalibrated.cpp
endif # CONFIG_ST_HAL_ACCEL_UNCALIB_AP_ENABLED

ifdef CONFIG_ST_HAL_PRESSURE_ENABLED
LOCAL_SRC_FILES += Pressure.cpp
endif # CONFIG_ST_HAL_PRESSURE_ENABLED

ifdef CONFIG_ST_HAL_RHUMIDITY_ENABLED
LOCAL_SRC_FILES += RHumidity.cpp
endif # CONFIG_ST_HAL_RHUMIDITY_ENABLED

ifdef CONFIG_ST_HAL_TEMP_ENABLED
LOCAL_SRC_FILES += Temp.cpp
endif # CONFIG_ST_HAL_TEMP_ENABLED

ifdef CONFIG_ST_HAL_HAS_GEOMAG_FUSION
LOCAL_SRC_FILES += SWAccelMagnFusion6X.cpp
endif # CONFIG_ST_HAL_HAS_GEOMAG_FUSION

ifdef CONFIG_ST_HAL_GEOMAG_ROT_VECTOR_AP_ENABLED
LOCAL_SRC_FILES += SWGeoMagRotationVector.cpp
endif # CONFIG_ST_HAL_GEOMAG_ROT_VECTOR_AP_ENABLED

ifdef CONFIG_ST_HAL_HAS_6AX_FUSION
LOCAL_SRC_FILES += SWAccelGyroFusion6X.cpp
endif # CONFIG_ST_HAL_HAS_6AX_FUSION

ifdef CONFIG_ST_HAL_GAME_ROT_VECTOR_AP_ENABLED
LOCAL_SRC_FILES += SWGameRotationVector.cpp
endif # CONFIG_ST_HAL_GAME_ROT_VECTOR_AP_ENABLED

ifdef CONFIG_ST_HAL_HAS_9AX_FUSION
LOCAL_SRC_FILES += SWAccelMagnGyroFusion9X.cpp
endif # CONFIG_ST_HAL_HAS_9AX_FUSION

ifdef CONFIG_ST_HAL_ROT_VECTOR_AP_ENABLED
LOCAL_SRC_FILES += SWRotationVector.cpp
endif # CONFIG_ST_HAL_ROT_VECTOR_AP_ENABLED

ifdef CONFIG_ST_HAL_ORIENTATION_AP_ENABLED
LOCAL_SRC_FILES += SWOrientation.cpp
endif # CONFIG_ST_HAL_ORIENTATION_AP_ENABLED

ifdef CONFIG_ST_HAL_GRAVITY_AP_ENABLED
LOCAL_SRC_FILES += SWGravity.cpp
endif # CONFIG_ST_HAL_GRAVITY_AP_ENABLED

ifdef CONFIG_ST_HAL_LINEAR_AP_ENABLED
LOCAL_SRC_FILES += SWLinearAccel.cpp
endif # CONFIG_ST_HAL_LINEAR_AP_ENABLED

ifdef CONFIG_ST_HAL_VIRTUAL_GYRO_ENABLED
LOCAL_SRC_FILES += SWVirtualGyroscope.cpp
endif # CONFIG_ST_HAL_VIRTUAL_GYRO_ENABLED

ifdef CONFIG_ST_HAL_HAS_SELFTEST_FUNCTIONS
LOCAL_SRC_FILES += SelfTest.cpp
endif # CONFIG_ST_HAL_HAS_SELFTEST_FUNCTIONS

ifdef CONFIG_ST_HAL_DYNAMIC_SENSOR
LOCAL_SHARED_LIBRARIES += libdynamic_sensor_ext
LOCAL_SRC_FILES += DynamicSensorProxy.cpp
endif # CONFIG_ST_HAL_DYNAMIC_SENSOR

LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

endif # !TARGET_SIMULATOR
