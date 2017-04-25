//
//  FTCommandClient.m
//  FTCommandClient
//
//  Created by 何霞雨 on 17/3/1.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "FTCommandClient.h"


#import "FTTcpClient.h"
#import "FTCommandHead.h"

#include <ConditionalMacros.h>
#undef TYPE_BOOL
#import "business.pb.h"
#define TAG "FTCommandClient:"

#define MAX_BODY_SIZE (50*1024)

@interface FTCommandClient ()<FTTcpClientDelegate>{
    uint8_t * _recvData;
    int _recvSize;
    FTTcpClient *_tcpClient;
}

@end

@implementation FTCommandClient

- (instancetype)init{
    self = [super init];
    if (self) {
        _recvData = (uint8_t*)malloc(MAX_BODY_SIZE+FT_COMMAND_HEAD_SIZE);
        _recvSize = 0;
    }
    return self;
}

- (void)dealloc{
    [self stop];
    free(_recvData);
    _recvData = NULL;
}

-(int)status{
    return _tcpClient.status;
}

-(BOOL)start:(NSString *)ip port:(int)port{
    NSLog(@TAG"start 0");
    if(_tcpClient!=nil)
        return YES;
    NSLog(@TAG"start 0.5");
    _recvSize = 0;
    _tcpClient = [[FTTcpClient alloc]init];
    _tcpClient.ip = ip;
    _tcpClient.port = port;
    _tcpClient.delegate = self;
    NSLog(@TAG"start 1");
    if(![_tcpClient open]){
        NSLog(@TAG"TcpClient open fail");
        _tcpClient = nil;
        return NO;
    }
    NSLog(@TAG"TcpClient open2");
    return YES;
}

-(void)stop{
    if(_tcpClient==nil)
        return;
    
    [_tcpClient close];
    _tcpClient = nil;
}

-(void)login:(FTLoginParam *)loginParam strategy:(int)strategy doctorAccount:(NSString *)doctorAccount{
    
    if(loginParam==nil){
        NSLog(@TAG"param==null");
        return;
    }
    
    if(loginParam.deviceId.length<=0 && loginParam.account.length<=0){
        NSLog(@TAG"deviceId and account is empty");
        return;
    }
    loginParam.druggistId=doctorAccount;
    loginParam.doctorType=strategy;
    
    NSData * data = [self serializeJson:loginParam];
    assert(data!=nil);
    
    mobile_login_content body;
    if(loginParam.account.length>0)
        body.set_phone_num(loginParam.account.UTF8String);
    body.set_need_stratey(strategy);
    if(doctorAccount.length>0)
        body.set_specifiy_id(doctorAccount.UTF8String);
    if(loginParam.deviceId.length>0){
        body.set_device_id(loginParam.deviceId.UTF8String);
    }
    
    body.set_json_value((const char*)data.bytes, data.length);
    
    [self send:FT_PROTO_MOBILE_LOGIN body:&body];
}
    
-(void)login:(NSDictionary *)loginParam{
    
    if(loginParam==nil){
        NSLog(@TAG"param==null");
        return;
    }
    
    NSError *error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:loginParam options:kNilOptions error:&error];
    assert(data!=nil);
    
    NSString *account = [loginParam objectForKey:@"account"];
    NSString *doctorAccount = [loginParam objectForKey:@"doctorAccount"];
    int strategy = [[loginParam objectForKey:@"strategy"] intValue];
    NSString *deviceId = [loginParam objectForKey:@"deviceId"];
    if ([loginParam objectForKey:@"tokenId"]) {
        deviceId = [loginParam objectForKey:@"tokenId"];
    }
    
    if(deviceId.length<=0 && account.length<=0){
        NSLog(@TAG"deviceId and account is empty");
        return;
    }
    
    if(doctorAccount.length<=0){
        NSLog(@TAG"doctor account is empty");
        return;
    }
    
    mobile_login_content body;
    if(account.length>0)
        body.set_phone_num(account.UTF8String);
    body.set_need_stratey(strategy);
    if(doctorAccount.length>0)
        body.set_specifiy_id(doctorAccount.UTF8String);
    if(deviceId.length>0){
        body.set_device_id(deviceId.UTF8String);
    }
    
    body.set_json_value((const char*)data.bytes, data.length);
    
    [self send:FT_PROTO_MOBILE_LOGIN body:&body];
}
-(void)logout{
    [self send:FT_PROTO_LOGOUT];
}

-(void)heart{
    [self send:FT_PROTO_HEARTBEAT];
}

- (void) avControl:(FTAVControlParam *)param {
    if(param==nil)
        return;
    
    NSData * data = [self serializeJson:param];
    assert(data!=nil);
    business_content body;
    body.set_business_id(_businessId);
    body.set_json_value((const char*)data.bytes, data.length);
    
    [self send:FT_PROTO_AV_CONTROL body:&body];
}

-(void)endBusiness:(int)error{
    business_content body;
    body.set_business_id(_businessId);
    body.set_int_value(error);
    [self send:FT_PROTO_END_BUSINESS body:&body];
}

-(void)sendImage:(NSString *)fileUrl{
    if(fileUrl.length<=0)
        return;
    business_content body;
    body.set_business_id(_businessId);
    body.set_string_value(fileUrl.UTF8String);
    [self send:FT_PROTO_FILE body:&body];
}


-(void) sendCoordinate:(double)longitude latitude:(double)latitude address:(NSString*)address chainId:(NSString*)chainId{
    FTCoordinateInfo *coordinateInfo = [[FTCoordinateInfo alloc]init];
    coordinateInfo.longitude = longitude;
    coordinateInfo.latitude = latitude;
    coordinateInfo.address = address;
    coordinateInfo.chainId=chainId;
    
    NSData * data = [self serializeJson:coordinateInfo];
    assert(data!=nil);
    
    business_content body;
    body.set_business_id(_businessId);
    body.set_json_value((const char*)data.bytes, data.length);
    [self send:FT_PROTO_GPS_INFO body:&body];
}


-(void)send:(int)command{
    if(_tcpClient == nil)
        return;
    
    FTCommandHead *head = [[FTCommandHead alloc]initWithCommand:command bodySize:0];
    NSData * data = head.bytes;
    
    [_tcpClient send:(uint8_t*)data.bytes maxLength:(int)data.length];
    
    NSLog(@TAG"send command :%s(%d) ", [FTCommandHead getCommandString:command], command);
}

-(void)send:(int)command body:(::google::protobuf::Message* ) body{
    if(_tcpClient == nil)
        return;
    std::string  str;
    if(!body->SerializeToString(&str)){
        NSLog(@TAG"SerializeToString fail command:%d",command);
        return;
    }
    FTCommandHead *head = [[FTCommandHead alloc]initWithCommand:command bodySize:(int)str.length()];
    NSData * data = head.bytes;
    
    [_tcpClient send:(uint8_t*)data.bytes maxLength:(int)data.length];
    [_tcpClient send:(uint8_t*)str.c_str() maxLength:(int)str.length()];
    
    
    NSLog(@TAG"send command :%s(%d) \n%s",[FTCommandHead getCommandString:command],command,body->DebugString().c_str());
}

-(NSData*) serializeJson:(id<FTJsonSerializable>) obj{
    if(obj==nil)
        return nil;
    NSError *error;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [obj serialize:dictionary];
    return [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
}

-(void) deserializeJson:(id<FTJsonSerializable>) obj  txt:(const std::string &)txt{
    if(txt.length()<=0)
        return;
    NSError *error;
    
    NSData *data = [NSData dataWithBytes:txt.c_str() length:txt.length()];
    NSDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(![dictionary isKindOfClass:NSDictionary.class])
        return;
    
    [obj deserialize:dictionary];
}


-(void)onStatus:(int)status{
    [_delegate onStatus:status];
}

-(void)onRecv{
    int recvSize = 0;
    if(_recvSize<FT_COMMAND_HEAD_SIZE){
        recvSize = [_tcpClient recv:_recvData+_recvSize maxLength:FT_COMMAND_HEAD_SIZE-_recvSize];
        if(recvSize<=0){
            //NSLog(@TAG"step 1");
            return;
        }
        _recvSize+=recvSize;
    }
    
    if(_recvSize<FT_COMMAND_HEAD_SIZE){
        //NSLog(@TAG"step 2");
        return;
    }
    FTCommandHead *head = [[FTCommandHead alloc]initWithBytes:_recvData];
    if(head.bodySize>MAX_BODY_SIZE || head.bodySize<0){
        _recvSize = 0;
        //NSLog(@TAG"step 3");
        return;
    }
    
    if(head.bodySize==0){
        [self processCommand:head];
        _recvSize = 0;
        //NSLog(@TAG"step 4");
        return;
    }
    recvSize = [_tcpClient recv:_recvData+_recvSize maxLength:head.bodySize+FT_COMMAND_HEAD_SIZE-_recvSize];
    if(recvSize<=0){
        //NSLog(@TAG"step 5");
        return;
    }
    _recvSize+=recvSize;
    
    if(_recvSize<FT_COMMAND_HEAD_SIZE+head.bodySize){
        //NSLog(@TAG"step 6");
        return;
    }
    
    [self processCommand:head];
    // NSLog(@TAG"step 7");
    
    _recvSize = 0;
}

-(void)processCommand:(FTCommandHead*) head{
    int command = head.command;
    int intValue = 0;
    NSString * stringValue = nil;
    id<FTJsonSerializable> jsonValue = nil;
    std::string protoStr = "";
    
    if(command == FT_PROTO_MOBILE_LOGIN){
        login_response_content body;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        intValue = body.rt_value();
        protoStr = body.DebugString();
        if(intValue==0){
            _logined = YES;
        }
    }
    else if (command == FT_PROTO_MATCH_WAIT) {
        match_wait_content body;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        intValue = body.wait_count();
        protoStr = body.DebugString();
    } else if (command == FT_PROTO_MATCH_SUCCESS) {
        match_success_content body;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        _businessId = body.business_id();
        _proxyServerIp = [NSString  stringWithUTF8String:body.proxy_server_ip().c_str()];
        _proxyServerPort = body.proxy_server_port();
        stringValue =[NSString stringWithUTF8String:body.druggist_account().c_str()];
        protoStr = body.DebugString();
    } else if (command == FT_PROTO_MATCH_FAILURE) {
        match_failure_content body;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        intValue = body.match_error();
        protoStr = body.DebugString();
    } else if (command == FT_PROTO_AV_START) {
        business_content body ;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        _businessId = body.business_id();
        stringValue =[NSString stringWithUTF8String:body.string_value().c_str()];
        protoStr = body.DebugString();
    } else if (command == FT_PROTO_PUSH_DRUG) {
        business_content body ;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        jsonValue = [[FTRecommendDrug alloc]init];
        [self deserializeJson:jsonValue txt:body.json_value()];
        protoStr = body.DebugString();
    } else if(command == FT_PROTO_AV_CONTROL ){
        business_content body ;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        jsonValue =[[FTAVControlParam alloc]init];
        [self deserializeJson:jsonValue txt:body.json_value()];
        protoStr=body.DebugString();
    } else if(command == FT_PROTO_END_BUSINESS){
        business_content body ;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        intValue = body.int_value();
        protoStr=body.DebugString();
        _businessId = 0;//收到业务结束情况本地业务id，避免清理时发送endBusiness
    } else if(command == FT_PROTO_MATCHER_OFFLINE){
        business_content body ;
        if(head.bodySize<=0 || !body.ParseFromArray(_recvData+FT_COMMAND_HEAD_SIZE, head.bodySize)){
            NSLog(@TAG"processCommand fail:%d",command);
            return;
        }
        
        protoStr=body.DebugString();
    }else if(command == FT_PROTO_DISCONNECT){
        
    }
    
    NSLog(@TAG"recv command :%s(%d) \n%s", [FTCommandHead getCommandString:command], command, protoStr.c_str());
    [_delegate onCommand:command intValue:intValue stringValue:stringValue jsonValue:jsonValue ];
}

@end
