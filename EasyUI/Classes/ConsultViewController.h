//
//  ConsultViewController.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTalkerClient.h"

@protocol ConsultViewControllerDelegate;

@interface ConsultViewController : UIViewController

+(instancetype)instance;

@property (nonatomic,weak)id<ConsultViewControllerDelegate> delegate;

@property(nonatomic,strong)MTalkerClient *shareTalker;//控制器
@property(nonatomic,strong)MTLoginInfo *loginInfo;//登录信息

@property(nonatomic,strong)NSArray *asserts;//上传选择的图片
@property (nonatomic,strong)NSMutableArray *pushDrugs;//推荐的药品

@property (nonatomic) BOOL needPushDrug; //是否需要推药
@property (nonatomic) BOOL needPushPicture; //是否需要推图

@end

@protocol ConsultViewControllerDelegate <NSObject>

-(void)didHangUpCall:(ConsultViewController *)consultVC withCallTime:(double)time;

- (void)updatePic:(NSArray <__kindof UIImage *> *)avatars updateNumber:(int)number Progress:(void (^)(NSProgress * progress, int number))progresscall success:(void(^)(NSString * path))successCall failed:(void(^)(NSError *error)) failedCall;
@end
