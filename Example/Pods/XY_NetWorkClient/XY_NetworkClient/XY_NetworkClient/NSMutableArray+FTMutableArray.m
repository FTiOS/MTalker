//
//  NSMutableArray+FTMutableArray.m
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "NSMutableArray+FTMutableArray.h"

@implementation NSMutableArray (FTMutableArray)
- (void)ft_addObject:(NSObject *)anObject{
    if (anObject) {
        [self addObject:anObject];
    }else{
        NSLog(@"插入数组，数据为空！,没有执行插入");
    }
}
- (void)ft_insertObject:(NSObject *)anObject atIndex:(NSUInteger)index{
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    }else{
        NSLog(@"插入数组，数据为空！,没有执行插入");
    }
}
- (void)ft_replaceObjectAtIndex:(NSUInteger)index withObject:(NSObject *)anObject{
    if (anObject) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }else{
        NSLog(@"插入数组，数据为空！,没有执行插入");
    }
}

@end
