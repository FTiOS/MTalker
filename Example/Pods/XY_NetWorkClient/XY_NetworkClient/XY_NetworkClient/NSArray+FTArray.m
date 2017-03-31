//
//  NSArray+FTArray.m
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "NSArray+FTArray.h"

@implementation NSArray (FTArray)

#pragma mark -
+ (instancetype)ft_arrayWithObject:(NSObject *)anObject{
    if (!anObject) {
        NSLog(@"array 插入空,返回一个空的数组");
        return [NSArray new];
    }
    return [NSArray arrayWithObject:anObject];
}

@end
