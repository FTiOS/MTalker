//
//  TPImageView.m
//  GoodPharmacist
//
//  Created by hexiayu on 14/12/4.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import "TPImageView.h"

static NSString *kLLARingSpinnerAnimationKey = @"llaringspinnerview.rotation";

@implementation TPImageView
{
    CAShapeLayer *circleShape;
}
#pragma init
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
-(void)awakeFromNib{
    [self initialize];
}

- (void)initialize {
    [self.layer addSublayer:self.progressLayer];
  
}
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}
- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(-M_PI_4);
    CGFloat endAngle = (CGFloat)(3 * M_PI_2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
}

#pragma mark -animations
- (void)startAnimating {//loading animation
    if (self.isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 1.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.progressLayer addAnimation:animation forKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = true;
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;
    [self.progressLayer removeAnimationForKey:kLLARingSpinnerAnimationKey];
    [self.progressLayer removeFromSuperlayer];
    self.isAnimating = false;
}
-(void)startRippleEffec{//波纹效果
    
        UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
    
        if (!circleShape) {
            CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
        
            // accounts for left/right offset and contentOffset of scroll view
            CGPoint shapePosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
            circleShape = [CAShapeLayer layer];
            circleShape.path = path.CGPath;
            circleShape.position = shapePosition;
            circleShape.fillColor = [UIColor clearColor].CGColor;
            circleShape.opacity = 0;
            circleShape.strokeColor = stroke.CGColor;
            circleShape.lineWidth = 1;
        
            [self.layer addSublayer:circleShape];
        
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
        
            CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            alphaAnimation.fromValue = @1;
            alphaAnimation.toValue = @0;
        
            CAAnimationGroup *animation = [CAAnimationGroup animation];
            animation.animations = @[scaleAnimation, alphaAnimation];
            animation.duration = 0.8f;
            animation.repeatCount=INFINITY;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [circleShape addAnimation:animation forKey:nil];
        }

    
}

#pragma mark -settings

-(void)setRippleEffectWithColor:(UIColor *)color{
     rippleColor = color;
}
- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}
@end
