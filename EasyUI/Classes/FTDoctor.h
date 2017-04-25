//
//  FTDoctor.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/4/7.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "MTDoctor.h"

@interface FTDoctor : MTDoctor
@property (nonatomic,strong)NSString *dpmtName;
@property (nonatomic,strong)NSString *title;
@property(nonatomic,strong) NSString *hospitalId;//医院id
@property(nonatomic,strong) NSString *doctorAccount;//医生帐号
@property(nonatomic,assign) int doctorType;//医生类型

@property(nonatomic,strong) NSString *avatar;//医生头像
@property(nonatomic,strong) NSString *name;//医生名字

@end
