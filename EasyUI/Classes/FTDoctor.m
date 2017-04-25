//
//  FTDoctor.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/4/7.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "FTDoctor.h"

@implementation FTDoctor
@dynamic hospitalId;
@dynamic doctorAccount;
@dynamic doctorType;
@dynamic avatar;
@dynamic name;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"name":@"fullName"
             };  
}
@end
