//
//  FTCoordinateInfo.h
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import <Foundation/Foundation.h>
#import "FTJsonSerializable.h"

@interface FTCoordinateInfo : NSObject<FTJsonSerializable>

+(FTCoordinateInfo *)instance;

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) NSString * address;
@property (nonatomic) NSString * chainId;

-(void)save;
-(void)load;

@end
