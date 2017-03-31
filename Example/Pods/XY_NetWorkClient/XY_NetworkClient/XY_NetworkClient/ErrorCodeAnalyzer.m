//
//  ErrorCodeAnalyzer.m
//  XY_NetworkClient
//
//  Created by 何霞雨 on 16/6/8.
//  Copyright © 2016年 何霞雨. All rights reserved.
//

#import "ErrorCodeAnalyzer.h"
#import "NSDictionary+FTDictionary.h"

const static NSString *CustomErrorDomain = @"com.cdfortis.network";

@implementation ErrorCodeAnalyzer

#pragma mark - analyze error code
-(void)analyzeFile:(NSString *)plistPath{
    NSDictionary *errorDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    assert(!errorDic);//判断是否错误码字典为空
    self.errorDic = errorDic;
}
-(void)analyzeDic:(NSDictionary *)codeDic{
    self.errorDic = codeDic;
}

#pragma mark - packaging error object
-(NSError *)desErrorCode:(NSInteger )code{
    NSNumber * codeNum = [NSNumber numberWithInteger:code];
    NSString *codeStr = [codeNum stringValue];
    
    NSString *ErrorValue = [self.errorDic ft_stringForKey:codeStr];
    
    if (!ErrorValue) {//如果对应错误码信息没有，返回空
        return nil;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:ErrorValue forKey:NSLocalizedDescriptionKey];
    NSError *error=[NSError errorWithDomain:CustomErrorDomain code:code userInfo:userInfo];
     NSLog(@"网络请求失败，错误码%d,错误信息:%@",code,ErrorValue);
    
    return error;

}

#pragma mark - Getter and Setter
-(NSDictionary *)errorDic{
    if (!_errorDic) {
        _errorDic = [NSDictionary new];
    }
    return _errorDic;
}

@end
