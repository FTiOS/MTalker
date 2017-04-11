//
//  FTAppService.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/4/7.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

//url:http://ip:port/serviceName/action?parmaters

#import <Foundation/Foundation.h>
#import "FTDoctor.h"
#import "FTUser.h"

//请求借口出错
static int const url_error = -1001;

@interface FTAppService : NSObject

@property (nonatomic,strong,nullable)NSString * ip;
@property (nonatomic,assign)int port;

@property (nonatomic,strong,nullable)NSString *serviceName;

@property (nonatomic,strong,nullable)NSString *platformKey;//密钥
@property (nonatomic,strong,nullable)NSString *appId;//应用ID

+(instancetype _Nonnull )instance;

-(void)getUserTokenByTel:(NSString *_Nonnull)tel DUserId:(NSString *_Nonnull)dUserId FinshWithBlock:(void(^_Nullable)(FTUser * _Nullable user,NSError * _Nullable error)) block;
-(void)getDoctorInfo:(NSString *_Nonnull)account FinshWithBlock:(void(^_Nullable)(FTDoctor * _Nullable user,NSError * _Nullable error)) block;

@end
