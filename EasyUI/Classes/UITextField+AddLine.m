//
//  UITextField+AddLine.m
//  cdoctor
//
//  Created by 何霞雨 on 16/6/15.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "UITextField+AddLine.h"
#import <Aspects/Aspects.h>
@implementation UITextField (AddLine)


-(void)replaceSetTextSEl{
    [self aspect_hookSelector:@selector(setText:) withOptions:AspectPositionAfter usingBlock:^(void){
        [self layoutIfNeeded];
    } error:nil];
    
    [self aspect_hookSelector:@selector(setPlaceholder:) withOptions:AspectPositionAfter usingBlock:^(void){
        [self layoutIfNeeded];
    } error:nil];
    
    [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^(void){
        [super layoutIfNeeded];
    } error:nil];
}
@end
