//
//  MTalkerClient.h
//  MTalkerClient
//
//  Created by 何霞雨 on 2017/3/21.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTRinger.h"

#import "MTTalkInfo.h"
#import "MTLoginInfo.h"
#import "MTTalkerSetting.h"

#import "MTTalkerCommandDelegate.h"

#define TAG "Talker:"
#define HEART_TIME (8)//心跳发送间隔时间
#define HEART_TIME_OUT (30)//心跳返回超时时间，如果超过此时间没有收到

//音频类型 @1
typedef NS_OPTIONS(NSUInteger,AudioType) {
    AV_Normal = 0      ,//正常
    AV_Silent = 1 << 0 ,//屏蔽对方的声音，自己听不见
    AV_Mute   = 1 << 1 ,//屏蔽自身的声音，对方听不见
};

//咨询状态 @2
typedef NS_ENUM(NSUInteger,TalkerStatus) {
    ST_Default = 0 ,//咨询结束||咨询未开始
    ST_Wait        ,//开始咨询，等待接听
    ST_Talking     ,//咨询中
};

//连接服务器状态 @3
typedef NS_ENUM(NSUInteger,ConnectStatus) {
    CS_Disconnected = 0 ,//连接断开
    CS_Connecting       ,//连接中
    CS_Connect_Success  ,//连接成功
    CS_Connect_Fail     ,//连接失败
};

@class TalkInfo;//咨询调试的信息

@interface MTalkerClient : NSObject

@property (nonatomic,assign) BOOL         isVideo;   //是否视频
@property (nonatomic,assign) AudioType    avType;    //音频类型 @1
@property (nonatomic,assign) BOOL         isRing;    //是否Ring
@property (nonatomic,assign) BOOL         isVibrate; //是否震动

@property (nonatomic,assign,readonly) TalkerStatus tkStatus;  //咨询状态 @2
@property (nonatomic,assign,readonly) ConnectStatus csStatus; //连接服务器状态 @3

@property (nonatomic,strong)id<MTTalkerCommandDelegate> delegate;//回调，处理咨询状态

@property(nonatomic,strong)MTRinger *ringer;//铃声|震动控制器

@property(nonatomic,strong,readonly)TalkInfo *info;//通讯的调试数据
@property(nonatomic,assign)NSTimeInterval talkTime;//通话时长

+(instancetype)shareTalker;
-(void)loadSettings:(MTTalkerSetting *)setting;

-(void)login:(MTLoginInfo *)loginInfo finishBlock:(void(^)(BOOL loginSuccess))bolck;
-(void)logout;

-(void)startVideoWithEncoderView:(UIView *)encoderView DecoderView:(UIView *)decoderView;//初次打开视频，需要初始化
-(void)changeVideo;//切换视频位置
-(void)stopVideo;

-(void)sendImage:(NSString *)imageUrl;

@end

@interface TalkInfo : NSObject
//--------------调试统计信息--------------

//音频统计
@property (assign,nonatomic)  int audioSendPackCount;
@property (assign,nonatomic)  int audioSendDataSize;
@property (assign,nonatomic)  int audioRecvPackCount;
@property (assign,nonatomic)  int audioRecvDataSize;

//视频统计
@property (assign,nonatomic)  int videoSendPackCount;
@property (assign,nonatomic)  int videoSendDataSize;
@property (assign,nonatomic)  int videoRecvPackCount;
@property (assign,nonatomic)  int videoRecvDataSize;

@end
