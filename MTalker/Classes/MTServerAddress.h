//
//  MTServerAddress.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

//地址类型 @1
typedef NS_ENUM(NSInteger,ServerAddressType) {
    ServerType_Talker=7,//调度服务udp对讲地址
};


@interface MTServerAddress : MTModel

@property (nonatomic,assign)NSInteger id          ;//端口id
@property (nonatomic,strong)NSString  *name       ;//名称
@property (nonatomic,strong)NSString  *remark     ;//备注
@property (nonatomic,strong)NSString  *ip         ;//ip
@property (nonatomic,strong)NSString  *domain     ;//域名
@property (nonatomic,assign)int port        ;//端口

@property (nonatomic,assign)ServerAddressType type;//地址类型 @1

@end
