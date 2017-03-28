//
//  FTUnit.m
//  Talkback
//
//  Created by xiachao on 14/10/23.
//
//

#import "FTUnit.h"

@implementation NSMutableData (Uint8Bytes)

-(uint8_t*) uint8Bytes{
    return (uint8_t*)self.mutableBytes;
}

@end