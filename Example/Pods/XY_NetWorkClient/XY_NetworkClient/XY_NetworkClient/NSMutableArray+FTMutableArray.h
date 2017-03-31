//
//  NSMutableArray+FTMutableArray.h
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (FTMutableArray)

//插入空对象到数组时，会自动判断失败，避免奔溃
- (void)ft_addObject:(NSObject *)anObject;
- (void)ft_insertObject:(NSObject *)anObject atIndex:(NSUInteger)index;
- (void)ft_replaceObjectAtIndex:(NSUInteger)index withObject:(NSObject *)anObject;

@end
