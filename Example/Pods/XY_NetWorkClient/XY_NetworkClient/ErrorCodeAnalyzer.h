//
//  ErrorCodeAnalyzer.h
//  XY_NetworkClient
//
//  Created by 何霞雨 on 16/6/8.
//  Copyright © 2016年 何霞雨. All rights reserved.
//

#import "BaseModel.h"

@interface ErrorCodeAnalyzer : BaseModel

@property (nonatomic,strong)NSDictionary *errorDic;//错误码字典 ［int<错误码> ->string <错误码对应提示语句> ］

-(void)analyzeFile:(NSString *)plistPath;//错误码的plist文件
-(void)analyzeDic:(NSDictionary *)codeDic;//错误码数据字典

-(NSError *)desErrorCode:(NSInteger )code;//根据错误码获取错误数据

@end
