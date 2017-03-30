//
//  CirleProgressView.m
//  BYAlertView
//
//  Created by 包勇 on 16/10/17.
//  Copyright © 2016年 BaoYong. All rights reserved.
//

#import "CirleProgressView.h"

@interface CirleProgressView ()

{
    CGFloat _progress;
}

@property (nonatomic, strong) UILabel *contentlabel;

@end

@implementation CirleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //27,66,86 #1b4256
        //self.backgroundColor = [UIColor colorWithRed:(27/255.0f) green:(66/255.0f) blue:(86/255.0f) alpha:1.0f];
        self.backgroundColor = [UIColor clearColor];
 //       CGFloat leftMargin = 5.0f;
        
        CGFloat diameter = MIN(frame.size.width, frame.size.height);
//        CGFloat width = (diameter - 4 - leftMargin*2.0);
//        CGFloat orginX = (frame.size.width - width)/2.0f;
//        CGFloat orginY = (frame.size.height - 20)/2.0;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, diameter - 8, 20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:label];
        label.center = self.center;
        self.contentlabel = label;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if(self.totalCount == 0) {
        _progress = 0.0f;
    }
    
    CGPoint center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    CGFloat diameter = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat radius = diameter/2.0f - 2;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:endA endAngle:startA clockwise:YES];
    CGContextSetLineWidth(ctx, 2); //设置线条宽度
    
    //58,92,109 #3a5c6d
    //[UIColor colorWithRed:(58/255.0f) green:(92/255.0f) blue:(109/255.0f) alpha:1.0f]
    [[UIColor lightGrayColor] setStroke]; //设置描边颜色
    CGContextAddPath(ctx, path1.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染

    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 2); //设置线条宽度
    [[UIColor whiteColor] setStroke]; //设置描边颜色
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx);  //渲染
}

- (void)drawProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)updateCurrentCount:(NSInteger)count
{
    NSString *progressStr = [NSString stringWithFormat:@"%ld/%ld", (long)count, self.totalCount];
    self.currentCount = count;
    self.contentlabel.text = progressStr;
}


@end
