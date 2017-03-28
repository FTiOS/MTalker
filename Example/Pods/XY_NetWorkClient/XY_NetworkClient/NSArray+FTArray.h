//
//  NSArray+FTArray.h
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FTArray)

//如果object为空，返回一个空数组
+ (instancetype)ft_arrayWithObject:(NSObject *)anObject;

@end
