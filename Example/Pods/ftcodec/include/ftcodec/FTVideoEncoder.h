//
//  FTVideoEncoder.h
//  Talker
//
//  Created by xiachao on 14-9-25.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTMediaDelegate.h"

@interface FTVideoEncoder : NSObject

@property (nonatomic) BOOL isFront;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int frameRate;
@property (nonatomic) int bitrate;
@property (nonatomic) int rotate;
@property (nonatomic,weak) id<FTMediaDelegate> mediaDelegate;

-(BOOL) isStarted;
-(BOOL) start:(UIView* )view orientation:(NSInteger)orientation;
-(void) stop;

@end
