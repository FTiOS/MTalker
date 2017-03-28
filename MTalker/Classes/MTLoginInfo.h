//
//  MTLoginInfo.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

#import "MTDoctor.h"
#import "MTUser.h"
#import "MTDevice.h"

//登陆信息
@interface MTLoginInfo : MTModel

@property (nonatomic,strong) MTDevice *device;
@property (nonatomic,strong) MTUser *user;
@property (nonatomic,strong) MTDoctor *doctor;

//简单登录
+(instancetype)simpleLogin:(NSString *)doctor User:(NSString *)user;

-(NSDictionary *)joinSubModels;

@end
