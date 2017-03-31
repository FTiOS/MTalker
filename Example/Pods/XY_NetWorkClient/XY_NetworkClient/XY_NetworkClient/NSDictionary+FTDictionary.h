//
//  NSDictionary+FTDictionary.h
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FTDictionary)

//初始化，如果有空值，进行了处理 返回为空字典
+ (instancetype)ft_dictionaryWithObject:(NSObject *)object forKey:(NSObject<NSCopying>*)key;
+ (instancetype)ft_dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION NS_SWIFT_UNAVAILABLE("Use dictionary literals instead");
- (instancetype)ft_initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

//自动将字典中的value转换成需要的对象
-(NSString *)ft_stringForKey:(NSString *)key;
-(NSNumber *)ft_numberForKey:(NSString *)key;

@end
