#!/bin/bash

cd "${SRCROOT}"

if [ "${CONFIGURATION}" = "Release" ]; then

cp 商汤正式证书/活体检测/SenseID_Liveness.lic  XBApp/Vendor/libSTLivenessController/SenseID_Liveness.lic

cp 商汤正式证书/证卡识别/SenseID_OCR.lic XBApp/Vendor/STCardSDK/STResource/SenseID_OCR.lic

else

cp 商汤测试证书/活体检测/SenseID_Liveness.lic  XBApp/Vendor/libSTLivenessController/SenseID_Liveness.lic


cp 商汤测试证书/证卡识别/SenseID_OCR.lic XBApp/Vendor/STCardSDK/STResource/SenseID_OCR.lic

fi

