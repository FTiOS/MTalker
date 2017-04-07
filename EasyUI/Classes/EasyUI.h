//
//  EasyUI.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsultViewController.h"

@class EasyUISettings;
@interface EasyUI : NSObject

+(instancetype)instance;
-(void)setup:(EasyUISettings *)settings finishBlock:(void(^)(ConsultViewController *))block;

@end


@interface EasyUISettings : NSObject

@property (nonatomic,strong)NSString *platformKey;//平台密钥
@property (nonatomic,strong)NSString *appId;//应用id

@property (nonatomic,strong)NSString *tel;//用户电话
@property (nonatomic,strong)NSString *dUserId;//用户ID

@property (nonatomic,strong)NSString *account;//医生账号

@end
