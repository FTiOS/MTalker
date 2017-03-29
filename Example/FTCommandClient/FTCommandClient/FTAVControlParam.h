//
//  FTAVControlParam.h
//  Talkback
//
//  Created by xiachao on 15/9/19.
//
//

#import <Foundation/Foundation.h>
#import "FTJsonSerializable.h"


@interface FTAVControlParam : NSObject<FTJsonSerializable>

/**
 * 是否打开视频
 */
@property (nonatomic) BOOL video;

/**
 * 是否打开音频
 */
@property (nonatomic) BOOL audio;

/**
 * 视频旋转角度
 */
@property(nonatomic) int videoOrientation;

/**
 * 手机宽度，单位像素
 */
@property(nonatomic) int screenWidth ;

/**
 * 手机高度，单位像素
 */
@property(nonatomic)int screenHeight;

/**
 * 音频编码类型
 */
@property(nonatomic) int audioCodec;

/**
 * 视频编码类型
 */
@property(nonatomic) int videoCodec;


@end
