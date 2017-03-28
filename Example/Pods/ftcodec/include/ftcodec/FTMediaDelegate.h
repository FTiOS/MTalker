//
//  FTMediaDelegate.h
//  Talker
//
//  Created by xiachao on 14-9-25.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FTMediaFormat.h"

@protocol FTMediaDelegate <NSObject>

-(void) outputMedia:(const uint8_t*)data
               size:(int)size
          mediaType:(int)mediaType
          codecType:(int)codecType;
@end
