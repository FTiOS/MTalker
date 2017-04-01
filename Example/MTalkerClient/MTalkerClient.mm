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
-(void)loadSettings:(MTTalkerSetting *)setting finishBlock:(void(^)(BOOL loadSuccess))bolck{
    self.setting = setting;
    [MTAddressMonitor instance].parmas = self.setting.parmas;
    [MTAddressMonitor instance].api = self.setting.api;
    [[MTAddressMonitor instance] patchAddressWithFinshiBlock:^(NSArray<MTServerAddress *> *addresses, NSError *error) {
        if (!error) {
            self.talkerAddress = [[MTAddressMonitor instance]getServerAddress:ServerType_Talker];
            bolck(YES);
        }else
            bolck(NO);
    }];
}

#pragma mark - 登录控制
-(void)login:(MTLoginInfo *)loginInfo{
    if (self.tkStatus != ST_Default) {
        return;
    }
    
    _loginInfo = loginInfo;
    
    [self.ringer playRing];//开始铃声
    //test
    self.talkerAddress = [[MTServerAddress alloc]init];
    self.talkerAddress.ip = @"114.215.253.88";
    self.talkerAddress.port = 25000;
    
    NSLog(@"开始连接调度！");
    if ([self.talkerAddress.ip length]!=0&&self.talkerAddress.port!=0) {
        NSLog(@"咨询连接,ip:%@,port:%ld,状态:%lu,%@",self.talkerAddress.ip,(long)self.talkerAddress.port,(unsigned long)self.tkStatus,_client);
        if (self.csStatus != CS_Disconnected) {
            return;
        }
        [self.client start:self.talkerAddress.ip port:self.talkerAddress.port];//连接命令台
        _csStatus = CS_Connecting;
        _tkStatus = ST_Wait;
        if ([self.delegate respondsToSelector:@selector(receiveCommand:withInstance:withInfo:)]) {
            [self.delegate receiveCommand:command_login withInstance:nil withInfo:@"登录"];
        }
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:[NSNumber numberWithInteger:command_login] forKey:@"command"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_COMMAND object:params];
    }else{
        if ([self.delegate respondsToSelector:@selector(receiveCommand:withInstance:withInfo:)]) {
            [self.delegate receiveCommand:command_logout withInstance:[NSString stringWithFormat:@"%ld",(long)logout_disconnect] withInfo:@"登录失败"];
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:[NSNumber numberWithInteger:command_logout] forKey:@"command"];
            [params setObject:[NSNumber numberWithInteger:logout_disconnect] forKey:@"logoutype"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_COMMAND object:params];
        }
    }

    
}
-(void)logout{
    if (self.tkStatus == ST_Default) {
        return;
    }
    
    [self.ringer stopRing];
    
    [self stopTalk:logout_normal];
    
    if (self.talkTime>0) {
        if (self.info==nil) {
            NSLog(@"“音视频咨询数据统计”为空");
            return;
        }
    }
}

#pragma mark -咨询控制

//开始咨询
-(void)startTalk{
    
    [self.ringer stopRing];//停止铃声
    [self.ringer vibrate];//震动一声
    
    FTAVControlParam * param = [[FTAVControlParam alloc]init];
    param.video = NO;
    
    [_client avControl:param];
    [self.talker openAudio:YES];
    _isVideo = NO;

    [self.talker startProxyStream:_client.proxyServerIp port:_client.proxyServerPort clientId:_client.businessId];
    NSLog(@"end startProxyStream");
    _tkStatus = ST_Talking;
    
    //初始化通话时长
    self.talkTime = 0;
    _startTalkTime = [[NSDate date] timeIntervalSince1970] * 1000;
    _lastTalkTime = _startTalkTime;
}

//停止咨询
-(void)stopTalk:(LogoutType)code{
    
    if (self.tkStatus == ST_Default)
        return;
    
    [self.ringer stopRing];//停止铃声
    
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
    _csStatus = CS_Disconnected;
    
    //初始化通话时长
    self.talkTime = _lastTalkTime - _startTalkTime;
    _startTalkTime = 0;
    _lastTalkTime = 0;
    if ([self.delegate respondsToSelector:@selector(receiveCommand:withInstance:withInfo:)]) {
        [self.delegate receiveCommand:command_logout withInstance:[NSString stringWithFormat:@"%d",code] withInfo:@"退出类型:LogoutType"];
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[NSNumber numberWithInteger:command_logout] forKey:@"command"];
    [params setObject:[NSNumber numberWithInteger:code] forKey:@"logoutype"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_COMMAND object:params];
}

#pragma mark - 音视频控制
-(void)startVideoWithEncoderView:(UIView *)encoderView DecoderView:(UIView *)decoderView{
    if (encoderView) {
        self.setting.encodeView = encoderView;
    }
    if (decoderView) {
        self.setting.decodeView = decoderView;
    }
    
    if (self.tkStatus != ST_Talking) {
        return;
    }
    
    FTAVControlParam * param = [[FTAVControlParam alloc]init];
    param.video = YES;
    param.screenHeight = self.setting.decodeView.frame.size.height;
    param.screenWidth =self.setting.decodeView.frame.size.width;
    if (param.screenHeight==0) {
        param.screenHeight=560;
    }
    if (param.screenWidth==0) {
        param.screenHeight=320;
    }
    [self.client avControl:param];
    [self.talker openVideo: self.setting.encodeView
encoderViewOrientation:[[UIApplication sharedApplication] statusBarOrientation]
           decoderView:self.setting.decodeView];
    _isVideo = YES;
}

-(void)stopVideo{
    if (self.tkStatus != ST_Talking) {
        return;
    }
    
    FTAVControlParam * param = [[FTAVControlParam alloc]init];
    param.video = NO;
    [_client avControl:param];
    [_talker closeVideo];
    _isVideo = NO;
    
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
            [self stopTalk:logout_disconnect];
            return;
        }
        
        [self getTalkInfo];
        
        _lastTalkTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
        [self performSelector:@selector(onTimer) withObject:self afterDelay:HEART_TIME];
    }
}

#pragma mark - Getter or Setter

//获取语音或视频调试信息
-(void)getTalkInfo{
    
    NSLog(@TAG"ar:%d,as:%d,vr:%d,vs:%d",
          self.talker.audioLastRecvSize,
          self.talker.audioLastSendSize,
          self.talker.videoLastRecvSize,
          self.talker.videoLastSendSize);
    
    self.info.audioSendPackCount=self.talker.audioSendPackCount;
    self.info.audioSendDataSize=self.talker.audioSendDataSize;
    self.info.audioRecvPackCount=self.talker.audioRecvPackCount;
    self.info.audioRecvDataSize=self.talker.audioRecvDataSize;
    
    self.info.videoSendPackCount=self.talker.videoSendPackCount;
    self.info.videoSendDataSize=self.talker.videoSendDataSize;
    self.info.videoRecvPackCount=self.talker.videoRecvPackCount;
    self.info.videoRecvDataSize=self.talker.videoRecvDataSize;
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

-(MTRinger *)ringer{
    if (!_ringer) {
        _ringer = [[MTRinger alloc]init];
    }
    return _ringer;
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
-(void)setAvType:(AudioType)avType{
    _avType = avType;
    switch (_avType) {
        case AV_Normal:{
            [self.talker setMuteMic:NO];
            [self.talker setMutePlayer:NO];
        }
            break;
        case AV_Mute:{
            [self.talker setMuteMic:YES];
            [self.talker setMutePlayer:NO];
        }
            break;
        case AV_Silent:{
            [self.talker setMuteMic:NO];
            [self.talker setMutePlayer:YES];
        }
            break;
        case AV_Silent|AV_Mute:{
            [self.talker setMuteMic:YES];
            [self.talker setMutePlayer:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)setIsVideo:(BOOL)isVideo{
    _isVideo = isVideo;
    if (_isVideo) {
        [self startVideoWithEncoderView:nil DecoderView:nil];
    }else{
        [self stopVideo];
    }
}

-(BOOL)isRing{
    return self.ringer.isRing;
}
#pragma mark - 发送数据
//发送图片路径到医生端
-(void)sendImage:(NSString *)imageUrl{
    if (imageUrl) {
        [self.client sendImage:imageUrl];
    }
}

//发送药店地位数据
-(void)sendCoordinateInfo:(MTPharmacy *)info {
    NSLog(@"定位信息：");
    NSLog(@"定位信息_经纬度:{%f,%f}",info.latitude,info.longitude);
    if (info.latitude !=0 && info.longitude!=0) {
        [self.client sendCoordinate:info.longitude latitude:info.latitude address:info.address chainId:info.chainId];
    }
}

#pragma mark -药品信息
- (void) deserializeRecommend:(FTRecommendDrug*)recommend{
    if(recommend.drugInfos.count==0)
        return;
    //更新药店数据
    if(!_loginInfo.pharmacy){
        _loginInfo.pharmacy = [[MTPharmacy alloc]init];
    }
    _loginInfo.pharmacy.storeId=recommend.storeId;
    _loginInfo.pharmacy.name=recommend.name;
    _loginInfo.pharmacy.longitude=recommend.longitude;
    _loginInfo.pharmacy.latitude=recommend.latitude;
    _loginInfo.pharmacy.address=recommend.address;
    double postage=recommend.postage; //获取邮费
    
    NSMutableArray *pushDrugss=[NSMutableArray array];
    for(int i = 0 ; i < recommend.drugInfos.count;i++){
        
        MTDrug *drogToBy = [[MTDrug alloc]init];
        FTDrugInfo *drug=recommend.drugInfos[i];
        
        drogToBy.onsellId=drug.onsellId;
        drogToBy.drugName=drug.drugName;
        drogToBy.dosage=drug.dosage;
        drogToBy.company=drug.company;
        drogToBy.drugNum=drug.drugNum;
        drogToBy.pic=drug.pic;
        drogToBy.price=drug.price;
        drogToBy.type=drug.type;
        drogToBy.packing=drug.packing;
        drogToBy.isTax = drug.isTax;
        [pushDrugss addObject:drogToBy];
    }
   _drugs=pushDrugss;//配送药品
    
    if ([self.delegate respondsToSelector:@selector(receiveDrugs:withPharmacy:withPostage:)]) {
        [self.delegate receiveDrugs:_drugs withPharmacy:_loginInfo.pharmacy withPostage:postage];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_drugs forKey:@"drugs"];
    [params setObject:[NSNumber numberWithDouble:postage] forKey:@"postage"];
    [params setObject:_loginInfo.pharmacy forKey:@"pharmacy"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_DRUGS object:params];
}
-(NSString *)serializeRecommand{
    if ([_drugs count]==0) {
        return nil;
    }
    NSString *temp=[[NSString alloc]init];
    for (MTDrug *drug in _drugs) {
        temp=[temp stringByAppendingString:[NSString stringWithFormat:@"%@ (%ld)\n",drug.drugName,(long)drug.drugNum]];
    }
    return temp;
}

#pragma mark - FTCommandClientDelegate
//收到命令
-(void) onCommand:(int)command intValue:(int)intValue stringValue:(NSString*)stringValue jsonValue:(id<FTJsonSerializable>)jsonValue{
    
    if (_tkStatus == ST_Default) {//咨询结束
        NSLog(@"咨询状态结束");
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
            _recvHeartTime = [[NSDate date] timeIntervalSince1970];
            
            _lastTalkTime =  [[NSDate date] timeIntervalSince1970]*1000;
            _talkTime = _lastTalkTime - _startTalkTime;
        }
            break;
        case FT_PROTO_LOGOUT://登出
        case FT_PROTO_END_BUSINESS:
        case FT_PROTO_LEAVE:
        case FT_PROTO_MATCHER_OFFLINE:
        case FT_PROTO_MATCH_FAILURE:
        case FT_PROTO_DISCONNECT:{ /*正常断开链接//在收到以下命令以后会马上收到该命令
                                    //FT_PROTO_END_BUSINESS
                                    //FT_PROTO_LEAVE
                                    //FT_PROTO_MATCHER_OFFLINE
                                    //FT_PROTO_MATCH_FAILURE*/
            LogoutType logoutType = logout_normal;
            switch (command) {
                case FT_PROTO_DISCONNECT:{
                    logoutType = logout_disconnect;
                }
                    break;
                case FT_PROTO_LEAVE:
                case FT_PROTO_MATCHER_OFFLINE:
                case FT_PROTO_MATCH_FAILURE:{
                    logoutType = logout_matchfail;
                }
                    break;
                    
                default:{
                    logoutType = logout_normal;
                }
                    break;
            }
            
            [self stopTalk:logoutType];
        }
            break;
        case FT_PROTO_MATCH_WAIT:{ //等待匹配医生
             NSLog(@TAG"%@",[NSString stringWithFormat:@"您排在第%d位",intValue]);
            if ([self.delegate respondsToSelector:@selector(receiveCommand:withInstance:withInfo:)]) {
                [self.delegate receiveCommand:command_talking withInstance:[NSString stringWithFormat:@"%d",intValue] withInfo:@"排在第几位"];
            }
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:[NSNumber numberWithInt:intValue] forKey:@"rank"];
            [params setObject:[NSNumber numberWithInteger:command_waiting] forKey:@"command"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_COMMAND object:params];
        }
            break;
        case FT_PROTO_MATCH_SUCCESS:{ //匹配医生成功
              NSLog(@TAG"匹配医生成功，医生账号:%@",stringValue);
            if ([self.delegate respondsToSelector:@selector(receiveCommand:withInstance:withInfo:)]) {
                [self.delegate receiveCommand:command_match withInstance:stringValue withInfo:@"医生账号"];
            }
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:stringValue forKey:@"doctorAccount"];
            [params setObject:[NSNumber numberWithInteger:command_match] forKey:@"command"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_COMMAND object:params];
        }
            break;
        case FT_PROTO_AV_START:{ //开始咨询
            NSLog(@TAG"咨询开始，数据库业务id:%@",stringValue);
            _loginInfo.busiId=[NSString stringWithFormat:@"%@",stringValue];
            [self startTalk];
            
            if (self.loginInfo.pharmacy) {
                [self sendCoordinateInfo:self.loginInfo.pharmacy];
            }
            if ([self.delegate respondsToSelector:@selector(receiveCommand:withInstance:withInfo:)]) {
                [self.delegate receiveCommand:command_talking withInstance:stringValue withInfo:@"本次咨询的业务id"];
            }
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:stringValue forKey:@"busiId"];
            [params setObject:[NSNumber numberWithInteger:command_talking] forKey:@"command"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:MT_NOTIC_COMMAND object:params];
        }
            break;
        case FT_PROTO_PUSH_DRUG:{ //推荐药品
            NSLog(@TAG"收到推荐药品");
            FTRecommendDrug *drugsInfo=(FTRecommendDrug *)jsonValue;
            [self deserializeRecommend:drugsInfo];
           
        }
            break;
        default:
            break;
    }
}

//连接状态
-(void) onStatus:(int)status{
    
    if(self.tkStatus == ST_Default)
    {
        NSLog(@"咨询已结束");
        return;
    }
    
    switch (status) {
        case TCP_STATUS_CONNECT_SUCCESS:{
            NSLog(@TAG"TCP连接成功");
            [self.client login:[self.loginInfo joinSubModel]];
            _csStatus = CS_Connect_Success;
        }
            break;
        case TCP_STATUS_CONNECT_FAIL:
        case TCP_STATUS_DISCONNECTED:{
            _csStatus = CS_Disconnected;
            [self stopTalk:logout_disconnect];
        }
            break;
        default:
            break;
    }
    
    NSLog(@"TCP连接:%d",status);
}

@end

@implementation TalkInfo


@end
