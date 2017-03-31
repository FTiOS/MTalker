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
#import "MTPharmacy.h"

typedef NS_ENUM(NSInteger,STRATEGY_TYPE){
    RANDOM_ALL=0,//随机分配
    RANDOM_DOCTOR,//随机分配医生
    RANDOM_PHARMACEUTIST,//随机分配药师
    POINT_DOCTOR,//指定医生
    POINT_PHARMACEUTIST,//指定药师
};

//登陆信息
@interface MTLoginInfo : MTModel

@property (nonatomic,strong) NSString * busiId;//业务id,初始化无值,咨询成功,系统自动匹配
@property (nonatomic,assign) STRATEGY_TYPE strategy;//服务类型

@property (nonatomic,strong) MTDevice *device;//设备数据
@property (nonatomic,strong) MTUser *user;//用户数据
@property (nonatomic,strong) MTDoctor *doctor;//咨询医生的数据
@property (nonatomic,strong) MTPharmacy *pharmacy;//推荐药品药店/医院数据

//简单登录
+(instancetype)simpleLogin:(NSString *)doctor User:(NSString *)user;

-(NSDictionary *)joinSubModel;

@end
