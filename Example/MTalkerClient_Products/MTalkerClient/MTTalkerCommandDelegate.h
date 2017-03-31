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
    command_login,
    command_waiting,
    command_match,
    command_talking,
    command_logout,
};

@protocol MTTalkerCommandDelegate <NSObject>

//command-命令，instance-传递的参数，info-参数的作用解释说明
-(void)receiveCommand:(CommandType)command withInstance:(NSString *)instance withInfo:(NSString*)info;
//drugs-药品数据，pharmacy-药店数据,postage-邮费
-(void)receiveDrugs:(NSArray<MTDrug *> *)drugs withPharmacy:(MTPharmacy *)pharmacy withPostage:(double)postage;

@end
