//
//  CirleProgressView.h
//  BYAlertView
//
//  Created by 包勇 on 16/10/17.
//  Copyright © 2016年 BaoYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirleProgressView : UIView

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger currentCount;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawProgress:(CGFloat)progress;
- (void)updateCurrentCount:(NSInteger)count;

@end
