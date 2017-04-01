//
//  EasyUI.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsultViewController.h"
#import "MTalkerClient.h"

@interface EasyUI : NSObject

+(ConsultViewController *)consultView;
+(MTalkerClient *)talkerClient;

@end
