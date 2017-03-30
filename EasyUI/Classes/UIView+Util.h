//
//  UIView+Util.h
//  cdoctor
//
//  Created by ft on 16/6/13.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+AddLine.h"
@interface UIView (Util)

/**
 *  定制一个view上UITextField的风格
 */
- (void)fixSubViewTextFieldStyle;

/**
 *  增加一个分割线
 */
- (void)addALineView;

@end
