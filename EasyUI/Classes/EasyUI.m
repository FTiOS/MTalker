//
//  EasyUI.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "EasyUI.h"
#import "FTAppService.h"

@interface EasyUI()

@property (nonatomic,weak)ConsultViewController *consultVC;

@property (nonatomic,strong)EasyUISettings *settings;

@end

@implementation EasyUI

+(instancetype)instance{
    static EasyUI *easyUI;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        easyUI = [[EasyUI alloc]init];
    });
    return easyUI;
}

#pragma mark - Settup
-(void)setup:(EasyUISettings *)settings finishBlock:(void(^)(ConsultViewController *))block{
    self.settings = settings;
    
    __weak typeof(self) weakSelf = self;
    [[FTAppService instance]getUserTokenByTel:settings.tel DUserId:settings.dUserId FinshWithBlock:^(FTUser * _Nullable user, NSError * _Nullable error) {
        ConsultViewController *consultVC =[weakSelf consultView];
        MTLoginInfo *loginInfo = [MTLoginInfo simpleLogin:settings.account User:settings.tel];
        loginInfo.user = user;
        consultVC.loginInfo = loginInfo;
        block(consultVC);
    }];

}

#pragma mark - Getter
-(ConsultViewController *)consultView{
    if (!self.consultVC) {
        self.consultVC = [ConsultViewController instance];
    }
    
    return self.consultVC;
}

@end


@implementation EasyUISettings


@end
