//
//  NSDictionary+FTDictionary.m
//  cdoctor
//
//  Created by 何霞雨 on 16/6/1.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "NSDictionary+FTDictionary.h"

@implementation NSDictionary (FTDictionary)

#pragma mark - Init

+ (instancetype)ft_dictionaryWithObject:(NSObject *)object forKey:(NSObject<NSCopying>*)key{
    if (!object) {
        NSLog(@"初始化dict,Value:为空,返回一个空的字典");
        return [NSDictionary dictionary];
    }
    return [NSDictionary dictionaryWithObject:object forKey:key];
}

+ (instancetype)ft_dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION NS_SWIFT_UNAVAILABLE("Use dictionary literals instead"){
    va_list parms_list;
    NSMutableArray * resourceArr = [NSMutableArray new];
    if (firstObject) {
        resourceArr=[NSMutableArray arrayWithObject:firstObject];
        NSObject *otherObj;
        va_start(parms_list, firstObject);
        while ((otherObj = va_arg(parms_list, NSObject *))) {
            [resourceArr addObject:otherObj];
        }
        va_end(parms_list);
    }
    if ([resourceArr count]%2!=0) {
        return [NSDictionary new];
    }else{
        NSMutableArray *values=[NSMutableArray new];
        NSMutableArray *keys = [NSMutableArray new];
        
        for (NSInteger index =0;index<resourceArr.count;index=index+2) {
            NSObject *value = [resourceArr objectAtIndex:index];
            NSObject<NSCoding> *key = [resourceArr objectAtIndex:index+1];
            [values addObject:value];
            [keys addObject:key];
        }
        
        return [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
}

- (instancetype)ft_initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION{
    va_list parms_list;
    NSMutableArray * resourceArr = [NSMutableArray new];
    if (firstObject) {
        resourceArr=[NSMutableArray arrayWithObject:firstObject];
        NSObject *otherObj;
        va_start(parms_list, firstObject);
        while ((otherObj = va_arg(parms_list, NSObject *))) {
            [resourceArr addObject:otherObj];
        }
        va_end(parms_list);
    }
    if ([resourceArr count]%2!=0) {
        return [NSDictionary new];
    }else{
        NSMutableArray *values=[NSMutableArray new];
        NSMutableArray *keys = [NSMutableArray new];
        
        for (NSInteger index =0;index<resourceArr.count;index=index+2) {
            NSObject *value = [resourceArr objectAtIndex:index];
            NSObject<NSCoding> *key = [resourceArr objectAtIndex:index+1];
            [values addObject:value];
            [keys addObject:key];
        }
        
        return [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
}

#pragma mark - Object For Key
-(NSString *)ft_stringForKey:(NSString *)key{
    if (!key) {
        key = @"";
    }
    NSString *value = @"";
    
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        value = (NSString *)object;
    }else if ([object isKindOfClass:[NSNumber class]]){
        value = [(NSNumber *)object stringValue];
    }else if ([object isKindOfClass:[NSNull class]]){
        value = @"";
    }else{
        NSLog(@"key:%@，value:未知类型",key);
    }
    
    return value;
}

-(NSNumber *)ft_numberForKey:(NSString *)key{
    if (!key) {
        key = @"";
    }
    NSNumber *value = nil;
    
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        NSNumberFormatter *numberFormmater = [[NSNumberFormatter alloc]init];
        id result = [numberFormmater numberFromString:(NSString *)object];
        if (!result) {
            result = [NSNumber numberWithInteger:0];
        }
        value = result;
    }else if ([object isKindOfClass:[NSNumber class]]){
        value = (NSNumber *)object;
    }else if ([object isKindOfClass:[NSNull class]]){
        value = [NSNumber numberWithInteger:0];
    }else{
        value = [NSNumber numberWithInteger:0];
        NSLog(@"key:%@，value:未知类型",key);
    }
    
    return value;
}

@end
