//
//  MTDevice.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

//当前设备信息
@interface MTDevice : MTModel

/**
 * 设备类型
 * 使用代码: Build.HARDWARE + " " + Build.MODEL;
 */
@property(nonatomic) NSString *deviceType;

/**
 * 设备系统操作系统版本号
 * 使用代码：Build.VERSION.RELEASE
 */
@property(nonatomic) NSString *osVersion;

/**
 * app包名
 */
@property(nonatomic) NSString *appId;

/**
 * app版本号
 * 在调用者app中使用代码：BuildConfig.VERSION_NAME
 */
@property(nonatomic) NSString *version;

/**
 * 设备号 imei,使用的是 identifierForAdvertising+keychain
 * 和account必须设置其中之一
 */
@property(nonatomic) NSString *deviceId;
/**
 * 手机分辨率
 */
@property(nonatomic) NSString *resolution;
/**
 * 手机dpi
 */
@property(nonatomic) NSString *dpi;
/**
 * "IOS"或"Android"
 */
@property(nonatomic) NSString *osType;
/**
 * 应用渠道 默认为sdk
 */
@property(nonatomic) NSString *channel;
/**
 * CPU类型
 */
@property(nonatomic) NSString *cpu;

@end
