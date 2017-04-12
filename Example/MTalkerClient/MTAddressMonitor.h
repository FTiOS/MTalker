//
//  MTAddressMonitor.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/27.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTServerAddress.h"

static NSString const *VauleKey = @"result";

@interface MTAddressMonitor : NSObject

@property (nonatomic,strong)NSString *api;//接口
@property (nonatomic,strong)NSDictionary *parmas;//参数
@property (nonatomic,strong,readonly)MTServerAddress *addresses;//获取的所有地址

+(instancetype)instance;

//获取网络配置，若本地有直接返回，再请求网络
-(void)patchAddressWithFinshiBlock:(void (^)(MTServerAddress *address,NSError *error))block;


@end
