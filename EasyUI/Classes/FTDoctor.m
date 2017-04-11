//
//  FTDoctor.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/4/7.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "FTDoctor.h"

@implementation FTDoctor
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"doctorAccount":@"account",
             @"name":@"fullName"
             };  //从这里可以看出，model中的Mydog对应我们数据源中的dog，Smallbird对应bird.twoBird
}
@end
