//
//  MTPharmacy.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

//药房
@interface MTPharmacy : MTModel

@property (nonatomic,assign)double latitude;//经度
@property (nonatomic,assign)double longitude;//纬度
@property (nonatomic,strong) NSString * address;//药店地址
@property (nonatomic,strong) NSString * chainId;//连锁id

@property (nonatomic,assign) int64_t storeId;//配送药店id
@property (nonatomic,strong) NSString* name;//	配送药店名称
@property (nonatomic,assign) int type;//药店类型
@property (nonatomic,assign) int status;//药店状态

@end
