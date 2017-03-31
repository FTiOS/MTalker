//
//  MTModel.m
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

@implementation MTModel

+(NSDictionary *)joinSubModel:(MTModel *)model{
    NSDictionary * temp = model.mj_keyValues;
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

@end
