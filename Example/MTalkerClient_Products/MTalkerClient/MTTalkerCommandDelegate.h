//
//  MTTalkerCommandDelegate.h
//  MTalker
  /*
        监听命令，有两种方式：
        1.监听通知,数据随通知
        2.实现回调，随机随回调
  */
//  Created by 何霞雨 on 2017/3/23.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import <Foundation/Foundation.h>

//通知key
#define MT_NOTIC_COMMAND @"mt_notice_command"
#define MT_NOTIC_DRUGS @"mt_notice_drugs"

typedef NS_ENUM(NSInteger,CommandType) {
    command_login,//开始登录咨询
    command_waiting,//排队
    command_match,//匹配了医生
    command_talking,//开始咨询
    command_logout,//退出咨询
};

typedef NS_ENUM(NSInteger,LogoutType) {
    logout_normal,//正常登出
    logout_disconnect,//断开链接
    logout_matchfail,//匹配失败
};

@protocol MTTalkerCommandDelegate <NSObject>

//command-命令，instance-传递的参数，info-参数的作用解释说明
-(void)receiveCommand:(CommandType)command withInstance:(NSString *)instance withInfo:(NSString*)info;
//drugs-药品数据，pharmacy-药店数据,postage-邮费
-(void)receiveDrugs:(NSArray<MTDrug *> *)drugs withPharmacy:(MTPharmacy *)pharmacy withPostage:(double)postage;

@end
