//
//  NSMutableDictionary+FTMutableDictionary.m
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "NSMutableDictionary+FTMutableDictionary.h"

@implementation NSMutableDictionary (FTMutableDictionary)

- (void)ft_setObject:(NSObject *)anObject forKey:(NSObject <NSCopying> *)aKey{
    if (!anObject) {
        NSLog(@"设置字典，值为空，未设置成功！");
        return;
    }
    [self setObject:anObject forKey:aKey];
}



@end
