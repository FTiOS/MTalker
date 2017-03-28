//
//  FTVideoDecoder.h
//  Talker
//
//  Created by xiachao on 14-9-25.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTVideoDecoder : NSObject

-(BOOL) isStarted;
-(BOOL) start:(UIView* )view ;
-(void) stop;
-(BOOL)inputMedia:(const uint8_t *)buff size:(int)size;

@end
