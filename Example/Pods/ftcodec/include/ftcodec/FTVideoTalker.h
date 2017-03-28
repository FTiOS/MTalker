//
//  FTCodec.h
//  Talker
//
//  Created by xiachao on 14-10-14.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTPenetrationStream.h"


@interface FTVideoTalker : NSObject

//-------------视频配置------------------
@property (nonatomic) BOOL isFront;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int frameRate;
@property (nonatomic) int videoBitrate;
@property (nonatomic) int videoRotate;
//-------------音频配置------------------
@property (nonatomic) int channels;
@property (nonatomic) int sampleRate;
@property (nonatomic) int audioBitrate;
@property (nonatomic) BOOL muteMic;
@property (nonatomic) BOOL mutePlayer;
//--------------调试统计信息--------------
//调试定时显示
@property (readonly,nonatomic)  int audioLastRecvSize;
@property (readonly,nonatomic)  int audioLastSendSize;
@property (readonly,nonatomic)  int videoLastRecvSize;
@property (readonly,nonatomic)  int videoLastSendSize;

//音频统计
@property (readonly,nonatomic)  int audioSendPackCount;
@property (readonly,nonatomic)  int audioSendDataSize;
@property (readonly,nonatomic)  int audioRecvPackCount;
@property (readonly,nonatomic)  int audioRecvDataSize;

//视频统计
@property (readonly,nonatomic)  int videoSendPackCount;
@property (readonly,nonatomic)  int videoSendDataSize;
@property (readonly,nonatomic)  int videoRecvPackCount;
@property (readonly,nonatomic)  int videoRecvDataSize;
//
@property (nonatomic) BOOL debug;

-(void)resetLastSize;

-(instancetype) init ;

-(BOOL)         openVideo:(UIView* )encoderView
   encoderViewOrientation:(NSInteger)encoderViewOrientation
              decoderView:(UIView* )decoderView;

-(void) closeVideo;

-(BOOL) openAudio:(BOOL) speaker;
-(void) closeAudio;

//打开功放模式，打开后插入耳机，会自动使用耳机，拔出耳机则会切换到听筒
//插入耳机后打开后，会使用功放，拔出耳机也会是功放
-(BOOL) openSpeaker;

//关闭功放模式，如果有耳机则会自动使用耳机
-(BOOL) closeSpeaker;

-(BOOL) startUdpStream:(NSString *)ip port:(int32_t)port ;
-(BOOL) startProxyStream:(NSString *)ip port:(int32_t)port clientId:(int) clientId;
-(BOOL) startPenetrationStream:(NSString *)ip port:(int32_t)port targetId:(NSString*) targetId
                      delegate:(id<FTPenetrationFailDelegate>) delegate;


-(void) stopStream;

@end
