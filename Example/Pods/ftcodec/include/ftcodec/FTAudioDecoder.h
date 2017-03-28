//
//  FTAudioDecoder.h
//  Talker
//
//  Created by xiachao on 14-9-25.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTAudioUnit.h"



@interface FTAudioDecoder : NSObject

@property (nonatomic,weak) FTAudioUnit* audioUnit;
@property (nonatomic) BOOL debug;

-(BOOL) isStarted;
-(BOOL) start ;
-(void) stop;
-(BOOL) inputMedia:(const uint8_t*)buff size:(int)size;
@end
