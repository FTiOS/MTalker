//
//  TPImageView.h
//  GoodPharmacist
//
//  Created by hexiayu on 14/12/4.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPImageView : UIImageView
{
    UIImageView *imageView;
    UIColor *rippleColor;
    double angle;
    BOOL isEndRotate;
}

@property(nonatomic,strong)CAShapeLayer *progressLayer;
@property BOOL isAnimating;
@property (nonatomic) CGFloat lineWidth;
-(void)startRippleEffec;
-(void)setRippleEffectWithColor:(UIColor *)color;


@end
