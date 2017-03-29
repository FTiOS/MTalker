//
//  FTCommandClient.h
//  FTCommandClient
//
//  Created by 何霞雨 on 17/3/1.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTCommandHead.h"
#import "FTDrugInfo.h"
#import "FTRecommendDrug.h"
#import "FTLoginParam.h"
#import "FTAVControlParam.h"
#import "FTTcpClient.h"
#import "FTCoordinateInfo.h"

@protocol FTCommandClientDelegate <NSObject>

-(void) onCommand:(int)command intValue:(int)intValue stringValue:(NSString*)stringValue jsonValue:(id<FTJsonSerializable>)jsonValue;
-(void) onStatus:(int)status;
@end

@interface FTCommandClient : NSObject



@property (nonatomic,weak) id<FTCommandClientDelegate> delegate;

//获取业务id，业务匹配成功后才有值
@property(nonatomic,readonly) int businessId;

//获取音视频传输的代理服务ip，业务匹配成功后才有值
@property(nonatomic,readonly) NSString* proxyServerIp;

//获取音视频传输的代理服务端口，业务匹配成功后才有值
@property(nonatomic,readonly) int proxyServerPort;

@property(nonatomic,readonly) BOOL logined;

@property(nonatomic,strong)FTTcpClient *tcpClient;
//获取tcp状态
-(int)status;

//启动客户端并且监听消息
-(BOOL) start:(NSString*)ip port:(int)port;


//停止客户端
-(void) stop;

//登录调度服务并且等待分配医生
// loginParam 用户登录信息,会转发给药剂师端
// strategy    0-  随机分配
//             1-	随机分配医生
//             2-	随机分配药师
//             3-	指定医生
//             4-	指定药师
// doctorAccount 如果是指定医生需要填写，否则为空
-(void) login:(FTLoginParam*) loginParam strategy:(int)strategy doctorAccount:(NSString*)doctorAccount;
-(void) login:(NSDictionary*) loginParam ;
//用户退出
-(void) logout;

//发送心跳包
-(void) heart;

- (void) avControl:(FTAVControlParam *)param ;

//结束业务
-(void) endBusiness:(int)error;

//发送处方图片地址
//files : NSString 数组,http绝对地址
-(void) sendImage:(NSString*) fileUrl;

//发送咨询定位信息
//longitude :经度
//latitude:纬度
//address:定位地址
-(void) sendCoordinate:(double)longitude latitude:(double)latitude address:(NSString*)address chainId:(NSString*)chainId;


@end

