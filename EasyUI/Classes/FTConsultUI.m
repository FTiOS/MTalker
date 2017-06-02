//
//  FTConsultUI.m
//  FTConsultUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "FTConsultUI.h"
#import "FTAppService.h"

@interface FTConsultUI()<ConsultViewControllerDelegate>

@property (nonatomic,weak)ConsultViewController *consultVC;

@property (nonatomic,strong)EasyUISettings *settings;

@property (nonatomic,copy) void (^FinishBlock)(ConsultViewController *consultVC,double callTime);


@property (nonatomic,copy) void (^UploadBlock)(NSArray<UIImage *> * _Nullable, ProgressBlock _Nullable progress, SuccessBlock _Nullable success, FailBlock _Nullable fail);

@end

@implementation FTConsultUI

+(instancetype)instance{
    static FTConsultUI *easyUI;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        easyUI = [[FTConsultUI alloc]init];
    });
    return easyUI;
}

#pragma mark - Settup
-(void)setup:(EasyUISettings *)settings startBlock:(void(^)(ConsultViewController *consultVC))startBlock finishBlock:(void(^)(ConsultViewController *consultVC,double callTime))finishBlock{
    
    //配置信息
    self.settings = settings;
    if (self.settings.platformKey) {
        [FTAppService instance].platformKey = self.settings.platformKey;
    }
    if (self.settings.appId) {
        [FTAppService instance].appId = self.settings.appId;
    }
    if (self.settings.api) {
        [FTAppService instance].ip = self.settings.api;
    }
    [FTAppService instance].port = self.settings.port;
    
    
    //挂断回调
    self.FinishBlock = finishBlock;
    
    __weak typeof(self) weakSelf = self;
    [[FTAppService instance]getUserTokenByTel:settings.tel DUserId:settings.dUserId FinshWithBlock:^(FTUser * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            startBlock(nil);
            return ;
        }
        
        ConsultViewController *consultVC =[ConsultViewController instance];
        weakSelf.consultVC = consultVC;
        consultVC.delegate = self;
        
        MTLoginInfo *loginInfo = [MTLoginInfo simpleLogin:settings.account User:settings.tel];
        
        loginInfo.user.tokenId = user.tokenId;
        NSLog(@"login_info:%@",[loginInfo joinSubModel]);
        consultVC.loginInfo = loginInfo;
        startBlock(consultVC);
        
    }];

}

#pragma mark - upload images
-(void)setUploadImages:(void (^)(NSArray<UIImage *> * _Nullable, ProgressBlock _Nullable progress, SuccessBlock _Nullable success, FailBlock _Nullable fail))uploadBlock{
    self.UploadBlock = uploadBlock;
}

#pragma mark - ConsultViewControllerDelegate
-(void)didHangUpCall:(ConsultViewController *)consultVC withCallTime:(double)time{
    if (self.FinishBlock) {
        self.FinishBlock(consultVC, time);
    }
}

-(void)updatePic:(NSArray<__kindof UIImage *> *)avatars updateNumber:(int)number Progress:(void (^)(NSProgress *, int))progresscall success:(void (^)(NSString *))successCall failed:(void (^)(NSError *))failedCall{
    if (self.UploadBlock) {
         self.UploadBlock(avatars, progresscall, successCall, failedCall);
    }
   
}

@end


@implementation EasyUISettings


@end
