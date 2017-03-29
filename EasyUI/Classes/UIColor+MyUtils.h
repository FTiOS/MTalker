//
//  UIColor+myUtils.h
//  Monitor
//
//  Created by ft on 15/11/2.
//  Copyright © 2015年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MyUtils)
/*
 *  获取颜色
 *  color :  RBG格式颜色
 *  alpha :  透明度
 */
+(UIColor *)colorWithRGB:(int)color alpha:(float)alpha;

/**
 *  获取hex的颜色
 *
 *  @param stringToConvert @“＃eeeeee”，val：透明度
 *
 *  @return 颜色
 */
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert alpha : (CGFloat) val;
@end
