//
//  UIView+Util.m
//  cdoctor
//
//  Created by ft on 16/6/13.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "UIView+Util.h"
#import "UIColor+MyUtils.h"
#import <Masonry/Masonry.h>

@implementation UIView (Util)

- (void)fixSubViewTextFieldStyle
{
    for(id obj in self.subviews){
        if([obj isKindOfClass:[UITextField class]]){
            
            UITextField * textField = obj;
            [textField replaceSetTextSEl];
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            
            //添加左边缩进
            leftView.backgroundColor = textField.backgroundColor;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.leftView = leftView;
            
            //添加底部线条
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor hexStringToColor:@"#e1e1e1"];
            [textField addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(textField);
                make.right.equalTo(textField);
                make.bottom.equalTo(textField);
                make.height.equalTo(@1);
            }];
        }
    }
}

- (void)addALineView
{

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor hexStringToColor:@"#e1e1e1"];
    [self addSubview:lineView];
    if ([self isKindOfClass:[UITextField class]]) {
        UITextField *field = (UITextField *)self;
        [field replaceSetTextSEl];
    }
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.superview);
        make.right.equalTo(lineView.superview);
        make.bottom.equalTo(lineView.superview);
        make.height.equalTo(@1);
    }];
}

@end
