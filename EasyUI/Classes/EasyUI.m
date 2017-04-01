//
//  EasyUI.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "EasyUI.h"

@implementation EasyUI
+(ConsultViewController *)consultView{
    return [ConsultViewController instance];
}
+(MTalkerClient *)talkerClient{
    return [MTalkerClient shareTalker];
}
@end
