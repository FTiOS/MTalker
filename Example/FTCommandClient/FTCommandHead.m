//
//  FTCommandHead.m
//  Talkback
//
//  Created by xiachao on 15/6/24.
//
//

#import "FTCommandHead.h"

@implementation FTCommandHead{
    int _command;
    int _bodySize;
}



-(instancetype)initWithCommand:(int)command bodySize:(int)bodySize{
    self = [super init];
    if (self) {
        _command = command;
        _bodySize = bodySize;
    }
    return self;
}

-(instancetype)initWithBytes:(uint8_t *)bytes{
    self = [super init];
    if (self) {
        assert(bytes!=NULL);
        
        _command = bytes[0];
        _bodySize =
        ((int)bytes[5] & 0xff) << 24 |
        ((int)bytes[6] & 0xff) << 16|
        ((int)bytes[7] & 0xff) <<  8 |
        ((int)bytes[8] & 0xff) ;
    }
    return self;
}

-(int)command{
    return _command;
}

-(int)bodySize{
    return _bodySize;
}

-(NSData *)bytes{
    
    uint8_t bytes[FT_COMMAND_HEAD_SIZE]={0};
    bytes[0] = (uint8_t)_command;

    bytes[5] = (uint8_t) (_bodySize >>24 & 0xff);
    bytes[6] = (uint8_t) (_bodySize >> 16 & 0xff);
    bytes[7] = (uint8_t) (_bodySize >> 8 & 0xff);
    bytes[8] = (uint8_t) (_bodySize  & 0xff);
    return [NSData dataWithBytes:bytes length:FT_COMMAND_HEAD_SIZE];
}

+(const char *)getCommandString:(int)command{
    if(command==FT_PROTO_CLIENT_LOGIN){
        return "FT_PROTO_CLIENT_LOGIN";
    }else if(command==FT_PROTO_MOBILE_LOGIN){
        return "FT_PROTO_MOBILE_LOGIN";
    }else if(command==FT_PROTO_DRUGGIST_LOGIN){
        return "FT_PROTO_DRUGGIST_LOGIN";
    }else if(command==FT_PROTO_DOCTOR_LOGIN){
        return "FT_PROTO_DOCTOR_LOGIN";
    }else if(command==FT_PROTO_MONITOR_LOGIN){
        return "FT_PROTO_MONITOR_LOGIN";
    }else if(command==FT_PROTO_PROXY_LOGIN){
        return "FT_PROTO_PROXY_LOGIN";
    }else if(command==FT_PROTO_HEARTBEAT){
        return "FT_PROTO_HEARTBEAT";
    }else if(command==FT_PROTO_LOGOUT){
        return "FT_PROTO_LOGOUT";
    }else if(command==FT_PROTO_DISCONNECT){
        return "FT_PROTO_DISCONNECT";
    }else if(command==FT_PROTO_MATCH_WAIT){
        return "FT_PROTO_MATCH_WAIT";
    }else if(command==FT_PROTO_MATCH_SUCCESS){
        return "FT_PROTO_MATCH_SUCCESS";
    }else if(command==FT_PROTO_MATCH_FAILURE){
        return "FT_PROTO_MATCH_FAILURE";
    }else if(command==FT_PROTO_FREE){
        return "FT_PROTO_FREE";
    }else if(command==FT_PROTO_AV_START){
        return "FT_PROTO_AV_START";
    }else if(command==FT_PROTO_AV_CONTROL){
        return "FT_PROTO_AV_CONTROL";
    }else if(command ==FT_PROTO_FILE){
        return "FT_PROTO_FILE";
    }else if(command ==FT_PROTO_PUSH_DRUG){
        return "FT_PROTO_PUSH_DRUG";
    }else if(command ==FT_PROTO_END_BUSINESS){
        return "FT_PROTO_END_BUSINESS";
    }else if(command ==FT_PROTO_GPS_INFO){
        return "FT_PROTO_GPS_INFO";
    }else if(command ==FT_PROTO_LEAVE){
        return "FT_PROTO_LEAVE";
    }else if(command ==FT_PROTO_MATCHER_OFFLINE){
        return "FT_PROTO_MATCHER_OFFLINE";
    }

    return "other";
}



@end
