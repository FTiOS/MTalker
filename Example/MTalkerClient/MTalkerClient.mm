//
//  MTalkerClient.m
//  MTalkerClient
//
//  Created by 何霞雨 on 2017/3/21.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTalkerClient.h"

#import "FTCommandClient/FTCommandClient.h"
#import "ftcodec/FTVideoTalker.h"
#import "MTAddressMonitor.h"

@interface MTalkerClient()<FTCommandClientDelegate>{
    BOOL _heart;//是否心跳
    NSTimeInterval _recvHeartTime;//最近心跳时间戳
    
    NSTimeInterval _lastTalkTime;//最近通话时间戳
    NSTimeInterval _startTalkTime;//开始通话时间戳
}

@property (nonatomic,strong)FTCommandClient *client ;//命令台
@property (nonatomic,strong)FTVideoTalker   *talker ;//音视频控制器

@property (nonatomic,strong)MTTalkerSetting *setting;//配置 信息
@property (nonatomic,strong)MTServerAddress *talkerAddress;//udp地址信息

@end


@implementation MTalkerClient

static MTalkerClient *_instance;
+(instancetype)shareTalker{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc]init];
        }
    });
    return _instance;
}

#pragma mark - 配置
-(void)loadSettings:(MTTalkerSetting *)setting{
    self.setting = setting;
    [MTAddressMonitor instance].parmas = self.setting.parmas;
    [MTAddressMonitor instance].api = [NSString stringWithFormat:@"%@:%d",self.setting.ip,self.setting.port];
    [[MTAddressMonitor instance] patchAddressWithFinshiBlock:^(NSArray<MTServerAddress *> *addresses, NSError *error) {
        if (!error) {
            self.talkerAddress = [[MTAddressMonitor instance]getServerAddress:ServerType_Talker];
        }
    }];
}

#pragma mark - 登录控制
-(void)login:(MTLoginInfo *)loginInfo finishBlock:(void(^)(BOOL loginSuccess))bolck{
    NSDictionary * loginParams = [loginInfo joinSubModels];
    [self.client login:loginParams];
}
-(void)logout{
    
}

#pragma mark -咨询控制

//开始咨询
-(void)startTalk{
    
    [self.ringer stopRing];//停止铃声
    [self.ringer vibrate];//震动一声
    
    FTAVControlParam * param = [[FTAVControlParam alloc]init];
    param.video = NO;
    
    [_client avControl:param];
    [_talker openAudio:YES];
    _isVideo = NO;

    [_talker startProxyStream:_client.proxyServerIp port:_client.proxyServerPort clientId:_client.businessId];
    NSLog(@"end startProxyStream");
    _tkStatus = ST_Talking;
    
    //初始化通话时长
    self.talkTime = 0;
    _startTalkTime = [[NSDate date] timeIntervalSince1970] * 1000;
    _lastTalkTime = _startTalkTime;
}

//停止咨询
-(void)stopTalk{
    
    if (self.tkStatus == ST_Default)
        return;
    
    [self getTalkInfo];
    
    //停止音视频
    [_talker closeVideo];
    [_talker closeAudio];
    [_talker stopStream];

    //停止心跳
     _heart=NO;
    
    //停止命令台
    if(_client.businessId!=0){
        [_client endBusiness:0];
    }
    if(_client.logined){
        [_client logout];
    }
    
    [_client stop];
    
    _tkStatus = ST_Default;
    
    //初始化通话时长
    self.talkTime = _lastTalkTime - _startTalkTime;
    _startTalkTime = 0;
    _lastTalkTime = 0;
    
}

#pragma mark - 音视频控制
-(void)startVideoWithEncoderView:(UIView *)encoderView DecoderView:(UIView *)decoderView{
    
}
-(void)changeVideo{
    
}

#pragma mark - 心跳
-(void) onTimer{
    NSLog(@TAG"onTimer");
    if (_heart) {
        [self.client heart];
        NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
        if(_recvHeartTime == 0.0 || nowTime < _recvHeartTime){
            _recvHeartTime =nowTime;
        }else if(nowTime - _recvHeartTime > HEART_TIME_OUT){
            NSLog(@TAG"调度服务心跳返回超时");
            [self stopTalk];
            return;
        }
        
        [self getTalkInfo];
        
        _lastTalkTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
        [self performSelector:@selector(onTimer) withObject:self afterDelay:HEART_TIME];
    }
}

#pragma mark - Getter

//获取语音或视频调试信息
-(void)getTalkInfo{
    
    NSLog(@TAG"ar:%d,as:%d,vr:%d,vs:%d",
          _talker.audioLastRecvSize,
          _talker.audioLastSendSize,
          _talker.videoLastRecvSize,
          _talker.videoLastSendSize);
    
    self.info.audioSendPackCount=_talker.audioSendPackCount;
    self.info.audioSendDataSize=_talker.audioSendDataSize;
    self.info.audioRecvPackCount=_talker.audioRecvPackCount;
    self.info.audioRecvDataSize=_talker.audioRecvDataSize;
    
    self.info.videoSendPackCount=_talker.videoSendPackCount;
    self.info.videoSendDataSize=_talker.videoSendDataSize;
    self.info.videoRecvPackCount=_talker.videoRecvPackCount;
    self.info.videoRecvDataSize=_talker.videoRecvDataSize;
}

-(FTCommandClient *)client{
    if (!_client) {
        _client=[[FTCommandClient alloc]init];
        _client.delegate = self;
    }
    return _client;
}

-(FTVideoTalker *)talker{
    if (!_talker) {
        _talker = [[FTVideoTalker alloc]init ];
        _talker.isFront = YES;
        _talker.audioBitrate = _setting.audioBitRate;
        _talker.videoBitrate = _setting.videoBitRate;
        _talker.sampleRate = _setting.sampleRate;
        _talker.channels = _setting.channels;
        _talker.frameRate = _setting.frameRate;
    }
    return _talker;
}

-(MTTalkerSetting *)setting{
    if (!_setting) {
        _setting = [[MTTalkerSetting alloc]init];
    }
    return _setting;
}

-(NSTimeInterval)talkTime{
    if (self.tkStatus == ST_Talking) {
        _lastTalkTime = [[NSDate date]timeIntervalSince1970]*1000;
        _talkTime = _lastTalkTime - _startTalkTime;
    }
    return _talkTime;
}

#pragma mark - FTCommandClientDelegate
-(void) onCommand:(int)command intValue:(int)intValue stringValue:(NSString*)stringValue jsonValue:(id<FTJsonSerializable>)jsonValue{
    
    if (_tkStatus == ST_Default) {//咨询结束
        return;
    }
    
    switch (command) {
        case FT_PROTO_MOBILE_LOGIN:{ //手机登录
            if (intValue == 0) {
                _heart = YES;
                [self onTimer];
            }
        }
            break;
        case FT_PROTO_HEARTBEAT:{ //维持心跳
            
        }
            break;
        case FT_PROTO_LOGOUT:{ //登出
            
        }
            break;
        case FT_PROTO_END_BUSINESS:
        case FT_PROTO_LEAVE:
        case FT_PROTO_MATCHER_OFFLINE:
        case FT_PROTO_MATCH_FAILURE:
        case FT_PROTO_DISCONNECT:{ /*正常断开链接//在收到以下命令以后会马上收到该命令
                                    //FT_PROTO_END_BUSINESS
                                    //FT_PROTO_LEAVE
                                    //FT_PROTO_MATCHER_OFFLINE
                                    //FT_PROTO_MATCH_FAILURE*/
            
            
        }
            break;
        case FT_PROTO_MATCH_WAIT:{ //等待匹配医生
            
        }
            break;
        case FT_PROTO_MATCH_SUCCESS:{ //匹配医生成功
            
        }
            break;
        case FT_PROTO_AV_START:{ //开始咨询
            
        }
            break;
        case FT_PROTO_PUSH_DRUG:{ //推荐药品
            
        }
            break;
        default:
            break;
    }
}
-(void) onStatus:(int)status{
    switch (status) {
        case TCP_STATUS_CONNECT_SUCCESS:{
            
        }
            break;
        case TCP_STATUS_CONNECT_FAIL:{
            
        }
            break;
        case TCP_STATUS_DISCONNECTED:{
            
        }
            break;
            
        default:
            break;
    }
}
@end

@implementation TalkInfo


@end
