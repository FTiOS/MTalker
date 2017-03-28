//
//  MTTalkerSetting.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"
#import <UIKit/UIView.h>

@interface MTTalkerSetting : MTModel

@property(nonatomic,assign)  int width ;//宽度
@property(nonatomic,assign)  int height ;//高度

@property(nonatomic,assign)  int frameRate;
@property(nonatomic,assign)  int videoBitRate;
@property(nonatomic,assign)  int sampleRate ;
@property(nonatomic,assign)  int channels;
@property(nonatomic,assign)  int audioBitRate;

@property(nonatomic,strong,nullable)  NSString     *ip   ;//获取调度服务和udp地址的api地址
@property(nonatomic,assign)           int          port  ;//获取调度服务和udp地址的api端口
@property (nonatomic,strong,nullable)          NSDictionary *parmas;//获取调度服务地址的参数


@property(nonatomic,strong,nonnull)UIView *decodeView;//对方视频展示的页面
@property(nonatomic,strong,nonnull)UIView *encodeView;//自己视频展示的页面

@property(nonatomic,assign)BOOL defaultVideo  ;//默认视频
@property(nonatomic,assign)BOOL keepTalkerType;//维持上次咨询视频或音频状态

@end
