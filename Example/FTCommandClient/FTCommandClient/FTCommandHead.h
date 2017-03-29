//
//  FTCommandHead.h
//  Talkback
//
//  Created by xiachao on 15/6/24.
//
//

#import <Foundation/Foundation.h>
#import "FTCommandHead.h"

#define FT_PROTO_CLIENT_LOGIN   1
#define FT_PROTO_MOBILE_LOGIN   2
#define FT_PROTO_DRUGGIST_LOGIN   3
#define FT_PROTO_DOCTOR_LOGIN   4
#define FT_PROTO_MONITOR_LOGIN   5
#define FT_PROTO_PROXY_LOGIN   6
#define FT_PROTO_HEARTBEAT  7
#define FT_PROTO_LOGOUT  8
#define FT_PROTO_DISCONNECT 9

#define FT_PROTO_MATCH_WAIT 10
#define FT_PROTO_MATCH_SUCCESS 11
#define FT_PROTO_MATCH_FAILURE 12 //用户排队失败，返回用户的命令, 周期内清除用户
#define FT_PROTO_FREE 13

#define FT_PROTO_AV_START 20
#define FT_PROTO_AV_CONTROL 21
#define FT_PROTO_FILE 25
#define FT_PROTO_PUSH_DRUG 26
#define FT_PROTO_END_BUSINESS 27  //主动结束业务方发送命令（匹配成功后）, 包含主动结束错误码, 正常结束错误码为0,
#define FT_PROTO_GPS_INFO 28

//调度主动发起的命令（匹配成功后发出）
#define FT_PROTO_LEAVE				 30
#define FT_PROTO_MATCHER_OFFLINE	 31


//命令头的固定大小
#define FT_COMMAND_HEAD_SIZE 9

@interface FTCommandHead : NSObject

//通过命令id和消息体大小构造一个命令头
//command:命令id
//bodySize:命令体大小
-(instancetype)initWithCommand:(int)command bodySize:(int)bodySize;

//通过命令缓存构造一个命令头
//bytes:命令头的缓存
-(instancetype)initWithBytes:(uint8_t*)bytes;

//获取命令id
-(int) command;

//获取命令体大小
-(int) bodySize;

//获取命令头的缓存
-(NSData*) bytes;

//获取命令对应的字符串
//command:命令ID
+(const char *) getCommandString:(int)command;

@end
