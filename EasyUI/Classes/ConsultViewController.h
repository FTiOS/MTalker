//
//  ConsultViewController.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTalkerClient.h"


@interface ConsultViewController : UIViewController

+(instancetype)instance;

@property(nonatomic,weak)MTalkerClient *shareTalker;//控制器

@property(nonatomic,weak)MTLoginInfo *loginInfo;//登录信息
@property(nonatomic,strong)NSArray *asserts;//上传选择的图片
@property (nonatomic,strong)NSMutableArray *pushDrugs;//推荐的药品

@property (nonatomic) BOOL needPushDrug; //需要推药

@end
