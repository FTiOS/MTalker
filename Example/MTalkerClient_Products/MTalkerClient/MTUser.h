//
//  MTUser.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

//咨询用户
@interface MTUser : MTModel

@property (nonatomic,strong)NSString *account;//用户账号
@property (nonatomic,strong)NSString *userAvatar;//用户头像地址
@property (nonatomic,strong)NSString *userName;//用户名称

@end
