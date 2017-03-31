//
//  MTLoginInfo.m
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTLoginInfo.h"

@implementation MTLoginInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        self.device = [[MTDevice alloc]init];
        self.user   = [[MTUser alloc]init];
        self.doctor = [[MTDoctor alloc]init];
    }
    return self;
}
-(NSDictionary *)joinSubModel{
    NSDictionary * temp = self.mj_keyValues;
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSString *key in temp.allKeys) {
        id value = [temp objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [result addEntriesFromDictionary:value];
        }else
            [result setObject:value forKey:key];
    }
    return result;
}
+(instancetype)simpleLogin:(NSString *)doctor User:(NSString *)user{
    MTLoginInfo *info  = [[MTLoginInfo alloc]init];
    info.doctor.doctorAccount = doctor;
    info.user.account = user;
    info.strategy = POINT_DOCTOR;
    
    return info;
}
@end
