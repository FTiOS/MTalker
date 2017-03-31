//
//  NSMutableDictionary+FTMutableDictionary.h
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (FTMutableDictionary)

//设置字典的键值对，如果值为空，则设置失败
- (void)ft_setObject:(NSObject *)anObject forKey:(NSObject <NSCopying> *)aKey;

@end
